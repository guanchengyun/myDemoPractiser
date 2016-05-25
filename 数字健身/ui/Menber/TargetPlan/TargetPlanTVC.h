//
//  TargetPlanTVC.h
//  数字健身
//
//  Created by 城云 官 on 14-4-17.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListMenber.h"
#import "SKSTableView.h"

@interface TargetPlanTVC : UITableViewController<SKSTableViewDelegate>
@property(weak , nonatomic)ListMenber *listerMenber;
@end
