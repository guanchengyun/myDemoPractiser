//
//  SchedulePageDataViewController.h
//  SchedulePage
//
//  Created by 城云 官 on 14-5-7.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentClassFirstVC.h"
#import "ListMenber.h"

@interface SchedulePageDataViewController : ParentClassFirstVC

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;
@property(weak, nonatomic)ListMenber *lisyMenber;

-(void)reloadSchlePageDate;
@end
