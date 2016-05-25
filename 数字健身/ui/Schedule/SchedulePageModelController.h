//
//  SchedulePageModelController.h
//  SchedulePage
//
//  Created by 城云 官 on 14-5-7.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListMenber.h"

@class SchedulePageDataViewController;

@interface SchedulePageModelController : NSObject <UIPageViewControllerDataSource>
@property (weak, nonatomic) UIPageViewController *pageViewController;

- (SchedulePageDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(SchedulePageDataViewController *)viewController;

@property(strong, nonatomic)ListMenber *lisyMenber;
-(void)reloadmodelSchlePageDate;
@end
