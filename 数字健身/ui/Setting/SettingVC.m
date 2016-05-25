//
//  SettingVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-1.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "SettingVC.h"
#import "SettingRootVC.h"
#import "SettingDetailVC.h"

@interface SettingVC ()<UISplitViewControllerDelegate>
@property(weak, nonatomic)UISplitViewController *SplitVC;
@property(strong, nonatomic)UISplitViewController *SplitVCAddsubview;
@property(weak, nonatomic)SettingDetailVC *DetailVC;
@property(weak, nonatomic)SettingRootVC *RootVC;
@property(strong, nonatomic)UIPopoverController *popover;
@property(strong, nonatomic)NSArray *ViewControllers;
@end

@implementation SettingVC

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
    self.title = @"设置";
    UIStoryboard *SplitStory = [UIStoryboard storyboardWithName:@"SetitingStoryboard" bundle:nil];
    //    self.SplitVC.viewControllers = @[_RootVC,_DetailVC];
    self.SplitVC = SplitStory.instantiateInitialViewController;
    self.SplitVC.presentsWithGesture = NO;
    self.SplitVC.delegate = self;
    self.SplitVC.view.frame = self.view.bounds;
    self.ViewControllers = self.SplitVC.viewControllers;
    [self.view addSubview:self.SplitVC.view];
    [self addChildViewController:self.SplitVC];
    self.RootVC = _SplitVC.viewControllers[0];
    self.DetailVC = _SplitVC.viewControllers[1];
    self.RootVC.delegate = _DetailVC;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setSplitToView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)setSplitToView{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if ((orientation==UIInterfaceOrientationPortrait)||(orientation==UIInterfaceOrientationPortraitUpsideDown)) {
        if (_popover == nil) {
            [self.SplitVC removeFromParentViewController];
            [self.SplitVC.view removeFromSuperview];
            [self.SplitVCAddsubview removeFromParentViewController];
            [self.SplitVCAddsubview.view removeFromSuperview];
            
            self.SplitVCAddsubview = [[UISplitViewController alloc]init];
            self.SplitVCAddsubview.viewControllers = @[self.ViewControllers[0],self.ViewControllers[1]];
            self.SplitVCAddsubview.delegate = self;
            self.SplitVCAddsubview.view.frame = self.view.bounds;
            [self.view addSubview:self.SplitVCAddsubview.view];
            [self addChildViewController:self.SplitVCAddsubview];
        }
    }else{
        if (_popover) {
            [self.SplitVC removeFromParentViewController];
            [self.SplitVC.view removeFromSuperview];
            [self.SplitVCAddsubview removeFromParentViewController];
            [self.SplitVCAddsubview.view removeFromSuperview];
            
            self.SplitVCAddsubview = [[UISplitViewController alloc]init];
            self.SplitVCAddsubview.viewControllers = @[self.ViewControllers[0],self.ViewControllers[1]];
            self.SplitVCAddsubview.delegate = self;
            self.SplitVCAddsubview.view.frame = self.view.bounds;
            [self.view addSubview:self.SplitVCAddsubview.view];
            [self addChildViewController:self.SplitVCAddsubview];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ===================UISplitViewDelegate methods =======

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    //Grab a reference to the popover
    self.popover = pc;
    
    //Set the title of the bar button item
    barButtonItem.title = @"目录";
    
    //Set the bar button item as the Nav Bar's leftBarButtonItem
    [self.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //Remove the barButtonItem.
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    
    
    //Nil out the pointer to the popover.
    _popover = nil;
}
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation NS_AVAILABLE_IOS(5_0){
    
    if((orientation == UIDeviceOrientationLandscapeRight)||(orientation == UIDeviceOrientationLandscapeLeft)){
        return NO;
    }
    return YES;
}

@end
