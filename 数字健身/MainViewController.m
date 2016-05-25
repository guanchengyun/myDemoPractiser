//
//  MainViewController.m
//  数字健身
//
//  Created by 城云 官 on 14-3-27.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "MainViewController.h"
#import "MenberVC.h"
#import "CoachCircleVC.h"
#import "ConsultVC.h"
#import "MessageVC.h"
#import "StatisticsVC.h"
#import "SettingVC.h"
#import "SchedulePageRootViewController.h"
#import <QuartzCore/QuartzCore.h>

NSString *const MainViewControllerNotification = @"MainViewControllerNotification";


typedef enum {
    ToSchedule = 1,
    ToMenber,
    ToCoachCircle,
    ToConsult,
    ToMessage,
    ToStatistics,
    ToSetting
}ContainSelet;

typedef NS_ENUM(NSUInteger, ICSDrawerControllerState)
{
    ICSDrawerControllerStateClosed = 0,
    ICSDrawerControllerStateOpening,
    ICSDrawerControllerStateOpen,
    ICSDrawerControllerStateClosing
};
@interface MainViewController ()<UIGestureRecognizerDelegate>{
//    ConsultVC *_consultVC;//咨询
//    CoachCircleVC *_coachCircleVC;//教练圈
//    MenberVC *_menberVC;//会员
//    MessageVC *_messageVC;//消息
//    ScheduleVC *_scheduleVC;//日程
//    StatisticsVC *_statisticsVC;//统计
//    SettingVC *_settingVC;//
    BOOL isSide;//侧边栏是否显示,来控制单机侧边栏按钮,来开关侧边栏
    //正常状态下的图片数组
	NSArray  *_nomalImageArray;
    //高亮状态下的图片数组
	NSArray  *_hightlightedImageArray;
}

@property (nonatomic, strong) SchedulePageRootViewController *scheduleVC;//日程
@property (nonatomic, strong) MenberVC *menberVC;//会员
@property (nonatomic, strong) CoachCircleVC *coachCircleVC;//教练圈
@property (nonatomic, strong) ConsultVC *consultVC;//咨询
@property (nonatomic, strong) MessageVC *messageVC;//消息
@property (nonatomic, strong) StatisticsVC *statisticsVC;//统计
@property (nonatomic, strong) SettingVC *settingVC;
@property (nonatomic, weak) UIViewController *previousViewController;

@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic, assign) CGPoint panGestureStartLocation;
@property(nonatomic, assign) ICSDrawerControllerState drawerState;
@property(nonatomic, assign) NSInteger indexDuration;

@end

@implementation MainViewController
@synthesize viewControllers = _viewControllers;
@synthesize seletedIndex = _seletedIndex;
@synthesize previousNavViewController = _previousNavViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        _seletedIndex = -1;
    }
    return self;
}
-(id)init{
    self = [super init];
    if (self) {
//        _seletedIndex = -1;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        _seletedIndex = -1;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.indexDuration = 1;//赋值后可以横横竖屏
}

//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    self.indexDuration = 0;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self initAllVC];
    [self initNotification];
//
    self.navigationController.delegate=self;
    [self setAutoLayout];
    [self initBarbutton];
//    _seletedIndex = -1;
////    [self setSeletedIndex:1];
//    [self setSeletedIndex:0];
    _seletedIndex = 0;
    [self initAllVC];
}

-(void)setAutoLayout{

    [self.tabbarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray * tempConstraints;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        //创建一个存放约束的数组
        tempConstraints = [NSMutableArray array];
        [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-44-[_tabbarView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tabbarView,_tabbarView.subviews)]];
        [self.view addConstraints:tempConstraints];
    }
    
}

