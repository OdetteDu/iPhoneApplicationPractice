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
@property (nonatomic, strong) NSMutableDictionary *categories; //of NSArray of photos in that categories (photos is type of NSDitionary
//@property (nonatomic, strong) NSMutableArray *recentPhotos;
@end

@implementation PhotoManager



//- (NSMutableArray *)recentPhotos
//{
//    if(!_recentPhotos) _recentPhotos=[[NSMutableArray alloc]init];
//    return _recentPhotos;
//}

- (NSMutableDictionary *)categories
{
    if(!_categories)
    {
        _categories = [[NSMutableDictionary alloc] init];
        [self parsePhotos];
    }
    return _categories;
}

- (NSArray *)photos
{
    if(!_photos) _photos = [FlickrFetcher stanfordPhotos];
    return _photos;
}

//- (void) addRecentlyViewedPhoto: (NSDictionary *)photo
//{
//    NSLog(@"%@",[photo[FLICKR_PHOTO_TITLE] description]);
//    [self.recentPhotos addObject:photo];
//}
//
//- (NSArray *) getRecentlyViewedPhotos: (NSUInteger) count
//{
//    NSMutableArray *photos=[[NSMutableArray alloc] init];
//    NSUInteger index= count<self.recentPhotos.count ? count : self.recentPhotos.count;
//
//    while (index>0)
//    {
//        [photos addObject:self.recentPhotos[index-1]];
//        index--;
//    }
//    return photos;
//}

- (NSArray *)getPhotosWithCategory: (NSString *) category
{
    return self.categories[category];
}

- (NSArray *)getCategoriesList
{
    NSMutableArray *list= [[NSMutableArray alloc] init];
    NSEnumerator *enumerator = [self.categories keyEnumerator];
    id key;
    
    while ((key = [enumerator nextObject]))
    {
        if([key isKindOfClass:[NSString class]])
        {
            NSString *temp=(NSString*)key;
            [list addObject: temp];
        }
        
    }
    
    return list;
}

- (NSUInteger)getCountForCategory: (NSString *)category
{
    NSArray *temp=self.categories[category];
    return temp.count;
}

- (void)parsePhotos
{
    for(int i=0;i<self.photos.count;i++)
    {
        NSDictionary *photo=self.photos[i];
        NSString *tag=[photo[FLICKR_TAGS] description];
        NSArray *tags=[tag componentsSeparatedByString:@" "];
        for(int j=0;j<tags.count;j++)
        {
            NSString *currentTag=tags[j];
            if([currentTag compare:@"cs193pspot"] && [currentTag compare:@"portrait"] && [currentTag compare:@"landscape"])
            {
                if( self.categories[currentTag] == nil)
                {
                    NSMutableArray *tempArray=[[NSMutableArray alloc] init];
                    [tempArray addObject:photo];
                    [self.categories setObject: tempArray forKey:currentTag];
                }
                else
                {
                    NSMutableArray *tempArray=self.categories[currentTag];
                    [tempArray addObject:photo];
                }
            }
            
        }
    }
}



@end