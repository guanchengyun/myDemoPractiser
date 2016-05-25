//
//  SeletTypeLevelVC.h
//  数字健身
//
//  Created by 城云 官 on 14-6-24.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SeletTypeLevelVCDelegate <NSObject>

-(void)SeletTypeLevelVCDelegateSaveSuccessful;

@end
@interface SeletTypeLevelVC : UITableViewController
@property(copy, nonatomic)NSString *FK_CIN_ID;
@property(copy, nonatomic)NSString *Level_Id;
@property(strong, nonatomic)NSDictionary *dicGet;

@property(weak, nonatomic)id<SeletTypeLevelVCDelegate>delegate;
@end
