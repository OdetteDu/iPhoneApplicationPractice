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
@end

@implementation SetGameViewController

-(CardMatchingGame *)game
{
    if (!super.game) super.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[ShapeCardDeck alloc] init]];
    return super.game;
}

-(UIColor *)getColor:(NSString *)colorDescription
{
    UIColor *color;
    if([colorDescription compare: @"Green"]==0)
    {
        color=[UIColor greenColor];
    }
    else if([colorDescription compare: @"Blue"]==0)
    {
        color=[UIColor blueColor];
    }
    else if([colorDescription compare: @"Red"]==0)
    {
        color=[UIColor redColor];
    }
    return color;
}

-(void)updateUI
{
    for(UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        if([card isKindOfClass:[ShapeCard class]])
        {
            ShapeCard *shapeCard=(ShapeCard *)card;
            

            NSMutableAttributedString *cardContents=[[NSMutableAttributedString alloc] initWithString:shapeCard.contents];
            
            
            [cardContents addAttributes: @{NSForegroundColorAttributeName: [self getColor: shapeCard.color]} range:[shapeCard.contents rangeOfString: shapeCard.contents]];
            
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
