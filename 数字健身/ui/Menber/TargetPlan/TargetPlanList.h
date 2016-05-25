//
//  TargetPlanList.h
//  数字健身
//
//  Created by 城云 官 on 14-5-23.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PiecewiseMutarr.h"

@interface TargetPlanList : NSObject

@property(strong, nonatomic)NSString *Title;
@property(strong, nonatomic)NSData *DataStart;
@property(strong, nonatomic)NSData *DataEnd;
@property(strong, nonatomic)NSArray *ArrayPiecewiseList;

@end
