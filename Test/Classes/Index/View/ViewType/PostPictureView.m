//
//  PostPictureView.m
//  Test
//
//  Created by 展亮 on 2018/2/3.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "PostPictureView.h"
#import "AllViewPost.h"
#import "SeeBigPictureViewController.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
@interface PostPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;


@end

@implementation PostPictureView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}
/**
 *  查看大图
 */
- (void)seeBigPicture{
    SeeBigPictureViewController *sbvc = [[SeeBigPictureViewController alloc] init];
    sbvc.topic = self.topic;
    [self.window.rootViewController presentViewController:sbvc animated:YES completion:nil];
}

- (void)setTopic:(AllViewPost *)topic
{
    _topic = topic;
    
    // 设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1]];

    // gif
    self.gifView.hidden = !topic.is_gif;
    
    // 点击查看大图
    if (topic.isBigPicture) { // 超长图
        self.seeBigPictureButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    } else {
        self.seeBigPictureButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
}

@end
