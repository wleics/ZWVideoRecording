//
//  VideoRecordingController.h
//  VideoRecording
//
//  Created by wlei on 17/1/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoRecordingController;

@protocol VideoRecordingControllerDelegate <NSObject>

/// 视频录制页面关闭后的回调
-(void)videoRecordingController:(VideoRecordingController *)controller recordComplete:(NSString *)videoPath coverImage:(UIImage *)coverImage;

@end

@interface VideoRecordingController : UIViewController

@property (nonatomic,weak) id<VideoRecordingControllerDelegate> delegate;

@end
