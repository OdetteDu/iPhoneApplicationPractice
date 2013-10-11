//
//  PhotoManager.h
//  SPoT
//
//  Created by Caidie on 10/11/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoManager : NSObject

- (NSArray *)getPhotosWithCategory: (NSString *) category;

@end
