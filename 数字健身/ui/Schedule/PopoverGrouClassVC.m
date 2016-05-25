//
//  PopoverGrouClassVC.m
//  数字健身
//
//  Created by 城云 官 on 14-6-17.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "PopoverGrouClassVC.h"

@interface PopoverGrouClassVC ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *LabelClass;
@property (weak, nonatomic) IBOutlet UILabel *LabelNumberFull;
@property (weak, nonatomic) IBOutlet UILabel *LabelNumberParticipate;
@property (weak, nonatomic) IBOutlet UILabel *LabelTitle;

@end

@implementation PopoverGrouClassVC

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
   
}

-(void)viewWillAppear:(BOOL)animated{
     NSLog(@"dicget::%@",self.DictionaryGet);
    self.dateLabel.text = [NSString stringWithFormat:@"%@---%@",[self dateFromString:[self.DictionaryGet objectForKey:@"CTO_DateStart"]],[self dateFromString:[self.DictionaryGet objectForKey:@"CTO_DateEnd"]]];
    self.LabelTitle.text = [NSString stringWithFormat:@"%@",[self.DictionaryGet objectForKey:@"CTO_Name"]];
    self.LabelNumberFull.text = [NSString stringWithFormat:@"满员人数：%@",[self.DictionaryGet objectForKey:@"CTO_PeopleFull"]];
    self.LabelNumberParticipate.text = [NSString stringWithFormat:@"参加人数：%@",[self.DictionaryGet objectForKey:@"CTO_PeopleAttend"]];
    [super viewWillAppear:animated];
}

- (NSString *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-ddHH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat: @"MM月dd日HH:mm"];
    NSString *string = [dateFormatter1 stringFromDate:destDate];
    return string;
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
