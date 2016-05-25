//
//  CoachCircleVC.h
//  数字健身
//
//  Created by 城云 官 on 14-3-28.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentClassFirstVC.h"
#import "CoachCircleDetailVC.h"

@interface CoachCircleVC : ParentClassFirstVC<UISplitViewControllerDelegate>

@property(strong, nonatomic)UISplitViewController *SplitVC;
@property(strong, nonatomic)CoachCircleDetailVC *DetailVC;
@property(strong, nonatomic)UINavigationController *RootNav;
@property(strong, nonatomic)UIPopoverController *popover;
@end
