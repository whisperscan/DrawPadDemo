//
//  ColorPath.h
//  DrawPadDemo
//
//  Created by caramel on 5/26/15.
//  Copyright (c) 2015 caramel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorPath : UIBezierPath

@property (strong, nonatomic) UIColor *color;

+ (instancetype)colorPathWithColor:(UIColor *)color withLineWidth:(CGFloat)lineWidth withStartPoint:(CGPoint)startPoint;

@end
