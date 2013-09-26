//
//  PlayingCardMatchingGame.m
//  GraphicalSet
//
//  Created by Caidie on 9/24/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "PlayingCardMatchingGame.h"
#import "PlayingCardDeck.h"

@implementation PlayingCardMatchingGame

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
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
            
            
            
            for(int i=0; i<self.cards.count; i++)
            {
                Card *otherCard=[self.cards objectAtIndex:i];
                
                if(otherCard.isFaceUp && !otherCard.isUnplayable)
                {
                    [self.activeCardsIndexes addObject:[NSNumber numberWithInt:i]];
                    
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore)
                    {
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        
                        self.score += matchScore *MATCH_BONUS;
                        description=[NSString stringWithFormat:@"Matched %@ & %@ for %d points",card.contents, otherCard.contents, matchScore*MATCH_BONUS];
                        match=YES;
                        
                    }
                    else
                    {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        description=[NSString stringWithFormat:@"%@ & %@ don't match! %d point penalty!",card.contents, otherCard.contents, MISMATCH_PENALTY];
                        match=NO;
                    }
                    break;
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
    return [[PlayingCardDeck alloc]init];
}

@end
