//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Caidie on 9/4/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Deck.h"

@interface CardMatchingGame()
@property (strong, nonatomic) Deck *deck;

@end

@implementation CardMatchingGame

-(NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(NSMutableArray *)activeCardsIndexes
{
    if (!_activeCardsIndexes) _activeCardsIndexes = [[NSMutableArray alloc] init];
    return _activeCardsIndexes;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

-(BOOL)flipCardAtIndex:(NSUInteger)index
{
    //abstract
    return false;
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(id)initWithCardCount:(NSUInteger)count
             usingDeck:(Deck *)deck
{
    self = [super init];
    
    self.deck=deck;
    
    if(self)
    {
        for (int i=0; i < count; i++)
        {
            Card *card = [self.deck drawRandomCard];
            
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

-(void)addCards:(NSUInteger) numberOfCards
{
    for (int i=0;i<numberOfCards;i++)
    {
        Card *card = [self.deck drawRandomCard];
        
        if(card)
        {
            [self.cards addObject:card];
        }
        else
        {
            self.deck=[self resetDeck];
            card=[self.deck drawRandomCard];
            [self.cards addObject:card];
        }
    }
}

-(void)removeCards: (NSArray *) indexes
{
    NSMutableIndexSet *is=[[NSMutableIndexSet alloc]init];
    for(NSNumber *n in indexes)
    {
        int x=[n intValue];
        [is addIndex:x];
    }
    [self.cards removeObjectsAtIndexes:is];
}

-(Deck *)resetDeck
{
    return nil;
}

@end
