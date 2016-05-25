//
//  CoachCircleVC.m
//  数字健身
//
//  Created by 城云 官 on 14-3-28.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "CoachCircleVC.h"
#import "CoachCirleRoot.h"
@class ConsultDetailVC;

@interface CoachCircleVC ()<CoachCircleRootDelegate>
@property(strong, nonatomic)UISplitViewController *SplitVCAddsubview;
@property(strong, nonatomic)NSArray *ViewControllers;

@end

@implementation CoachCircleVC
@synthesize DetailVC = _DetailVC;
@synthesize SplitVC = _SplitVC;
@synthesize RootNav = _RootNav;
@synthesize popover = _popover;

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
    self.title = @"教练圈";
//    self.SplitVC = [[UISplitViewController alloc]init];
//    self.RootVC = [[CoachCircleRootVC alloc]init];
//    self.DetailVC = [[CoachCircleDetailVC alloc]init];
//    
////    _RootNav = [[UINavigationController alloc] initWithRootViewController:_RootVC];
//    self.SplitVC.viewControllers = @[_RootVC,_DetailVC];
//    self.SplitVC.presentsWithGesture = NO;
//    self.SplitVC.delegate = self;
//    self.SplitVC.view.frame = self.view.bounds;
//    [self.view addSubview:self.SplitVC.view];
//    [self addChildViewController:self.SplitVC];
    UIStoryboard *SplitStory = [UIStoryboard storyboardWithName:@"CoachCircleStoryboard" bundle:nil];
//    self.SplitVC.viewControllers = @[_RootVC,_DetailVC];
    self.SplitVC = SplitStory.instantiateInitialViewController;
//    self.SplitVC.presentsWithGesture = NO;
    self.SplitVC.delegate = self;
    //    [self.view addSubview:self.SplitVC.view];
//    [self addChildViewController:self.SplitVC];
    CoachCirleRoot *coachroot = self.SplitVC.viewControllers[0];
    CoachCircleDetailVC *coachdetail = self.SplitVC.viewControllers[1];
    coachroot.delegate = coachdetail;
    
    self.SplitVC.view.frame = self.view.bounds;
    self.ViewControllers = self.SplitVC.viewControllers;
    [self.view addSubview:self.SplitVC.view];
    [self addChildViewController:self.SplitVC];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self setSplitToView];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    UIImageView *imgeview = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    [imgeview setImage:[UIImage imageNamed:@"教练圈+导航.png"]];
//    [self.view addSubview:imgeview];
   
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
