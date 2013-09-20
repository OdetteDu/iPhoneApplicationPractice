//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Caidie on 9/17/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "SetGameViewController.h"
#import "CardMatchingGame.h"
#import "ShapeCardDeck.h"
#import "ShapeCard.h"

@interface SetGameViewController ()
//@property (strong, nonatomic) CardMatchingGame *setgame;
@end

@implementation SetGameViewController

//@synthesize game=_game;
-(CardMatchingGame *)game
{
    if (!super.game) super.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[ShapeCardDeck alloc] init]];
    return super.game;
}

-(void)updateUI
{
    
    for(UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        if([card isKindOfClass:[ShapeCard class]])
        {
            ShapeCard *shapeCard=(ShapeCard *)card;
            UIColor *color;
            if([shapeCard.color compare: @"Green"]==0)
            {
                color=[UIColor greenColor];
                NSLog(@"Green");
            }
            else if([shapeCard.color compare: @"Blue"]==0)
            {
                color=[UIColor blueColor];
                NSLog(@"Blue");
            }
            else if([shapeCard.color compare: @"Red"]==0)
            {
                color=[UIColor redColor];
                NSLog(@"Red");
            }
            NSLog(@"Color is %@", shapeCard.color);
            NSMutableAttributedString *mas=[[NSMutableAttributedString alloc] initWithString:shapeCard.contents];
            [mas addAttributes: @{NSForegroundColorAttributeName: color} range:[shapeCard.contents rangeOfString: shapeCard.contents]];
            
            [cardButton setAttributedTitle:mas forState:UIControlStateNormal];
        }
        else
        {
            [cardButton setTitle:card.contents forState:UIControlStateNormal];
        }
        
        //[cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        if(card.isFaceUp)
        {
            [cardButton setBackgroundColor:[UIColor lightGrayColor]];
        }
        else
        {
            [cardButton setBackgroundColor:[UIColor whiteColor]];
        }
        
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.1 :1.0);
        
    }
    
    [super updateUI];
}

-(void)viewDidLoad
{
    self.game.useThreeCard=YES;
}

@end
