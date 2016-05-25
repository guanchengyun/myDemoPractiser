//
//  MatchingBeSenderVC.m
//  数字健身
//
//  Created by 城云 官 on 14-5-9.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "MatchingBeSenderVC.h"
#import "UIImageView+AFNetworking.h"

@interface MatchingBeSenderVC (){
    NSTimer *_matchTime;
}
@property (weak, nonatomic) IBOutlet UILabel *LabelEnddate;

@property(weak, nonatomic)IBOutlet UILabel *TimeLabel;
@property(assign, nonatomic)NSInteger CountDownTimer;

@property (weak, nonatomic) IBOutlet UILabel *LabelClassCount;
@property (weak, nonatomic) IBOutlet UILabel *LabelClassName;

@property (weak, nonatomic) IBOutlet UIImageView *MenberImageView;
@property (weak, nonatomic) IBOutlet UILabel *MenberName;

@property (weak, nonatomic) IBOutlet UILabel *LabelClassType;
@property (weak, nonatomic) IBOutlet UILabel *LabelNameSender;

@property (weak, nonatomic) IBOutlet UIButton *ButtonAccept;
@property (weak, nonatomic) IBOutlet UIButton *ButtonCancel;


@end

@implementation MatchingBeSenderVC
-(void)initViewColor{
    _TimeLabel.backgroundColor = [UIColor colorWithHexString:[RainbowColor RainbowColorArray][7]];
    
    _LabelClassCount.backgroundColor = [UIColor colorWithHexString:[RainbowColor RainbowColorArray][5]];
    _LabelClassName.backgroundColor = [UIColor colorWithHexString:[RainbowColor RainbowColorArray][1]];
    
//    _MenberImageView.backgroundColor = [UIColor colorWithHexString:[RainbowColor RainbowColorArray][7]];
    _MenberName.textColor = [UIColor colorWithHexString:[RainbowColor RainbowColorArray][1]];
    
//    _LabelClassType.backgroundColor = [UIColor colorWithHexString:[RainbowColor RainbowColorArray][1]];
//    _LabelClassNamed.backgroundColor = [UIColor colorWithHexString:[RainbowColor RainbowColorArray][1]];
//    _LabelNameSender.backgroundColor = [UIColor colorWithHexString:[RainbowColor RainbowColorArray][1]];
    
    _ButtonAccept.backgroundColor = [UIColor colorWithHexString:[RainbowColor RainbowColorArray][7]];
    _ButtonCancel.backgroundColor = [UIColor colorWithHexString:[RainbowColor RainbowColorArray][1]];

}
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
    // Do any additional setup after loading the view.
    [self initViewColor];
   
//    self.CountDownTimer = [str unsignedIntegerValue];
   _matchTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [_matchTime invalidate];
}

-(void)viewWillAppear:(BOOL)animated{
//    NSLog(@"fa:%d",self.CountDownTimer);
    NSInteger intermy = [[self.DictionaryGet objectForKey:@"timeout"] integerValue];
    if (intermy<0) {
        self.CountDownTimer = 10000;
//        _TimeLabel.text = @"本次预约已过期";
    }else{
        self.CountDownTimer = intermy;
    }
    NSInteger iHours = self.CountDownTimer/3600;
    NSInteger iMinutes = (self.CountDownTimer-3600*iHours)/60;
    NSInteger iSeconds = (self.CountDownTimer-3600*iHours - 60*iMinutes)%60;
    _TimeLabel.text = [NSString stringWithFormat:@"%ld:%ld:%ld",(long)iHours,(long)iMinutes,(long)iSeconds];
   
//    NSLog(@"ArrayGet::%@",self.DictionaryGet);
    self.LabelClassCount.text = [self.DictionaryGet objectForKey:@"numHave"];
    self.LabelNameSender.text = [NSString stringWithFormat:@"发起人：%@",[self.DictionaryGet objectForKey:@"pushName"]];
    //    self.LabelClassType
    NSURL *url = [NSURL URLWithString:[self.DictionaryGet objectForKey:@"face"]];
    [self.MenberImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"6.png"]];
    self.MenberName.text = [self.DictionaryGet objectForKey:@"name"];
    self.LabelEnddate.text = [self.DictionaryGet objectForKey:@"enddate"];
    if ([[self.DictionaryGet objectForKey:@"pushState"]isEqualToString:@"True"]) {
        self.ButtonAccept.hidden = YES;
        self.ButtonCancel.hidden = YES;
    }else{
        self.ButtonAccept.hidden = NO;
        self.ButtonCancel.hidden = NO;
    }
    if (self.CountDownTimer >0) {
        if (_matchTime) {
            [_matchTime fire];
        }
    }

    [super viewWillAppear:animated];
}

-(NSInteger)CountDownTimer{
    if (!_CountDownTimer) {
        _CountDownTimer = 60;
    }
    return _CountDownTimer;
}

