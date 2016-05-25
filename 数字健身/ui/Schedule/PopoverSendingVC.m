//
//  PopoverSendingVC.m
//  数字健身
//
//  Created by 城云 官 on 14-6-16.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "PopoverSendingVC.h"
#import <QuartzCore/QuartzCore.h>
#import "ContractListByCoach.h"

@interface PopoverSendingVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *ButtonCancel;
@property (weak, nonatomic) IBOutlet UIButton *ButtonSender;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;

@end

@implementation PopoverSendingVC

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
//    self.contentSizeForViewInPopover = CGSizeMake(500, 500);
    self.textView.delegate = self;
    self.textView.text = @"说点什么....";
    self.textView.textColor = [UIColor lightGrayColor]; //optional
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 6.0;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.ButtonSender setBackgroundColor:[UIColor colorWithHexString:@"d95644"]];
    [self.ButtonCancel setBackgroundColor:[UIColor colorWithHexString:@"5489ab"]];
//    self.ButtonCancel.layer.masksToBounds = YES;
//    self.ButtonCancel.layer.cornerRadius = 6.0;
//    self.ButtonSender.layer.masksToBounds = YES;
//    self.ButtonSender.layer.cornerRadius = 6.0;
//    self.ButtonCancel.layer.borderWidth = 1.0;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    self.TimeLabel.text = self.textString;
    self.textView.text = @"说点什么....";
    self.textView.textColor = [UIColor lightGrayColor]; //optional
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 6.0;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [super viewWillAppear:animated];
}
- (IBAction)senderAction:(id)sender {
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    ContractListByCoach *contractlist = self.buttonMatching.contrectlistbycoach;
    
    if (!self.startDate) {
        return;
    }
    if (!self.endDate) {
        return;
    }
    if ((self.textView.text.length < 1)||([self.textView.text isEqualToString:@"说点什么...."])) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"必填项不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSDictionary *parameters = @{@"startDate": self.startDate,
                                 @"endDate":self.endDate,
                                 @"content":self.textView.text,
                                 @"userid":[NSString stringWithFormat:@"%d",self.lisyMenber.ID],
                                 @"username":username_str,
                                 @"password":username_pass,
                                 @"key":Key_HTTP,
                                 };
//    NSLog(@"parameters::%@",parameters);
    MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.margin = 10.f;
    
    progressHUD.alpha=0.75;
    __weak PopoverSendingVC *vc = self;
    [[AFClient sharedCoachClient]getPath:@"Contract_Info_CoachToUser" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        //        NSLog(@"resultDict::%@",resultDict);
        if (resultDict) {
            NSInteger interget = [[resultDict objectForKey:@"_return"] integerValue];
            if (interget == 1) {
                if ([vc.delegate respondsToSelector:@selector(PopoverSendingVCDelegateSender)]) {
                    [vc.delegate PopoverSendingVCDelegateSender];
                }
                [progressHUD hide:YES];
            }else if(interget == -1){
                progressHUD.labelText = @"健身房的会员帐号或密码不正确";
                [progressHUD hide:YES afterDelay:2];
            }else if(interget == -2){
                progressHUD.labelText = @"必填项不能为空";
                [progressHUD hide:YES afterDelay:2];
            }else if(interget == -3){
                progressHUD.labelText = @"课程数量不足";
                [progressHUD hide:YES afterDelay:2];
            }else{
                progressHUD.labelText = @"预约失败";
                [progressHUD hide:YES afterDelay:2];
            }
        }else{
            progressHUD.labelText = @"预约失败";
            [progressHUD hide:YES afterDelay:2];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        progressHUD.labelText = @"预约失败";
        [progressHUD hide:YES afterDelay:2];
    }];
}
- (IBAction)cancelAction:(id)sender {
    if (self.popverCT) {
        [self.popverCT dismissPopoverAnimated:YES];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"说点什么...."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"说点什么....";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL boolretun = YES;
    if ([text isEqualToString:@"\n"])  {
        [textView resignFirstResponder];
        boolretun = NO;
    }
    return boolretun;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
