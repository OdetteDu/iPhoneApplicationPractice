//
//  CategoryTableViewController.m
//  SPoT
//
//  Created by Caidie on 10/11/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoManager.h"
#import "PhotoTableViewController.h"

@interface CategoryTableViewController ()
@property (strong, nonatomic) PhotoManager *photoManager;

@end

@implementation CategoryTableViewController

- (PhotoManager *)photoManager
{
    if(!_photoManager) _photoManager=[[PhotoManager alloc] init];
    return _photoManager;
}

- (void) setCategories:(NSArray *)categories
{
    _categories=categories;
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
    self.categories = [self.photoManager getCategoriesList];
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
            if([segue.identifier isEqualToString:@"Show List"])
            {
                if ([segue.destinationViewController isKindOfClass:[PhotoTableViewController class]])
                {
                    NSString *category=[sender textLabel].text;
                    PhotoTableViewController *photoTVC=(PhotoTableViewController *)segue.destinationViewController;
                    [photoTVC setPhotos:[self.photoManager getPhotosWithCategory:category]];
                    [segue.destinationViewController setTitle:category];
                }
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categories count];
}

- (NSString *)titleForRow:(NSUInteger)row
{
    return self.categories[row];
}

- (NSString *)subtitleForRow:(NSInteger)row
{
    return [NSString stringWithFormat:@"%d",[self.photoManager getCountForCategory:self.categories[row]]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Category";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}
@end
