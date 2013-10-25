//
//  PhotosByCategoryCDTVC.m
//  CoreDataSPoT
//
//  Created by Caidie on 10/24/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "PhotosByCategoryCDTVC.h"
#import "Photo.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface PhotosByCategoryCDTVC ()
@property (nonatomic, strong) NSFileManager *fileManager;
@end

@implementation PhotosByCategoryCDTVC

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
            
            dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
            dispatch_async(imageFetchQ, ^{
                
                NSData *imageData = [self loadPhoto:photo.unique];
                if(!imageData)
                {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                    NSURL *url = [[NSURL alloc] initWithString:photo.imageURL];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    imageData = [[NSData alloc] initWithContentsOfURL:url];
                    [self savePhoto:photo.unique withData:imageData];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([segue.destinationViewController respondsToSelector:@selector(setImageData:)])
                    {
                        [segue.destinationViewController performSelector:@selector(setImageData:) withObject:imageData];
                        [segue.destinationViewController setTitle:photo.title];
                    }
                    
                });
                
                //photo.lastAccessDate = [NSDate date];
                //[self.photoCategory.managedObjectContext save:nil];
                
            });
        }
    }
}

- (void)setPhotoCategory:(PhotoCategory *)photoCategory
{
    _photoCategory = photoCategory;
    self.title = photoCategory.name;
    [self setupFetchedResultsController];
}

- (void)viewWillAppear:(BOOL)animated
{
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
                [self.photoCategory.managedObjectContext save:nil];
                
            }
        }
        
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

- (void)setupFetchedResultsController
{
    if (self.photoCategory.managedObjectContext)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"whichCategory = %@", self.photoCategory];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.photoCategory.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    }
    else
    {
        self.fetchedResultsController = nil;
    }
}

@end
