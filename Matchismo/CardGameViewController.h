//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Caidie on 8/31/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) NSString *description;

-(void)updateUI;
- (IBAction)flipCard:(UIButton *)sender;
@end
