//
//  ViewController.m
//  DrawPadDemo
//
//  Created by caramel on 5/26/15.
//  Copyright (c) 2015 caramel. All rights reserved.
//

#import "ViewController.h"
#import "PaintView.h"
#import "UIImage+Tools.h"
#import "MBProgressHUD+MJ.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet PaintView *paintView;
@property (strong, nonatomic) UIView *clipView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
}

#pragma mark - toolsbar监听方法

- (IBAction)clearClick:(UIBarButtonItem *)sender
{
    [self.paintView clearScreen];
}

- (IBAction)undoClick:(UIBarButtonItem *)sender
{
    [self.paintView undo];
}

- (IBAction)eraserClick:(UIBarButtonItem *)sender
{
    self.paintView.color = [UIColor whiteColor];
}

- (IBAction)selectPhotoClick:(UIBarButtonItem *)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
//    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)savePhotoClick:(UIBarButtonItem *)sender
{
    UIImage *image = [UIImage imageClipScreen:self.paintView];
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

/** 保存图片完成之后的方法*/
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if(error)
    {
        [MBProgressHUD showError:@"保存失败"];
    }
    else
    {
        [MBProgressHUD showError:@"保存成功"];
    }
}

#pragma mark - UIImagePickerControllerDelegate代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    NSLog(@"%@",info);
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
//    self.paintView.image = image;
    UIView *view = [[UIView alloc]initWithFrame:self.paintView.frame];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:view.bounds];
    [view addSubview:imageView];
    [self.view addSubview:view];

    self.clipView = view;
    self.imageView = imageView;
    
    // 设置属性
    view.backgroundColor = [UIColor clearColor];
    imageView.userInteractionEnabled = YES;
    
    imageView.image = image;
    
    // 添加捏合手势
    [self addPinch];
    
    // 添加长按手势
    [self addLongPress];
    
    // 添加旋转手势
    [self addRotation];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 手势方法

- (void)addPinch
{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    pinch.delegate = self;
    [self.imageView addGestureRecognizer:pinch];
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, gesture.scale, gesture.scale);
    gesture.scale = 1;
}

- (void)addLongPress
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.imageView addGestureRecognizer:longPress];
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.5f animations:^{
        self.imageView.alpha = 0.2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f animations:^{
            self.imageView.alpha = 1;
        } completion:^(BOOL finished) {
            [self.clipView removeFromSuperview];
            
            self.paintView.image = [UIImage imageClipScreen:self.clipView];
        }];
    }];
}

- (void)addRotation
{
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotation:)];
    rotation.delegate = self;
    [self.imageView addGestureRecognizer:rotation];
}

- (void)rotation:(UIRotationGestureRecognizer *)gesture
{
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, gesture.rotation);
    gesture.rotation = 0;
}

#pragma mark - 手势代理方法
/** 想要一次操作支持多个手势必需实现些代理方法*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


#pragma mark - slider监听方法

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    self.paintView.lineWidth = sender.value;
}

#pragma mark - 颜色按键监听方法

- (IBAction)colorButtonClick:(UIButton *)sender
{
    self.paintView.color = sender.backgroundColor;
}

@end
