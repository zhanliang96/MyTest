//
//  NewViewController.m
//  Test
//
//  Created by 展亮 on 2018/1/21.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "NewViewController.h"
#import "UIBarButtonItem+Item.h"
#import "FindViewController.h"
#import "AllViewController.h"
#import "TitleButton.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface NewViewController ()<UIScrollViewDelegate>
/** 用来存放所有子控制器view的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;

@end

@implementation NewViewController
#pragma mark - ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化子控制器
    [self addChildViewController:[[AllViewController alloc] init]];
    // 设置导航条
    [self setupNavBar];
    // scrollView
    [self setupScrollView];
    // 标题栏
    [self setupTitlesView];
    // 添加第0个子控制器的view
    [self addChildVcViewIntoScrollView:0];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TabBarButtonDidRepeatClick) name:@"TabBarButtonDidRepeatClickNotification" object:nil];
    

}
- (void)TabBarButtonDidRepeatClick{
    if (self.view.window == nil) return;
    NSLog(@"New");
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 设置导航条
- (void)setupNavBar{
    //左边按钮
    
    //把UIBarButton包装成UIBarButtonItem就会导致按钮点击区域扩大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    //右边按钮
    //titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"front_page_icon_52x18_"]];
}
/**
 *  scrollView
 */
- (void)setupScrollView{
    // 不允许自动修改UIScrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor blueColor];
    scrollView.frame = self.view.bounds;
    scrollView.delegate= self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollsToTop = NO; // 点击状态栏的时候，这个scrollView不会滚动到最顶部
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 添加子控制器的view
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 0);
    
}
- (void)setupTitlesView{
    
    
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
    //    titlesView.alpha = 0.5;
    titlesView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 35);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 标题栏按钮
    [self setupTitleButtons];

    
}

/**
 *  标题栏按钮
 */
- (void)setupTitleButtons{
    // 文字
    NSArray *titles = @[@"全部动态"];
    NSUInteger count = titles.count;
    // 创建3个标题按钮
    for (NSInteger i = 0; i < count; i++) {
        TitleButton *titleButton = [[TitleButton alloc] init];
        titleButton.tag = i;
//        [titleButton addTarget:self action:@selector(TitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesView addSubview:titleButton];
        CGFloat titleButtonW = SCREEN_WIDTH / count;
        CGFloat titleButtonH = SCREEN_HEIGHT;
        //frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, 35);
        // 文字
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        
    }
    
}


- (void)tagClick{
    // 进入推荐标签界面
    FindViewController *subTag = [[FindViewController alloc] init];
    [self.navigationController pushViewController:subTag animated:YES];
}

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
@end
