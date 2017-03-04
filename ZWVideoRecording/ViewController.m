//
//  ViewController.m
//  ZWVideoRecording
//
//  Created by wlei on 2017/3/4.
//  Copyright © 2017年 cloverstudio.app. All rights reserved.
//

#import "ViewController.h"
#import "VideoRecordingHelper.h"


@interface ViewController (){
    
}

/// 视频封面
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
/// 播放按钮
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
/// 视频存放地址
@property (weak, nonatomic) IBOutlet UILabel *videoPath;

@property (nonatomic,strong) VideoRecordingHelper *helper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/// 启用视频录制
- (IBAction)startVideoRecording:(id)sender {
    _helper = [[VideoRecordingHelper alloc] init];
    __weak typeof(self)weakSelf = self;
    [_helper startVideoRecordingByViewController:self finishHander:^(NSString *videoPath, UIImage *coverImage) {
        NSLog(@"videoPath:%@",videoPath);
        weakSelf.coverImage.image = coverImage;
        weakSelf.playBtn.hidden = NO;
        weakSelf.videoPath.text = videoPath;
    }];
}

///播放按钮被点击
- (IBAction)playBtnOnClick:(id)sender {
    [_helper playVideoByViewController:self videoPath:_videoPath.text];
}


@end
