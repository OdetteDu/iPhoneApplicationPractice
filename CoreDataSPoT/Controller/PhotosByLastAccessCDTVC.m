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
#import "ImageViewController.h"

@interface PhotosByLastAccessCDTVC ()

@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation PhotosByLastAccessCDTVC

-(NSFileManager *)fileManager
{
    if(!_fileManager)_fileManager=[[NSFileManager alloc] init];
    return _fileManager;
}

- (void) savePhoto:(NSString *)photoID withData:(NSData *)data
{
    NSArray *urls = [self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *url=[[urls[0] URLByAppendingPathComponent:photoID] URLByAppendingPathExtension:@".jpg"];
    [data writeToURL:url atomically:YES];
}

- (NSData *) loadPhoto: (NSString *)photoID
{
    NSArray *urls = [self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *url=[[urls[0] URLByAppendingPathComponent:photoID] URLByAppendingPathExtension:@".jpg"];
    return [NSData dataWithContentsOfURL:url];
}

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
            
            NSData *imageData = [self loadPhoto:photo.unique];
            if(!imageData)
            {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                NSURL *url = [[NSURL alloc] initWithString:photo.imageURL];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                imageData = [[NSData alloc] initWithContentsOfURL:url];
                [self savePhoto:photo.unique withData:imageData];
            }
            
            if ([segue.destinationViewController respondsToSelector:@selector(setImageData:)])
            {
                [segue.destinationViewController performSelector:@selector(setImageData:) withObject:imageData];
                [segue.destinationViewController setTitle:photo.title];
            }
            
            photo.lastAccessDate = [NSDate date];
            
            [self.managedObjectContext save:nil];
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
    
    NSArray *photos = [self.fetchedResultsController fetchedObjects];
    for(int i=0; i<photos.count; i++)
    {
        if([[photos objectAtIndex:i] isKindOfClass:[Photo class]])
        {
            Photo *photo = (Photo *)[photos objectAtIndex:i];
            
            NSData *imageData=photo.thumbnailImage;
            if(!imageData)
            {
                NSURL *url = [[NSURL alloc] initWithString:photo.thumbnailURL];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                imageData = [[NSData alloc] initWithContentsOfURL:url];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                photo.thumbnailImage = imageData;
                [self.managedObjectContext save:nil];
                
            }
        }
        
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
    
    NSData *imageData=photo.thumbnailImage;
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    cell.imageView.image = image;
    
    return cell;
}

@end
