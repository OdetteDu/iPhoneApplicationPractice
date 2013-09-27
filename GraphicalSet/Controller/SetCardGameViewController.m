//
//  SetCardGameViewController.m
//  GraphicalSet
//
//  Created by Caidie on 9/26/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardView.h"
#import "ShapeCard.h"
#import "ShapeCardDeck.h"
#import "SetCardMatchingGame.h"
#import "SetCardCollectionViewCell.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

-(CardMatchingGame *)createGame
{
    return [[SetCardMatchingGame alloc] initWithCardCount:12 usingDeck:[[ShapeCardDeck alloc]init]];
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{

    if ([cell isKindOfClass:[SetCardCollectionViewCell class]])
    {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setView;
        if([card isKindOfClass:[ShapeCard class]])
        {
            ShapeCard *shapeCard = (ShapeCard *)card;
            setCardView.count=shapeCard.count;
            setCardView.shape=shapeCard.shape;
            setCardView.fill=shapeCard.fill;
            setCardView.color=shapeCard.color;
            setCardView.alpha=shapeCard.isUnplayable ? 0.3:1.0;
        }
    }
}

@end
