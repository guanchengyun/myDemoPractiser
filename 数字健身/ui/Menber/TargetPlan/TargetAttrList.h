//
//  TargetAttrList.h
//  数字健身
//
//  Created by 城云 官 on 14-6-3.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TargetAttrList : NSObject
@property(assign, nonatomic)NSInteger ID_out;
@property(assign, nonatomic)NSInteger ID;
@property(strong, nonatomic)NSString *TA_CD;//名称
@property(strong, nonatomic)NSString *TA_Content;//单位
@property(strong, nonatomic)NSString *TA_DetailContent;//内容
@property(assign, nonatomic)BOOL isIncrease;//增长还是减少
@end
