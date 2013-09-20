//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Caidie on 9/4/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards; //of Card
@property (nonatomic) BOOL shouldCleanActiveCards;
@property (strong, nonatomic) Card *facedupCard;
@end

@implementation CardMatchingGame

-(NSMutableArray *)activeCards
{
    if(!_activeCards)
    {
        _activeCards=[[NSMutableArray alloc] init];
    }
    return _activeCards;
}

-(NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

-(NSString *)flipCardAtIndex:(NSUInteger)index
{
    if(self.shouldCleanActiveCards==YES)
    {
        self.activeCards=nil;
        if(self.facedupCard)
        {
            [self.activeCards addObject:self.facedupCard];
        }
        self.facedupCard=nil;
        self.shouldCleanActiveCards=NO;
    }
    
    NSString *description;
    
  
    
    Card *card = [self cardAtIndex:index];
    
    
    if(card && !card.isUnplayable)
    {
        if(!card.isFaceUp)
        {
            description=[NSString stringWithFormat:@"Flipped up %@", card.contents];
            
            
            if(!self.useThreeCard)
            {
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
                            self.shouldCleanActiveCards=YES;
                        }
                        else
                        {
                            otherCard.faceUp = NO;
                            self.score -= MISMATCH_PENALTY;
                            description=[NSString stringWithFormat:@"%@ & %@ don't match! %d point penalty!",card.contents, otherCard.contents, MISMATCH_PENALTY];
                            self.shouldCleanActiveCards=YES;
                            self.facedupCard=card;
                        }
                        //self.activeCards=nil;
                        break;
                    }
                }
            }
            else
            {
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
                        description=[NSString stringWithFormat:@"Matched %@, %@ & %@ for %d points",  otherCard1.contents, otherCard2.contents, card.contents,matchScore*MATCH_BONUS];
                        self.shouldCleanActiveCards=YES;
                        
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
                        description=[NSString stringWithFormat:@"%@, %@ & %@ don't match. %d point penalty",  otherCard1.contents, otherCard2.contents, card.contents,MISMATCH_PENALTY];
                        self.shouldCleanActiveCards=YES;
                        self.facedupCard=card;
                    }
                    //self.activeCards=nil;
                }
                else
                {
                    //error
                }
            }
            self.score -= FLIP_COST;
            
            
            [self.activeCards addObject:card];
        }
        else
        {
            [self.activeCards removeObject:card];
        }
        card.faceUp = !card.isFaceUp;
        
    }
    
    return description;
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(id)initWithCardCount:(NSUInteger)count
             usingDeck:(Deck *)deck
{
    self = [super init];
    
    if(self)
    {
        for (int i=0; i < count; i++)
        {
            Card *card = [deck drawRandomCard];
            
            if(card)
            {
                self.cards[i] = card;
            }
            else
            {
                self = nil;
                break;
            }
            
        }
    }
    
    return self;
}

@end
