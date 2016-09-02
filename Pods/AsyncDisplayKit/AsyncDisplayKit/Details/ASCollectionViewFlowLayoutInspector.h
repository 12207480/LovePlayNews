//
//  ASCollectionViewFlowLayoutInspector.h
//  AsyncDisplayKit
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//

#pragma once

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/ASDimension.h>

@class ASCollectionView;
@protocol ASCollectionDataSource;
@protocol ASCollectionDelegate;

NS_ASSUME_NONNULL_BEGIN

@protocol ASCollectionViewLayoutInspecting <NSObject>

/**
 * Asks the inspector to provide a constarained size range for the given collection view node.
 */
- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 * Asks the inspector to provide a constrained size range for the given supplementary node.
 */
- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForSupplementaryNodeOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

/**
 * Asks the inspector for the number of supplementary sections in the collection view for the given kind.
 */
- (NSUInteger)collectionView:(ASCollectionView *)collectionView numberOfSectionsForSupplementaryNodeOfKind:(NSString *)kind;

/**
 * Asks the inspector for the number of supplementary views for the given kind in the specified section.
 */
- (NSUInteger)collectionView:(ASCollectionView *)collectionView supplementaryNodesOfKind:(NSString *)kind inSection:(NSUInteger)section;

/**
 * Allow the inspector to respond to delegate changes.
 *
 * @discussion A great time to update perform selector caches!
 */
- (void)didChangeCollectionViewDelegate:(nullable id<ASCollectionDelegate>)delegate;

/**
 * Allow the inspector to respond to dataSource changes.
 *
 * @discussion A great time to update perform selector caches!
 */
- (void)didChangeCollectionViewDataSource:(nullable id<ASCollectionDataSource>)dataSource;

@end

/**
 * A layout inspector for non-flow layouts that returns a constrained size to let the cells layout itself as
 * far as possible based on the scrollable direction of the collection view. It throws exceptions for delegate
 * methods that are related to supplementary node's management.
 */
@interface ASCollectionViewLayoutInspector : NSObject <ASCollectionViewLayoutInspecting>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCollectionView:(ASCollectionView *)collectionView NS_DESIGNATED_INITIALIZER;

@end

/**
 * A layout inspector implementation specific for the sizing behavior of UICollectionViewFlowLayouts
 */
@interface ASCollectionViewFlowLayoutInspector : NSObject <ASCollectionViewLayoutInspecting>

@property (nonatomic, weak, readonly) UICollectionViewFlowLayout *layout;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCollectionView:(ASCollectionView *)collectionView flowLayout:(UICollectionViewFlowLayout *)flowLayout NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
