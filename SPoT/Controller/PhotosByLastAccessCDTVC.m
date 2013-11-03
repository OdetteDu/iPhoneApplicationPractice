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
#import "FileSaver.h"
#import "PhotoCategoryCDTVC.h"

@interface PhotosByLastAccessCDTVC () <UISplitViewControllerDelegate>

@end

@implementation PhotosByLastAccessCDTVC

- (void)awakeFromNib
{
    self.splitViewController.delegate=self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void) splitViewController:(UISplitViewController *)svc
      willHideViewController:(UIViewController *)aViewController
           withBarButtonItem:(UIBarButtonItem *)barButtonItem
        forPopoverController:(UIPopoverController *)pc
{
    
    barButtonItem.title = @"Navigation";
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    [detailViewController setSplitViewBarButtonItem:barButtonItem];
    
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

            if ([segue.destinationViewController isKindOfClass:[ImageViewController class]])
            {
                ImageViewController *ivc = (ImageViewController *)segue.destinationViewController;
                [ivc setPhoto: photo.unique withURL: photo.imageURL];
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
        //get the managedObjectContext from superview
        UITabBarController *tbc = self.tabBarController;
        if(tbc)
        {
            NSArray *tbcs = tbc.viewControllers;
            UIViewController *fvc = [tbcs objectAtIndex:0];
            if([fvc isKindOfClass:[UINavigationController class]])
            {
                UINavigationController *nc = (UINavigationController *)fvc;
                NSArray *ncs = nc.viewControllers;
                UIViewController *vc=[ncs objectAtIndex:0];
                if([vc isKindOfClass:[PhotoCategoryCDTVC class]])
                {
                    PhotoCategoryCDTVC *pccdtvc = (PhotoCategoryCDTVC *)vc;
                    self.managedObjectContext = pccdtvc.managedObjectContext;
                }
            }
        }
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
                
            }
        }
        
    }
}

- (void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastAccessDate" ascending:NO]];
        //request.predicate = nil;
        request.predicate = [NSPredicate predicateWithFormat:@"lastAccessDate != %@", nil];
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

- (IBAction)refresh:(id)sender {
    [self.refreshControl beginRefreshing];
    [NSThread sleepForTimeInterval:0.5];
    [self.refreshControl endRefreshing];
}
@end
