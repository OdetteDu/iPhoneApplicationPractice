//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Caidie on 9/22/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

@property (nonatomic) BOOL faceUp;

- (void)pinch: (UIPinchGestureRecognizer *)gesture;

@end
