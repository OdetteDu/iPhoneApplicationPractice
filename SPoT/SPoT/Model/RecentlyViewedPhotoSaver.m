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
//@property (nonatomic, strong) NSMutableArray *recentPhotos;
@property (nonatomic, strong) NSMutableArray *recentPhotoIds;//of NSString
@end

@implementation RecentlyViewedPhotoSaver

- (NSMutableArray *)recentPhotoIds
{
    if(!_recentPhotoIds) _recentPhotoIds=[[NSMutableArray alloc]init];
    return _recentPhotoIds;
}

- (void) addRecentlyViewedPhoto: (NSDictionary *)photo
{
    [self readFromDisk];
    
    for(int i=0;i<self.recentPhotoIds.count;i++)
    {
        if([self.recentPhotoIds[i] compare: photo[FLICKR_PHOTO_ID]]==0)
        {
            [self.recentPhotoIds removeObject:self.recentPhotoIds[i]];
            break;
        }
    }

    [self.recentPhotoIds addObject:photo[FLICKR_PHOTO_ID]];
    
    if(self.recentPhotoIds.count > RECENTLY_VIEWED_PHOTO_CAPACITY)
    {
        [self.recentPhotoIds removeObjectAtIndex:0];
    }
    
    [self saveToDisk];
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

@end