-(void)initBarbutton{
    
    _nomalImageArray = [[NSArray alloc]  initWithObjects:@"Schedule.png",@"Menber.png",@"CoachCircle.png",@"Consult.png",@"Message.png",@"Statistics",@"Setting",nil];
    
    _hightlightedImageArray = [[NSArray alloc]initWithObjects:@"Schedule_pre.png",@"Menber_pre.png",@"CoachCircle_pre.png",@"Consult_pre.png",@"Message_pre",@"Statistics_pre",@"Setting_pre",nil];
  
    NSArray *array = [NSArray arrayWithObjects:@"日程",@"会员",@"教练圈",@"资讯",@"消息",@"统计",@"设置", nil];
    for (UIButton *btn in self.tabbarView.subviews) {
        if ([btn isKindOfClass:[BarButton class]]) {
            BarButton *btnBar = (BarButton *)btn;
            btnBar.contentEdgeInsets=UIEdgeInsetsMake(-10, 0, 0, 0);
            [btnBar setImage:[UIImage imageNamed:[_nomalImageArray objectAtIndex:(btn.tag - 1)]] forState:UIControlStateNormal];
            [btnBar setTabbarTitleLabel:[array objectAtIndex:(btn.tag - 1)]];
            if (btn.tag==1) {
                [btnBar setBackgroundImage:[UIImage imageNamed:[_hightlightedImageArray objectAtIndex:0]] forState:UIControlStateNormal];
                [btnBar setBarButtonTitleColor:1];
//                BarButton *previousButton = (BarButton *)[self.tabbarView viewWithTag:  1];
//                //设置为正常状态下的图片
//                //		[previousButton setImage:[UIImage imageNamed:[_nomalImageArray objectAtIndex:_seletedIndex]] forState:UIControlStateNormal];
//                [previousButton setBackgroundImage:nil forState:UIControlStateNormal];
//                previousButton.backgroundColor = [UIColor clearColor];
//                [previousButton setBarButtonTitleColor:0];
            }
           
        }
    }
    
}

-(void)initNotification{
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    //注册从新登入通知
    [center addObserver:self selector:@selector(NewLoginAction:) name:MainViewControllerNotification object:nil];
    
    
}


-(void)initAllVC{
//    _scheduleVC = [[ScheduleVC alloc] init];//日程
//    _menberVC = [[MenberVC alloc]init];//会员
//    _coachCircleVC = [[CoachCircleVC alloc]init];//咨询
//    _consultVC = [[ConsultVC alloc]init];//教练圈
//    _messageVC = [[MessageVC alloc]init];//消息
//    _statisticsVC = [[StatisticsVC alloc]init];//统计
//    _settingVC = [[SettingVC alloc]init];//设置
    UIStoryboard *MenberStory = [UIStoryboard storyboardWithName:@"MenberVCStoryboard" bundle:nil];
    
    
    self.scheduleVC = (SchedulePageRootViewController *)[[UIStoryboard storyboardWithName:@"SchedulePage" bundle:nil]instantiateInitialViewController];
//    self.menberVC = [[MenberVC alloc]init];
    self.menberVC = MenberStory.instantiateInitialViewController;
    self.coachCircleVC = [[CoachCircleVC alloc]init];
    self.consultVC = [[ConsultVC alloc]init];
    self.messageVC = [[MessageVC alloc]init];
    self.statisticsVC = [[StatisticsVC alloc]init];
    self.settingVC = [[SettingVC alloc]init];
    
    UINavigationController *navi1 = [[UINavigationController alloc]initWithRootViewController:_scheduleVC];
    UINavigationController *navi2 = [[UINavigationController alloc]initWithRootViewController:_menberVC];
    UINavigationController *navi3 = [[UINavigationController alloc]initWithRootViewController:_coachCircleVC];
    UINavigationController *navi4 = [[UINavigationController alloc]initWithRootViewController:_consultVC];
    UINavigationController *navi5 = [[UINavigationController alloc]initWithRootViewController:_messageVC];
    UINavigationController *navi6 = [[UINavigationController alloc]initWithRootViewController:_statisticsVC];
    UINavigationController *navi7 = [[UINavigationController alloc]initWithRootViewController:_settingVC];
    
    if (IS_IOS_7) {
        navi1.navigationBar.translucent = NO;
        navi2.navigationBar.translucent = NO;
        navi3.navigationBar.translucent = NO;
        navi4.navigationBar.translucent = NO;
        navi5.navigationBar.translucent = NO;
        navi6.navigationBar.translucent = NO;
        navi7.navigationBar.translucent = NO;
    }
    NSArray *array=[NSArray arrayWithObjects:navi1,navi2,navi3,navi4,navi5,navi6,navi7,nil];
    self.viewControllers = array;
    self.previousViewController = navi1;
    self.previousViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.previousViewController.view];
    [self addChildViewController:self.previousViewController];
    
    [self setupGestureRecognizers];
}

#pragma mark 键盘隐藏时调用
-(void)NewLoginAction:(NSNotification *)notification{
    if ([notification.name isEqualToString:MainViewControllerNotification]) {
        NSString *Str_UserInfo = [notification.userInfo objectForKey:@"NotificationKey1"];
        if ([Str_UserInfo isEqualToString:@"ShowTabBarView"]) {
            if (isSide == YES) {
                [self hideSide];
                
            }else{
                [self showSide];
            }
           
        }else if ([Str_UserInfo isEqualToString:@"willShowViewController"]){
            if (isSide == YES) {
                [self hideSide];
                
            }//            [self hideSide];
            self.isHidenPan = YES;
        }else if ([Str_UserInfo isEqualToString:@"willDissViewController"]){
            self.isHidenPan = NO;
        }
    }

}

