//
//  MYTabBar.m
//  Test
//
//  Created by 展亮 on 2018/1/22.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "MYTabBar.h"
@interface MYTabBar ()

//@property (nonatomic, weak) UIButton *plusButton;
/** 上一次点击的按钮 */
@property (nonatomic, weak) UIControl *previousClickedTabBarButton;


@end

@implementation MYTabBar

//- (UIButton *)plusButton{
//    if(!_plusButton){
//        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
//        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
//        [plusButton sizeToFit];
//        _plusButton = plusButton;
//        [self addSubview:plusButton];
//    }
//    return _plusButton;
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 跳转tabBarButton位置
    NSInteger count = self.items.count ;
    CGFloat btnW = self.frame.size.width / count;
    CGFloat btnH = self.frame.size.height;
    CGFloat btnX = 0;
    NSInteger i = 0;
    // 私有类:打印出来有个类,但是敲出来没有,说明这个类是系统私有类
    // 遍历子控件 调整布局
    for (UIControl *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            // 设置previousClickedTabBarButton默认值为最前面的按钮
            if (i == 0 && self.previousClickedTabBarButton == nil) {
                self.previousClickedTabBarButton = tabBarButton;
            }
            //原本想在中间设置一个高亮按钮（类似于微博设计），后删去
//            if (i == 2) {
//                i += 1;
//            }
            
            btnX = i * btnW;
            
            tabBarButton.frame = CGRectMake(btnX, 0, btnW, btnH);
            i++;
            // UIControlEventTouchDownRepeat : 在短时间内连续点击按钮
            // 监听点击
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            

        }
    }
    // 调整发布按钮位置
//    self.plusButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
}
/**
 *  tabBarButton的点击
 */
- (void)tabBarButtonClick:(UIControl *)tabBarButton{
    if (self.previousClickedTabBarButton == tabBarButton) {
        // 发出通知，告知外界tabBarButton被重复点击了
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TabBarButtonDidRepeatClickNotification" object:nil];
    }
    self.previousClickedTabBarButton = tabBarButton;
}

@end
