//
//  VideoRecordingController.m
//  VideoRecording
//
//  Created by wlei on 17/1/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "VideoRecordingController.h"
#import "VideoRecordingManager.h"
#import "VideoRecordingWriter.h"
#import "VideoRecordingProgress.h"
#import "AVAuthorizationHelper.h"

@interface VideoRecordingController () <VideoRecordingManagerDelegate,UIAlertViewDelegate>{
    UIImage * _videoCover;//视频封面
}

@property (nonatomic, strong) VideoRecordingManager *recordingManager;

@property (nonatomic, weak) UIView   *topToolBar;
@property (nonatomic, weak) UIButton *flashBtn;
@property (nonatomic, weak) UIButton *switchCameraBtn;

@property (nonatomic, weak) UIView    *bottomToolBar;
@property (nonatomic, weak) UIButton  *startRecordingBtn;
@property (nonatomic, weak) UIButton  *playVideoBtn;
@property (nonatomic, weak) UIButton  *closeBtn;

@property (nonatomic, weak) UIView    *bottomToolBar2;

@property (nonatomic, weak) VideoRecordingProgress *recordingProgress;

@end

@implementation VideoRecordingController

#pragma mark - Lazy Load

- (VideoRecordingManager *)recordingManager {
    
    if (!_recordingManager) {
        _recordingManager = [[VideoRecordingManager alloc] init];
        _recordingManager.maxRecordingTime = 9.0;//最长录像时间，当前设置为9秒
        _recordingManager.autoSaveVideo = NO;//不自动保存
        _recordingManager.delegate = self;
    }
    return _recordingManager;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupTopToolBar];
    [self setupBottomToolBar];
    
    self.recordingManager.previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.recordingManager.previewLayer atIndex:0];
    [self.recordingManager startCapture];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
}

-(void)dealloc{
    
}

#pragma mark - Init UI

