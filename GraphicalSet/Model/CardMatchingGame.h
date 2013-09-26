//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Caidie on 9/4/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (nonatomic) int score;
@property (nonatomic) Boolean useThreeCard;
@property (strong, nonatomic) NSMutableArray *cards; //of Card
@property (strong, nonatomic) NSMutableArray *activeCardsIndexes; //of int

//designated initializer
-(id)initWithCardCount:(NSUInteger)count
             usingDeck:(Deck *)deck;

-(BOOL)flipCardAtIndex:(NSUInteger)index;

-(Card *)cardAtIndex:(NSUInteger)index;

-(void)addCards:(NSUInteger) numberOfCards;

-(void)removeCards: (NSArray *) indexes;

-(Deck *)resetDeck;

@end
