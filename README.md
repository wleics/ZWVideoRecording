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

>为了**兼容iOS10**，需要在**info.plist**中加入如下描述
>
```
	<key>NSCameraUsageDescription</key>
	<string>应用需要使用您手机的摄像头</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>应用需要使用您手机的麦克风</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>应用需要访问您的相册</string>
```