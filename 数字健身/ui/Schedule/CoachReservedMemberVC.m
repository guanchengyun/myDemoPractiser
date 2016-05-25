//
//  CoachReservedMemberVC.m
//  数字健身
//
//  Created by 城云 官 on 14-7-7.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "CoachReservedMemberVC.h"
#import "UIImageView+AFNetworking.h"

@interface CoachReservedMemberVC (){
    NSTimer *CoachReservedTimer;
}

@property (weak, nonatomic) IBOutlet UILabel *LabelTimeOut;
@property (weak, nonatomic) IBOutlet UILabel *LabelClassNumber;
@property (weak, nonatomic) IBOutlet UIImageView *ImageMenber;
@property (weak, nonatomic) IBOutlet UILabel *LabelMenberName;
@property (weak, nonatomic) IBOutlet UILabel *LabelClassType;
@property (weak, nonatomic) IBOutlet UILabel *LabelSenderNmae;
@property (weak, nonatomic) IBOutlet UITextView *TextViewReason;

@property(assign, nonatomic)NSInteger CountDownTimer;
@property (weak, nonatomic) IBOutlet UILabel *LabelClassName;

@end

@implementation CoachReservedMemberVC

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
    self.TextViewReason.textColor = [UIColor lightGrayColor]; //optional
    self.TextViewReason.layer.masksToBounds = YES;
    self.TextViewReason.layer.cornerRadius = 6.0;
    self.TextViewReason.layer.borderWidth = 1.0;
    self.TextViewReason.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _LabelTimeOut.backgroundColor = [UIColor colorWithHexString:[RainbowColor RainbowColorArray][7]];
    
    _LabelClassNumber.backgroundColor = [UIColor colorWithHexString:[RainbowColor RainbowColorArray][5]];
    _LabelClassName.backgroundColor = [UIColor colorWithHexString:[RainbowColor RainbowColorArray][1]];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSLog(@"DictionaryGet::%@",self.DictionaryGet);
    self.LabelMenberName.text = [self.DictionaryGet objectForKey:@"name"];
    self.LabelSenderNmae.text = [NSString stringWithFormat:@"发起人：%@",[self.DictionaryGet objectForKey:@"pushName"]];
    self.LabelClassNumber.text = [self.DictionaryGet objectForKey:@"numHave"];
    NSURL *url = [NSURL URLWithString:[self.DictionaryGet objectForKey:@"face"]];
    [self.ImageMenber setImageWithURL:url placeholderImage:[UIImage imageNamed:@"6.png"]];
    self.TextViewReason.text = [self.DictionaryGet objectForKey:@"cause"];
    
    
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
    _LabelTimeOut.text = [NSString stringWithFormat:@"%ld:%ld:%ld",(long)iHours,(long)iMinutes,(long)iSeconds];
    if (self.CountDownTimer>0) {
        if (!CoachReservedTimer) {
            CoachReservedTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        }
    }
    
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
    _LabelTimeOut.text = [NSString stringWithFormat:@"%ld:%ld:%ld",(long)iHours,(long)iMinutes,(long)iSeconds];
    if ((_CountDownTimer <1)&&(self.buttonMatching)) {
        if (CoachReservedTimer) {
            [CoachReservedTimer invalidate];
            CoachReservedTimer = nil;
        }
        self.buttonMatching.ButtonType = -1;
    }
    
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
