//
//  IndexViewController.m
//  Test
//
//  Created by 展亮 on 2018/1/21.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "IndexViewController.h"
#import "UIBarButtonItem+Item.h"
#import "LoginRegisterViewController.h"
#import "TitleButton.h"
#import "VideoViewController.h"
#import "PictureViewController.h"
#import "WordViewController.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
//#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
//#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface IndexViewController ()<UIScrollViewDelegate>
/** 用来存放所有子控制器view的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;
/** 标题下划线 */
@property (nonatomic, weak) UIView *titleUnderline;
/** 上一次点击的标题按钮 */
@property (nonatomic, weak) TitleButton *previousClickedTitleButton;

@end

@implementation IndexViewController
#pragma mark - ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化子控制器
    [self setupAllChildVcs];
    // 设置导航条
    [self setupNavBar];
    // scrollView
    [self setupScrollView];
    // 标题栏
    [self setupTitlesView];
    // 添加第0个子控制器的view
    [self addChildVcViewIntoScrollView:0];

}
/**
 *  初始化子控制器
 */
- (void)setupAllChildVcs{
//    [self addChildViewController:[[AllViewController alloc] init]];
    [self addChildViewController:[[VideoViewController alloc] init]];
    [self addChildViewController:[[PictureViewController alloc] init]];
    [self addChildViewController:[[WordViewController alloc] init]];
    
}
/**
 *  设置导航条
 */
- (void)setupNavBar{
    //左边按钮
    //把UIBarButton包装成UIBarButtonItem就会导致按钮点击区域扩大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"commentLikeButton" highImage:@"commentLikeButtonClick" target:self action:@selector(game)];
    //右边按钮
    
    //titleView
//    self.navigationItem.title = @"我的";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"front_page_icon_52x18_"]];
}
/**
 *  scrollView
 */
- (void)setupScrollView{
    // 不允许自动修改UIScrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor darkGrayColor];
    scrollView.frame = self.view.bounds;
    scrollView.delegate= self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollsToTop = NO; // 点击状态栏的时候，这个scrollView不会滚动到最顶部
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 添加子控制器的view
    scrollView.contentSize = CGSizeMake(3 * scrollView.frame.size.width, 0);
    
}
/**
 *  标题栏
 */
- (void)setupTitlesView{

    
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor whiteColor];
//    titlesView.alpha = 0.5;

    titlesView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 35);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;

    // 标题栏按钮
    [self setupTitleButtons];
    // 标题下划线
    [self setupTitleUnderline];
    
}
/**
 *  标题栏按钮
 */
- (void)setupTitleButtons{
    // 文字
    NSArray *titles = @[@"视频",@"图片",@"文字"];
    NSUInteger count = titles.count;
    // 创建3个标题按钮
    for (NSInteger i = 0; i < count; i++) {
        TitleButton *titleButton = [[TitleButton alloc] init];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(TitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesView addSubview:titleButton];
        CGFloat titleButtonW = SCREEN_WIDTH / count;
        CGFloat titleButtonH = SCREEN_HEIGHT;
        //frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, 35);
        // 文字
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        //设置被选中的按钮的颜色，在程序第一次运行时，默认将选中第一个按钮
        [titleButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        if (titleButton.tag == 0) {
            [self dealTitleButtonClick:titleButton];
        }
    }
    
}
/**
 *  标题下划线
 */
- (void)setupTitleUnderline{
    // 标题按钮
    TitleButton *firstTitleButton = self.titlesView.subviews.firstObject;
    // 下划线
    UIView *titleUnderline = [[UIView alloc] init];

    titleUnderline.frame = CGRectMake(30, 33, 70, 2);
    titleUnderline.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];

    [self.titlesView addSubview:titleUnderline];
    self.titleUnderline = titleUnderline;
}
#pragma mark - Monitoring
/**
 *  点击标题按钮
 */
- (void)TitleButtonClick:(TitleButton *)titleButton{
    // 重复点击了标题按钮
    if (self.previousClickedTitleButton == titleButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TabBarButtonDidRepeatClickNotification" object:nil];
    }
    // 处理标题按钮点击
    [self dealTitleButtonClick:titleButton];
    
}
/**
 *  处理标题按钮点击
 */
- (void)dealTitleButtonClick:(TitleButton *)titleButton{
    // 切换按钮状态
    self.previousClickedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.previousClickedTitleButton = titleButton;
    NSInteger index = titleButton.tag;
    
    [UIView animateWithDuration:0.25 animations:^{
        // 处理下划线
        self.titleUnderline.frame = CGRectMake(titleButton.center.x - 35, 33, 70, 2);
        // 滚动scrollView
        CGFloat offsetX = self.scrollView.frame.size.width * index;
        self.scrollView.contentOffset = CGPointMake(offsetX, self.scrollView.contentOffset.y);

    }completion:^(BOOL finished) {
        // 添加子控制器的view
        [self addChildVcViewIntoScrollView:index];
    }];
    // 设置index位置对应的tableView.scrollsToTop = YES， 其他都设置为NO
    for (NSUInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        // 如果view还没有被创建，就不用去处理
        if (!childVc.isViewLoaded) continue;
        
        UIScrollView *scrollView = (UIScrollView *)childVc.view;
        if (![scrollView isKindOfClass:[UIScrollView class]]) continue;
        
        if (i == index) { // 是标题按钮对应的子控制器
            scrollView.scrollsToTop = YES;
        } else {
            scrollView.scrollsToTop = NO;
        }
        
    }
}


#pragma mark - <UIScrollViewDelegate>
/**
 *  当用户松开scrollView并且滑动结束时调用这个代理方法（scrollView停止滚动的时候）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 求出标题按钮的索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    // index == [0, 4]
    
    // 点击对应的标题按钮
    TitleButton *titleButton = self.titlesView.subviews[index];
    //    TitleButton *titleButton = [self.titlesView viewWithTag:index];
    [self TitleButtonClick:titleButton];
}
#pragma mark - other
/**
 *  添加第index个子控制器的view到scrollView中
 */
- (void)addChildVcViewIntoScrollView:(NSUInteger)index{
    UIView *childVcView = self.childViewControllers[index].view;
    //当已经加载完成后，不再重复加载（有时候我们想要让他重新加载，所以这个功能并不能说是一定需要或一定不需要）
    if (childVcView.window) return;
    childVcView.frame = CGRectMake(index   * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    // 添加子控制器的view到scrollView中
    [self.scrollView addSubview:childVcView];
}
- (void)game{
    // 进入到登录注册界面
    LoginRegisterViewController *loginVc = [[LoginRegisterViewController alloc] init];
    [self presentViewController:loginVc animated:YES completion:nil];
}

@end
