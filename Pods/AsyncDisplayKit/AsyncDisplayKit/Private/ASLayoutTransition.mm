//
//  ASLayoutTransition.mm
//  AsyncDisplayKit
//
//  Created by Huy Nguyen on 3/8/16.
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//

#import "ASLayoutTransition.h"

#import "ASDisplayNodeInternal.h"
#import "ASLayout.h"

#import <queue>
#import <memory>

#import "NSArray+Diffing.h"
#import "ASEqualityHelpers.h"

/**
 * Search the whole layout stack if at least one layout has a layoutable object that can not be layed out asynchronous.
 * This can be the case for example if a node was already loaded
 */
static inline BOOL ASLayoutCanTransitionAsynchronous(ASLayout *layout) {
  // Queue used to keep track of sublayouts while traversing this layout in a BFS fashion.
  std::queue<ASLayout *> queue;
  queue.push(layout);
  
  while (!queue.empty()) {
    layout = queue.front();
    queue.pop();
    
    if (layout.layoutableObject.canLayoutAsynchronous == NO) {
      return NO;
    }
    
    // Add all sublayouts to process in next step
    for (ASLayout *sublayout in layout.sublayouts) {
      queue.push(sublayout);
    }
  }
  
  return YES;
}

@implementation ASLayoutTransition {
  std::shared_ptr<ASDN::RecursiveMutex> __instanceLock__;
  
  BOOL _calculatedSubnodeOperations;
  NSArray<ASDisplayNode *> *_insertedSubnodes;
  NSArray<ASDisplayNode *> *_removedSubnodes;
  std::vector<NSUInteger> _insertedSubnodePositions;
  std::vector<NSUInteger> _removedSubnodePositions;
}

- (instancetype)initWithNode:(ASDisplayNode *)node
               pendingLayout:(ASLayout *)pendingLayout
              previousLayout:(ASLayout *)previousLayout
{
  self = [super init];
  if (self) {
    __instanceLock__ = std::make_shared<ASDN::RecursiveMutex>();
      
    _node = node;
    _pendingLayout = pendingLayout;
    _previousLayout = previousLayout;
  }
  return self;
}

- (BOOL)isSynchronous
{
  ASDN::MutexSharedLocker l(__instanceLock__);
  return ASLayoutCanTransitionAsynchronous(_pendingLayout);
}

- (void)startTransition
{
  [self applySubnodeInsertions];
  [self applySubnodeRemovals];
}

- (void)applySubnodeInsertions
{
  ASDN::MutexSharedLocker l(__instanceLock__);
  [self calculateSubnodeOperationsIfNeeded];
  
  NSUInteger i = 0;
  for (ASDisplayNode *node in _insertedSubnodes) {
    NSUInteger p = _insertedSubnodePositions[i];
    [_node insertSubnode:node atIndex:p];
    i += 1;
  }
}

- (void)applySubnodeRemovals
{
  ASDN::MutexSharedLocker l(__instanceLock__);
  [self calculateSubnodeOperationsIfNeeded];
  for (ASDisplayNode *subnode in _removedSubnodes) {
    [subnode removeFromSupernode];
  }
}

- (void)calculateSubnodeOperationsIfNeeded
{
  ASDN::MutexSharedLocker l(__instanceLock__);
  if (_calculatedSubnodeOperations) {
    return;
  }
  if (_previousLayout) {
    NSIndexSet *insertions, *deletions;
    [_previousLayout.sublayouts asdk_diffWithArray:_pendingLayout.sublayouts
                                                 insertions:&insertions
                                                  deletions:&deletions
                                               compareBlock:^BOOL(ASLayout *lhs, ASLayout *rhs) {
                                                 return ASObjectIsEqual(lhs.layoutableObject, rhs.layoutableObject);
                                               }];
    findNodesInLayoutAtIndexes(_pendingLayout, insertions, &_insertedSubnodes, &_insertedSubnodePositions);
    findNodesInLayoutAtIndexesWithFilteredNodes(_previousLayout,
                                                      deletions,
                                                      _insertedSubnodes,
                                                      &_removedSubnodes,
                                                      &_removedSubnodePositions);
  } else {
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [_pendingLayout.sublayouts count])];
    findNodesInLayoutAtIndexes(_pendingLayout, indexes, &_insertedSubnodes, &_insertedSubnodePositions);
    _removedSubnodes = nil;
  }
  _calculatedSubnodeOperations = YES;
}

