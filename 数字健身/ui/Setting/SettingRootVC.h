//
//  SettingRootVC.h
//  数字健身
//
//  Created by 城云 官 on 14-4-24.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingRootVCDelegate <NSObject>
@required
-(void)selectedContainVc:(NSInteger )ContainNumber;
@end

@interface SettingRootVC : UITableViewController

@property(weak, nonatomic)id<SettingRootVCDelegate>delegate;
@end
