//
//  LoginViewController.m
//  数字健身
//
//  Created by 城云 官 on 14-3-24.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize PopViewPoint = _PopViewPoint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    //注册键盘显示通知
    [center addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏通知
    [center addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [self.TextFieldUser addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.TextFieldPass.delegate = self;
    self.TextFieldUser.delegate = self;
    self.TextFieldPass.secureTextEntry = YES;
    [self.TextFieldPass setReturnKeyType:UIReturnKeyGo];
    UILabel * leftUser = [[UILabel alloc] initWithFrame:CGRectMake(10,0,14,352)];
    UILabel * leftPass = [[UILabel alloc] initWithFrame:CGRectMake(10,0,14,352)];
    leftUser.font = [UIFont systemFontOfSize:20];
    leftPass.font = [UIFont systemFontOfSize:20];
    leftUser.backgroundColor = [UIColor clearColor];
    leftPass.backgroundColor = [UIColor clearColor];
    
    self.TextFieldUser.leftView = leftUser;
    self.TextFieldPass.leftView = leftPass;
    self.TextFieldUser.leftViewMode = UITextFieldViewModeAlways;
    self.TextFieldUser.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.TextFieldPass.leftViewMode = UITextFieldViewModeAlways;
    self.TextFieldPass.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
   
    
    UIImage *image = [[UIImage imageNamed:@"LoginBackGround.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(300, 0, 50, 0)];
    [self.imageView setImage:image];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    NSString *struser = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    NSString *strpass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    if ((strpass)&&(struser)) {
        self.TextFieldUser.text = struser;
        self.TextFieldPass.text = strpass;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    MainViewController *mainvc = [[MainViewController alloc]init];
//    [self presentViewController:mainvc animated:NO completion:^{
//        mainvc.seletedIndex = 0;
//        [[NSUserDefaults standardUserDefaults]setObject:@"username" forKey:UserName];
//        [[NSUserDefaults standardUserDefaults]setObject:@"passvalue" forKey:PassValue];
//    }];
}

- (IBAction)loginAction:(id)sender {
    if (self.TextFieldUser.text.length == 0) {
        [self alertError:@"请输入帐号"];
        return;
    }
    
    // 2.密码
    if (self.TextFieldPass.text.length == 0) {
        [self alertError:@"请输入密码"];
        return;
    }
    
    MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.removeFromSuperViewOnHide=YES;
    progressHUD.labelFont=[UIFont systemFontOfSize:12];
    progressHUD.minSize=CGSizeMake(140, 130);
    progressHUD.labelText=@"登录中...";
    NSDictionary *dic = @{
                          @"username": self.TextFieldUser.text,
                          @"password":self.TextFieldPass.text,
                          @"ip":@"113231431",
                          @"key":Key_HTTP
                          };
    [[AFClient sharedCoachClient]postPath:@"Coach_Info_Login" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
//            NSLog(@"resultDict::%@",resultDict);
            NSString *string = [resultDict objectForKey:@"_return"];
            NSInteger IsLogin = [string integerValue];
            if (IsLogin > 0) {
                [[NSUserDefaults standardUserDefaults]setObject:self.TextFieldUser.text forKey:UserName];
                [[NSUserDefaults standardUserDefaults]setObject:self.TextFieldPass.text forKey:PassValue];
                [[NSUserDefaults standardUserDefaults]setObject:nil forKey:MatChingID];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                if (self.blockEnterMain) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"yes",@"isLogin", nil];
                self.blockEnterMain(dic);
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
        [progressHUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [progressHUD hide:YES];
    }];
    
}

#pragma mark 弹出错误提示
- (void)alertError:(NSString *)error
{
    // 1.弹框
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:error delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
    // 2.发抖
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    anim.repeatCount = 1;
    anim.values = @[@-10, @10, @-10];
    [_popLoginView.layer addAnimation:anim forKey:nil];
}

//点击done跳到密码
- (IBAction)textFieldDone:(id)sender {
    [self.TextFieldPass becomeFirstResponder];
}

#pragma mark textfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
      [textField setBackground:[UIImage imageNamed:@"SelectBox.png"]];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField setBackground:[UIImage imageNamed:@"GreyBox.png"]];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    [self loginAction];
    return YES;
}

#pragma mark 监听View点击事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:NO];
}

#pragma mark - 通知
#pragma mark 键盘显示时调用
- (void)keyBoardWillShow:(NSNotification *)notification
{
    self.KeyShow = YES;
//    NSLog(@"[UIScreen mainScreen]::%@",NSStringFromCGRect([[UIScreen mainScreen] applicationFrame]));
    if ([[UIScreen mainScreen] applicationFrame].size.width == 768) {
        self.GrawBackGroundView.hidden = YES;
        return;
    }
    self.GrawBackGroundView.hidden = NO;
    [self.imageView setBackgroundColor:[UIColor grayColor]];
    //键盘Rect
    CGRect keyBoardRect=[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
//    NSLog(@"keyBoardRectWillShow:%@",NSStringFromCGRect(keyBoardRect));
    CGRect rectcent = self.popLoginView.frame;
    if (keyBoardRect.origin.x >0) {
        rectcent.origin.y = keyBoardRect.origin.x - self.popLoginView.frame.size.height;
    }else{
        rectcent.origin.y = -(keyBoardRect.origin.x - 416) - self.popLoginView.frame.size.height;
    }
    
    [self animationWithUserInfo:notification.userInfo bloack:^{
        self.popLoginView.frame=rectcent;
    }];
    return;
    //偏移量
    CGFloat distance;
    if (IS_IOS_7) {
        distance=-keyBoardRect.size.width+180;
    }else{
        distance=-keyBoardRect.size.width+160;
    }
    _PopViewPoint = self.popLoginView.center;
    _PopViewPoint.y = self.popLoginView.center.y + distance;
    if (distance<0){
        [self animationWithUserInfo:notification.userInfo bloack:^{
                    self.popLoginView.center=self.PopViewPoint;
                }];
    }

}
#pragma mark 键盘隐藏时调用
- (void)keyBoardWillHidden:(NSNotification *)notification
{
      self.KeyShow = NO;
    if ([[UIScreen mainScreen] applicationFrame].size.width == 768) {
        self.GrawBackGroundView.hidden = YES;
        return;
    }
//
//    if (_PopViewPoint.y != self.popLoginView.center.y) {
//        return;
//    }
    self.GrawBackGroundView.hidden = YES;
    //键盘Rect
    CGRect keyBoardRect=[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
//     NSLog(@"keyBoardRectWillHidden:%@",NSStringFromCGRect(keyBoardRect));
    
    //366 292
    CGRect rectcent = self.popLoginView.frame;
    if (keyBoardRect.origin.x >0) {
         rectcent.origin.y = keyBoardRect.origin.x - 402;
    }else{
         rectcent.origin.y = -(keyBoardRect.origin.x - 416) - 402;
    }
   
    [self animationWithUserInfo:notification.userInfo bloack:^{
        self.popLoginView.frame=rectcent;
    }];
    
    return;
    //偏移量
    CGFloat distance;
    if (IS_IOS_7) {
        distance=-keyBoardRect.size.width+180;
    }else{
        distance=-keyBoardRect.size.width+160;
    }
   
    _PopViewPoint = self.popLoginView.center;
    _PopViewPoint.y = self.popLoginView.center.y - distance;
    if (distance<0){
        [self animationWithUserInfo:notification.userInfo bloack:^{
            self.popLoginView.center=self.PopViewPoint;
        }];
    }
//    [self animationWithUserInfo:notification.userInfo bloack:^{
//        self.popLoginView.transform=CGAffineTransformMake(1, 0, 0, 1, 0, 0);
//    }];
  
}

#pragma mark 键盘动画
- (void)animationWithUserInfo:(NSDictionary *)userInfo bloack:(void (^)(void))block
{
    // 取出键盘弹出的时间
    CGFloat duration=[userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue];
    // 取出键盘弹出动画曲线
    NSInteger curve=[userInfo[UIKeyboardAnimationCurveUserInfoKey]integerValue];
    //开始动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    //调用bock
    block();
    [UIView commitAnimations];
}

//禁止竖屏
//-(NSUInteger)supportedInterfaceOrientations
//{
//    
//    return UIInterfaceOrientationMaskLandscape;
//}
//
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//- (void)orientationChanged
//{
//    //UIView *ftView = [self.view viewWithTag:200];
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)//判断左右
//    {
//        //界面的新布局
//    }
//    if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait )//我有个方向不支持，如果想都支持那就不要这个if条件就行了
//    {
//        //界面的新布局
//    }
//}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if ((toInterfaceOrientation == UIDeviceOrientationLandscapeRight)&&(toInterfaceOrientation == UIDeviceOrientationLandscapeLeft)) {
        if (self.KeyShow == YES) {
             self.GrawBackGroundView.hidden = NO;
        }
    }else{
        self.GrawBackGroundView.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