- (void)setupTopToolBar {
    
    UIView *topToolBar = [[UIView alloc] init];
    topToolBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    topToolBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    [self.view addSubview:topToolBar];
    _topToolBar = topToolBar;
    
    CGFloat btnWH = 44;
    CGFloat margin = 15;
    
    UIButton *flashBtn = [[UIButton alloc] init];
    flashBtn.frame = CGRectMake(0, margin, btnWH, btnWH);
    UIImage *camera_flash_off = [UIImage imageNamed:[@"VideoRecording.bundle" stringByAppendingPathComponent:@"camera_flash_off"]];
    UIImage *camera_flash_on = [UIImage imageNamed:[@"VideoRecording.bundle" stringByAppendingPathComponent:@"camera_flash_on"]];
    [flashBtn setImage:camera_flash_off forState:UIControlStateNormal];
    [flashBtn setImage:camera_flash_on forState:UIControlStateSelected];
    [flashBtn addTarget:self action:@selector(flashBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:flashBtn];
    _flashBtn = flashBtn;
    
    UIButton *switchCameraBtn = [[UIButton alloc] init];
    switchCameraBtn.frame = CGRectMake(self.view.frame.size.width - btnWH, margin, btnWH, btnWH);
    UIImage *switch_camera = [UIImage imageNamed:[@"VideoRecording.bundle" stringByAppendingPathComponent:@"switch_camera"]];
    [switchCameraBtn setImage:switch_camera forState:UIControlStateNormal];
    [switchCameraBtn addTarget:self action:@selector(switchCameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:switchCameraBtn];
    _switchCameraBtn = switchCameraBtn;
}

- (void)setupBottomToolBar {
    
    UIView *bottomToolBar = [[UIView alloc] init];
    bottomToolBar.frame = CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150);
    bottomToolBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    [self.view addSubview:bottomToolBar];
    _bottomToolBar = bottomToolBar;
    
    UIButton *startRecordingBtn = [[UIButton alloc] init];
    startRecordingBtn.frame = CGRectMake((bottomToolBar.frame.size.width - 75) * 0.5, (bottomToolBar.frame.size.height - 75) * 0.5, 75, 75);
    UIImage *start_recording = [UIImage imageNamed:[@"VideoRecording.bundle" stringByAppendingPathComponent:@"start_recording"]];
    [startRecordingBtn setImage:start_recording forState:UIControlStateNormal];
    [startRecordingBtn addTarget:self action:@selector(startRecordingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBar addSubview:startRecordingBtn];
    _startRecordingBtn = startRecordingBtn;
    
    VideoRecordingProgress *recordingProgress = [[VideoRecordingProgress alloc] initWithFrame:_startRecordingBtn.frame];
    recordingProgress.progressTintColor = [UIColor colorWithRed:1.00 green:0.28 blue:0.26 alpha:1.00];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopRecording)];
    [recordingProgress addGestureRecognizer:tap];
    [_bottomToolBar addSubview:recordingProgress];
    _recordingProgress = recordingProgress;
    _recordingProgress.hidden = YES;
    
    UIButton *playVideoBtn = [[UIButton alloc] init];
    playVideoBtn.frame = CGRectMake((_bottomToolBar.frame.size.width * 0.5 - 50) * 0.5, (_bottomToolBar.frame.size.height - 50) * 0.5, 50, 50);
    playVideoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    playVideoBtn.layer.cornerRadius = playVideoBtn.frame.size.height * 0.5;
    playVideoBtn.layer.masksToBounds = YES;
    [playVideoBtn addTarget:self action:@selector(playVideoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolBar addSubview:playVideoBtn];
    _playVideoBtn = playVideoBtn;
    _playVideoBtn.hidden = YES;
    
    //添加取消按钮
    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.frame = CGRectMake(0, 0, 20, 30);
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn sizeToFit];
    CGFloat x = _bottomToolBar.frame.size.width-closeBtn.frame.size.width;
    CGFloat y = _bottomToolBar.frame.size.height * 0.5;
    closeBtn.center = CGPointMake(x,y);
    [closeBtn addTarget:self action:@selector(closeBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolBar addSubview:closeBtn];
    _closeBtn = closeBtn;
    
    
    //底部视图2
    CGFloat bottomToolBar2H = 80.0;
    UIView *bottomToolBar2 = [[UIView alloc] init];
    bottomToolBar2.frame = CGRectMake(0, self.view.frame.size.height - bottomToolBar2H, self.view.frame.size.width, bottomToolBar2H);
    bottomToolBar2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    [self.view addSubview:bottomToolBar2];
    _bottomToolBar2 = bottomToolBar2;
    
    //使用视频按钮
    UIButton *useVideoBtn = [[UIButton alloc] init];
    [useVideoBtn setTitle:@"使用视频" forState:UIControlStateNormal];
    [useVideoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    useVideoBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [useVideoBtn sizeToFit];
    useVideoBtn.frame = CGRectMake(bottomToolBar2.frame.size.width-useVideoBtn.frame.size.width -10, (bottomToolBar2.frame.size.height-useVideoBtn.frame.size.height) *0.5, useVideoBtn.frame.size.width, useVideoBtn.frame.size.height);
    [useVideoBtn addTarget:self action:@selector(useVideoBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolBar2 addSubview:useVideoBtn];
    
    //添加重拍按钮
    UIButton *reRecordVideoBtn = [[UIButton alloc] init];
    [reRecordVideoBtn setTitle:@"重拍" forState:UIControlStateNormal];
    [reRecordVideoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reRecordVideoBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [reRecordVideoBtn sizeToFit];
    reRecordVideoBtn.frame = CGRectMake(10, (bottomToolBar2.frame.size.height-reRecordVideoBtn.frame.size.height) *0.5, reRecordVideoBtn.frame.size.width, reRecordVideoBtn.frame.size.height);
    [reRecordVideoBtn addTarget:self action:@selector(reRecordBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolBar2 addSubview:reRecordVideoBtn];
    
    //添加播放按钮
    UIButton *playRecordBtn = [[UIButton alloc] init];
    UIImage *image = [UIImage imageNamed:[@"VideoRecording.bundle" stringByAppendingPathComponent:@"play"]];
    [playRecordBtn setBackgroundImage:image forState:UIControlStateNormal];
    playRecordBtn.frame = CGRectMake(0, 0, 50, 50);
    playRecordBtn.center = CGPointMake(bottomToolBar2.frame.size.width*0.5, bottomToolBar2.frame.size.height*0.5);
    [playRecordBtn addTarget:self action:@selector(playVideoBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolBar2 addSubview:playRecordBtn];
    
    bottomToolBar2.hidden = YES;
}

#pragma mark - Actions



- (void)flashBtnAction:(UIButton *)sender {
    
    if (_switchCameraBtn.selected) {
        return;
    }
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.recordingManager openFlashLight];
    } else {
        [self.recordingManager closeFlashLight];
    }
}

- (void)switchCameraBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        _flashBtn.selected = NO;
        [self.recordingManager closeFlashLight];
        [self.recordingManager switchCameraInputDeviceToFront];
    } else {
        [self.recordingManager swithCameraInputDeviceToBack];
    }
}

- (void)startRecordingBtnAction:(UIButton *)sender {
    
    //对是否拥有录像权限进行验证，验证通过后方可进行录像
    if ([AVAuthorizationHelper checkHasRecordVideoAuthorization]) {
        sender.hidden = YES;
        _recordingProgress.hidden = NO;
        //隐藏取消按钮
        _closeBtn.hidden = YES;
        //隐藏工具栏
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _topToolBar.transform = CGAffineTransformMakeTranslation(0, -64);
                         } completion:nil];
        
        [self.recordingManager startRecoring];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您没有启用与录像相关的权限，请开启相应权限后，重新尝试当前操作！" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles: nil];
        [alert show];
    }
    
    
}