-(void)timeFireMethod{
    self.CountDownTimer--;
    NSInteger iHours = self.CountDownTimer/3600;
    NSInteger iMinutes = (self.CountDownTimer-3600*iHours)/60;
    NSInteger iSeconds = (self.CountDownTimer-3600*iHours - 60*iMinutes)%60;
    _TimeLabel.text = [NSString stringWithFormat:@"%ld:%ld:%ld",(long)iHours,(long)iMinutes,(long)iSeconds];
    if (self.CountDownTimer < 1) {
        [_matchTime invalidate];
        self.buttonMatching.ButtonType = -1;
        if ([self.view window]) {
            MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            progressHUD.mode=MBProgressHUDModeText;
            progressHUD.margin = 10.f;
            progressHUD.yOffset = 150.f;
            progressHUD.alpha=0.75;
            progressHUD.labelText=@"已超时";
            progressHUD.removeFromSuperViewOnHide = YES;
            [progressHUD hide:YES afterDelay:2];
        }
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)AcceptAction:(id)sender {
    if ([[self.DictionaryGet objectForKey:@"pushState"]isEqualToString:@"True"]) {
        [self Contract_Info_Agree];
    }
}
- (IBAction)Cancel:(id)sender {
    [self Contract_Info_Refuse];
   
}
//- (IBAction)ShutDownAction:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

// 发起预约-教练同意
-(void)Contract_Info_Agree{
    __weak MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    progressHUD.margin = 10.f;
    progressHUD.yOffset = 150.f;
    progressHUD.alpha=0.75;
    progressHUD.removeFromSuperViewOnHide = YES;

    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:username_str,@"username",username_pass,@"password",Key_HTTP,@"key",self.CIN_ID,@"CIN_ID", nil];
    static NSString *Contract_Info_Agree = @"Contract_Info_Agree";
     __weak MatchingBeSenderVC *vc = self;
    [[AFClient sharedCoachClient]getPath:Contract_Info_Agree parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
      
        NSInteger interget = [[resultDict objectForKey:@"_return"] integerValue];
        if (interget == 1) {
            if ([vc.delegate respondsToSelector:@selector(MatchingBeSenderString:)]) {
                [vc.delegate MatchingBeSenderString:@"yes"];
                
            }
            [progressHUD hide:YES];
        }else if(interget == -1){
            progressHUD.labelText = @"健身房的会员帐号或密码不正确";
            [progressHUD hide:YES afterDelay:2];
        }else if(interget == -2){
            progressHUD.labelText = @"记录不存在";
            [progressHUD hide:YES afterDelay:2];
        }else{
            progressHUD.labelText = @"请求失败";
            [progressHUD hide:YES afterDelay:2];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        progressHUD.labelText =  @"请求失败";
        [progressHUD hide:YES afterDelay:2];
    }];
}

//教练拒绝会员发起的预约
-(void)Contract_Info_Refuse{
    if (!self.CIN_ID) {
        return;
    }
    __weak MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    progressHUD.margin = 10.f;
    progressHUD.yOffset = 150.f;
    progressHUD.alpha=0.75;
    progressHUD.removeFromSuperViewOnHide = YES;
    
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:username_str,@"username",username_pass,@"password",Key_HTTP,@"key",self.CIN_ID,@"CIN_ID", nil];
    static NSString *Contract_Info_Refuse = @"Contract_Info_Refuse";
    __weak MatchingBeSenderVC *vc = self;
    [[AFClient sharedCoachClient]getPath:Contract_Info_Refuse parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        NSInteger interget = [[resultDict objectForKey:@"_return"] integerValue];
        if (interget == 1) {
            if ([vc.delegate respondsToSelector:@selector(MatchingBeSenderString:)]) {
                [vc.delegate MatchingBeSenderString:@"yes"];
                
            }
            [progressHUD hide:YES];
        }else if(interget == -1){
            progressHUD.labelText = @"健身房的会员帐号或密码不正确";
            [progressHUD hide:YES afterDelay:2];
        }else if(interget == -2){
            progressHUD.labelText = @"记录不存在";
            [progressHUD hide:YES afterDelay:2];
        }else{
            progressHUD.labelText = @"请求失败";
            [progressHUD hide:YES afterDelay:2];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        progressHUD.labelText = @"请求失败";
        [progressHUD hide:YES afterDelay:2];
    }];

}

//教练取消会员发起的预约
//-(void)Contract_Info_Cancle_byCoach{
//    
//    __weak MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    
//    progressHUD.userInteractionEnabled=NO;
//    progressHUD.margin = 10.f;
//    progressHUD.yOffset = 150.f;
//    progressHUD.alpha=0.75;
//    progressHUD.removeFromSuperViewOnHide = YES;
//    
//    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
//    
//    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:username_str,@"username",username_pass,@"password",Key_HTTP,@"key",self.CIN_ID,@"CIN_ID", nil];
//    static NSString *Contract_Info_Cancle_byCoach = @"Contract_Info_Refuse";
//    [[AFClient sharedCoachClient]getPath:Contract_Info_Cancle_byCoach parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *resultDict = nil;
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            resultDict = responseObject;
//        }else{
//            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        }
//        [progressHUD hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        progressHUD.labelText = @"失败";
//        [progressHUD hide:YES afterDelay:2];
//    }];
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
