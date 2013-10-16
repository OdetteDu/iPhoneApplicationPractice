//
//  PhotoTableViewController.m
//  SPoT
//
//  Created by Caidie on 10/11/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "FlickrFetcher.h"
#import "RecentlyViewedPhotoSaver.h"

@interface PhotoTableViewController ()
@property (strong, nonatomic) RecentlyViewedPhotoSaver *photoSaver;

@end

@implementation PhotoTableViewController

- (RecentlyViewedPhotoSaver *)photoSaver
{
    if(!_photoSaver) _photoSaver=[[RecentlyViewedPhotoSaver alloc] init];
    return _photoSaver;
}

- (void) setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.photos = [FlickrFetcher stanfordPhotos];
    //self.photos = [self.photoManager getPhotosWithCategory:@"fountain"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if(indexPath)
        {
            if([segue.identifier isEqualToString:@"Show Image"])
            {
                if([segue.destinationViewController respondsToSelector:@selector(setImageURL:)])
                {
                    NSString *imageTitle=[sender textLabel].text;
                    NSString *imageDescription=[sender detailTextLabel].text;
                    for(int i=0;i<self.photos.count;i++)
                    {
                        if([[self.photos[i][FLICKR_PHOTO_TITLE] description] compare: imageTitle]==0 &&
                           [[self.photos[i][@"description"][FLICKR_PLACE_NAME] description] compare: imageDescription]==0)
                        {
                            [self.photoSaver addRecentlyViewedPhoto:self.photos[i]];
                        }
                    }
                    
                    NSURL *url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatLarge];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (NSString *)titleForRow:(NSUInteger)row
{
    return [self.photos[row][FLICKR_PHOTO_TITLE] description];
}

- (NSString *)subtitleForRow:(NSInteger)row
{
    return [self.photos[row][@"description"][FLICKR_PLACE_NAME] description];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

@end
