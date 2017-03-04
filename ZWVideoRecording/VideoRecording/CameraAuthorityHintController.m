//
//  CameraAuthorityHintController.m
//  VideoRecording
//
//  Created by wlei on 2017/3/3.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "CameraAuthorityHintController.h"
#import "AVAuthorizationHelper.h"

@interface CameraAuthorityHintController ()

/// 提示信息
@property (weak, nonatomic) IBOutlet UILabel *hintMsg;
/// 提示信息
@property (weak, nonatomic) IBOutlet UILabel *hintMsg2;
/// 警告图片
@property (weak, nonatomic) IBOutlet UIImageView *hintImage;

@end

@implementation CameraAuthorityHintController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
    if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
    
    NSString * str4Video = @"";
    NSString * str4Audio = @"";
    
    if (![AVAuthorizationHelper checkHasVideoAuthorization]) {
        str4Video = [NSString stringWithFormat:@"请在iPhone的\"设置-隐私-相机\"中允许%@访问相机",appName];
    }
    if (![AVAuthorizationHelper checkHasAudioAuthorization]) {
        str4Audio = [NSString stringWithFormat:@"请在iPhone的\"设置-隐私-麦克风\"中允许%@访问麦克风",appName];
    }
    
    _hintMsg.text = str4Video;
    _hintMsg2.text = str4Audio;
    
    //设置警告图片
    UIImage *image = [UIImage imageNamed:[@"VideoRecording.bundle" stringByAppendingPathComponent:@"warning"]];
    _hintImage.image = image;
    
    //设置标题
    self.title = @"相机";
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置导航栏右侧按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnOnClick)];
    self.navigationItem.rightBarButtonItem = item;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)closeBtnOnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
