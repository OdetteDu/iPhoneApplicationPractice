//
//  ImageViewController.h
//  SPoT
//
//  Created by Caidie on 10/11/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (nonatomic, strong) NSURL *imageURL;

- (void)setImageURL:(NSURL *)imageURL;

@end