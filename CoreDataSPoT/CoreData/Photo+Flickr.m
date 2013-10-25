//
//  Photo+Flickr.m
//  CoreDataSPoT
//
//  Created by Caidie on 10/24/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "PhotoCategory+Create.h"

@implementation Photo (Flickr)

+(Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
       inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [photoDictionary[FLICKR_PHOTO_ID] description]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] >1))
    {
        //handle error
    }
    else if (![matches count])
    {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = [photoDictionary[FLICKR_PHOTO_ID] description];
        photo.title = [photoDictionary[FLICKR_PHOTO_TITLE] description];
        photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
        
        NSString *tag=[photoDictionary[FLICKR_TAGS] description];
        NSArray *tags=[tag componentsSeparatedByString:@" "];
        for(int j=0;j<tags.count;j++)
        {
            NSString *currentTag=tags[j];
            if([currentTag compare:@"cs193pspot"] && [currentTag compare:@"portrait"] && [currentTag compare:@"landscape"])
            {
                currentTag = [currentTag capitalizedString];
                NSString *photoCategoryName = currentTag;
                PhotoCategory *photoCategory = [PhotoCategory photoCategoryWithName:photoCategoryName inManagedObjectContext:context];
                photo.whichCategory = photoCategory;
            }
            
        }
        
        
    }
    else
    {
        photo = [matches lastObject];
    }
    
    return photo;
}

@end
