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

@end

@implementation ImageViewController

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

- (void)resetImage
{
    if (self.scorllView)
    {
        self.scorllView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        if (image)
        {
            self.scorllView.zoomScale=1.0;
            self.scorllView.contentSize=image.size;
            self.imageView.image=image;
            self.imageView.frame=CGRectMake(0,0, image.size.width, image.size.height);
        }
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
}


@end