- (IBAction)selectTabbar:(id)sender {
    //获得索引
    
	BarButton *btn = (BarButton *)sender;
	NSInteger index = btn.tag - 1;
    if (self.seletedIndex == index) {
        return;
    }
    //用self.赋值默认会调set方法 伴随着控制器自动切换的过程
    self.seletedIndex = index;
//    [self SetSelectContainVC:btn];
    [self setSeletNavi:index];
  
}

-(void)setSeletNavi:(NSInteger)sender{
    if ((sender>-1)&&(sender < _viewControllers.count)) {
        [self.previousViewController removeFromParentViewController];
        [self.previousViewController.view removeFromSuperview];
        self.previousViewController = _viewControllers[sender];
        self.previousViewController.view.frame = self.view.bounds;
        [self.view addSubview:self.previousViewController.view];
        [self addChildViewController:self.previousViewController];
        [self setupGestureRecognizers];
        [self hideSide];
    }
  
}

-(void)SetSelectContainVC:(id)sender{
    for (UIGestureRecognizer * recognizer in self.previousViewController.view.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.view removeGestureRecognizer:recognizer];
        }
    }
//    self.previousViewController.view.hidden = YES;
//    CGPoint centerPre = self.previousViewController.view.center;
    [self.previousViewController.view removeFromSuperview];
    if ([sender isKindOfClass:[UIButton class]]) {
        BarButton *btn = (BarButton *)sender;
        switch (btn.tag) {
            case ToSchedule:
                //日历
                self.previousViewController = self.scheduleVC;
                break;
            case ToMenber:
                //会员
                self.previousViewController = self.menberVC;
                break;
            case ToCoachCircle:
                //教练圈
                self.previousViewController = self.coachCircleVC;
                break;
            case ToConsult:
                //咨询
                self.previousViewController = self.consultVC;
                break;
            case ToMessage:
                //消息
                self.previousViewController = self.messageVC;
                break;
            case ToStatistics:
                //统计
                self.previousViewController = self.statisticsVC;
                break;
            case ToSetting:
                //设置
                self.previousViewController = self.settingVC;
                break;
                
            default:
                break;
        }
        self.previousViewController.view.hidden = NO;
//        self.previousViewController.view.center = centerPre;
        [self.view addSubview:self.previousViewController.view];
        if (self.previousViewController == self.scheduleVC) {
            
        }else{
            [self setupGestureRecognizers];
        }
        
        [self hideSide];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ContainToScheduleVC"])
	{
		self.scheduleVC = segue.destinationViewController;
        self.previousViewController = self.scheduleVC;
	}
	else if ([segue.identifier isEqualToString:@"ContainToMenberVC"])
	{
		self.menberVC = segue.destinationViewController;
        
	}
    else if ([segue.identifier isEqualToString:@"ContainToCoachCircleVC"])
	{
		self.coachCircleVC = segue.destinationViewController;
	}
    else if ([segue.identifier isEqualToString:@"ContainToConsultVC"])
	{
		self.consultVC = segue.destinationViewController;
	}
    else if ([segue.identifier isEqualToString:@"ContainToMessageVC"])
	{
		self.messageVC = segue.destinationViewController;
	}
    else if ([segue.identifier isEqualToString:@"ContainToStatisticsVC"])
	{
		self.statisticsVC = segue.destinationViewController;
	}
    else if ([segue.identifier isEqualToString:@"ContainToSettingVC"])
	{
		self.settingVC = segue.destinationViewController;
	}

}

- (void)setSeletedIndex:(NSInteger)aIndex

