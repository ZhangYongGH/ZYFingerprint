//
//  ViewController.m
//  测试-指纹解锁
//
//  Created by zhangyong on 16/8/2.
//  Copyright © 2016年 zhangyong. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h> //提供LAContext类

@interface ViewController ()
- (IBAction)btn:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
}


- (void)fingerprint{
    
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    NSString* result = @"通过Home键验证已有手机指纹";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"指纹验证成功");
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //验证成功，主线程处理UI
                    
                }];

            }
            else {
//                NSLog(@"%@",error.localizedDescription);
                
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"系统取消了身份验证");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"用户取消了身份验证");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"用户选择 输入密码");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else {
        //不支持指纹识别，LOG出错误详情
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID没有注册");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"密码没有设置");
                break;
            }
            default:
            {
                NSLog(@"TouchID不能获得");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn:(UIButton *)sender {
    
    [self fingerprint];
}

@end
