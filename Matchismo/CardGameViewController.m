//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Caidie on 8/31/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"


@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;


@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end

@implementation CardGameViewController

//-(CardMatchingGame *)game
//{
//    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc] init]];
//    return _game;
//}

-(void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

-(void)updateUI
{
    //for(UIButton *cardButton in self.cardButtons)
    //{
    //    Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
     //   [cardButton setTitle:card.contents forState:UIControlStateSelected];
    //    [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
    //    cardButton.selected = card.isFaceUp;
    //    cardButton.enabled = !card.isUnplayable;
     //   cardButton.alpha = (card.isUnplayable ? 0.3 :1.0);
        
        
     //   cardButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
     //   UIImage *cardBackImage = [UIImage imageNamed:@"bg.png"];
     //   [cardButton setBackgroundImage: (cardButton.selected)? nil:cardBackImage forState: UIControlStateNormal];
        
    
   // }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
}

-(void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text=[NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    NSString *description=[self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.descriptionLabel.text = description;
    self.flipCount++;
    [self updateUI];
}

- (IBAction)deal:(UIButton *)sender
{
    self.flipCount=0;
    self.game=nil;
    self.descriptionLabel.text = [NSString stringWithFormat:@"Start a new game."];
    [self updateUI];
    
}

@end
