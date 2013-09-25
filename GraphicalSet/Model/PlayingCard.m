//
//  PlayingCard.m
//  Matchismo
//
//  Created by Caidie on 9/1/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1)
    {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString: self.suit])
        {
            score = 1;
        }
        else if(otherCard.rank == self.rank)
        {
            score = 3;
        }
    }
    else if ([otherCards count] == 2)
    {
        PlayingCard *otherCard1 = [otherCards objectAtIndex:0];
        PlayingCard *otherCard2 = [otherCards objectAtIndex:1];
        
        if ([otherCard1.suit isEqualToString:self.suit] && [otherCard2.suit isEqualToString:self.suit])
        {
            score = 8;
        }
        else if (otherCard1.rank == self.rank && otherCard2.rank == self.rank)
        {
            score = 16;
        }
        else if ((self.rank == otherCard1.rank && [self.suit isEqualToString:otherCard2.suit]) || (self.rank == otherCard2.rank && [self.suit isEqualToString:otherCard1.suit]))
        {
            score = 6;
        }
        else if ((otherCard1.rank == otherCard2.rank && [self.suit isEqualToString:otherCard1.suit]) || (self.rank == otherCard1.rank && [otherCard1.suit isEqualToString:otherCard2.suit]))
        {
            score = 6;
        }
        else if ((otherCard1.rank == otherCard2.rank && [self.suit isEqualToString:otherCard2.suit]) || (self.rank == otherCard2.rank && [otherCard1.suit isEqualToString:otherCard2.suit]))
        {
            score = 6;
        }
        else if (otherCard1.rank == self.rank || otherCard2.rank == self.rank || otherCard1.rank == otherCard2.rank)
        {
            score = 4;
        }
        else if ([otherCard1.suit isEqualToString:self.suit] || [otherCard2.suit isEqualToString:self.suit] || [otherCard1.suit isEqualToString:otherCard2.suit])
        {
            score = 2;
        }
            
    }
    
    return score;
}

-(NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit=_suit; //because we provide setter ADN getter

+(NSArray *)validSuits
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

-(void)setSuit:(NSString *)suit
{
    if([ [PlayingCard validSuits]containsObject:suit])
    {
        _suit=suit;
    }
}

-(NSString *)suit
{
    return _suit ? _suit : @"?";
}

+(NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+(NSUInteger)maxRank
{
    return [self rankStrings].count-1;
}

-(void)setRank:(NSUInteger)rank
{
    if(rank<=[PlayingCard maxRank])
    {
        _rank=rank;
    }
}



@end
