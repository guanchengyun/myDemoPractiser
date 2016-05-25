//
//  RightBarPopviewTVC.h
//  数字健身
//
//  Created by 城云 官 on 14-7-4.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RightBarPopviewTVCDelegate <NSObject>
-(void)RightBarPopviewTVCDelegateReturnIndexPath:(NSIndexPath *)IndexPath;

@end

@interface RightBarPopviewTVC : UITableViewController

@property(weak, nonatomic)id<RightBarPopviewTVCDelegate>delegate;
@end
