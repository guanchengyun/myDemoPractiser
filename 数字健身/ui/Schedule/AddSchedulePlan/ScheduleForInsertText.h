//
//  ScheduleForInsertText.h
//  数字健身
//
//  Created by 城云 官 on 14-6-26.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleForInsertText : NSObject
+(ScheduleForInsertText *)sharedInstance;
+(NSArray *)TotalTime;
+(NSArray *)piecewiseString;
+(NSArray *)GradientString;

-(NSString *)SecondsWithSegmentedTime:(NSString *)string;
-(NSString *)MinutesAndSecondsWithSegmentedTime:(NSInteger )timeCount;
@end
