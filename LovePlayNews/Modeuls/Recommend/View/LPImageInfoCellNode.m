//
//  LPImageInfoNode.m
//  LovePlayNews
//
//  Created by tanyang on 16/8/27.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPImageInfoCellNode.h"

@interface LPImageInfoCellNode ()

@property (nonatomic, strong) LPTopicImageInfo *imageInfo;

@property (nonatomic, strong) ASNetworkImageNode *imageNode;

@end

@implementation LPImageInfoCellNode

- (instancetype)initWithImageInfo:(LPTopicImageInfo *)imageInfo
{
    if (self = [super init]) {
        _imageInfo = imageInfo;
        
        [self addImageNode];
    }
    return self;
}

- (void)addImageNode
{
    ASNetworkImageNode *imageNode = [[ASNetworkImageNode alloc]init];
    imageNode.placeholderEnabled = YES;
    imageNode.placeholderColor = RGB_255(245, 245, 245);
    imageNode.contentMode = UIViewContentModeScaleToFill;
    imageNode.layerBacked = YES;
    imageNode.URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://timge8.126.net/image?w=750&h=20000&quality=70&url=%@",_imageInfo.imgUrl]];
    [self addSubnode:imageNode];
    _imageNode = imageNode;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    _imageNode.preferredFrameSize = CGSizeMake(267, 113);
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:_imageNode];
    return insetLayout;
}

@end
