//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Caidie on 9/23/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PlayingCardView *playingView;
@end
