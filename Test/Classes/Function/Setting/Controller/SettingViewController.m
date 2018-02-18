//
//  SettingViewController.m
//  Test
//
//  Created by 展亮 on 2018/1/22.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "SettingViewController.h"
#import "UIBarButtonItem+Item.h"
#import "SDImageCache.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

static NSString * const ID = @"cell";
#pragma mark - ViewController
//设置界面，点击我的右上角设置图标进入
- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}



#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 8;
}
- (UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.textLabel.text = @"设置功能";
    return cell;
}


@end
