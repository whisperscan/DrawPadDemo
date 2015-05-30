//
//  PaintView.h
//  DrawPadDemo
//
//  Created by caramel on 5/26/15.
//  Copyright (c) 2015 caramel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintView : UIView

@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) float lineWidth;
@property (strong, nonatomic) UIImage *image;

- (void)clearScreen;
- (void)undo;


@end
