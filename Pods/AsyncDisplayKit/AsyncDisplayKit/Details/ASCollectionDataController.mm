//
//  ASCollectionDataController.mm
//  AsyncDisplayKit
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//

#import "ASCollectionDataController.h"

#import "ASAssert.h"
#import "ASMultidimensionalArrayUtils.h"
#import "ASCellNode.h"
#import "ASDataController+Subclasses.h"
#import "ASIndexedNodeContext.h"

//#define LOG(...) NSLog(__VA_ARGS__)
#define LOG(...)

@interface ASCollectionDataController () {
  BOOL _dataSourceImplementsSupplementaryNodeBlockOfKindAtIndexPath;
}

- (id<ASCollectionDataControllerSource>)collectionDataSource;

@end

@implementation ASCollectionDataController {
  NSMutableDictionary<NSString *, NSMutableArray<ASIndexedNodeContext *> *> *_pendingContexts;
}

- (instancetype)init
{
  self = [super init];
  if (self != nil) {
    _pendingContexts = [NSMutableDictionary dictionary];
  }
  return self;
}

- (void)prepareForReloadData
{
  for (NSString *kind in [self supplementaryKinds]) {
    LOG(@"Populating elements of kind: %@", kind);
    NSMutableArray<ASIndexedNodeContext *> *contexts = [NSMutableArray array];
    [self _populateSupplementaryNodesOfKind:kind withMutableContexts:contexts];
    _pendingContexts[kind] = contexts;
  }
}

- (void)willReloadData
{
  [_pendingContexts enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull kind, NSMutableArray<ASIndexedNodeContext *> * _Nonnull contexts, __unused BOOL * _Nonnull stop) {
    // Remove everything that existed before the reload, now that we're ready to insert replacements
    NSArray *indexPaths = [self indexPathsForEditingNodesOfKind:kind];
    [self deleteNodesOfKind:kind atIndexPaths:indexPaths completion:nil];
    
    NSArray *editingNodes = [self editingNodesOfKind:kind];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, editingNodes.count)];
    [self deleteSectionsOfKind:kind atIndexSet:indexSet completion:nil];
    
    // Insert each section
    NSUInteger sectionCount = [self.collectionDataSource dataController:self numberOfSectionsForSupplementaryNodeOfKind:kind];
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    for (int i = 0; i < sectionCount; i++) {
      [sections addObject:[NSMutableArray array]];
    }
    [self insertSections:sections ofKind:kind atIndexSet:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sectionCount)] completion:nil];
    
    [self batchLayoutNodesFromContexts:contexts ofKind:kind completion:^(NSArray<ASCellNode *> *nodes, NSArray<NSIndexPath *> *indexPaths) {
      [self insertNodes:nodes ofKind:kind atIndexPaths:indexPaths completion:nil];
    }];
  }];
  [_pendingContexts removeAllObjects];
}

- (void)prepareForInsertSections:(NSIndexSet *)sections
{
  for (NSString *kind in [self supplementaryKinds]) {
    LOG(@"Populating elements of kind: %@, for sections: %@", kind, sections);
    NSMutableArray<ASIndexedNodeContext *> *contexts = [NSMutableArray array];
    [self _populateSupplementaryNodesOfKind:kind withSections:sections mutableContexts:contexts];
    _pendingContexts[kind] = contexts;
  }
}

- (void)willInsertSections:(NSIndexSet *)sections
{
  [_pendingContexts enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull kind, NSMutableArray<ASIndexedNodeContext *> * _Nonnull contexts, BOOL * _Nonnull stop) {
    NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:sections.count];
    for (NSUInteger i = 0; i < sections.count; i++) {
      [sectionArray addObject:[NSMutableArray array]];
    }
    
    [self insertSections:sectionArray ofKind:kind atIndexSet:sections completion:nil];
    [self batchLayoutNodesFromContexts:contexts ofKind:kind completion:^(NSArray<ASCellNode *> *nodes, NSArray<NSIndexPath *> *indexPaths) {
      [self insertNodes:nodes ofKind:kind atIndexPaths:indexPaths completion:nil];
    }];
  }];
  [_pendingContexts removeAllObjects];
}

- (void)willDeleteSections:(NSIndexSet *)sections
{
  for (NSString *kind in [self supplementaryKinds]) {
    NSArray *indexPaths = ASIndexPathsForMultidimensionalArrayAtIndexSet([self editingNodesOfKind:kind], sections);
    
    [self deleteNodesOfKind:kind atIndexPaths:indexPaths completion:nil];
    [self deleteSectionsOfKind:kind atIndexSet:sections completion:nil];
  }
}

