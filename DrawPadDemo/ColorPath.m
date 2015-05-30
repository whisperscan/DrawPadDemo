//
//  ColorPath.m
//  DrawPadDemo
//
//  Created by caramel on 5/26/15.
//  Copyright (c) 2015 caramel. All rights reserved.
//

#import "ColorPath.h"

@implementation ColorPath

+ (instancetype)colorPathWithColor:(UIColor *)color withLineWidth:(CGFloat)lineWidth withStartPoint:(CGPoint)startPoint
{
    ColorPath *path = [[ColorPath alloc]init];
    
    path.lineWidth = lineWidth;
    path.color = color;
    [path moveToPoint:startPoint];
    path.lineCapStyle = kCGLineCapRound;
    
    return path;
}

@end
