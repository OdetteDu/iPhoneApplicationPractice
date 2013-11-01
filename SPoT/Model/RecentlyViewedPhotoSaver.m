//
//  RecentlyViewedPhotoSaver.m
//  SPoT
//
//  Created by Caidie on 10/14/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "RecentlyViewedPhotoSaver.h"
#import "FlickrFetcher.h"
@interface RecentlyViewedPhotoSaver()
@property (nonatomic, strong) NSArray *photos; // of NSDitionary
//@property (nonatomic, strong) NSMutableArray *recentPhotos;
@property (nonatomic, strong) NSMutableArray *recentPhotoIds;//of NSString
@property (nonatomic, strong) NSFileManager *fileManager;
@end

@implementation RecentlyViewedPhotoSaver

- (NSArray *)photos
{
    if(!_photos)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        _photos = [FlickrFetcher stanfordPhotos];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    return _photos;
}

-(NSFileManager *)fileManager
{
    if(!_fileManager)_fileManager=[[NSFileManager alloc] init];
    return _fileManager;
}

- (NSMutableArray *)recentPhotoIds
{
    if(!_recentPhotoIds) _recentPhotoIds=[[NSMutableArray alloc]init];
    return _recentPhotoIds;
}

- (void) addRecentlyViewedPhoto: (NSString *)photoID
{
    [self readFromDisk];
    
    [self.recentPhotoIds removeObject:photoID];

    [self.recentPhotoIds addObject:photoID];
    
    if(self.recentPhotoIds.count > RECENTLY_VIEWED_PHOTO_CAPACITY)
    {
        [self.recentPhotoIds removeObjectAtIndex:0];
    }
    
    [self saveToDisk];
    
    NSData *imageData = [self getCachedPhoto:photoID];
    
    [self savePhoto:photoID withData:imageData];
}

- (NSArray *) getRecentlyViewedPhotos
{
    [self readFromDisk];
    
    NSArray *photos= [FlickrFetcher stanfordPhotos];
    NSMutableArray *list=[[NSMutableArray alloc]init];
    for (int i=self.recentPhotoIds.count-1;i>=0;i--)
    {
        for (int j=0;j<photos.count;j++)
        {
            if([photos[j][FLICKR_PHOTO_ID] compare: self.recentPhotoIds[i]]==0)
            {
                [list addObject:photos[j]];
                break;
            }
        }
        
    }
    
    return list;
}

- (void) saveToDisk
{
    [[NSUserDefaults standardUserDefaults] setObject:self.recentPhotoIds forKey:RECENTLY_VIEWED_PHOTO_KEY ];
    [[NSUserDefaults standardUserDefaults] synchronize]; 
}

- (void) readFromDisk
{
    self.recentPhotoIds = [[[NSUserDefaults standardUserDefaults] arrayForKey:RECENTLY_VIEWED_PHOTO_KEY ] mutableCopy];
}

- (void) savePhoto:(NSString *)photoID withData:(NSData *)data
{
    NSArray *urls = [self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *url=[[urls[0] URLByAppendingPathComponent:photoID] URLByAppendingPathExtension:@".jpg"];
    [data writeToURL:url atomically:YES];
}

- (NSData *) loadPhoto: (NSString *)photoID
{
    NSArray *urls = [self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *url=[[urls[0] URLByAppendingPathComponent:photoID] URLByAppendingPathExtension:@".jpg"];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    return imageData;
}

- (NSData *) getCachedPhoto: (NSString *)photoID
{
    NSData *imageData = [self loadPhoto:photoID];
    if(!imageData)
    {
        NSLog(@"Get image data from the internet");
        NSDictionary *photo;
        for(int i=0; i<self.photos.count; i++)
        {
            if([photoID compare:[self.photos objectAtIndex:i][FLICKR_PHOTO_ID]]==0)
            {
                photo = [self.photos objectAtIndex:i];
                break;
            }
        }
        NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [NSThread sleepForTimeInterval:2.0];
        imageData = [[NSData alloc] initWithContentsOfURL:url];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    else
    {
        NSLog(@"Get image data from the disk");
    }
    
    return imageData;
}

@end
