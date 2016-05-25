//
//  MessageMasterVC.h
//  数字健身
//
//  Created by 城云 官 on 14-4-25.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MessageMasterVCDelegate <NSObject>
@required
-(void)selectedContainVc:(NSInteger )ContainNumber;
@end
@interface MessageMasterVC : UIViewController

@property(weak, nonatomic)id<MessageMasterVCDelegate>delegate;

@end
