//
//  LoginRegisterViewController.m
//  Test
//
//  Created by 展亮 on 2018/1/24.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "LoginRegisterViewController.h"
#import "LoginRegisterView.h"
//#import "Frame.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)


@interface LoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadCons;

@end

@implementation LoginRegisterViewController
#pragma mark - IBAction
// 点击关闭
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 点击注册
- (IBAction)clickRegister:(UIButton *)sender {
    sender.selected = !sender.selected;
    // 平移中间view
    _leadCons.constant = _leadCons.constant == 0? -SCREEN_WIDTH:0;
    //做个动画会稍微好一点
    [self.view layoutIfNeeded];

}
#pragma mark - ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建登录view
    LoginRegisterView *loginView = [LoginRegisterView loginView];
    // 添加到中间的view
    [self.middleView addSubview:loginView];
    // 添加注册界面
    LoginRegisterView *registerView = [LoginRegisterView registerView];
    // 添加到中间的view
    [self.middleView addSubview:registerView];
}
// viewDidLayoutSubviews:才会根据布局调整控件的尺寸
- (void)viewDidLayoutSubviews
{
    // 一定要调用super
    [super viewDidLayoutSubviews];
    // 设置登录view
    LoginRegisterView *loginView = self.middleView.subviews[0];
    loginView.frame = CGRectMake(SCREEN_WIDTH * 0.25, 0, SCREEN_WIDTH * 0.5, SCREEN_HEIGHT);
    // 设置注册view
    LoginRegisterView *registerView = self.middleView.subviews[1];
    registerView.frame = CGRectMake(SCREEN_WIDTH * 1.25, 0,SCREEN_WIDTH * 0.5, SCREEN_HEIGHT);
    
}




@end
