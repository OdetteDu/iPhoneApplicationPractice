//
//  ImageViewController.m
//  SPoT
//
//  Created by Caidie on 10/11/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scorllView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ImageViewController

- (void)setTitle:(NSString *)title
{
    super.title=title;
    self.titleBarButtonItem.title=title;
}

//- (void)setImageURL:(NSURL *)imageURL
//{
//    _imageURL = imageURL;
//    [self resetImage];
//}

- (void)setImageData:(NSData *)imageData
{
    _imageData = imageData;
    [self resetImage];
}

- (void)resetImage
{
    if (self.scorllView)
    {
        self.scorllView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        [self.spinner startAnimating];
//        NSURL *imageURL = self.imageURL;
        
        dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
        dispatch_async(imageFetchQ, ^{
            
            [NSThread sleepForTimeInterval:2.0];
            
//            if(!self.imageData)
//            {
//                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//                self.imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
//                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            }
            UIImage *image = [[UIImage alloc] initWithData:self.imageData];
            
//            if(self.imageURL == imageURL)
//            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image)
                    {
                        self.scorllView.zoomScale=1.0;
                        self.scorllView.contentSize=image.size;
                        self.imageView.image=image;
                        self.imageView.frame=CGRectMake(0,0, image.size.width, image.size.height);
                    }
                    [self.spinner stopAnimating];
                });
//            }
            
        });
        
    }
}

- (void) viewDidLayoutSubviews
{
    CGRect target = self.scorllView.bounds;
    CGSize source = self.imageView.image.size;
    
    if(target.size.width > target.size.height)
    {
        self.scorllView.zoomScale=target.size.width/source.width;
        self.scorllView.minimumZoomScale = target.size.height/source.height;
    }
    else
    {
        self.scorllView.zoomScale=target.size.height/source.height;
        self.scorllView.minimumZoomScale = target.size.width/source.width;
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
