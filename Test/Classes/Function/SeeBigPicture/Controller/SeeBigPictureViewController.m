//
//  SeeBigPictureViewController.m
//  Test
//
//  Created by 展亮 on 2018/2/6.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "SeeBigPictureViewController.h"
#import "AllViewPost.h"
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface SeeBigPictureViewController ()
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation SeeBigPictureViewController
#pragma mark - IBAction
- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    //点击任意地方返回
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:scrollView atIndex:0];
    self.scrollView = scrollView;
    //imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image0]];
    CGFloat imageY = 0;
    NSInteger imageH = self.topic.height;
    // 超过一个屏幕
    if (imageH > SCREEN_HEIGHT) {
        imageY = 0;
        scrollView.contentSize = CGSizeMake(0, imageH);
    }else{
        imageY = (SCREEN_HEIGHT / 2) - (imageH / 2);
    }
    imageView.frame = CGRectMake(0, imageY, SCREEN_WIDTH, imageH);
    [scrollView addSubview:imageView];
    self.imageView = imageView;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}




@end
