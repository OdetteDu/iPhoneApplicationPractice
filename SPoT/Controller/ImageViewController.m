//
//  ImageViewController.m
//  SPoT
//
//  Created by Caidie on 10/11/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "ImageViewController.h"
#import "RecentlyViewedPhotoSaver.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scorllView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSData *imageData;
@property (strong, nonatomic) RecentlyViewedPhotoSaver *photoSaver;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end

@implementation ImageViewController

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
//    UIToolbar *toolbar = self.toolbar;
//    NSMutableArray *toolbarItems = [toolbar.items mutableCopy];
//    if (_splitViewBarButtonItem) {
//        [toolbarItems removeObject:_splitViewBarButtonItem];
//    }
//    if (splitViewBarButtonItem) {
//        [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
//    }
//    toolbar.items = toolbarItems;
//    _splitViewBarButtonItem = splitViewBarButtonItem;
    self.toolbar.items = @[splitViewBarButtonItem];
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (RecentlyViewedPhotoSaver *)photoSaver
{
    if(!_photoSaver) _photoSaver=[[RecentlyViewedPhotoSaver alloc] init];
    return _photoSaver;
}

- (void)setTitle:(NSString *)title
{
    super.title=title;
    self.titleBarButtonItem.title=title;
}

- (void)setPhotoId:(NSString *)photoId
{
    _photoId = photoId;
    [self resetImage];
}

- (void)resetImage
{
    self.imageData = nil;
    
    if(!self.photoId)
        return;
    
    if (self.scorllView)
    {
        self.scorllView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        if (self.imageData)
        {
            UIImage *image = [[UIImage alloc] initWithData:self.imageData];
            self.scorllView.zoomScale=1.0;
            self.scorllView.contentSize=image.size;
            self.imageView.image=image;
            self.imageView.frame=CGRectMake(0,0, image.size.width, image.size.height);
            
        }
        else
        {
            [self.spinner startAnimating];
            
            dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
            dispatch_async(imageFetchQ, ^{

                self.imageData=[self.photoSaver getCachedPhoto: self.photoId];
                UIImage *image = [[UIImage alloc] initWithData:self.imageData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.scorllView.zoomScale=1.0;
                    self.scorllView.contentSize=image.size;
                    self.imageView.image=image;
                    self.imageView.frame=CGRectMake(0,0, image.size.width, image.size.height);
                    [self resetZoom];
                    [self.spinner stopAnimating];
                });
                
            });
        }
    }
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self resetZoom];
}

- (void) resetZoom
{
    CGRect target = self.scorllView.bounds;
    CGSize source = self.imageView.image.size;
    
    if(target.size.width > target.size.height)
    {
        self.scorllView.zoomScale=target.size.height/source.height;
    }
    else
    {
        self.scorllView.zoomScale=target.size.width/source.width;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (UIImageView *)imageView
{
    if(!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scorllView addSubview:self.imageView];
    self.scorllView.minimumZoomScale = 0.2;
    self.scorllView.maximumZoomScale = 5.0;
    self.scorllView.delegate = self;
	[self resetImage];
    self.titleBarButtonItem.title=self.title;
}


@end
