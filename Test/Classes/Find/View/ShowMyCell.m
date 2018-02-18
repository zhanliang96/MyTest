//
//  FindMyCell.m
//  Test
//
//  Created by 展亮 on 2018/1/24.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "ShowMyCell.h"
#import "FindItem.h"
#import <UIImageView+WebCache.h>
@interface ShowMyCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *numView;

@end

@implementation ShowMyCell
- (void)setItem:(FindItem *)item{
    _item = item;
    // 设置内容
    _nameView.text = item.theme_name;
    // 判断下有没有>10000
    NSString *numStr = [NSString stringWithFormat:@"%@人关注",item.sub_number] ;
    NSInteger num = item.sub_number.integerValue;
    if (num > 10000) {
        CGFloat numF = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f万人关注",numF];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    
    _numView.text = numStr;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:item.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}
// 从xib加载就会调用一次
- (void)awakeFromNib {
    [super awakeFromNib];
    // 设置头像圆角,iOS9苹果修复
//    _iconView.layer.cornerRadius = 30;
//    _iconView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
