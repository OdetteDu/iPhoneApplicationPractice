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

+(NSArray *)validShadings
{
    return @[@"Empty", @"Fill", @"Stripe"];
}

+(NSUInteger)maxCount
{
    return 3;
}

-(NSString *)contents
{
    NSString *contents=@"";
    
    for(int i=0;i<self.count;i++)
    {
        contents=[contents stringByAppendingString: self.shape];
    }
    
    contents=[contents stringByAppendingString:@" Color: "];
    contents=[contents stringByAppendingString:self.color];
    contents=[contents stringByAppendingString:@" Shadings: "];
    contents=[contents stringByAppendingString:self.shading];
    
    NSLog(@"Card Contents: %@",contents);
    return contents;
}

-(int)match:(NSArray *)otherCards
{
    int score=0;
    
    if([otherCards count]==2)
    {
        ShapeCard *otherCard1 = [otherCards objectAtIndex:0];
        ShapeCard *otherCard2 = [otherCards objectAtIndex:1];
        
        if((otherCard1.count == self.count || otherCard2.count == self.count || otherCard1.count == otherCard2.count))
        {
            if(self.count==otherCard1.count && self.count==otherCard2.count)
            {
                score=4;
            }
            else
            {
                return 0;
            }
        }
        
        if([otherCard1.shape isEqualToString: self.shape] || [otherCard2.shape isEqualToString: self.shape] || [otherCard1.shape isEqualToString: otherCard2.shape])
        {
            if([otherCard1.shape isEqualToString: self.shape]&&[otherCard2.shape isEqualToString: self.shape])
            {
                score=4;
            }
            else
            {
                return 0;
            }
        }
        
        if([otherCard1.color isEqualToString: self.color] || [otherCard2.color isEqualToString: self.color] || [otherCard1.color isEqualToString: otherCard2.color])
        {
            if([otherCard1.color isEqualToString: self.color] && [otherCard2.color isEqualToString: self.color])
            {
                score=4;
            }
            else
            {
                return 0;
            }
        }
        
        if([otherCard1.shading isEqualToString: self.shading] || [otherCard2.shading isEqualToString: self.shading] || [otherCard1.shading isEqualToString: otherCard2.shading])
        {
            if([otherCard1.shading isEqualToString: self.shading] && [otherCard2.shading isEqualToString: self.shading] )
            {
                score=4;
            }
            else{
                return 0;
            }
        }
        
    }
    
    return score;
}

@end