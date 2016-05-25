//
//  SeletTypeHeartRateVC.h
//  数字健身
//
//  Created by 城云 官 on 14-6-24.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SeletTypeHeartRateVCDelegate <NSObject>

-(void)SeletTypeHeartRateVCDelegateSaveSuccessful;

@end

@interface SeletTypeHeartRateVC : UITableViewController
@property(copy, nonatomic)NSString *FK_CIN_ID;
@property(copy, nonatomic)NSString *Heart_Id;
@property(strong, nonatomic)NSDictionary *dicGet;

@property(weak, nonatomic)id<SeletTypeHeartRateVCDelegate>delegate;
@end
