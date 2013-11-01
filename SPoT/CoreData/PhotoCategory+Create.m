//
//  PhotoCategory+Create.m
//  CoreDataSPoT
//
//  Created by Caidie on 10/24/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "PhotoCategory+Create.h"

@implementation PhotoCategory (Create)

+ (PhotoCategory *)photoCategoryWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    PhotoCategory *photoCategory = nil;
    
    // This is just like Photo(Flickr)'s method.  Look there for commentary.
    
    if (name.length) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PhotoCategory"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1))
        {
            // handle error
        }
        else if (![matches count])
        {
            photoCategory = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoCategory"
                                                          inManagedObjectContext:context];
            photoCategory.name = name;
        }
        
        else {
            photoCategory = [matches lastObject];
        }
    }
    
    return photoCategory;
}

@end
