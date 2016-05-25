//
//  ConsultVC.m
//  数字健身
//
//  Created by 城云 官 on 14-3-28.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "ConsultVC.h"
#import "MainViewController.h"
#import "ConsultMasterVC.h"
#import "ConsultDetailVC.h"

@interface ConsultVC ()<UISplitViewControllerDelegate>

@property(strong, nonatomic)UISplitViewController *SplitVC;
@property(strong, nonatomic)UISplitViewController *SplitVCAddsubview;
@property(strong, nonatomic)UIPopoverController *popover;
@property(strong, nonatomic)NSArray *ViewControllers;
@end

@implementation ConsultVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.title = @"资讯";
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"ConsultStoryboard" bundle:nil];
        self.SplitVC.presentsWithGesture = NO;
        self.SplitVC = story.instantiateInitialViewController;
        self.SplitVC.delegate = self;
        
        ConsultMasterVC *masterVC = self.SplitVC.viewControllers[0];
        ConsultDetailVC *detailVC = self.SplitVC.viewControllers[1];
        self.ViewControllers = self.SplitVC.viewControllers;
        masterVC.delegate = detailVC;
        self.SplitVC.view.frame = self.view.bounds;
        [self.view addSubview:self.SplitVC.view];
        [self addChildViewController:self.SplitVC];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    UIImageView *imgeview = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    [imgeview setImage:[UIImage imageNamed:@"教练圈+导航.png"]];
//    [self.view addSubview:imgeview];
//    [self setSplitToView];//解决左边view不显示的bug
    [self setSplitToView];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
