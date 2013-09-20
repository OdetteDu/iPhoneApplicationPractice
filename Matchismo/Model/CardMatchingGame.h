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

@property (readonly, nonatomic) int score;
@property (nonatomic) Boolean useThreeCard;
@property (strong, nonatomic) NSMutableArray *activeCards;

//designated initializer
-(id)initWithCardCount:(NSUInteger)count
             usingDeck:(Deck *)deck;

-(NSString *)flipCardAtIndex:(NSUInteger)index;

-(Card *)cardAtIndex:(NSUInteger)index;

@end
