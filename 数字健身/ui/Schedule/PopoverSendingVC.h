//
//  PopoverSendingVC.h
//  数字健身
//
//  Created by 城云 官 on 14-6-16.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractListByCoach.h"
#import "ButtonmMatching.h"
#import "ListMenber.h"

@protocol PopoverSendingVCDelegate <NSObject>

-(void)PopoverSendingVCDelegateSender;

@end

@interface PopoverSendingVC : UIViewController

@property(copy, nonatomic)NSString *textString;
@property (weak, nonatomic)ButtonmMatching *buttonMatching;
@property (weak, nonatomic)UIPopoverController *popverCT;
@property(copy, nonatomic)NSString *startDate;
@property(copy, nonatomic)NSString *endDate;
@property(weak, nonatomic)ListMenber *lisyMenber;

@property(weak, nonatomic)id<PopoverSendingVCDelegate>delegate;
@end
