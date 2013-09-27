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
    [self drawBorder:self.bounds];
    
    [self drawMultipleShapes:self.count withShape:self.shape withColor:self.color filledWith:self.fill withBounds:self.bounds];
}

- (void)drawBorder:(CGRect)bounds
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:12.0];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
}

-(UIBezierPath *)getPath:(NSString *)shape withScale:(NSUInteger) scale withUpperLeftCorner:(CGPoint)position
{
    UIBezierPath *path;
    CGFloat x=position.x;
    CGFloat y=position.y;
    
    if([self.shape compare: @"Ovals"]==0)
    {
        path=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1*scale+x,0*scale+y,2*scale,4*scale)];
    }
    else if([self.shape compare: @"Squiggles"]==0)
    {
        path=[UIBezierPath bezierPathWithArcCenter: CGPointMake(2*scale+x,0*scale+y) radius:1*scale startAngle:0 endAngle:M_PI/2 clockwise:YES];
        [path addArcWithCenter:CGPointMake(2*scale+x, 3*scale+y) radius:2*scale startAngle:M_PI*3/2 endAngle:M_PI clockwise:NO];
        [path addArcWithCenter:CGPointMake(1*scale+x, 3*scale+y) radius:1*scale startAngle:M_PI endAngle:M_PI/2 clockwise:NO];
        [path addArcWithCenter:CGPointMake(2*scale+x, 4*scale+y) radius:1*scale startAngle:M_PI endAngle:M_PI*3/2 clockwise:YES];
        [path addArcWithCenter:CGPointMake(2*scale+x, 1*scale+y) radius:2*scale startAngle:M_PI/2 endAngle:0 clockwise:NO];
        [path addArcWithCenter:CGPointMake(3*scale+x, 1*scale+y) radius:1*scale startAngle:0 endAngle:M_PI*3/2 clockwise:NO];
        
        
    }
    else if([self.shape compare: @"Diamonds"]==0)
    {
        path=[[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(2*scale+x, 0*scale+y)];
        [path addLineToPoint:CGPointMake(1*scale+x, 2*scale+y)];
        [path addLineToPoint:CGPointMake(2*scale+x, 4*scale+y)];
        [path addLineToPoint:CGPointMake(3*scale+x, 2*scale+y)];
        [path closePath];
    }
    return path;
}

-(void)drawMultipleShapes:(NSUInteger)count withShape:(NSString *)shape withColor:(NSString *)color filledWith:(NSString *)fill withBounds:(CGRect)bounds
{
    NSUInteger scale=bounds.size.width/12;
    CGPoint center=CGPointMake(bounds.origin.x+bounds.size.width/2, bounds.origin.y+bounds.size.height/2);
    CGPoint leftCenter=CGPointMake(bounds.origin.x+bounds.size.width/4, bounds.origin.y+bounds.size.height/2);
    CGPoint rightCenter=CGPointMake(bounds.origin.x+bounds.size.width/4*3, bounds.origin.y+bounds.size.height/2);
    
    if(count==1 || count==3)
    {
        [self drawSingleShape:[self getPath: shape withScale:scale withUpperLeftCorner:CGPointMake(center.x-2*scale, center.y-2*scale)] withColor:[self getColor: color] filledWith:fill withScale:scale withUpperLeftCorner:CGPointMake(center.x-2*scale, center.y-2*scale)];
    }
    
    if(count==2 || count==3)
    {
        [self drawSingleShape:[self getPath: shape withScale:scale withUpperLeftCorner:CGPointMake(leftCenter.x-2*scale, leftCenter.y-2*scale)] withColor:[self   getColor: color] filledWith:fill withScale:scale withUpperLeftCorner:CGPointMake(leftCenter.x-2*scale, leftCenter.y-2*scale)];
        
        [self drawSingleShape:[self getPath: shape withScale:scale withUpperLeftCorner:CGPointMake(rightCenter.x-2*scale, rightCenter.y-2*scale)] withColor:[self   getColor: color] filledWith:fill withScale:scale withUpperLeftCorner:CGPointMake(rightCenter.x-2*scale, rightCenter.y-2*scale)];
    }
    
}

-(void)drawSingleShape:(UIBezierPath *)path withColor:(UIColor *) color filledWith: (NSString *)fill withScale:(NSUInteger) scale withUpperLeftCorner:(CGPoint)position
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    
    if([self.fill compare: @"Solid"]==0)
    {
        [path addClip];
        [color setFill];
        [path fill];
    }
    else if([self.fill compare: @"Striped"]==0)
    {
        [path addClip];
        [color setStroke];
        [path stroke];
        for(int i=0;i<7;i++)
        {
            UIBezierPath *bp=[UIBezierPath bezierPathWithRect:CGRectMake(position.x+(0*scale), position.y+0.5*(i+1)*scale, 4*scale, 0.1*scale)];
            [color setFill];
            [bp fill];
        }
        
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
