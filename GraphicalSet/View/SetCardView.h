//
//  SetCardView.h
//  GraphicalSet
//
//  Created by Caidie on 9/26/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface SetCardView : CardView
@property (strong, nonatomic) NSString *fill;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *shape;
@property (nonatomic) NSUInteger count;
@property (nonatomic) BOOL faceUp;

-(void)drawMultipleShapes:(NSUInteger)count withShape:(NSString *)shape withColor:(NSString *)color filledWith:(NSString *)fill withBounds:(CGRect)bounds;
- (void)drawBorder:(CGRect)bounds;
@end
