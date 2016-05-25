//
//  AppDelegate.h
//  数字健身
//
//  Created by 城云 官 on 14-3-24.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@class MainViewController,LoginViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    MainViewController *mainViewController;
    LoginViewController *loginViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) NetworkStatus WorkStatus;

-(void)logOut;
@end
