//
//  VideoRecordingHelper.h
//  ZWVideoRecording
//
//  Created by wlei on 2017/3/4.
//  Copyright © 2017年 cloverstudio.app. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^didFinishVideoRecordingHandle)(NSString * videoPath, UIImage *coverImage);

@interface VideoRecordingHelper : NSObject

@property (nonatomic,copy) void (^didFinishVideoRecordingHandle)(NSString * videoPath, UIImage *coverImage);

/**
 录制视频

 @param controller 视图控制器
 @param finishHander 结束后的回调代码块
 */
-(void)startVideoRecordingByViewController:(UIViewController *)controller finishHander:(didFinishVideoRecordingHandle)finishHander;

/// 播放视频
-(void)playVideoByViewController:(UIViewController *)controller videoPath:(NSString *)videoPath;

@end
