//
//  AVAuthorizationHelper.m
//  VideoRecording
//  
//  Created by wlei on 2017/3/3.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "AVAuthorizationHelper.h"
#import <AVFoundation/AVFoundation.h>

@implementation AVAuthorizationHelper

+(BOOL)checkHasRecordVideoAuthorization{
    BOOL result = NO;
    //摄像头权限
    AVAuthorizationStatus authVideoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //麦克风权限
    AVAuthorizationStatus authAudioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authAudioStatus==AVAuthorizationStatusNotDetermined || authVideoStatus==AVAuthorizationStatusNotDetermined) {
        result = YES;
    }else if (authAudioStatus == AVAuthorizationStatusAuthorized && authVideoStatus == AVAuthorizationStatusAuthorized) {
        result = YES;
    }
    return result;
}

/// 检查是否拥有视频权限
+(BOOL)checkHasVideoAuthorization{
    BOOL result = NO;
    //摄像头权限
    AVAuthorizationStatus authVideoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authVideoStatus == AVAuthorizationStatusAuthorized) {
        result = YES;
    }
    
    return result;
}

/// 检查是否拥有音频权限
+(BOOL)checkHasAudioAuthorization{
    BOOL result = NO;
    //摄像头权限
    AVAuthorizationStatus authAudioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authAudioStatus == AVAuthorizationStatusAuthorized) {
        result = YES;
    }
    
    return result;
}

@end
