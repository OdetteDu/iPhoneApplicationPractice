//
//  SetCardMatchingGame.m
//  GraphicalSet
//
//  Created by Caidie on 9/24/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "SetCardMatchingGame.h"
#import "ShapeCardDeck.h"

@implementation SetCardMatchingGame

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 1
#define FLIP_COST 1

-(BOOL)flipCardAtIndex:(NSUInteger)index
{
    BOOL match=NO;
    self.activeCardsIndexes=nil;
    NSString *description;
    
    Card *card = [self cardAtIndex:index];
    
    if(card && !card.isUnplayable)
    {
        if(!card.isFaceUp)
        {
            description=[NSString stringWithFormat:@"Flipped up %@", card.contents];
            
            NSMutableArray *otherCards=[[NSMutableArray alloc] init];
            for(int i=0; i<self.cards.count; i++)
            {
                Card *otherCard=[self.cards objectAtIndex:i];
                if(otherCard.isFaceUp && !otherCard.isUnplayable)
                {
                    [self.activeCardsIndexes addObject:[NSNumber numberWithInt:i]];
                    [otherCards addObject:otherCard];
                }
            }
            
            if([otherCards count]==2)
            {
                int matchScore = [card match:otherCards];
                if (matchScore)
                {
                    card.unplayable = YES;
                    for (Card *oc in otherCards)
                    {
                        oc.unplayable = YES;
                    }
                    self.score += matchScore * MATCH_BONUS;
                    Card *otherCard1=[otherCards objectAtIndex:0];
                    Card *otherCard2=[otherCards objectAtIndex:1];
                    description=[NSString stringWithFormat:@"%@ %@ & %@ matched for %d points",  otherCard1.contents, otherCard2.contents, card.contents,matchScore*MATCH_BONUS];
                    match=YES;
                    
                    
                }
                else
                {
                    for (Card *oc in otherCards)
                    {
                        oc.faceUp = NO;
                    }
                    self.score -= MISMATCH_PENALTY;
                    Card *otherCard1=[otherCards objectAtIndex:0];
                    Card *otherCard2=[otherCards objectAtIndex:1];
                    description=[NSString stringWithFormat:@"%@ %@ & %@ don't match. %d point penalty",  otherCard1.contents, otherCard2.contents, card.contents,MISMATCH_PENALTY];
                    match=NO;
                    
                }
            }
            
            self.score -= FLIP_COST;
        }
        
        card.faceUp = !card.isFaceUp;
        if(card.faceUp)
        {
            [self.activeCardsIndexes addObject:[NSNumber numberWithInt:index]];
        }
    }
    
    return match;
}

-(Deck *)resetDeck
{
    return [[ShapeCardDeck alloc]init];
}

@end
