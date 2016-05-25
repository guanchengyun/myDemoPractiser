//
//  SchedulePageDateCell.h
//  数字健身
//
//  Created by 城云 官 on 14-5-8.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchedulePageDateCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *Buttons;
@property (weak, nonatomic) IBOutlet UIView *TopLine;
@property (weak, nonatomic) IBOutlet UIView *BottomLine;

@end
