//
//  UIBarButtonItem+Item.h
//  Test
//
//  Created by 展亮 on 2018/1/22.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)selImage target:(id)target action:(SEL)action title: (NSString *)title;
@end
