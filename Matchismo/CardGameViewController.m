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
//@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end

@implementation CardGameViewController

-(NSString *)description
{
    if(!_description)
    {
        _description=@"";
    }
    return _description;
}

-(void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

-(void)updateUI
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
}

-(void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text=[NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    //NSString *description=[self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    //self.descriptionLabel.text = description;
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