{
    //_selectIndex = aIndex;赋值
    // self. selectIndex = aIndex;死循环
	
    
    
    //如果索引值没有改变不做其他操作
	if (_seletedIndex == aIndex) return;
	
    //如果索引值改变了需要做操作
    /*
     安全性判断
     如果_seletedIndex表示当前显示的有视图
     需要把原来的移除掉，然后把对应的TabBar按钮设置为正常状态
     */
	if (_seletedIndex >= 0)
		
	{
        //找出对应索引的视图控制器
//		UIViewController *priviousViewController = [_viewControllers objectAtIndex:_seletedIndex];
        //移除掉
//		[priviousViewController.view removeFromSuperview];
	
        //找出对应的TabBar按钮
		BarButton *previousButton = (BarButton *)[self.tabbarView viewWithTag:_seletedIndex + 1];
        //设置为正常状态下的图片
//		[previousButton setImage:[UIImage imageNamed:[_nomalImageArray objectAtIndex:_seletedIndex]] forState:UIControlStateNormal];
        [previousButton setBackgroundImage:nil forState:UIControlStateNormal];
        previousButton.backgroundColor = [UIColor clearColor];
        [previousButton setBarButtonTitleColor:0];
        
        
        
	}
	
    /*
     记录当前索引，采用属性直接赋值的方式
     更改TabBar按钮状态为高亮状态
     添加视图
     */
    
    //记录一下当前的索引
	_seletedIndex = aIndex;
	
    //获得对应的按钮并且设置为高亮状态下的图片
	BarButton *currentButton = (BarButton *)[self.tabbarView viewWithTag:(aIndex + 1)];
//	[currentButton setImage:[UIImage imageNamed:[_hightlightedImageArray objectAtIndex:aIndex]] forState:UIControlStateNormal];
    [currentButton setBackgroundImage:[UIImage imageNamed:[_hightlightedImageArray objectAtIndex:aIndex]] forState:UIControlStateNormal];
	[currentButton setBarButtonTitleColor:1];
    //获得对应的视图控制器
//	UIViewController *currentViewController = [_viewControllers objectAtIndex:aIndex];
//    //如果次条件成立表示当前是第一个，即“导航控制器”
//    
//    
//    if ([currentViewController isKindOfClass:[UIViewController class]])
//  
//    //设置当前视图的大小
//	currentViewController.view.frame = self.view.bounds;
//	
//    //添加到Tab上
//	[self.view addSubview:currentViewController.view];
//    
//  
//    //把视图放到TabBar下面
//	[self.view sendSubviewToBack:currentViewController.view];
    
}

#pragma mark - Gesture recognizers

- (void)setupGestureRecognizers
{
    if (self.panGestureRecognizer==nil) {
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        self.panGestureRecognizer.maximumNumberOfTouches = 1;
        self.panGestureRecognizer.delegate = self;
    }
    [self.previousViewController.view addGestureRecognizer:self.panGestureRecognizer];
    
}

-(void)addTapgestureWhenShow{
     self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self.previousViewController.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)addClosingGestureRecognizers
{
    [self.previousViewController.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)removeClosingGestureRecognizers
{
    [self.previousViewController.view removeGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark Tap to close the drawer
- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
       
        [self hideSide];

    }
}

#pragma mark Pan to open/close the drawer
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    NSParameterAssert([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]);
//    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view];
//    
//    if (self.drawerState == ICSDrawerControllerStateClosed && velocity.x > 0.0f) {
//        return YES;
//    }
//    else if (self.drawerState == ICSDrawerControllerStateOpen && velocity.x < 0.0f) {
//        return YES;
//    }
//    
//    return NO;
//}
#pragma mark -
#pragma mark 左右滑动
BOOL gestureOrientation = NO;
BOOL IS_first_gesture = NO;
- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    int x=0;
    if ([[UIScreen mainScreen] applicationFrame].size.width == 768 ) {
          x=[UIApplication sharedApplication].keyWindow.center.x+125;
    }else{
        x=[UIApplication sharedApplication].keyWindow.center.y+125;
    }
  
    
    if (!self.isHidenPan) {
        
        
//        if (IS_first_gesture==NO) {
//            [self addTapGesture];
//        }
//        
        IS_first_gesture=YES;
        
//        [self caredLeftView];
        
        CGPoint translation = [recognizer translationInView:self.view];
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            
            if (translation.x>0) {
                //往左滑动
                
                gestureOrientation = NO;
                if ((recognizer.view.center.x>=x)||((recognizer.view.center.x + translation.x)>=x)) {
                    
                    recognizer.view.center = CGPointMake(x,
                                                         recognizer.view.center.y);
                }else{
                    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                                         recognizer.view.center.y);
                }
            }else if(translation.x<0){
                gestureOrientation = YES;
                if ((recognizer.view.center.x>=x-125)&&((recognizer.view.center.x+ translation.x)>=x-125)) {
                    
                    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                                         recognizer.view.center.y);
                }else{
                    recognizer.view.center = CGPointMake(x-125,
                                                         recognizer.view.center.y);
                }
//                NSLog(@"%f",recognizer.view.center.x);
//                NSLog(@"xxxx:%d",x);
                
            }
            
            
