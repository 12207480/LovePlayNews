//
//  LPNewsBreifCellNode.m
//  LovePlayNews
//
//  Created by tany on 16/8/11.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsBreifCellNode.h"

@interface LPNewsBreifCellNode ()

@property (nonatomic, strong) NSString *breif;

@end

@implementation LPNewsBreifCellNode

- (instancetype)initWithBreif:(NSString *)breif
{
    if (self = [super init]) {
        _breif = breif;
    }
    return self;
}

@end
