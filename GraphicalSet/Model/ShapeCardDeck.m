//
//  ShapeCardDeck.m
//  Matchismo
//
//  Created by Caidie on 9/17/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "ShapeCardDeck.h"
#import "ShapeCard.h"

@implementation ShapeCardDeck

-(id)init
{
    self=[super init];
    if(self)
    {
        for(NSString *fill in [ShapeCard validFills])
        {
            for(NSString *shape in [ShapeCard validShapes])
            {
                for(NSString *color in [ShapeCard validColors])
                {
                    for(NSUInteger count=1; count <= [ShapeCard maxCount]; count++)
                    {
                        ShapeCard *card = [[ShapeCard alloc]init];
                        card.shape=shape;
                        card.color=color;
                        card.count=count;
                        card.shading=fill;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}

@end
