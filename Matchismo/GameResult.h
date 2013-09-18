//
//  GameResult.h
//  Matchismo
//
//  Created by Caidie on 9/17/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *)allGameResults;//of GameResult

@property (readonly,nonatomic) NSDate *start;
@property (readonly,nonatomic) NSDate *end;
@property (readonly,nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;

@end
