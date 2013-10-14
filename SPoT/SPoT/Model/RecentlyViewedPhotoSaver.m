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
@property (nonatomic, strong) NSMutableArray *recentPhotos;
@end

@implementation RecentlyViewedPhotoSaver

- (NSMutableArray *)recentPhotos
{
    if(!_recentPhotos) _recentPhotos=[[NSMutableArray alloc]init];
    return _recentPhotos;
}

- (void) addRecentlyViewedPhoto: (NSDictionary *)photo
{
    [self synchronize];
    
    for(int i=0;i<self.recentPhotos.count;i++)
    {
        if(self.recentPhotos[i][FLICKR_PHOTO_ID]==photo[FLICKR_PHOTO_ID])
        {
            [self.recentPhotos removeObject:self.recentPhotos[i]];
            break;
        }
    }

    [self.recentPhotos addObject:photo];
    
    [self synchronize];
}

- (NSArray *) getRecentlyViewedPhotos
{
    [self synchronize];
    
    NSMutableArray *list=[[NSMutableArray alloc]init];
    for (int i=self.recentPhotos.count-1;i>=0;i--)
    {
        [list addObject:self.recentPhotos[i]];
    }
    
    return list;
}

- (void) synchronize
{
    
}

@end
