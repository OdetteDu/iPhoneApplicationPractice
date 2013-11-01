//
//  PhotoCategory+Create.h
//  CoreDataSPoT
//
//  Created by Caidie on 10/24/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "PhotoCategory.h"

@interface PhotoCategory (Create)

+ (PhotoCategory *)photoCategoryWithName:(NSString *)name
                  inManagedObjectContext:(NSManagedObjectContext *)context;

@end
