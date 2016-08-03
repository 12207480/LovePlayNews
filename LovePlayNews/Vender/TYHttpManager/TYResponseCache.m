//
//  TYResponseCache.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYResponseCache.h"
#import <CommonCrypto/CommonDigest.h>

@interface TYResponseCache ()

@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *cachePath;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

static NSString * const TYRequestManagerCacheDirectory = @"TYRequestCacheDirectory";

@implementation TYResponseCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create([TYRequestManagerCacheDirectory UTF8String], DISPATCH_QUEUE_CONCURRENT);
        [self createCachesDirectory];
    }
    return self;
}

- (void)createCachesDirectory
{
    _fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _cachePath = [cachePath stringByAppendingPathComponent:TYRequestManagerCacheDirectory];
    BOOL isDirectory;
    if (![_fileManager fileExistsAtPath:_cachePath isDirectory:&isDirectory]) {
        __autoreleasing NSError *error = nil;
        BOOL created = [_fileManager createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!created) {
            NSLog(@"<> - create cache directory failed with error:%@", error);
        }
    }
}

- (NSString *)md5String:(NSString *)str
{
    const char *cStr = [str UTF8String];
    if (cStr == NULL) {
        cStr = "";
    }
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key
{
    NSString *encodedKey = [self md5String:key];
    dispatch_async(_queue, ^{
        NSString *filePath = [_cachePath stringByAppendingPathComponent:encodedKey];
        BOOL written = [NSKeyedArchiver archiveRootObject:object toFile:filePath];
        if (!written) {
            NSLog(@"<> - set object to file failed");
        }
    });
}

- (id <NSCoding>)objectForKey:(NSString *)key
{
    return [self objectForKey:key overdueDate:nil];
}

- (id<NSCoding>)objectForKey:(NSString *)key overdueDate:(NSDate *)overdueDate
{
    NSString *encodedKey = [self md5String:key];
    id<NSCoding> object = nil;
    NSString *filePath = [_cachePath stringByAppendingPathComponent:encodedKey];
    
    if ([_fileManager fileExistsAtPath:filePath] ) {
        NSDate *modificationDate = [self cacheDateFilePath:filePath];
        if (!overdueDate || modificationDate.timeIntervalSince1970 - overdueDate.timeIntervalSince1970 >= 0) {
            object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        }else {
            NSLog(@"file cache was overdue");
        }
    }
    return object;
}

- (void)removeObjectForKey:(NSString *)key
{
    NSString *encodedKey = [self md5String:key];
    NSString *filePath = [_cachePath stringByAppendingPathComponent:encodedKey];
    if ([_fileManager fileExistsAtPath:filePath]) {
        __autoreleasing NSError *error = nil;
        BOOL removed = [_fileManager removeItemAtPath:filePath error:&error];
        if (!removed) {
            NSLog(@"<> - remove item failed with error:%@", error);
        }
    }
}

- (void)removeAllObjects
{
    __autoreleasing NSError *error;
    BOOL removed = [_fileManager removeItemAtPath:_cachePath error:&error];
    if (!removed) {
        NSLog(@" - remove cache directory failed with error:%@", error);
    }
}

#pragma mark - private

- (NSDate *)cacheDateFilePath:(NSString *)path {
    // get file attribute
    NSError *attributesRetrievalError = nil;
    NSDictionary *attributes = [_fileManager attributesOfItemAtPath:path
                                                              error:&attributesRetrievalError];
    if (!attributes) {
        NSLog(@"Error get attributes for file at %@: %@", path, attributesRetrievalError);
        return nil;
    }
    return [attributes fileModificationDate];
}

- (void)trimToDate:(NSDate *)date
{
    __autoreleasing NSError *error = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL URLWithString:_cachePath]
                                                   includingPropertiesForKeys:@[NSURLContentModificationDateKey]
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                        error:&error];
    if (error) {
        NSLog(@" - get files error:%@", error);
    }
    
    dispatch_async(_queue, ^{
        for (NSURL *fileURL in files) {
            NSDictionary *dictionary = [fileURL resourceValuesForKeys:@[NSURLContentModificationDateKey] error:nil];
            NSDate *modificationDate = [dictionary objectForKey:NSURLContentModificationDateKey];
            if (modificationDate.timeIntervalSince1970 - date.timeIntervalSince1970 < 0) {
                NSError *error = nil;
                if ([_fileManager removeItemAtURL:fileURL error:&error]) {
                    NSLog(@"delete cache yes");
                } else {
                    NSLog(@"delete cache no %@",fileURL.absoluteString);
                    
                }
                
            }
        }
    });
}

@end
