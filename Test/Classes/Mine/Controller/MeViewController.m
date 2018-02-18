//
//  MeViewController.m
//  Test
//
//  Created by 展亮 on 2018/1/21.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "MeViewController.h"
#import "LoginRegisterViewController.h"
#import "UIBarButtonItem+Item.h"
#import "SettingViewController.h"
#import <Masonry.h>
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)


#define IconButtonWidthAndHeight 91.5 * AutoLayoutScaleX


@interface MeViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, weak) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableViewCell *LoginButton;

@property (nonatomic, strong) UITableView *mytableView;



@end

@implementation MeViewController
#pragma mark - ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航条
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
//    entherSubController = NO;
    
    [self autoLayout];
    
    [self setupNavBar];
    // 处理cell间距,默认tableView分组样式,有额外头部和尾部间距
    self.mytableView.sectionHeaderHeight = 50;
    self.mytableView.sectionFooterHeight = 10;
//    self.mytableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TabBarButtonDidRepeatClick) name:@"TabBarButtonDidRepeatClickNotification" object:nil];
    

}


#pragma mark - monitoring
/**
 *  监听tabBarButton重复点击
 */
- (void)TabBarButtonDidRepeatClick{
    if (self.view.window == nil) return;
    NSLog(@"me");
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - autoLayout

- (void)autoLayout {
    
    // tableView
    [self.view addSubview:self.mytableView];

}
- (void)setupNavBar{
    
    //setting
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(setting)];
    //night
    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" selImage:@"mine-moon-icon-click" target:self action:@selector(night:)];
    self.navigationItem.rightBarButtonItems = @[settingItem,nightItem];
    //右边按钮
    //titleView
    self.navigationItem.title = @"我的";

}
//setting
- (void)setting{
    SettingViewController *settingVc = [[SettingViewController alloc] init];
    settingVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVc animated:YES];
}
//night
- (void)night:(UIButton *)button
{
    button.selected = !button.selected;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
#pragma mark - lazy load


- (UITableView *)tableView {
    if (_mytableView == nil) {
        _mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
    }
    return _mytableView;
}

#pragma mark - dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    // cell的属性
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    cell.textLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.87];
    self.mytableView.estimatedRowHeight = 0;
    self.mytableView.rowHeight = UITableViewAutomaticDimension;
    if (indexPath.section == 0) {
        cell.textLabel.text = @"点击登录账号";
        cell.imageView.image = [UIImage imageNamed:@"icon_1"];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"我关注的主题";
            cell.imageView.image = [UIImage imageNamed:@"icon_2"];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"我的收藏";
            cell.imageView.image = [UIImage imageNamed:@"icon_3"];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"我的通知";
            cell.imageView.image = [UIImage imageNamed:@"icon_4"];
        } else {
            cell.textLabel.text = @"帮助与反馈";
            cell.imageView.image = [UIImage imageNamed:@"icon_5"];
        }
    }
    else if (indexPath.section == 2) {
            cell.textLabel.text = @"创建主题";
            cell.imageView.image = [UIImage imageNamed:@"icon_6"];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 4;
    } else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }else{
        return UITableViewAutomaticDimension;
    }
}
#pragma mark - delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

        if (indexPath.section == 0) {

                LoginRegisterViewController *loginVc = [[LoginRegisterViewController alloc] init];
                [self presentViewController:loginVc animated:YES completion:nil];


        }
}








@end
