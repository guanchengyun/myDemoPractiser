//
//  SchedulePageRootViewController.m
//  SchedulePage
//
//  Created by 城云 官 on 14-5-7.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "SchedulePageRootViewController.h"

#import "SchedulePageModelController.h"

#import "SchedulePageDataViewController.h"
#import "SeletMenberVC.h"
#import "MenberVC.h"
#import "RightBarPopviewTVC.h"

@interface SchedulePageRootViewController ()<SeletMenberVCDelegate,RightBarPopviewTVCDelegate>
@property (readonly, strong, nonatomic) SchedulePageModelController *modelController;
@property (strong,nonatomic)NSNotificationCenter *center;
@property (strong, nonatomic)IBOutlet UIView *rightBarPopview;
@property (strong, nonatomic)RightBarPopviewTVC *rightbarTVC;
@property (strong, nonatomic)UIPopoverController *PopoverRightbarTVC;
@property (strong, nonatomic)SeletMenberVC *selemenbervc;
@end

NSString *const SchedulePageRootNotification = @"SchedulePageRootNotification";
@implementation SchedulePageRootViewController

@synthesize modelController = _modelController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    
    [self initNotification];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;

    SchedulePageDataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
  
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    self.pageViewController.dataSource = self.modelController;
    self.modelController.pageViewController = self.pageViewController;

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
//    pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
    self.pageViewController.view.frame = pageViewRect;

    [self.pageViewController didMoveToParentViewController:self];

    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightButtonAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
    UIStoryboard *seleMenberStory = [UIStoryboard storyboardWithName:@"MenberVCStoryboard" bundle:nil];
    self.selemenbervc = [seleMenberStory instantiateViewControllerWithIdentifier:@"SeletMenberVC"];
    self.selemenbervc.delegate = self;
    [self initRightBarPopview];
   
    
}

//初始化弹出框
-(void)initRightBarPopview{
    self.rightbarTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RightBarPopviewTVC"];
    self.rightbarTVC.delegate = self;
    self.PopoverRightbarTVC = [[UIPopoverController alloc]initWithContentViewController:self.rightbarTVC];
}

#pragma mark RightBarPopviewTVCDelegate =====
-(void)RightBarPopviewTVCDelegateReturnIndexPath:(NSIndexPath *)IndexPath{
    if (self.PopoverRightbarTVC) {
        [self.PopoverRightbarTVC dismissPopoverAnimated:YES];
    }
    if (IndexPath.row == 0) {
        self.modelController.lisyMenber = nil;
         [self.modelController reloadmodelSchlePageDate];
    }else if(IndexPath.row == 1){
        //
        [self.navigationController pushViewController:self.selemenbervc animated:YES];
    }
    
}

-(void)rightButtonAction{
    [self.PopoverRightbarTVC presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//     UIStoryboard *seleMenberStory = [UIStoryboard storyboardWithName:@"MenberVCStoryboard" bundle:nil];
//    SeletMenberVC *selemenbervc = [seleMenberStory instantiateViewControllerWithIdentifier:@"SeletMenberVC"];
//    selemenbervc.delegate = self;
//
//    [self.navigationController pushViewController:selemenbervc animated:YES];531
//    if (self.rightBarPopview.hidden == YES) {
//        self.rightBarPopview.hidden = NO;
////        [self.rightBarPopview addSubview:self.rightBarPopview];
//        [self.view addSubview:self.rightBarPopview];
////        UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapGesAction:)];
////        [self.navigationController.view addGestureRecognizer:tapgest];
//    }else{
//        self.rightBarPopview.hidden = YES;
////        [self.rightBarPopview removeFromSuperview];
//    }
    
}

//-(void)TapGesAction:(UITapGestureRecognizer *)tapGest{
//    self.rightBarPopview.hidden = YES;
//    [self.navigationController.view removeGestureRecognizer:tapGest];
//}

//-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//
//}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.rightBarPopview.hidden == NO) {
        self.rightBarPopview.hidden = YES;
      
    }
}

-(void)dealloc{
   
    [_center removeObserver:self name:SchedulePageRootNotification object:nil];
}

-(void)initNotification{
    _center=[NSNotificationCenter defaultCenter];
    //注册从新登入通知
    [_center addObserver:self selector:@selector(NotificationAction:) name:SchedulePageRootNotification object:nil];
}

-(void)NotificationAction:(NSNotification *)notification{
    if ([notification.name isEqualToString:SchedulePageRootNotification]) {
        NSString *Str_UserInfo = [notification.userInfo objectForKey:@"NotificationKey1"];
        if ([Str_UserInfo isEqualToString:@"Title"]) {
            self.title = [notification.userInfo objectForKey:@"Value"];
        }
    }
    
}

#pragma mark ---------SeletMenberVCDelegate==============
-(void)GetMenberID:(ListMenber *)menber{
  
//    [self.navigationController popViewControllerAnimated:YES];
    if (menber.ID != self.modelController.lisyMenber.ID) {
        self.modelController.lisyMenber = menber;
        [self.modelController reloadmodelSchlePageDate];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SchedulePageModelController *)modelController
{
     // Return the model controller object, creating it if necessary.
     // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[SchedulePageModelController alloc] init];
    }
    return _modelController;
}

#pragma mark - UIPageViewController delegate methods

/*
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}
 */

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        // In portrait orientation: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
        UIViewController *currentViewController = self.pageViewController.viewControllers[0];
        NSArray *viewControllers = @[currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        self.pageViewController.doubleSided = YES;
        return UIPageViewControllerSpineLocationMin;
    }

    // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
    SchedulePageDataViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = nil;

    NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
    if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
        UIViewController *nextViewController = [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
        viewControllers = @[currentViewController, nextViewController];
    } else {
        UIViewController *previousViewController = [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
        viewControllers = @[previousViewController, currentViewController];
    }
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];


    return UIPageViewControllerSpineLocationMid;
}

@end
