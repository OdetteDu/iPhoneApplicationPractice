//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Caidie on 8/31/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "CardGameViewController.h"



@interface CardGameViewController () <UICollectionViewDataSource>
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@end

@implementation CardGameViewController

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.game.cards.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}

-(void)updateCell: (UICollectionViewCell *)cell usingCard:(Card *)card
{
    //abstract
}

-(CardMatchingGame *)game
{
    if (!_game) _game = [self createGame];
    return _game;
}

-(CardMatchingGame *)createGame
{
    return nil;//abstract
}

-(void)updateUI
{
    for (UICollectionViewCell *cell in self.cardCollectionView.visibleCells)
    {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        if(card)
        {
            [self updateCell:cell usingCard:card];
        }
        else
        {
            //[self.cardCollectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            [self.cardCollectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]]];
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
}

-(void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text=[NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)sender
{
    CGPoint tapLocation = [sender locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if(indexPath)
    {
        BOOL match=[self.game flipCardAtIndex:indexPath.item];
        if(match)
        {
            NSMutableArray *cellsToBeRemoved=[[NSMutableArray alloc] init];
            for (NSNumber *n in self.game.activeCardsIndexes)
            {
                int x=[n intValue];
                
                [cellsToBeRemoved addObject:[NSIndexPath indexPathForItem:x inSection:0]];
            }
            [self.game removeCards:self.game.activeCardsIndexes];
            [self.cardCollectionView deleteItemsAtIndexPaths:cellsToBeRemoved];
        }
        self.flipCount++;
        [self updateUI];
    }
}


- (IBAction)deal:(UIButton *)sender
{
    self.flipCount=0;
    self.game=nil;
    [self updateUI];
    
}

- (IBAction)addCards:(UIButton *)sender
{
    for(int i=0;i<3;i++)
    {
        [self.game addCards:1];
        [self.cardCollectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:self.game.cards.count-1 inSection:0]]];
    }
}
@end
