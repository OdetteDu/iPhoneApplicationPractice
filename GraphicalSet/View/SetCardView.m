//
//  SetCardView.m
//  GraphicalSet
//
//  Created by Caidie on 9/26/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

-(void)setColor:(NSString *)color
{
    _color=color;
    [self setNeedsDisplay];
}

-(void)setFill:(NSString *)fill
{
    _fill=fill;
    [self setNeedsDisplay];
}

-(void)setShape:(NSString *)shape
{
    _shape=shape;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12.0];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawContent];
}

-(UIBezierPath *)getPath:(NSString *)shape
{
    UIBezierPath *path;
    if([self.shape compare: @"Ovals"]==0)
    {
        
    }
    else if([self.shape compare: @"Squiggles"]==0)
    {
        path=[UIBezierPath bezierPathWithArcCenter: CGPointMake(20,0) radius:10 startAngle:0 endAngle:M_PI/2 clockwise:YES];
        [path addArcWithCenter:CGPointMake(20, 30) radius:20 startAngle:M_PI*3/2 endAngle:M_PI clockwise:NO];
        [path addArcWithCenter:CGPointMake(10, 30) radius:10 startAngle:M_PI endAngle:M_PI/2 clockwise:NO];
        [path addArcWithCenter:CGPointMake(20, 40) radius:10 startAngle:M_PI endAngle:M_PI*3/2 clockwise:YES];
        [path addArcWithCenter:CGPointMake(20, 10) radius:20 startAngle:M_PI/2 endAngle:0 clockwise:NO];
        [path addArcWithCenter:CGPointMake(30, 10) radius:10 startAngle:0 endAngle:M_PI*3/2 clockwise:NO];
        //[path closePath];
        
    }
    else if([self.shape compare: @"Diamonds"]==0)
    {
        
    }
    return path;
}

-(void)drawContent
{
    [self draw:[self getPath: self.shape] withColor:[self getColor: self.color] filledWith:self.fill];
}

-(void)draw:(UIBezierPath *)path withColor:(UIColor *) color filledWith: (NSString *)fill
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextRotateCTM(context, M_PI/18);
    if([self.fill compare: @"Solid"]==0)
    {
        
        [path addClip];
        [color setFill];
        [path fill];
    }
    else if([self.fill compare: @"Striped"]==0)
    {
        
    }
    else if([self.fill compare: @"Unfilled"]==0)
    {
        [path addClip];
        [color setStroke];
        [path stroke];
    }
   
    CGContextRestoreGState(context);
}

-(UIColor *)getColor:(NSString *)colorDescription
{
    UIColor *color;
    if([colorDescription compare: @"Green"]==0)
    {
        color=[UIColor greenColor];
    }
    else if([colorDescription compare: @"Purple"]==0)
    {
        color=[UIColor blueColor];
    }
    else if([colorDescription compare: @"Red"]==0)
    {
        color=[UIColor redColor];
    }
    return color;
}


@end
