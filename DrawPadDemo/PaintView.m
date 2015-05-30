//
//  PaintView.m
//  DrawPadDemo
//
//  Created by caramel on 5/26/15.
//  Copyright (c) 2015 caramel. All rights reserved.
//

#import "PaintView.h"
#import "ColorPath.h"

@interface PaintView ()

@property (strong, nonatomic) UIBezierPath *path;

@property (strong, nonatomic) NSMutableArray *pathArr;

@end

@implementation PaintView

#pragma mark - image的set方法，用于在设置图片的时候，把图片画到view中，并刷新屏幕
- (void)setImage:(UIImage *)image
{
    _image = image;
    
    [self.pathArr addObject:image];
    
    [self setNeedsDisplay];
}

#pragma mark - 路径数据懒加载

- (NSMutableArray *)pathArr
{
    if(_pathArr == nil)
    {
        _pathArr = [NSMutableArray array];
    }
    
    return _pathArr;
}


#pragma mark - 初始化方法

- (void)awakeFromNib
{
    self.lineWidth = 2;
}

#pragma mark - 触摸事件方法

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [touches anyObject];
//    
//    CGPoint currPoint = [touch locationInView:self];
//    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    
////    path.lineWidth = self.lineWidth;
//    
////    [path moveToPoint:currPoint];
//    
//    self.path = path;
//    
//    // 添加路径到数组中
//    [self.pathArr addObject:path];
    
    [self createPathWithTouches:touches isBegan:YES];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [touches anyObject];
//    
//    CGPoint currPoint = [touch locationInView:self];
//    
//    [self.path addLineToPoint:currPoint];
//    
//    [self setNeedsDisplay];
    
    [self createPathWithTouches:touches isBegan:NO];
}

- (void)createPathWithTouches:(NSSet *)touches isBegan:(BOOL)isBegan
{
    UITouch *touch = [touches anyObject];
    
    CGPoint currPoint = [touch locationInView:self];
    
    if(isBegan) //是否点击开始，如果是生成新的路径
    {
        ColorPath *path = [ColorPath colorPathWithColor:self.color withLineWidth:self.lineWidth withStartPoint:currPoint];
        self.path = path;
        [self.pathArr addObject:path];
    }
    else
    {
        [self.path addLineToPoint:currPoint];
    }
    
    [self setNeedsDisplay];
}


#pragma mark - 绘图方法

- (void)drawRect:(CGRect)rect
{
    if(self.pathArr.count == 0)    return;
    
    for(ColorPath *path in self.pathArr)
    {
        if([path isKindOfClass:[UIImage class]])
        {
            UIImage *image = (UIImage *)path;
            [image drawAtPoint:CGPointZero];
        }
        else
        {
            [path.color setStroke];
            [path stroke];
        }
    } 
}

#pragma mark - 外部调用方法

/** 清屏*/
- (void)clearScreen
{
    [self.pathArr removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)undo
{
    [self.pathArr removeLastObject];
    
    [self setNeedsDisplay];
}

@end
