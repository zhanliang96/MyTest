//
//  LoginRegisterView.m
//  Test
//
//  Created by 展亮 on 2018/1/25.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "LoginRegisterView.h"


@interface LoginRegisterView ()
@property (weak, nonatomic)IBOutlet UIButton *loginRegisterButton;

@end

@implementation LoginRegisterView
// 越复杂的界面,封装 有特殊效果界面,也需要封装
+ (instancetype)loginView{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
+ (instancetype)registerView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    UIImage *image = _loginRegisterButton.currentBackgroundImage;
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    // 让按钮背景图片不要被拉伸
    [_loginRegisterButton setBackgroundImage:image forState:UIControlStateNormal];
}



@end
