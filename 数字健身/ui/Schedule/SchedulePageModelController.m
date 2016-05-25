//
//  SchedulePageModelController.m
//  SchedulePage
//
//  Created by 城云 官 on 14-5-7.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "SchedulePageModelController.h"

#import "SchedulePageDataViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface SchedulePageModelController()
@property (readonly, strong, nonatomic) NSArray *pageData;
@property (strong, nonatomic)NSMutableArray *viewControllers;
@end

@implementation SchedulePageModelController

- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        _pageData = [[dateFormatter monthSymbols] copy];
        _pageData = @[@0,@1];
    }
    return self;
}

- (SchedulePageDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
 
    NSInteger count = _pageData.count - _viewControllers.count;
    for (NSInteger i=0; i<count; i++) {
        if (!_viewControllers) {
            _viewControllers = [[NSMutableArray alloc]init];
        }
        [_viewControllers addObject:[storyboard instantiateViewControllerWithIdentifier:@"SchedulePageDataViewController"]];
    }
    // Create a new view controller and pass suitable data.
//    SchedulePageDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"SchedulePageDataViewController"];
    SchedulePageDataViewController *dataViewController = _viewControllers[index];
    dataViewController.dataObject = self.pageData[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(SchedulePageDataViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

-(void)reloadmodelSchlePageDate{
    for (SchedulePageDataViewController *vc in _viewControllers) {
        vc.lisyMenber = self.lisyMenber;
//        if ([vc.view window]) {
             [vc reloadSchlePageDate];
//        }
       
    }
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(SchedulePageDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(SchedulePageDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
