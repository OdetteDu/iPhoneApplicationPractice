//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Caidie on 9/17/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()
//@property (strong, nonatomic) CardMatchingGame *cardgame;
@end

@implementation PlayingCardGameViewController

//@synthesize game=_game;
-(CardMatchingGame *)game
{
    if (!super.game) super.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc] init]];
    return super.game;
}



-(void)updateUI
{
    for(UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 :1.0);
        
        
        cardButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        UIImage *cardBackImage = [UIImage imageNamed:@"bg.png"];
        [cardButton setBackgroundImage: (cardButton.selected)? nil:cardBackImage forState: UIControlStateNormal];
        
        
    }
    [super updateUI];
}

@end
