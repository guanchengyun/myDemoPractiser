//
//  AddAerobicPlanTVC.h
//  数字健身
//
//  Created by 城云 官 on 14-6-14.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddAerobicPlanTVCDelegate <NSObject>
-(void)AddAerobicPlanTVCDelegateSaveSuccessful;
@end

@interface AddAerobicPlanTVC : UITableViewController
@property(copy, nonatomic)NSString *FK_CIN_ID;
@property(copy, nonatomic)NSString *Speed_Id;
@property(strong, nonatomic)NSDictionary *dicGet;

@property(weak, nonatomic)id<AddAerobicPlanTVCDelegate>delegate;

@end
