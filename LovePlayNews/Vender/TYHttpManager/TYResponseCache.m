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

+ (dispatch_queue_t)cacheQueue {
    static dispatch_queue_t cacheQueue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheQueue = dispatch_queue_create("com.TYResponseCache.cacheQueue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_set_target_queue(cacheQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    });
    return cacheQueue;
}

- (dispatch_queue_t)queue
{
    return [[self class] cacheQueue];
}

- (NSString *)cachePath
{
    if (_cachePath == nil) {
        _cachePath = [self createCachesDirectory];
    }
    return _cachePath;
}

- (NSFileManager *)fileManager
{
    @synchronized (_fileManager) {
        if (_fileManager == nil) {
            _fileManager = [NSFileManager defaultManager];
        }
        return _fileManager;
    }
}

- (NSString *)createCachesDirectory
{
    NSString *cachePathDic = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [cachePathDic stringByAppendingPathComponent:TYRequestManagerCacheDirectory];
    BOOL isDirectory;
    if (![self.fileManager fileExistsAtPath:cachePath isDirectory:&isDirectory]) {
        __autoreleasing NSError *error = nil;
        BOOL created = [self.fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!created) {
            NSLog(@"<> - create cache directory failed with error:%@", error);
        }
    }
    return cachePath;
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
    NSString *cachePath = self.cachePath;
    dispatch_async([self queue], ^{
        NSString *filePath = [cachePath stringByAppendingPathComponent:encodedKey];
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
    NSString *filePath = [self.cachePath stringByAppendingPathComponent:encodedKey];
    
    if ([self.fileManager fileExistsAtPath:filePath] ) {
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
    NSString *filePath = [self.cachePath stringByAppendingPathComponent:encodedKey];
    if ([self.fileManager fileExistsAtPath:filePath]) {
        __autoreleasing NSError *error = nil;
        BOOL removed = [self.fileManager removeItemAtPath:filePath error:&error];
        if (!removed) {
            NSLog(@"<> - remove item failed with error:%@", error);
        }
    }
}

- (void)removeAllObjects
{
    __autoreleasing NSError *error;
    BOOL removed = [self.fileManager removeItemAtPath:self.cachePath error:&error];
    if (!removed) {
        NSLog(@" - remove cache directory failed with error:%@", error);
    }
}

#pragma mark - private

- (NSDate *)cacheDateFilePath:(NSString *)path {
    // get file attribute
    NSError *attributesRetrievalError = nil;
    NSDictionary *attributes = [self.fileManager attributesOfItemAtPath:path
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
    NSArray *files = [self.fileManager contentsOfDirectoryAtURL:[NSURL URLWithString:self.cachePath]
                                                   includingPropertiesForKeys:@[NSURLContentModificationDateKey]
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                        error:&error];
    if (error) {
        NSLog(@" - get files error:%@", error);
    }
    
    dispatch_async([self queue], ^{
        for (NSURL *fileURL in files) {
            NSDictionary *dictionary = [fileURL resourceValuesForKeys:@[NSURLContentModificationDateKey] error:nil];
            NSDate *modificationDate = [dictionary objectForKey:NSURLContentModificationDateKey];
            if (modificationDate.timeIntervalSince1970 - date.timeIntervalSince1970 < 0) {
                NSError *error = nil;
                if ([self.fileManager removeItemAtURL:fileURL error:&error]) {
                    NSLog(@"delete cache yes");
                } else {
                    NSLog(@"delete cache no %@",fileURL.absoluteString);
                    
                }
                
            }
        }
    });
}

@end
