//
//  SchedulePagePlanSenderMessageVC.m
//  数字健身
//
//  Created by 城云 官 on 14-7-3.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "SchedulePagePlanSenderMessageVC.h"
#import <QuartzCore/QuartzCore.h>

@interface SchedulePagePlanSenderMessageVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *ButtonCancel;
@property (weak, nonatomic) IBOutlet UIButton *ButtonSender;
@property (weak, nonatomic) IBOutlet UIButton *ButtonSelet;
@end

@implementation SchedulePagePlanSenderMessageVC

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
    self.textView.text = @"取消理由....";
    self.textView.textColor = [UIColor lightGrayColor]; //optional
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 6.0;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.ButtonSender setBackgroundColor:[UIColor colorWithHexString:@"d95644"]];
    [self.ButtonCancel setBackgroundColor:[UIColor colorWithHexString:@"5489ab"]];
}

- (IBAction)ButtonSeletAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)senderAction:(id)sender {
    if ((self.textView.text.length <1)||([self.textView.text isEqualToString:@"取消理由...."])) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请填写取消理由" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (self.textView.text.length  > 200) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"取消理由不能超过200个字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
         return;
    }
    MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progressHUD.removeFromSuperViewOnHide = YES;
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    if (!self.CIN_ID) {
        return;
    }
    NSDictionary *parameters = @{@"CIN_ID": self.CIN_ID,
                                 @"CIC_Cause":self.textView.text,
                                 @"userid":username_str,
                                 @"password":username_pass,
                                 @"key":Key_HTTP
                                 };
    __weak SchedulePagePlanSenderMessageVC *vc = self;
    [[AFClient sharedCoachClient]getPath:@"Contract_Info_Cancle_fromCoach" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
            
            NSInteger interget = [[resultDict objectForKey:@"_return"] integerValue];
            
            if (interget == 1) {
                if (vc.popverCT) {
                    [vc.popverCT dismissPopoverAnimated:YES];
                }
                
            }else{
                
                progressHUD.labelText = @"发送失败";
                
                [progressHUD hide:YES afterDelay:2];
                
            }
            
        }else{
            progressHUD.labelText = @"发送失败";
            
            [progressHUD hide:YES afterDelay:2];
        }
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        progressHUD.labelText = @"发送失败";
        
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
    if ([textView.text isEqualToString:@"取消理由...."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"取消理由....";
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
