//
//  ButtonmMatching.h
//  数字健身
//
//  Created by 城云 官 on 14-5-9.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractListByCoach.h"

@interface ButtonmMatching : UIButton

typedef NS_ENUM(NSUInteger, MatchingButtonType) {
    TypeMatchingNone = -1,
    TypeMatchingAgreed = 1,//同意
    TypeMatchingRefused ,//拒绝
    TypeMatchingModify ,//修改
    TypeMatchingCancel,//取消
    TypeMatchingComplete,//完成
    TypeMatchingOverdue,//过期
    TypeMatchingTakeUp,//被其他会员占用
    TypeMatchingInitiate//发起
};

@property(assign, nonatomic)MatchingButtonType ButtonType;
//@property (strong, nonatomic)NSString *StringDate;
@property (strong, nonatomic)UIView *viewLine;
@property (strong, nonatomic)UIImageView *myimageview;
@property (weak, nonatomic)ContractListByCoach *contrectlistbycoach;
@end
