//
//  Photo.h
//  CoreDataSPoT
//
//  Created by Caidie on 10/24/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoCategory;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSData * thumbnailImage;
@property (nonatomic, retain) NSDate * lastAccessDate;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) PhotoCategory *whichCategory;

@end