//            [recognizer setTranslation:CGPointZero inView:self.view];
        }
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            
            if (!gestureOrientation) {
                isSide=YES;
                [self addTapgestureWhenShow];
                [UIView beginAnimations:nil context:nil];
                recognizer.view.center = CGPointMake(x, recognizer.view.center.y);
                [UIView commitAnimations];
            }else{
                IS_first_gesture=NO;
                isSide=NO;
                for (UIGestureRecognizer * recognizer in self.previousViewController.view.gestureRecognizers) {
                    if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
                        [self.view removeGestureRecognizer:recognizer];
                    }
                }
                [UIView beginAnimations:nil context:nil];
                recognizer.view.center = CGPointMake(x-125, recognizer.view.center.y);
                [UIView commitAnimations];
                
            }
            
        }
    }
    
    
    
    
}

-(void)hideSide{
    int x=0;
    if ([[UIScreen mainScreen] applicationFrame].size.width == 768 ) {
        x=[UIApplication sharedApplication].keyWindow.center.x+125;
    }else{
        x=[UIApplication sharedApplication].keyWindow.center.y+125;
    }
    IS_first_gesture=NO;
    isSide=NO;
    for (UIGestureRecognizer * recognizer in self.previousViewController.view.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.previousViewController.view removeGestureRecognizer:recognizer];
        }
    }
    [UIView beginAnimations:nil context:nil];
    self.previousViewController.view.center = CGPointMake(x -125, self.previousViewController.view.center.y);
    [UIView commitAnimations];
}

-(void)showSide{
    int x=0;
    if ([[UIScreen mainScreen] applicationFrame].size.width == 768 ) {
        x=[UIApplication sharedApplication].keyWindow.center.x+125;
//        NSLog(@"width::%f",[[UIScreen mainScreen] applicationFrame].size.width);
    }else{
        x=[UIApplication sharedApplication].keyWindow.center.y+125;
    }
    [self addTapgestureWhenShow];
    isSide=YES;
    [UIView beginAnimations:nil context:nil];
    self.previousViewController.view.center = CGPointMake(x, self.previousViewController.view.center.y);
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	
	// UIViewController：栈顶的视图控制器；n和m
	
	if (!_previousNavViewController)
		
	{
        //导航控制器中的视图数组
		self.previousNavViewController = navigationController.viewControllers;
	}
	
	
	/*
     是否为压栈的标记，初始化为NO
     如果原来的控制器数不大于当前导航的视图控制器数表示是压栈
     */
	
	
//	BOOL isPush = NO;
//	
//	if ([_previousNavViewController count] <= [navigationController.viewControllers count])
//		
//	{
//		isPush = YES;
//	}
//	
	
    /*
     上一个视图控制器当压栈的时候底部条是否隐藏
     当前视图控制器当压栈的时候底部条是否隐藏
     这两个视图控制器有可能是同一个
     */
    //操作签的栈顶元素和操作后的栈顶元素，者两个控制器内容
    //设置隐藏了系统的tablebar，相当于一个标记内容来；
	BOOL isPreviousHidden = [[_previousNavViewController lastObject] hidesBottomBarWhenPushed];
	BOOL isCurrentHidden = viewController.hidesBottomBarWhenPushed;
	
    //重新记录当前导航器中的视图控制器数组
	self.previousNavViewController = navigationController.viewControllers;
	
    /*
     如果状态相同不做其他操作
     如果上一个显示则隐藏TabBar
     如果上一个隐藏则显示TabBar
     */
	if (!isPreviousHidden && !isCurrentHidden)
	{
		return;
	}
	else if(isPreviousHidden && isCurrentHidden)
	{
		return;
	}
	else if(!isPreviousHidden && isCurrentHidden)
	{
        self.isHidenPan=YES;
		//隐藏tabbar 操作前位no；操作后是yes的情况［压栈］
//		[self hideTabBar:isPush ? SlideDirectionLeft : SlideDirectionRight  animated:animated];
	}
	else if(isPreviousHidden && !isCurrentHidden)
	{
        self.isHidenPan=NO;
		//显示tabbar ［出栈］secondviewcontroller回到第一个控制器；
//		[self showTabBar:isPush ? SlideDirectionLeft : SlideDirectionRight animated:animated];
	}
	
}

//禁止竖屏
//-(NSUInteger)supportedInterfaceOrientations
//{
//    [super supportedInterfaceOrientations];
//    if (!self.indexDuration) {
//        return UIInterfaceOrientationMaskLandscape;
//        
//    }
//    return UIInterfaceOrientationMaskAll;
//}
//
//- (BOOL)shouldAutorotate
//{
//    [super shouldAutorotate];
//    return YES;
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload{
    [super viewDidUnload];
}

-(void)dealloc{
}

@end
