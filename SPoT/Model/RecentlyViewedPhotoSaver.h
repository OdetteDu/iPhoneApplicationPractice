//
//  RecentlyViewedPhotoSaver.h
//  SPoT
//
//  Created by Caidie on 10/14/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RECENTLY_VIEWED_PHOTO_CAPACITY 10
#define RECENTLY_VIEWED_PHOTO_KEY @"Recently_Viewed_Photo_Key"

@interface RecentlyViewedPhotoSaver : NSObject
- (void) addRecentlyViewedPhoto: (NSString *)photoID;
- (NSArray *) getRecentlyViewedPhotos;
- (NSData *) getCachedPhoto: (NSString *)photoID;

@end
