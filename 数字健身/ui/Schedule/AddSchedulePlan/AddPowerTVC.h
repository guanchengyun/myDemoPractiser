//
//  AddPowerTVC.h
//  数字健身
//
//  Created by 城云 官 on 14-6-30.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddPowerTVCDelegate <NSObject>
-(void)AddPowerTVCSaveSuccessfulDelegate;
@end

@interface AddPowerTVC : UITableViewController
@property(copy, nonatomic)NSString *contract_id;
@property(copy, nonatomic)NSString *Power_id;
@property(strong, nonatomic)NSDictionary *dicGet;

@property(weak, nonatomic)id<AddPowerTVCDelegate>delegate;
@end