- (void)willMoveSection:(NSInteger)section toSection:(NSInteger)newSection
{
  NSIndexSet *sectionAsIndexSet = [NSIndexSet indexSetWithIndex:section];
  for (NSString *kind in [self supplementaryKinds]) {
    NSMutableArray *editingNodes = [self editingNodesOfKind:kind];
    NSArray *indexPaths = ASIndexPathsForMultidimensionalArrayAtIndexSet(editingNodes, sectionAsIndexSet);
    NSArray *nodes = ASFindElementsInMultidimensionalArrayAtIndexPaths(editingNodes, indexPaths);
    [self deleteNodesOfKind:kind atIndexPaths:indexPaths completion:nil];
    
    // update the section of indexpaths
    NSMutableArray *updatedIndexPaths = [[NSMutableArray alloc] initWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
      NSUInteger newItem = [indexPath indexAtPosition:indexPath.length - 1];
      NSIndexPath *mappedIndexPath = [NSIndexPath indexPathForItem:newItem inSection:newSection];
      [updatedIndexPaths addObject:mappedIndexPath];
    }
    [self insertNodes:nodes ofKind:kind atIndexPaths:indexPaths completion:nil];
  }
}

- (void)prepareForInsertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
  for (NSString *kind in [self supplementaryKinds]) {
    LOG(@"Populating elements of kind: %@, for index paths: %@", kind, indexPaths);
    NSMutableArray<ASIndexedNodeContext *> *contexts = [NSMutableArray array];
    [self _populateSupplementaryNodesOfKind:kind atIndexPaths:indexPaths mutableContexts:contexts];
    _pendingContexts[kind] = contexts;
  }
}

- (void)willInsertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
  [_pendingContexts enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull kind, NSMutableArray<ASIndexedNodeContext *> * _Nonnull contexts, BOOL * _Nonnull stop) {
    [self batchLayoutNodesFromContexts:contexts ofKind:kind completion:^(NSArray<ASCellNode *> *nodes, NSArray<NSIndexPath *> *indexPaths) {
      [self insertNodes:nodes ofKind:kind atIndexPaths:indexPaths completion:nil];
    }];
  }];

  [_pendingContexts removeAllObjects];
}

- (void)prepareForDeleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
  for (NSString *kind in [self supplementaryKinds]) {
    NSMutableArray<ASIndexedNodeContext *> *contexts = [NSMutableArray array];
    [self _populateSupplementaryNodesOfKind:kind atIndexPaths:indexPaths mutableContexts:contexts];
    _pendingContexts[kind] = contexts;
  }
}

- (void)willDeleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
  for (NSString *kind in [self supplementaryKinds]) {
    NSArray<NSIndexPath *> *deletedIndexPaths = ASIndexPathsInMultidimensionalArrayIntersectingIndexPaths([self editingNodesOfKind:kind], indexPaths);

    [self deleteNodesOfKind:kind atIndexPaths:deletedIndexPaths completion:nil];

    // If any of the contexts remain after the deletion, re-insert them, e.g.
    // UICollectionElementKindSectionHeader remains even if item 0 is deleted.
    NSMutableArray<ASIndexedNodeContext *> *reinsertedContexts = [NSMutableArray array];
    for (ASIndexedNodeContext *context in _pendingContexts[kind]) {
      if ([deletedIndexPaths containsObject:context.indexPath]) {
        [reinsertedContexts addObject:context];
      }
    }
    
    [self batchLayoutNodesFromContexts:reinsertedContexts ofKind:kind completion:^(NSArray<ASCellNode *> *nodes, NSArray<NSIndexPath *> *indexPaths) {
      [self insertNodes:nodes ofKind:kind atIndexPaths:indexPaths completion:nil];
    }];
  }
  [_pendingContexts removeAllObjects];
}

- (void)_populateSupplementaryNodesOfKind:(NSString *)kind withMutableContexts:(NSMutableArray<ASIndexedNodeContext *> *)contexts
{
  id<ASEnvironment> environment = [self.environmentDelegate dataControllerEnvironment];
  ASEnvironmentTraitCollection environmentTraitCollection = environment.environmentTraitCollection;
  
  id<ASCollectionDataControllerSource> source = self.collectionDataSource;
  NSUInteger sectionCount = [source dataController:self numberOfSectionsForSupplementaryNodeOfKind:kind];
  for (NSUInteger i = 0; i < sectionCount; i++) {
    NSUInteger rowCount = [source dataController:self supplementaryNodesOfKind:kind inSection:i];
    for (NSUInteger j = 0; j < rowCount; j++) {
      NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
      [self _populateSupplementaryNodeOfKind:kind atIndexPath:indexPath mutableContexts:contexts environmentTraitCollection:environmentTraitCollection];
    }
  }
}

