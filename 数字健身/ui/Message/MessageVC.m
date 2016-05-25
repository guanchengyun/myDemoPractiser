//
//  MessageVC.m
//  数字健身
//
//  Created by 城云 官 on 14-3-28.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "MessageVC.h"
#import "MessageDetailVC.h"
#import "MessageMasterVC.h"

@interface MessageVC ()<UISplitViewControllerDelegate>
@property (strong, nonatomic)UISplitViewController *SplitVC;
@property(strong, nonatomic)UIPopoverController *popover;
@end

@implementation MessageVC

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
    self.title = @"消息";
    
    UIStoryboard *SplitStory = [UIStoryboard storyboardWithName:@"MessageSpliteStory" bundle:nil];
    //    self.SplitVC.viewControllers = @[_RootVC,_DetailVC];
    self.SplitVC = SplitStory.instantiateInitialViewController;
    //    self.SplitVC.presentsWithGesture = NO;
    MessageMasterVC *mastvc = self.SplitVC.viewControllers[0];
    MessageDetailVC *Detailvc = self.SplitVC.viewControllers[1];
    mastvc.delegate = Detailvc;
    
    self.SplitVC.delegate = self;
    
    self.SplitVC.view.frame = self.view.bounds;
    
    [self.view addSubview:self.SplitVC.view];
    [self addChildViewController:self.SplitVC];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    UIImageView *imgeview = [[UIImageView alloc]initWithFrame:self.view.bounds];
    //    [imgeview setImage:[UIImage imageNamed:@"教练圈+导航.png"]];
    //    [self.view addSubview:imgeview];
    [self setSplitToView];
}

-(void)setSplitToView{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if ((orientation==UIInterfaceOrientationPortrait)||(orientation==UIInterfaceOrientationPortraitUpsideDown)) {
        if (_popover == nil) {
            [self.view addSubview:self.SplitVC.view];
            [self addChildViewController:self.SplitVC];
            
        }
    }else{
        if (_popover) {
            [self.view addSubview:self.SplitVC.view];
            [self addChildViewController:self.SplitVC];
            
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
