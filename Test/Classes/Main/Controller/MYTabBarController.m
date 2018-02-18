//
//  MYTabBarController.m
//  Test
//
//  Created by 展亮 on 2018/1/22.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "MYTabBarController.h"
#import "IndexViewController.h"
//#import "FriendTrendViewController.h"
#import "FindViewController.h"
#import "MeViewController.h"
#import "NewViewController.h"
#import "UIImage+Image.h"
#import "MYTabBar.h"
#import "MYNavigationViewController.h"


@interface MYTabBarController ()

@end

@implementation MYTabBarController
#pragma mark - load
+ (void)load{
    //get UITabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    //设置按钮选中标题的颜色：富文本：描述一个文字颜色，字体，阴影，空心，图文混排
    //创建一个描述文本属性的字典
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
    // 设置字体尺寸:只有设置正常状态下,才会有效果
    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
    attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
}
#pragma mark - ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1.添加自控制器（五个子控件)
    [self setupAllChildViewController];
    //2.设置tabBar按钮上的内容
    [self setupAllTitleButton];
    //自定义tabBar
    [self setupTabBar];

}
#pragma mark - set tabBar
- (void)setupTabBar{
    MYTabBar *tabBar = [[MYTabBar alloc] init];
    [self setValue:tabBar forKeyPath:@"tabBar"];
}
#pragma mark - add child view
- (void)setupAllChildViewController{
    //首页
    IndexViewController *indexVc = [[IndexViewController alloc] init];
    MYNavigationViewController *nav = [[MYNavigationViewController alloc]initWithRootViewController:indexVc];
    [self addChildViewController:nav];
    //动态
    NewViewController *newVc = [[NewViewController alloc] init];
    MYNavigationViewController *nav1 = [[MYNavigationViewController alloc]initWithRootViewController:newVc];
    [self addChildViewController:nav1];

    //关注
    FindViewController *FindVc = [[FindViewController alloc] init];
    MYNavigationViewController *nav3 = [[MYNavigationViewController alloc]initWithRootViewController:FindVc];
    [self addChildViewController:nav3];
    //我的
    MeViewController *meVc = [[MeViewController alloc] init];
    MYNavigationViewController *nav4 = [[MYNavigationViewController alloc]initWithRootViewController:meVc];
    [self addChildViewController:nav4];
    
}
// 设置tabBar上所有按钮内容
- (void)setupAllTitleButton{
    //首页0
    MYNavigationViewController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"首页";
    nav.tabBarItem.image = [UIImage imageOriginalWithName:@"tabBar_essence_icon"];
    // 快速生成一个没有渲染图片
    nav.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_essence_click_icon"];

    //动态1
    MYNavigationViewController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"动态";
    nav1.tabBarItem.image = [UIImage imageOriginalWithName:@"tabBar_new_icon"];
    nav1.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_new_click_icon"];
    //关注3
    MYNavigationViewController *nav3 = self.childViewControllers[2];
    nav3.tabBarItem.title = @"关注";
    nav3.tabBarItem.image = [UIImage imageOriginalWithName:@"tabBar_friendTrends_icon"];
    nav3.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_friendTrends_click_icon"];
    //我的4
    MYNavigationViewController *nav4 = self.childViewControllers[3];
    nav4.tabBarItem.title = @"我的";
    nav4.tabBarItem.image = [UIImage imageOriginalWithName:@"tabBar_me_icon"];
    nav4.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_me_click_icon"];
}


@end
