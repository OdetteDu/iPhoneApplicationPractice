//
//  Photo+Flickr.h
//  CoreDataSPoT
//
//  Created by Caidie on 10/24/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+(Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
inManagedObjectContext:(NSManagedObjectContext *)context;

@end
