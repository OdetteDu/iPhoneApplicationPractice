//
//  ShapeCard.m
//  Matchismo
//
//  Created by Caidie on 9/17/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "ShapeCard.h"

@implementation ShapeCard
+(NSArray *)validShapes
{
    return @[@"●",@"■",@"▲"];
}

+(NSArray *)validColors
{
    return @[@"Green", @"Blue", @"Red"];
}

+(NSUInteger)maxCount
{
    return 3;
}

-(NSString *)contents
{
    NSString *contents;
    
    for(int i=0;i<self.count;i++)
    {
        [contents stringByAppendingString: self.shape];
    }
    
    return contents;
}

-(int)match:(NSArray *)otherCards
{
    int score=0;
    
    if([otherCards count]==2)
    {
        ShapeCard *otherCard1 = [otherCards objectAtIndex:0];
        ShapeCard *otherCard2 = [otherCards objectAtIndex:1];
        
        if(otherCard1.count == self.count && otherCard2.count == self.count)
        {
            return 4;
        }
        else if([otherCard1.shape isEqualToString: self.shape] && [otherCard2.shape isEqualToString: self.shape])
        {
            return 4;
        }
        else if([otherCard1.color isEqualToString: self.color] && [otherCard2.color isEqualToString: self.color])
        {
            return 4;
        }
    }
    
    return score;
}

@end
