//
//  SchedulePageRootViewController.h
//  SchedulePage
//
//  Created by 城云 官 on 14-5-7.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentClassFirstVC.h"

@interface SchedulePageRootViewController : ParentClassFirstVC <UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
extern NSString *const SchedulePageRootNotification;
@end
