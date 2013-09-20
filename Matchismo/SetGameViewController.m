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
            }
            else if([shapeCard.color compare: @"Blue"]==0)
            {
                color=[UIColor blueColor];
            }
            else if([shapeCard.color compare: @"Red"]==0)
            {
                color=[UIColor redColor];
            }

            NSMutableAttributedString *cardContents=[[NSMutableAttributedString alloc] initWithString:shapeCard.contents];
            
            
            [cardContents addAttributes: @{NSForegroundColorAttributeName: color} range:[shapeCard.contents rangeOfString: shapeCard.contents]];
            
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
            
            [cardButton setAttributedTitle:cardContents forState:UIControlStateNormal];
            
        }
    }
    [super updateUI];
}

-(void)viewDidLoad
{
    self.game.useThreeCard=YES;
}

- (IBAction)flipCard:(UIButton *)sender
{
    self.description=[self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    
    [super flipCard:sender];
}

@end