#pragma mark - _ASTransitionContextDelegate

- (NSArray<ASDisplayNode *> *)currentSubnodesWithTransitionContext:(_ASTransitionContext *)context
{
  ASDN::MutexSharedLocker l(__instanceLock__);
  return _node.subnodes;
}

- (NSArray<ASDisplayNode *> *)insertedSubnodesWithTransitionContext:(_ASTransitionContext *)context
{
  ASDN::MutexSharedLocker l(__instanceLock__);
  [self calculateSubnodeOperationsIfNeeded];
  return _insertedSubnodes;
}

- (NSArray<ASDisplayNode *> *)removedSubnodesWithTransitionContext:(_ASTransitionContext *)context
{
  ASDN::MutexSharedLocker l(__instanceLock__);
  [self calculateSubnodeOperationsIfNeeded];
  return _removedSubnodes;
}

- (ASLayout *)transitionContext:(_ASTransitionContext *)context layoutForKey:(NSString *)key
{
  ASDN::MutexSharedLocker l(__instanceLock__);
  if ([key isEqualToString:ASTransitionContextFromLayoutKey]) {
    return _previousLayout;
  } else if ([key isEqualToString:ASTransitionContextToLayoutKey]) {
    return _pendingLayout;
  } else {
    return nil;
  }
}

- (ASSizeRange)transitionContext:(_ASTransitionContext *)context constrainedSizeForKey:(NSString *)key
{
  ASDN::MutexSharedLocker l(__instanceLock__);
  if ([key isEqualToString:ASTransitionContextFromLayoutKey]) {
    return _previousLayout.constrainedSizeRange;
  } else if ([key isEqualToString:ASTransitionContextToLayoutKey]) {
    return _pendingLayout.constrainedSizeRange;
  } else {
    return ASSizeRangeMake(CGSizeZero, CGSizeZero);
  }
}

#pragma mark - Filter helpers

/**
 * @abstract Stores the nodes at the given indexes in the `storedNodes` array, storing indexes in a `storedPositions` c++ vector.
 */
static inline void findNodesInLayoutAtIndexes(ASLayout *layout,
                                              NSIndexSet *indexes,
                                              NSArray<ASDisplayNode *> * __strong *storedNodes,
                                              std::vector<NSUInteger> *storedPositions)
{
  findNodesInLayoutAtIndexesWithFilteredNodes(layout, indexes, nil, storedNodes, storedPositions);
}

/**
 * @abstract Stores the nodes at the given indexes in the `storedNodes` array, storing indexes in a `storedPositions` c++ vector.
 * @discussion If the node exists in the `filteredNodes` array, the node is not added to `storedNodes`.
 */
static inline void findNodesInLayoutAtIndexesWithFilteredNodes(ASLayout *layout,
                                                               NSIndexSet *indexes,
                                                               NSArray<ASDisplayNode *> *filteredNodes,
                                                               NSArray<ASDisplayNode *> * __strong *storedNodes,
                                                               std::vector<NSUInteger> *storedPositions)
{
  NSMutableArray<ASDisplayNode *> *nodes = [NSMutableArray arrayWithCapacity:indexes.count];
  std::vector<NSUInteger> positions = std::vector<NSUInteger>();
  // From inspection, this is how enumerateObjectsAtIndexes: works under the hood
  NSUInteger firstIndex = indexes.firstIndex;
  NSUInteger lastIndex = indexes.lastIndex;
  NSUInteger idx = 0;
  for (ASLayout *sublayout in layout.sublayouts) {
    if (idx > lastIndex) { break; }
    if (idx >= firstIndex && [indexes containsIndex:idx]) {
      ASDisplayNode *node = (ASDisplayNode *)sublayout.layoutableObject;
      ASDisplayNodeCAssert(node, @"A flattened layout must consist exclusively of node sublayouts");
      // Ignore the odd case in which a non-node sublayout is accessed and the type cast fails
      if (node != nil) {
        BOOL notFiltered = (filteredNodes == nil || [filteredNodes indexOfObjectIdenticalTo:node] == NSNotFound);
        if (notFiltered) {
          [nodes addObject:node];
          positions.push_back(idx);
        }
      }
    }
    idx += 1;
  }
  *storedNodes = nodes;
  *storedPositions = positions;
}

@end
