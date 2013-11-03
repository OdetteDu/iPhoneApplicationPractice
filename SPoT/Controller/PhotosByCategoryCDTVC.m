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
//@property (nonatomic, strong) NSFileManager *fileManager;
@end

@implementation PhotosByCategoryCDTVC

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
            
            if ([segue.destinationViewController isKindOfClass:[ImageViewController class]])
            {
                ImageViewController *ivc = (ImageViewController *)segue.destinationViewController;
                [ivc setPhoto: photo.unique withURL:photo.imageURL];
                [segue.destinationViewController setTitle:photo.title];
            }
            
            photo.lastAccessDate = [NSDate date];
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

- (IBAction)refresh:(id)sender {
    
    [self.refreshControl beginRefreshing];
    [NSThread sleepForTimeInterval:0.5];
    [self.refreshControl endRefreshing];
    
}
@end
