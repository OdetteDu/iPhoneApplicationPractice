//
//  PlayingCardMatchingGame.m
//  GraphicalSet
//
//  Created by Caidie on 9/24/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "PlayingCardMatchingGame.h"

@implementation PlayingCardMatchingGame

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
            
            
            
            for(Card *otherCard in self.cards)
            {
                if(otherCard.isFaceUp && !otherCard.isUnplayable)
                {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore)
                    {
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        self.score += matchScore *MATCH_BONUS;
                        description=[NSString stringWithFormat:@"Matched %@ & %@ for %d points",card.contents, otherCard.contents, matchScore*MATCH_BONUS];
                        
                    }
                    else
                    {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        description=[NSString stringWithFormat:@"%@ & %@ don't match! %d point penalty!",card.contents, otherCard.contents, MISMATCH_PENALTY];
                        
                    }
                    //self.activeCards=nil;
                    break;
                }
            }
            
            
            self.score -= FLIP_COST;
            
            
            //[self.activeCards addObject:card];
        }
        
        card.faceUp = !card.isFaceUp;
        
    }
    
    return description;
}

@end
