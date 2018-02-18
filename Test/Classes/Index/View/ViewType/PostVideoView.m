//
//  VideoView.m
//  Test
//
//  Created by 展亮 on 2018/2/3.
//  Copyright © 2018年 展亮. All rights reserved.
//

#import "PostVideoView.h"
#import "AllViewPost.h"
#import "SeeBigPictureViewController.h"
#import <UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>


@interface PostVideoView()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *playcountLbl;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderV;
@property (weak, nonatomic) IBOutlet UIButton *videoPlayBtn;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@end
static AVPlayer * video_player;
static AVPlayerLayer *playerLayer;
static UIButton *lastPlayBtn;
static AllViewPost *lastTopicM;
static NSTimer *avTimer;
static UIProgressView *progress;//进度条

@implementation PostVideoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.imageV.userInteractionEnabled = YES;
    [self.imageV addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}
- (void)seeBigPicture{

    [self play:self.videoPlayBtn];
}

- (void)setTopic:(AllViewPost *)topic{
    _topic = topic;
    
    self.placeholderV.hidden = YES;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:topic.image1]];
    
    if (topic.playcount >= 10000) {
        self.playcountLbl.text = [NSString stringWithFormat:@"%.1f万播放", topic.playcount / 10000.0];
    } else {
        self.playcountLbl.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    }
    
    self.videotimeLbl.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.videotime / 60, topic.videotime % 60];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.topic.videouri]];
        video_player = [AVPlayer playerWithPlayerItem:self.playerItem];
        video_player.volume = 1.0f;
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:video_player];
        playerLayer.backgroundColor = [UIColor clearColor].CGColor;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        avTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
        [avTimer setFireDate:[NSDate distantFuture]];
        progress = [[UIProgressView alloc] initWithFrame:CGRectZero];
        progress.backgroundColor = [UIColor whiteColor];
        progress.tintColor = [UIColor whiteColor];
        progress.trackTintColor =[UIColor whiteColor];
        progress.progressTintColor = [UIColor redColor];
    });
    self.topic.videoPlaying = NO;
    lastTopicM.videoPlaying = NO;
    [self.videoPlayBtn setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [lastPlayBtn  setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [video_player pause];//可以继续播放 else else else
    [avTimer setFireDate:[NSDate distantFuture]];
    [playerLayer removeFromSuperlayer];
    progress.hidden = !self.topic.videoPlaying;
    progress.progress = 0;
}

- (void)timer{

    Float64 currentTime = CMTimeGetSeconds(video_player.currentItem.currentTime);
    if (currentTime > 0){
        progress.progress =  currentTime / CMTimeGetSeconds(video_player.currentItem.duration);
    }
}

- (IBAction)play:(UIButton *)playBtn {
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion integerValue] < 9) {
        //如果当前的系统版本小于9
        MPMoviePlayerViewController *movieVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:self.topic.videouri]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentMoviePlayerViewControllerAnimated:movieVC];
    }else{
        //状态反转
        playBtn.selected = !playBtn.isSelected;
        lastPlayBtn.selected = !lastPlayBtn.isSelected;
        if (lastTopicM != self.topic) {
//            [video_player replaceCurrentItemWithPlayerItem:self.playerItem];
            //如果点击了一个新的视频
            [playerLayer removeFromSuperlayer];
            self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.topic.videouri]];
            //将之前的视频替换成现在的视频
            [video_player replaceCurrentItemWithPlayerItem:self.playerItem];
            //猜测，当替换完毕再进行播放
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playerItemDidReachEnd:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:self.playerItem];
            
            playerLayer.frame = CGRectMake(self.imageV.frame.origin.x, self.imageV.frame.origin.y, self.imageV.frame.size.width, self.imageV.frame.size.height);
            progress.frame = CGRectMake(playerLayer.frame.origin.x, CGRectGetMaxY(playerLayer.frame), playerLayer.frame.size.width, 2);

            [self.layer addSublayer:playerLayer];
            playerLayer.frame = CGRectMake(self.imageV.frame.origin.x, self.imageV.frame.origin.y, self.imageV.frame.size.width, self.imageV.frame.size.height);
            progress.frame = CGRectMake(playerLayer.frame.origin.x, CGRectGetMaxY(playerLayer.frame), playerLayer.frame.size.width, 2);
            [self.layer addSublayer:playerLayer];
            [self addSubview:progress];
            progress.progress = 0;
            [video_player play];
            [avTimer setFireDate:[NSDate date]];
            lastTopicM.videoPlaying = NO;
            self.topic.videoPlaying = YES;
            [lastPlayBtn setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
            [playBtn setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
        }else{
            if(lastTopicM.videoPlaying){
                //暂停
//              [playerLayer removeFromSuperlayer];
                [video_player pause];
                [avTimer setFireDate:[NSDate distantFuture]];
                self.topic.videoPlaying = NO;
                [playBtn setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
            }else{
                //暂停后继续播放
                playerLayer.frame = CGRectMake(self.imageV.frame.origin.x, self.imageV.frame.origin.y, self.imageV.frame.size.width, self.imageV.frame.size.height);
                progress.frame = CGRectMake(playerLayer.frame.origin.x, CGRectGetMaxY(playerLayer.frame), playerLayer.frame.size.width, 2);
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(playerItemDidReachEnd:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:self.playerItem];
                [self.layer addSublayer:playerLayer];
                [self addSubview:progress];
                [video_player play];
                [avTimer setFireDate:[NSDate date]];
                self.topic.videoPlaying = YES;
                [playBtn setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
            }
        }
        progress.hidden = !self.topic.videoPlaying;
        lastTopicM = self.topic;
        lastPlayBtn = playBtn;
        //        AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
        //        playerVC.player = player;
        //        [playerVC.player play];
        //        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playerVC animated:YES completion:nil];
    }
}

-(void)playerItemDidReachEnd:(AVPlayerItem *)playerItem{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    lastTopicM.videoPlaying = NO;
    self.topic.videoPlaying = NO;
    [lastPlayBtn setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [self.videoPlayBtn setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [video_player pause];
    [video_player seekToTime:kCMTimeZero];
    [playerLayer removeFromSuperlayer];
    progress.hidden = !self.topic.videoPlaying;
    progress.progress = 0;
}

-(void)dealloc{
    [video_player pause];
    [playerLayer removeFromSuperlayer];
    lastTopicM.videoPlaying = NO;
    [lastPlayBtn setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //[avTimer_ invalidate];
    //avTimer_= nil;
}

@end
