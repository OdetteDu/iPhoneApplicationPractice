//
//  SetCardMatchingGame.m
//  GraphicalSet
//
//  Created by Caidie on 9/24/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "SetCardMatchingGame.h"

@implementation SetCardMatchingGame

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

-(NSString *)flipCardAtIndex:(NSUInteger)index
{
    
    NSString *description;
    
    Card *card = [self cardAtIndex:index];
    
    if(card && !card.isUnplayable)
    {
        if(!card.isFaceUp)
        {
            description=[NSString stringWithFormat:@"Flipped up %@", card.contents];
            
            NSMutableArray *otherCards=[[NSMutableArray alloc] init];
            for(Card *otherCard in self.cards)
            {
                if(otherCard.isFaceUp && !otherCard.isUnplayable)
                {
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
                    
                }
            }
            
            self.score -= FLIP_COST;
        }
        
        card.faceUp = !card.isFaceUp;
        
    }
    
    return description;
}

@end
