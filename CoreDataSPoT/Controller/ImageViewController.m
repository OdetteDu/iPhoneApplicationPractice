//
//  ImageViewController.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ImageViewController

- (void)setTitle:(NSString *)title
{
    super.title = title;
}

- (void)setImageData:(NSData *)imageData
{
    _imageData = imageData;
    [self resetImage];
}

- (void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        [self.spinner startAnimating];
        
        dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
        dispatch_async(imageFetchQ, ^{
            
            UIImage *image = [[UIImage alloc] initWithData:self.imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    self.scrollView.zoomScale = 1.0;
                    self.scrollView.contentSize = image.size;
                    self.imageView.image = image;
                    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                }
                [self.spinner stopAnimating];
            });
            
        });
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self resetImage];
}

- (void) viewDidLayoutSubviews
{
    CGRect target = self.scrollView.bounds;
    CGSize source = self.imageView.image.size;
    
    if(target.size.width > target.size.height)
    {
        self.scrollView.zoomScale=target.size.height/source.height;
        //self.scorllView.minimumZoomScale = target.size.height/source.height;
    }
    else
    {
        self.scrollView.zoomScale=target.size.width/source.width;
        //self.scorllView.minimumZoomScale = target.size.width/source.width;
    }
}

@end
