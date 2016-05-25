//
//  PiecewiseList.h
//  数字健身
//
//  Created by 城云 官 on 14-5-23.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PiecewiseList : NSObject
@property(copy, nonatomic)NSString *Title;
@property(copy, nonatomic)NSString *Content;
@property(copy, nonatomic)NSDate *DateStart;
@property(copy, nonatomic)NSString *DateStartTitle;
@property(copy, nonatomic)NSDate *DateEnd;
@property(copy, nonatomic)NSString *DateEndTitle;

@property(copy, nonatomic)NSString *TU_Createdate;

@property(assign, nonatomic)NSInteger ID;
@property(assign, nonatomic)NSInteger FK_CD_ID;
@property(assign, nonatomic)NSInteger FK_UI_ID;

@end
