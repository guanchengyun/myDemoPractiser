//
//  SplitMainDetailMenberVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-17.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "SplitMainDetailMenberVC.h"
#import "TargetPlanTVC.h"
#import "FitnessTestVC.h"
#import "MenberMoreDetailed.h"
#import "InbodyTestVC.h"
#import "TargetPlanTVC.h"

@interface SplitMainDetailMenberVC ()

@property(weak, nonatomic)MenberMoreDetailed *menbermoredetailedvc;
@property(weak, nonatomic)UINavigationController *targetplantNav;
@property(weak, nonatomic)FitnessTestVC *fitnesstesttvc;
@property(weak, nonatomic)InbodyTestVC *inbodytestvc;
@property(strong, nonatomic)UINavigationController *navCt;
@property(assign,nonatomic)NSInteger index;
@property (nonatomic, weak) UIViewController *previousViewController;

@end

@implementation SplitMainDetailMenberVC

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
    if (!_navCt) {
        _navCt = [[UIStoryboard storyboardWithName:@"TargetPlan" bundle:nil] instantiateInitialViewController];
        TargetPlanTVC *targetvc = self.navCt.viewControllers[0];
        targetvc.listerMenber = self.listerMenber;
    }
}

//-(UINavigationController *)navCt{
//    if (!_navCt) {
//        _navCt = [[UIStoryboard storyboardWithName:@"TargetPlan" bundle:nil] instantiateInitialViewController];
//        TargetPlanTVC *targetvc = self.navCt.viewControllers[0];
//        targetvc.listerMenber = self.listerMenber;
//    }
//    return _navCt;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ToMenberMoreDetailed"]) {
        self.menbermoredetailedvc = segue.destinationViewController;
        self.menbermoredetailedvc.listerMenber = self.listerMenber;
        self.previousViewController = self.menbermoredetailedvc;
    }else if ([segue.identifier isEqualToString:@"ToFitnessTestVC"]){
        self.fitnesstesttvc = segue.destinationViewController;
        self.fitnesstesttvc.listerMenber = self.listerMenber;
    }else if ([segue.identifier isEqualToString:@"ToTargetPlanTVC"]){
        self.targetplantNav = segue.destinationViewController;
        TargetPlanTVC *targetvc = self.targetplantNav.viewControllers[0];
        targetvc.listerMenber = self.listerMenber;
    }else if ([segue.identifier isEqualToString:@"ToInbodyTestVC"]){
        self.inbodytestvc = segue.destinationViewController;
        self.inbodytestvc.listerMenber = self.listerMenber;
    }
}

#pragma mark ======= MenberDetailMasterDelegate =================
-(void)selectedContainVc:(NSInteger )ContainNumber{
    if (self.index == ContainNumber) {
        return;
    }
    
    self.index = ContainNumber;
    self.previousViewController.view.hidden = YES;
    [self.previousViewController.view removeFromSuperview];
    if (ContainNumber == 0) {
        self.previousViewController = self.menbermoredetailedvc;
    }else if(ContainNumber == 1){
        self.previousViewController = self.fitnesstesttvc;
    }else if(ContainNumber == 2){
        self.navCt.view.frame = self.view.bounds;
        self.previousViewController = self.navCt;
    }else if (ContainNumber == 3){
        self.previousViewController = self.inbodytestvc;
    }
    self.previousViewController.view.hidden = NO;
    [self.view addSubview:self.previousViewController.view];
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
