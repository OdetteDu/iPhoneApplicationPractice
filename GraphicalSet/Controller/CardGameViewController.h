//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Caidie on 8/31/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "Deck.h"

@interface CardGameViewController : UIViewController


@property (nonatomic) NSUInteger startingCardCount;

-(Deck *)createDeck;
-(void)updateCell: (UICollectionViewCell *)cell usingCard:(Card *)card;
@end
