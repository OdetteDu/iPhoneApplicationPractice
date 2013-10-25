//
//  PhotosByLastAccessCDTVC.m
//  CoreDataSPoT
//
//  Created by Caidie on 10/25/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "PhotosByLastAccessCDTVC.h"
#import "Photo+Flickr.h"
#import "FlickrFetcher.h"

@interface PhotosByLastAccessCDTVC ()

@end

@implementation PhotosByLastAccessCDTVC

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath)
    {
        if ([segue.identifier isEqualToString:@"Show Image"])
        {
            Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
            NSURL *url = [[NSURL alloc] initWithString:photo.imageURL];
            
            if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)])
            {
                [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                [segue.destinationViewController setTitle:photo.title];
            }
            
            photo.lastAccessDate = [NSDate date];
            
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext)
    {
        [self useDocument];
    }
}

- (void)useDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Demo Document"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success){
              if (success) {
                  self.managedObjectContext = document.managedObjectContext;
                  [self refresh];
              }
          }];
    }
    else if (document.documentState == UIDocumentStateClosed)
    {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    }
    else
    {
        self.managedObjectContext = document.managedObjectContext;
    }
}

- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *photos = [FlickrFetcher stanfordPhotos];
        // put the photos in Core Data
        [self.managedObjectContext performBlock:^{
            for (NSDictionary *photo in photos)
            {
                [Photo photoWithFlickrInfo:photo inManagedObjectContext:self.managedObjectContext];
            }
            dispatch_async(dispatch_get_main_queue(),^{
                [self.refreshControl endRefreshing];
            });
        }];
    });
}

- (void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastAccessDate" ascending:NO]];
        request.predicate = nil;
        request.fetchLimit = 5;
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        
    }
    else
    {
        self.fetchedResultsController = nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo"];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    
    NSURL *url = [[NSURL alloc] initWithString:photo.thumbnailURL];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
    //photo.thumbnailImage = imageData;
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    cell.imageView.image = image;
    
    return cell;
}

@end
