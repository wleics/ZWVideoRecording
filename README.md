# ZWVideoRecording
调用摄像头录制视频的封装，一行代码完成视频录制操作

##使用方法
```objective-c
@property (nonatomic,strong) VideoRecordingHelper *helper;
...
...
...
_helper = [[VideoRecordingHelper alloc] init];
    __weak typeof(self)weakSelf = self;
    [_helper startVideoRecordingByViewController:self finishHander:^(NSString *videoPath, UIImage *coverImage) {
        weakSelf.coverImage.image = coverImage;
        weakSelf.playBtn.hidden = NO;
        weakSelf.videoPath.text = videoPath;
    }];
```