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
    self.game.useThreeCard=YES;
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
            
            NSString *cardContents=shapeCard.contents;
            NSRange rangeOfColor=[cardContents rangeOfString: @"Color:"];
            if(rangeOfColor.location!=NSNotFound)
            {
                cardContents=[cardContents substringToIndex:rangeOfColor.location-1];
            }
            
            
            NSMutableAttributedString *coloredCardContents=[[NSMutableAttributedString alloc] initWithString:cardContents];
            
            
            
            
            if([shapeCard.shading compare:@"Empty"]==0)
            {
                [coloredCardContents addAttributes: @{NSForegroundColorAttributeName: [UIColor whiteColor],NSStrokeColorAttributeName: [self getColor: shapeCard.color], NSStrokeWidthAttributeName: @-5} range:[cardContents rangeOfString: cardContents]];
            }
            else if([shapeCard.shading compare:@"Stripe"]==0)
            {
                [coloredCardContents addAttributes: @{NSForegroundColorAttributeName: [UIColor grayColor],NSStrokeColorAttributeName: [self getColor: shapeCard.color],NSStrokeWidthAttributeName: @-5} range:[cardContents rangeOfString: cardContents]];
            }
            else if([shapeCard.shading compare:@"Fill"]==0)
            {
                [coloredCardContents addAttributes: @{NSForegroundColorAttributeName: [self getColor: shapeCard.color]} range:[cardContents rangeOfString: cardContents]];
            }
            
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
            
            [cardButton setAttributedTitle:coloredCardContents forState:UIControlStateNormal];
            
        }
    }
    
    
    
    [super updateUI];
}

-(NSMutableAttributedString *)parseDescription: (NSString *)description
{
    NSMutableAttributedString *coloredDescription = [[NSMutableAttributedString alloc] init];
    NSArray *temp=[description componentsSeparatedByString:@" "];
    NSRange r={NSNotFound,NSNotFound};
    for(int i=0;i<temp.count;i++)
    {
        NSString *s=temp[i];
        if([s compare: @"Color:"]==0)
        {
            i++;
            s=temp[i];
            UIColor *color=[self getColor:s];
            if(r.location!=NSNotFound)
            {
                NSUInteger x=r.location+r.length;
                r=[[[coloredDescription mutableString] substringFromIndex:x] rangeOfString:temp[i-2]];
                r.location+=x;
            }
            else
            {
                r=[[coloredDescription mutableString] rangeOfString:temp[i-2]];
            }
            
            i+=2;
            s=temp[i];
            
            if([s compare:@"Empty"]==0)
            {
                [coloredDescription addAttributes: @{NSForegroundColorAttributeName: [UIColor whiteColor],NSStrokeColorAttributeName: color, NSStrokeWidthAttributeName: @-5} range:r];
            }
            else if([s compare:@"Stripe"]==0)
            {
                [coloredDescription addAttributes: @{NSForegroundColorAttributeName: [UIColor grayColor],NSStrokeColorAttributeName: color,NSStrokeWidthAttributeName: @-5} range:r];
            }
            else if([s compare:@"Fill"]==0)
            {
                [coloredDescription addAttributes: @{NSForegroundColorAttributeName: color} range:r];
            }
            //[coloredDescription addAttributes: @{NSForegroundColorAttributeName: color} range: r];
        }
        else
        {
            s=[s stringByAppendingString:@" "];
            [coloredDescription appendAttributedString:[[NSMutableAttributedString alloc] initWithString:s]];
        }
    }
    
    return coloredDescription;
}

- (IBAction)flipCard:(UIButton *)sender
{
    self.description=[self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self.descriptionLabel setAttributedText:[self parseDescription:self.description]];
    [super flipCard:sender];
}

@end
