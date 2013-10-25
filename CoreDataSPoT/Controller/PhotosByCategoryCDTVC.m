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

@interface PhotosByCategoryCDTVC ()

@end

@implementation PhotosByCategoryCDTVC

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"Show Image"]) {
            Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
            NSURL *url = [[NSURL alloc] initWithString:photo.imageURL];
            
            if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)])
            {
                [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                NSLog(@"%@", photo.imageURL);
                [segue.destinationViewController setTitle:photo.title];
            }
        }
    }
}

- (void)setPhotoCategory:(PhotoCategory *)photoCategory
{
    _photoCategory = photoCategory;
    self.title = photoCategory.name;
    [self setupFetchedResultsController];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo"];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    
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
