//
//  VideoRecordingHelper.m
//  ZWVideoRecording
//
//  Created by wlei on 2017/3/4.
//  Copyright © 2017年 cloverstudio.app. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "VideoRecordingHelper.h"
#import "VideoRecordingController.h"
#import "CameraAuthorityHintController.h"
#import "AVAuthorizationHelper.h"
#import <AVKit/AVKit.h>

@interface VideoRecordingHelper ()<VideoRecordingControllerDelegate>

@end

@implementation VideoRecordingHelper

-(void)startVideoRecordingByViewController:(UIViewController *)controller finishHander:(didFinishVideoRecordingHandle)finishHander{
    if (!controller) {
        return;
    }
    
    _didFinishVideoRecordingHandle = finishHander;
    
    BOOL iOS7Later = ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f);
    if ([AVAuthorizationHelper checkHasRecordVideoAuthorization] && iOS7Later) {
        VideoRecordingController *vc= [VideoRecordingController new];
        vc.delegate = self;
        [controller presentViewController:vc animated:YES completion:nil];
    }else{
        //NSLog(@"您没有启用摄像头权限");
        CameraAuthorityHintController *rootViewController = [CameraAuthorityHintController new];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        //设置导航栏的背景色
        nvc.navigationBar.barTintColor = [UIColor colorWithRed:216/255.0 green:46/255.0 blue:57/255.0 alpha:1.0];
        
        [controller presentViewController:nvc animated:YES completion:nil];
    }

}

/// 播放视频
-(void)playVideoByViewController:(UIViewController *)controller videoPath:(NSString *)videoPath{
    if (videoPath&&![videoPath isEqualToString:@""]) {
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
        playerViewController.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:videoPath]];
        [controller presentViewController:playerViewController animated:YES completion:nil];
    }
}

#pragma mark - VideoRecordingControllerDelegate

-(void)videoRecordingController:(VideoRecordingController *)controller recordComplete:(NSString *)videoPath coverImage:(UIImage *)coverImage{
    if (controller) {
        controller.delegate = nil;
    }
    if (videoPath && coverImage &&_didFinishVideoRecordingHandle) {
        _didFinishVideoRecordingHandle(videoPath,coverImage);
    }

}

@end
