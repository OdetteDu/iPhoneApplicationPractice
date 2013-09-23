//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Caidie on 9/17/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

-(Deck *)createDeck
{
    return [[ PlayingCardDeck alloc] init];
}

- (NSUInteger)startingCardCount
{
    return 20;
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]])
    {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingView;
        if([card isKindOfClass:[PlayingCard class]])
        {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank=playingCard.rank;
            playingCardView.suit=playingCard.suit;
            playingCardView.faceUp=playingCard.isFaceUp;
            playingCardView.alpha=playingCard.isUnplayable ? 0.3:1.0;
        }
    }
}

@end
