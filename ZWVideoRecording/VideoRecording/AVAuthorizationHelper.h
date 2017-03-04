//
//  AVAuthorizationHelper.h
//  VideoRecording
//  音视频权限验证帮助类
//  Created by wlei on 2017/3/3.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVAuthorizationHelper : NSObject

/// 检查是否拥有录像权限
+(BOOL)checkHasRecordVideoAuthorization;

/// 检查是否拥有视频权限
+(BOOL)checkHasVideoAuthorization;

/// 检查是否拥有音频权限
+(BOOL)checkHasAudioAuthorization;

@end