- (void)_populateSupplementaryNodesOfKind:(NSString *)kind withSections:(NSIndexSet *)sections mutableContexts:(NSMutableArray<ASIndexedNodeContext *> *)contexts
{
  id<ASEnvironment> environment = [self.environmentDelegate dataControllerEnvironment];
  ASEnvironmentTraitCollection environmentTraitCollection = environment.environmentTraitCollection;
  
  [sections enumerateRangesUsingBlock:^(NSRange range, BOOL * _Nonnull stop) {
    for (NSUInteger sec = range.location; sec < NSMaxRange(range); sec++) {
      NSUInteger itemCount = [self.collectionDataSource dataController:self supplementaryNodesOfKind:kind inSection:sec];
      for (NSUInteger i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:sec];
        [self _populateSupplementaryNodeOfKind:kind atIndexPath:indexPath mutableContexts:contexts environmentTraitCollection:environmentTraitCollection];
      }
    }
  }];
}

- (void)_populateSupplementaryNodesOfKind:(NSString *)kind atIndexPaths:(NSArray<NSIndexPath *> *)indexPaths mutableContexts:(NSMutableArray<ASIndexedNodeContext *> *)contexts
{
  id<ASEnvironment> environment = [self.environmentDelegate dataControllerEnvironment];
  ASEnvironmentTraitCollection environmentTraitCollection = environment.environmentTraitCollection;

  NSMutableIndexSet *sections = [NSMutableIndexSet indexSet];
  for (NSIndexPath *indexPath in indexPaths) {
    [sections addIndex:indexPath.section];
  }

  [sections enumerateRangesUsingBlock:^(NSRange range, BOOL * _Nonnull stop) {
    for (NSUInteger sec = range.location; sec < NSMaxRange(range); sec++) {
      NSUInteger itemCount = [self.collectionDataSource dataController:self supplementaryNodesOfKind:kind inSection:sec];
      for (NSUInteger i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:sec];
        [self _populateSupplementaryNodeOfKind:kind atIndexPath:indexPath mutableContexts:contexts environmentTraitCollection:environmentTraitCollection];
      }
    }
  }];
}

- (void)_populateSupplementaryNodeOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath mutableContexts:(NSMutableArray<ASIndexedNodeContext *> *)contexts environmentTraitCollection:(ASEnvironmentTraitCollection)environmentTraitCollection
{
      ASCellNodeBlock supplementaryCellBlock;
      if (_dataSourceImplementsSupplementaryNodeBlockOfKindAtIndexPath) {
        supplementaryCellBlock = [self.collectionDataSource dataController:self supplementaryNodeBlockOfKind:kind atIndexPath:indexPath];
      } else {
        ASCellNode *supplementaryNode = [self.collectionDataSource dataController:self supplementaryNodeOfKind:kind atIndexPath:indexPath];
        supplementaryCellBlock = ^{ return supplementaryNode; };
      }
      
      ASSizeRange constrainedSize = [self constrainedSizeForNodeOfKind:kind atIndexPath:indexPath];
      ASIndexedNodeContext *context = [[ASIndexedNodeContext alloc] initWithNodeBlock:supplementaryCellBlock
                                                                            indexPath:indexPath
                                                                        constrainedSize:constrainedSize
                                                           environmentTraitCollection:environmentTraitCollection];
      [contexts addObject:context];
}

#pragma mark - Sizing query

- (ASSizeRange)constrainedSizeForNodeOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  if ([kind isEqualToString:ASDataControllerRowNodeKind]) {
    return [super constrainedSizeForNodeOfKind:kind atIndexPath:indexPath];
  } else {
    return [self.collectionDataSource dataController:self constrainedSizeForSupplementaryNodeOfKind:kind atIndexPath:indexPath];
  }
}

#pragma mark - External supplementary store querying

- (ASCellNode *)supplementaryNodeOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  ASDisplayNodeAssertMainThread();
  NSArray *nodesOfKind = [self completedNodesOfKind:kind];
  NSInteger section = indexPath.section;
  if (section < nodesOfKind.count) {
    NSArray *nodesOfKindInSection = nodesOfKind[section];
    NSInteger itemIndex = indexPath.item;
    if (itemIndex < nodesOfKindInSection.count) {
      return nodesOfKindInSection[itemIndex];
    }
  }
  return nil;
}

#pragma mark - Private Helpers

- (NSArray *)supplementaryKinds
{
  return [self.collectionDataSource supplementaryNodeKindsInDataController:self];
}

- (id<ASCollectionDataControllerSource>)collectionDataSource
{
  return (id<ASCollectionDataControllerSource>)self.dataSource;
}

- (void)setDataSource:(id<ASDataControllerSource>)dataSource
{
  [super setDataSource:dataSource];
  _dataSourceImplementsSupplementaryNodeBlockOfKindAtIndexPath = [self.collectionDataSource respondsToSelector:@selector(dataController:supplementaryNodeBlockOfKind:atIndexPath:)];

  ASDisplayNodeAssertTrue(_dataSourceImplementsSupplementaryNodeBlockOfKindAtIndexPath || [self.collectionDataSource respondsToSelector:@selector(dataController:supplementaryNodeOfKind:atIndexPath:)]);
}

@end
