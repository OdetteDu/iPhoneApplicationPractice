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
#define CACHED_PHOTO_CAPACITY 4
#define CACHED_PHOTO_KEY @"Cached_Photo_Key"

@interface FileSaver : NSObject

- (NSData *) getCachedPhoto: (NSString *)photoID withURL: (NSString *)photoURL;

@end
