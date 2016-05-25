//
//  AppDelegate.m
//  数字健身
//
//  Created by 城云 官 on 14-3-24.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "PhotoContrast.h"
#import "MBProgressHUD.h"
//shareSDK
#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
     UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    loginViewController =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (username_str) {
        self.window.rootViewController = mainViewController;
        mainViewController.seletedIndex = 0;
    }else{
        
        __unsafe_unretained AppDelegate *appDelegate=self;
        loginViewController.blockEnterMain=^(NSDictionary *info){
            [appDelegate enterMain:info];
        };
        self.window.rootViewController = loginViewController;
    }
    [self initNavigateionBar];
    [self initializePlat];
   [self.window makeKeyAndVisible];
    return YES;
}

- (void)enterMain:(NSDictionary *)info{
     UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    self.window.rootViewController = mainViewController;
    if ([[info objectForKey:@"isLogin"]isEqualToString:@"yes"]) {
        self.window.rootViewController = mainViewController;
        mainViewController.seletedIndex = 0;
    }
}

-(void)initNavigateionBar{
    UIImage *image = [[UIImage imageNamed:@"navigationbar.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(30, 512, 30, 512)];
    [[UINavigationBar appearance]setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

}

-(void)HideImageViewAction:(UIImageView *)imageview{
    [imageview removeFromSuperview];
}

-(void)LogOut{
    __unsafe_unretained AppDelegate *appDelegate=self;
    loginViewController.blockEnterMain=^(NSDictionary *info){
        [appDelegate enterMain:info];
    };
    self.window.rootViewController = loginViewController;
}

- (void)initializePlat{
    [ShareSDK registerApp:@"api20"];
    // Override point for customization after application launch.
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WeiboApi class]];
    
    
    /**
     连接网易微博应用以使用相关功能，此应用需要引用T163WeiboConnection.framework
     http://open.t.163.com上注册网易微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connect163WeiboWithAppKey:@"T5EI7BXe13vfyDuy"
                              appSecret:@"gZxwyNOvjFYpxwwlnuizHRRtBRZ2lV1j"
                            redirectUri:@"http://www.shareSDK.cn"];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    //    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    //    [ShareSDK connectQZoneWithAppKey:@"100371282"
    //                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
    //                   qqApiInterfaceCls:[QQApiInterface class]
    //                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    //    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
    //                     qqApiInterfaceCls:[QQApiInterface class]
    //                       tencentOAuthCls:[TencentOAuth class]];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    NSLog(@"window::%@", window.rootViewController.superclass);
////    for (UIView *view in window.rootViewController.superclass) {
////        NSLog(@"window::%@", window.rootViewController.superclass);
////    }
//    if (window.rootViewController.superclass) {
//            return UIInterfaceOrientationMaskAll;
//    }else{
//            return UIInterfaceOrientationMaskLandscape;
//    }
//
//}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.window animated:YES];
    progressHUD.removeFromSuperViewOnHide=YES;
    progressHUD.labelFont=[UIFont systemFontOfSize:12];
    progressHUD.minSize=CGSizeMake(140, 130);
   
    [progressHUD hide:YES afterDelay:2];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            if (self.WorkStatus > 0) {
                 progressHUD.labelText=@"使用3G网络";
            }
           
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            if (self.WorkStatus > 0) {
                 progressHUD.labelText=@"使用3G网络";
            }
           
            break;
        case ReachableViaWiFi:
            if (self.WorkStatus > 0) {
                 progressHUD.labelText=@"使用WiFi网络";
            }
            
            // 使用WiFi网络
            break;
    }
    self.WorkStatus = [reach currentReachabilityStatus];
}

-(void)setupReachability{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
//    reach.reachableOnWWAN = NO;
    [reach startNotifier];
}//判断是否连接到网络


@end
