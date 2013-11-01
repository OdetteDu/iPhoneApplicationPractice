//
//  RecentlyViewedPhotoSaver.m
//  SPoT
//
//  Created by Caidie on 10/14/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "FileSaver.h"
#import "FlickrFetcher.h"
@interface FileSaver()
@property (nonatomic, strong) NSMutableArray *cachedPhotoIds;//of NSString
@property (nonatomic, strong) NSFileManager *fileManager;
@end

@implementation FileSaver

-(NSFileManager *)fileManager
{
    if(!_fileManager)_fileManager=[[NSFileManager alloc] init];
    return _fileManager;
}

- (NSMutableArray *)cachedPhotoIds
{
    if(!_cachedPhotoIds) _cachedPhotoIds = [[NSMutableArray alloc] init];
    return _cachedPhotoIds;
}

- (void) saveCachedPhotoIdsToDisk
{
    [[NSUserDefaults standardUserDefaults] setObject:self.cachedPhotoIds forKey:CACHED_PHOTO_KEY ];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) readCachedPhotoIdsFromDisk
{
    self.cachedPhotoIds = [[[NSUserDefaults standardUserDefaults] arrayForKey:CACHED_PHOTO_KEY ] mutableCopy];
}

- (void) savePhoto:(NSString *)photoID withData:(NSData *)data
{
    NSArray *urls = [self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *url=[[urls[0] URLByAppendingPathComponent:photoID] URLByAppendingPathExtension:@".jpg"];
    [data writeToURL:url atomically:YES];
}

- (void)removePhoto: (NSString *)photoID
{
    NSArray *urls = [self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *url=[[urls[0] URLByAppendingPathComponent:photoID] URLByAppendingPathExtension:@".jpg"];
    if([self.fileManager removeItemAtURL:url error:nil])
    {
        NSLog(@"remove cached photos");
    }
}

- (NSData *) loadPhoto: (NSString *)photoID
{
    NSArray *urls = [self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *url=[[urls[0] URLByAppendingPathComponent:photoID] URLByAppendingPathExtension:@".jpg"];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    return imageData;
}

- (NSData *) getCachedPhoto: (NSString *)photoID withURL: (NSString *)photoURL
{
    NSData *imageData = [self loadPhoto:photoID];
    
    if(!imageData)
    {
        NSLog(@"Get image data from the internet");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [NSThread sleepForTimeInterval:2.0];
        NSURL *url = [NSURL URLWithString:photoURL];
        imageData = [[NSData alloc] initWithContentsOfURL:url];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    else
    {
        NSLog(@"Get image data from the disk");
    }
    
    [self readCachedPhotoIdsFromDisk];
    [self.cachedPhotoIds removeObject:photoID];
    [self.cachedPhotoIds addObject:photoID];
    
    if(self.cachedPhotoIds.count > CACHED_PHOTO_CAPACITY)
    {
        [self removePhoto:[self.cachedPhotoIds objectAtIndex:0]];
        [self.cachedPhotoIds removeObjectAtIndex:0];
    }
    
    [self saveCachedPhotoIdsToDisk];
    [self savePhoto:photoID withData:imageData];
    
    return imageData;
}

@end
