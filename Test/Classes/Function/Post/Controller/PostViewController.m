//
//  PostViewController.m
//  Test
//
//  Created by 展亮 on 2018/2/7.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "PostViewController.h"
#import "AllViewPost.h"
#import "PostCell.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <SDImageCache.h>
#import <MJRefresh.h>

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface PostViewController ()
/** 所有的帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 当前最后一条帖子数据的描述信息，专门用来加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;

@end



@implementation PostViewController



/* cell的重用标识 */
static NSString * const TopicCellId = @"TopicCellId";
/** 默认返回1 */
- (NSInteger)type
{
    return 1;
}
#pragma mark - ViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor grayColor];
    
    self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 49, 0);
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    // 注册cell
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([PostCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TopicCellId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TabBarButtonDidRepeatClick) name:@"TabBarButtonDidRepeatClickNotification" object:nil];
    [self setupRefresh];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setupRefresh{
    
    // 点击发布你的第一条动态～
//    UILabel *label = [[UILabel alloc] init];
//    label.backgroundColor = [UIColor whiteColor];
//    label.frame = CGRectMake(0, 0, 0, 30);
//    label.textColor = [UIColor greenColor];
//    label.text = @"点击发布你的第一条动态～";
//    label.textAlignment = NSTextAlignmentCenter;
//    self.tableView.tableHeaderView = label;
    
    //header
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.font = [UIFont systemFontOfSize:17];
    [header beginRefreshing];
    self.tableView.mj_header = header;
    
    //footer
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
#pragma mark - Monitoring
/**
 *  监听tabBarButton重复点击
 */
- (void)TabBarButtonDidRepeatClick{
    // 重复点击的不是精华按钮
    if (self.view.window == nil) return;
    // 显示在正中间的不是VideoViewController
    if (self.tableView.scrollsToTop == NO) return;
    //    NSLog(@"TopicViewController");
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - data processing
/**
 *  发送请求给服务器，下拉刷新数据
 */
- (void)loadNewData{
    //load new data
    //http://s.budejie.com/topic/list/zuixin/1/bs0315-iphone-4.5.6/0-20.json
    //http://api.budejie.com/api/api_open.php
    // 1.创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    
    // 3.发送请求
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        // 字典数组 -> 模型数据
        self.topics = [AllViewPost mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) { // 并非是取消任务导致的error，其他网络问题导致的error
        [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
        }
        [self.tableView.mj_header endRefreshing];
    }];
    
}
/**
 *  发送请求给服务器，上拉加载更多数据
 */
- (void)loadMoreData{
    //request more date
    // 1.创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    parameters[@"maxtime"] = self.maxtime;
    //    self.page ++;
    //    parameters[@"page"] = @"self.page";
    // 3.发送请求
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        // 字典数组 -> 模型数据
        NSArray *moreTopics = [AllViewPost mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 累加到旧数组的后面
        [self.topics addObjectsFromArray:moreTopics];
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) { // 并非是取消任务导致的error，其他网络问题导致的error
        [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
        }
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // 根据数据量显示或者隐藏footer
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:TopicCellId];
    
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllViewPost *topic = self.topics[indexPath.row];
    
    CGFloat cellHeight = 0;
    
    cellHeight += 55;
    
    CGSize textMaxSize = CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT);
    cellHeight += [topic.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + 20;
    
    if (topic.type != 29) { // 中间有内容（图片、声音、视频）
        
        CGFloat middleW = textMaxSize.width;
        //        CGFloat middleH = middleW * topic.height / topic.width;
        CGFloat middleH = middleW * topic.height / topic.width;
        if (middleH >= SCREEN_HEIGHT) { // 显示的图片高度超过一个屏幕，就是超长图片
            middleH = 200;
            topic.bigPicture = YES;
        }
        CGFloat middleY = cellHeight;
        CGFloat middleX = 10;
        topic.middleFrame = CGRectMake(middleX, middleY, middleW, middleH);
        cellHeight += middleH + 20;
    }
    
    cellHeight += 35;
    
    return cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 清除内存缓存
    [[SDImageCache sharedImageCache] clearMemory];
}
@end

