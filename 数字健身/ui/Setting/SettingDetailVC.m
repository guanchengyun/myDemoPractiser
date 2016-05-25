//
//  SettingDetailVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-24.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "SettingDetailVC.h"

@interface SettingDetailVC ()

@property(strong, nonatomic)NSMutableArray *viewcontrollers;
@property(weak, nonatomic)UIViewController *previousViewController;
@property(assign,nonatomic)NSInteger index;
@end

@implementation SettingDetailVC

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)viewcontrollers{
    if (!_viewcontrollers) _viewcontrollers = [[NSMutableArray alloc]init];
   return _viewcontrollers;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   
    [self.viewcontrollers addObject:segue.destinationViewController];
    if ([segue.identifier isEqualToString:@"ToSharingCenterVC"]) {
        self.previousViewController = segue.destinationViewController;
    }
    [self.view addSubview:self.previousViewController.view];
}

#pragma mark ======= MenberDetailMasterDelegate =================
-(void)selectedContainVc:(NSInteger )ContainNumber{
    if (self.index == ContainNumber) {
        return;
    }
    
    self.index = ContainNumber;
    self.previousViewController.view.hidden = YES;
    [self.previousViewController.view removeFromSuperview];
    self.previousViewController = self.viewcontrollers[ContainNumber];
    self.previousViewController.view.hidden = NO;
    [self.view addSubview:self.previousViewController.view];
}

@end