- (void)playVideoBtnAction {
    
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:self.recordingManager.videoPath]];
    [self presentViewController:playerViewController animated:YES completion:nil];
}

-(void)closeBtnOnClick{
    
    //回调父页面
    if (_delegate && [_delegate respondsToSelector:@selector(videoRecordingController:recordComplete:coverImage:)]) {
        [_delegate videoRecordingController:self recordComplete:self.recordingManager.videoPath coverImage:_videoCover];
    }

    //关闭当前页面
    [self dismissViewControllerAnimated:YES completion:^{

        
    }];
}

- (void)stopRecording {
    
    _startRecordingBtn.hidden = NO;
    _recordingProgress.hidden = YES;
    _playVideoBtn.hidden = NO;
    
    __weak typeof(self) weakSelf = self;
    [self.recordingManager stopRecordingHandler:^(UIImage *firstFrameImage) {
        _videoCover = firstFrameImage;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.bottomToolBar.alpha = 0;
            weakSelf.bottomToolBar2.alpha = 1;
        } completion:^(BOOL finished) {
            
            weakSelf.bottomToolBar.hidden = YES;
            weakSelf.bottomToolBar2.hidden = NO;
        }];

    }];
    
    //停止视频捕捉
    [self.recordingManager stopCapture];
}

/// 重拍
- (void)reRecordBtnOnClick{
    ///删除刚才拍摄的视频
    if (self.recordingManager.videoPath) {
        BOOL videoExist=[[NSFileManager defaultManager] fileExistsAtPath:self.recordingManager.videoPath];
        if (videoExist) {
            BOOL deleteResult = [[NSFileManager defaultManager] removeItemAtPath:self.recordingManager.videoPath error:nil];
            if (deleteResult) {
                self.recordingManager.videoPath = nil;
                _videoCover = nil;
            }
        }
    }
    
    //显示工具栏
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _topToolBar.transform = CGAffineTransformIdentity;
                     } completion:nil];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bottomToolBar.alpha = 1;
        weakSelf.bottomToolBar2.alpha = 0;
    } completion:^(BOOL finished) {
        weakSelf.bottomToolBar.hidden = NO;
        weakSelf.bottomToolBar2.hidden = YES;
        //显示取消按钮
        _closeBtn.hidden = NO;
        
    }];
    //重启启动视频捕捉
    [self.recordingManager startCapture];
}

/// 使用相册按钮被点击
- (void)useVideoBtnOnClick{
    //保存到相册
    [self.recordingManager saveVideoToAlbum];
    [self closeBtnOnClick];
}

/// 播放视频按钮被点击
- (void)playVideoBtnOnClick{
    [self playVideoBtnAction];
}

#pragma mark - SRRecordingManagerDelegate

- (void)updateRecordingProgress:(CGFloat)progress {
    
    _recordingProgress.progress = progress;
    
    if (progress >= 1.0) {
        [self stopRecording];
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self closeBtnOnClick];
    }
}

@end
