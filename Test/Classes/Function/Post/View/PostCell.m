//
//  TopicCell.m
//  Test
//
//  Created by 展亮 on 2018/2/2.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "PostCell.h"
#import "AllViewPost.h"
#import <UIImageView+WebCache.h>
#import "PostPictureView.h"
#import "PostVideoView.h"
#import "UIView+Frame.h"

@interface PostCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/* 中间控件 */
/** 图片控件 */
@property (nonatomic, weak) PostPictureView *pictureView;
/** 视频控件 */
@property (nonatomic, weak) PostVideoView *videoView;
@end

@implementation PostCell

#pragma mark - lazy load

- (PostPictureView *)pictureView
{
    if (!_pictureView) {
        PostPictureView *pictureView = [PostPictureView loadFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}
- (PostVideoView *)videoView
{
    if (!_videoView) {
        PostVideoView *videoView = [PostVideoView loadFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}
#pragma mark - init
- (void)awakeFromNib
{
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    //圆形头像（iOS9之前可能会出现问题）
    _profileImageView.layer.cornerRadius = 18;
    _profileImageView.layer.masksToBounds = YES;
}

- (void)setTopic:(AllViewPost *)topic
{
    _topic = topic;
    
    // 顶部控件的数据
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nameLabel.text = topic.name;
    self.passtimeLabel.text = topic.passtime;
    self.text_label.text = topic.text;
    
    // 底部按钮的文字
    [self setupButtonTitle:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.repostButton number:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton number:topic.comment placeholder:@"评论"];
    // 中间的内容
    if (topic.type == 10) { // 图片
        [self.pictureView setTopic:topic];
        self.pictureView.hidden = NO;
        self.videoView.hidden = YES;
    } else if (topic.type == 41) { // 视频
        [self.videoView setTopic:topic];
        self.pictureView.hidden = YES;

        self.videoView.hidden = NO;
    } else if (topic.type == 29) { // 段子
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.topic.type == 10) { // 图片
        self.pictureView.frame = self.topic.middleFrame;
    } else if (self.topic.type == 41) { // 视频
        self.videoView.frame = self.topic.middleFrame;
    }
}
/**
 *  设置按钮文字
 *  @param number      按钮的数字
 *  @param placeholder 数字为0时显示的文字
 */
- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder
{
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}
- (void)setFrame:(CGRect)frame{
    frame.size.height -= 10;
    [super setFrame:frame];
}

@end
