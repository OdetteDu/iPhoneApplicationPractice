//
//  PhotoManager.m
//  SPoT
//
//  Created by Caidie on 10/11/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "PhotoManager.h"
#import "FlickrFetcher.h"

@interface PhotoManager()
@property (nonatomic, strong) NSArray *photos; // of NSDitionary 
@end

@implementation PhotoManager

- (NSArray *)photos
{
    if(!_photos) _photos = [FlickrFetcher stanfordPhotos];
    return _photos;
}

- (NSArray *)getPhotosWithCategory: (NSString *) category
{
    NSMutableArray *photosInCategory=[[NSMutableArray alloc] init]; //of NSDictionary
    for (int i=0;i<self.photos.count;i++)
    {
        NSDictionary *photo=self.photos[i];
        NSString *tag=[photo[FLICKR_TAGS] description];
        if([tag rangeOfString:category].length != NSNotFound)
        {
            [photosInCategory addObject:photo];
        }
    }
    return photosInCategory;
}



@end
