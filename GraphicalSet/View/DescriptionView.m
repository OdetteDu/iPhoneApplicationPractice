//
//  DescriptionView.m
//  GraphicalSet
//
//  Created by Caidie on 9/27/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "DescriptionView.h"
#import "PlayingCardView.h"
#import "SetCardView.h"
#import "CardView.h"
#import "Card.h"
#import "PlayingCard.h"
#import "ShapeCard.h"

@interface DescriptionView()
@end

@implementation DescriptionView

-(void)setMatch:(BOOL)match
{
    _match=match;
    [self setNeedsDisplay];
}

-(void)setActiveCards:(NSArray *)activeCards
{
    _activeCards=activeCards;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    BOOL useShapeCard=NO;
    int i;
    for(i=0;i<self.activeCards.count;i++)
    {
        Card *card=[self.activeCards objectAtIndex:i];
        if([card isKindOfClass:[ShapeCard class]])
        {
            useShapeCard=YES;
            ShapeCard *shapeCard=(ShapeCard *)card;
            CGRect bounds=CGRectMake(5+i*60, 5, 60, 40);
            UIBezierPath *rect = [UIBezierPath bezierPathWithRect:bounds];
            
            [[UIColor whiteColor] setFill];
            UIRectFill(bounds);
            
            [[UIColor blackColor] setStroke];
            [rect stroke];
            
            [self drawMultipleShapes:shapeCard.count withShape:shapeCard.shape withColor:shapeCard.color filledWith:shapeCard.fill withBounds:bounds];
        }
    }
    
    NSString *text=@"";
    
    if(useShapeCard)
    {
        if(self.match)
        {
            text=@"matched.\n  16 points awards.";
        }
        else
        {
            if(self.activeCards.count==3)
            {
                text=@"do not match. \n  4 points penalty.";
            }
            else if(self.activeCards.count!=0)
            {
                text=@"flipped.";
            }
        }
    }
    else
    {
        for(i=0;i<self.activeCards.count;i++)
        {
            Card *card=[self.activeCards objectAtIndex:i];
            if([card isKindOfClass:[PlayingCard class]])
            {
                PlayingCard *playingCard=(PlayingCard *)card;
                text=[text stringByAppendingFormat:@" %@",playingCard.contents];
            }
        }
        
        if(self.match)
        {
            text=[text stringByAppendingFormat:@"matched. 16 points awards."];
        }
        else
        {
            if(self.activeCards.count==2)
            {
                text=[text stringByAppendingFormat:@"do not match. 4 points penalty."];
            }
            else if(self.activeCards.count!=0)
            {
                text=[text stringByAppendingFormat:@"flipped."];
            }
        }
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont systemFontOfSize:self.bounds.size.height * 0.30];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString: text attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : cornerFont}];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake(10,10);
    if(useShapeCard)
    {
        textBounds.origin = CGPointMake(i*60+10,5.0);
    }
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
}

@end