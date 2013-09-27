//
//  SetCardGameViewController.m
//  GraphicalSet
//
//  Created by Caidie on 9/26/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardView.h"

@interface SetCardGameViewController ()
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;

@end

@implementation SetCardGameViewController

-(void)setSetCardView:(SetCardView *)setCardView
{
    _setCardView=setCardView;
    setCardView.fill=@"Striped";
    setCardView.color=@"Red";
    setCardView.shape=@"Diamonds";
    setCardView.count=3;
    
}

@end
