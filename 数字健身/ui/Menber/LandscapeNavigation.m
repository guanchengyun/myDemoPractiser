//
//  LandscapeNavigation.m
//  数字健身
//
//  Created by 城云 官 on 14-5-4.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "LandscapeNavigation.h"

@interface LandscapeNavigation ()

@end

@implementation LandscapeNavigation

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

////禁止竖屏
-(NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskLandscape;
}


- (BOOL)shouldAutorotate
{
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
