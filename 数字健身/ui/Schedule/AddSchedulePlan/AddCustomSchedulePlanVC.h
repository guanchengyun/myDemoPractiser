//
//  AddCustomSchedulePlanVC.h
//  数字健身
//
//  Created by 城云 官 on 14-7-2.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCustomSchedulePlanVCDelegate <NSObject>
-(void)AddCustomSchedulePlanVCSuccessfulDelegate;
@end

@interface AddCustomSchedulePlanVC : UITableViewController
@property(copy, nonatomic)NSString *contract_id;
@property(copy, nonatomic)NSString *define_id;
@property(weak, nonatomic)id<AddCustomSchedulePlanVCDelegate>delegate;
@end
