//
//  RecentlyViewedPhotoSaver.h
//  SPoT
//
//  Created by Caidie on 10/14/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CACHED_PHOTO_CAPACITY 4
#define CACHED_PHOTO_KEY @"Cached_Photo_Key"

@interface FileSaver : NSObject

- (NSData *) getCachedPhoto: (NSString *)photoID withURL: (NSString *)photoURL;

@end
