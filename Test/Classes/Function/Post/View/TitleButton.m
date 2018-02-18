//
//  TitleButton.m
//  Test
//
//  Created by 展亮 on 2018/1/28.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "TitleButton.h"
/*
 特定构造方法
 1> 后面带有NS_DESIGNATED_INITIALIZER的方法，就是特定构造方法
 
 2> 子类如果重写了父类的【特定构造方法】，那么必须用super调用父类的【特定构造方法】，不然会出现警告
 */



@implementation TitleButton
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    // 只要重写了这个方法，按钮就无法进入highlighted状态
}

@end
