//
//  MenberMainControlSplitVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-17.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "MenberMainControlSplitVC.h"
//#import "MenberDetailSplit.m"
#import "MenberDetailMasterVC.h"
#import "SplitMainDetailMenberVC.h"
typedef enum{
    startOrientation,
    LandscapeOrientation,
    UpsideDownOrientation
}OrientationSaved;

@interface MenberMainControlSplitVC ()<UISplitViewControllerDelegate>
@property(strong, nonatomic)UIPopoverController *popover;
@property (strong, nonatomic) UISplitViewController *SplitVC;
@property (strong, nonatomic) UISplitViewController *SplitVCAddsubview;
@property (assign, nonatomic)OrientationSaved orientationSaved;
@property (strong, nonatomic) SplitMainDetailMenberVC *mainDetailMenberVC;
@property (strong, nonatomic) MenberDetailMasterVC *menberDetailMaster;
@end

@implementation MenberMainControlSplitVC

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
    // Do any additional setup after loading the view
    self.orientationSaved = startOrientation;
    [self.view addSubview:self.SplitVC.view];
    [self addChildViewController:self.SplitVC];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setSplitToView:self.orientationSaved];
}

-(void)setSplitToView:(OrientationSaved)orientationsave{
   
    OrientationSaved oriention = startOrientation;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if ((orientation==UIInterfaceOrientationPortrait)||(orientation==UIInterfaceOrientationPortraitUpsideDown)) {
        oriention = LandscapeOrientation;//竖屏
        if (_popover == nil) {
            [self.SplitVC removeFromParentViewController];
            [self.SplitVC.view removeFromSuperview];
            [self.SplitVCAddsubview removeFromParentViewController];
            [self.SplitVCAddsubview.view removeFromSuperview];
            
            self.SplitVCAddsubview = [[UISplitViewController alloc]init];
            self.SplitVCAddsubview.viewControllers = @[_menberDetailMaster,_mainDetailMenberVC];
            self.SplitVCAddsubview.delegate = self;
            self.SplitVCAddsubview.view.frame = self.view.bounds;
            [self.view addSubview:self.SplitVCAddsubview.view];
            [self addChildViewController:self.SplitVCAddsubview];
            self.orientationSaved = oriention;
            
        }
    }else{
        oriention = UpsideDownOrientation;//横屏
        if (_popover) {
            [self.SplitVC removeFromParentViewController];
            [self.SplitVC.view removeFromSuperview];
            [self.SplitVCAddsubview removeFromParentViewController];
            [self.SplitVCAddsubview.view removeFromSuperview];
            
            self.SplitVCAddsubview = [[UISplitViewController alloc]init];
            self.SplitVCAddsubview.viewControllers = @[_menberDetailMaster,_mainDetailMenberVC];
            self.SplitVCAddsubview.delegate = self;
            self.SplitVCAddsubview.view.frame = self.view.bounds;
            [self.view addSubview:self.SplitVCAddsubview.view];
            [self addChildViewController:self.SplitVCAddsubview];
            self.orientationSaved = oriention;
            
        }
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];


}

-(UISplitViewController *)SplitVC{
    if (!_SplitVC) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"MenberStoryboard" bundle:nil];
//        if ([story.instantiateInitialViewController isKindOfClass:[UISplitViewController class]]) {
            _SplitVC = story.instantiateInitialViewController;
            _SplitVC.delegate = self;
            _SplitVC.presentsWithGesture = YES;
            //
            _mainDetailMenberVC = [_SplitVC.viewControllers lastObject];
            _menberDetailMaster = [_SplitVC.viewControllers objectAtIndex:0];
            _menberDetailMaster.delegate = _mainDetailMenberVC;
            _menberDetailMaster.listerMenber = self.listerMenber;
            _mainDetailMenberVC.listerMenber = self.listerMenber;
//            NSLog(@"self.view.bounds::%@",NSStringFromCGRect(self.view.bounds));
//            NSLog(@"self.view.bounds::%@",NSStringFromCGRect(_SplitVC.view.bounds));
            _SplitVC.view.frame = self.view.bounds;
//        }
    }
    return _SplitVC;
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
