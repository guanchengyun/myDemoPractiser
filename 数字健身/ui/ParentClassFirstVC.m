//
//  ParentClassFirstVC.m
//  数字健身
//
//  Created by 城云 官 on 14-3-28.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "ParentClassFirstVC.h"
#import "MainViewController.h"

@interface ParentClassFirstVC ()

@end

@implementation ParentClassFirstVC

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
//    // Do any additional setup after loading the view.
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(leftBarAction)];
//    initWithImage:[UIImage imageNamed:@"LiftImage_leftbarbutton.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarAction)]
    [self initBarButton];
}

-(void)initBarButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"LiftImage_leftbarbutton.png"]
                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftBarAction)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(27, 0, 54, 30);
    
    UIView *menuview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 74, 30)];
    [menuview addSubview:button];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menuview];
    self.navigationItem.leftBarButtonItem = menuButton;
}
-(void)leftBarAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:MainViewControllerNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"ShowTabBarView",@"NotificationKey1", nil]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MainViewControllerNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"willDissViewController",@"NotificationKey1", nil]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:MainViewControllerNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"willShowViewController",@"NotificationKey1", nil]];
    }
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
