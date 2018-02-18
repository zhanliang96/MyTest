//
//  FindViewController.m
//  Test
//
//  Created by 展亮 on 2018/1/24.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "FindViewController.h"
#import <AFNetworking.h>
#import "FindItem.h"
#import <MJExtension.h>
#import "ShowMyCell.h"
#import <SVProgressHUD.h>
#import "UIBarButtonItem+Item.h"
#import "LoginRegisterViewController.h"
#import <Masonry.h>
#import "SearchViewController.h"

static NSString * const ID = @"cell";
@interface FindViewController ()
@property (nonatomic, strong) NSArray *Tags;
@property (nonatomic, weak) AFHTTPSessionManager *mgr;


@end

@implementation FindViewController

#pragma mark - ViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TabBarButtonDidRepeatClick) name:@"TabBarButtonDidRepeatClickNotification" object:nil];
    [self loadData];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ShowMyCell" bundle:nil] forCellReuseIdentifier:ID];
//    self.title = @"关注";
    // 提示用户当前正在加载数据 SVPro
    [SVProgressHUD showWithStatus:@"loading"];
}
// 界面即将消失调用
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [_mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
}
#pragma mark - data processing
- (void)loadData{
    // 1.创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    _mgr = mgr;
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"action"] = @"sub";
    parameters[@"c"] = @"topic";
    
    // 3.发送请求
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        // 字典数组转换模型数组
        _Tags = [FindItem mj_objectArrayWithKeyValuesArray:responseObject];
        
        // 刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
    
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.Tags.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    ShowMyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    FindItem *item = self.Tags[indexPath.row];
    cell.item = item;
//    cell.textLabel.text = item.theme_name;
    
    // Configure the cell...
    
    return cell;
}
//set high = 80
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
    
}

- (void)TabBarButtonDidRepeatClick{
    if (self.view.window == nil) return;
    NSLog(@"FriendTrend");
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
// 点击登录注册就会调用
- (IBAction)clickLoginRegister:(id)sender {
    // 进入到登录注册界面
    LoginRegisterViewController *loginVc = [[LoginRegisterViewController alloc] init];
    [self presentViewController:loginVc animated:YES completion:nil];
}
#pragma mark - 设置导航条
- (void)setupNavBar{
    //左边按钮
    //把UIBarButton包装成UIBarButtonItem就会导致按钮点击区域扩大
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsRecomment)];
//    右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"navbar_icon_search" highImage:@"navbar_icon_search" target:self action:@selector(friendsRecomment)];
    
    
    //titleView
    self.navigationItem.title = @"我的关注";
//    self.navigationItem.searchController;
    
    

}

// 推荐关注
- (void)friendsRecomment{
    [self.navigationController pushViewController:[[SearchViewController alloc]init] animated:YES];
}



















@end
