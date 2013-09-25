//
//  ShapeCard.h
//  Matchismo
//
//  Created by Caidie on 9/17/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "Card.h"

@interface ShapeCard : Card

@property (nonatomic) NSUInteger count;
@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *shading;

+(NSArray *)validShapes;
+(NSArray *)validColors;
+(NSArray *)validShadings;
+(NSUInteger)maxCount;

@end
