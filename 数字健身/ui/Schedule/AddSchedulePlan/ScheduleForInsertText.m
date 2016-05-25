//
//  ScheduleForInsertText.m
//  数字健身
//
//  Created by 城云 官 on 14-6-26.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "ScheduleForInsertText.h"

@implementation ScheduleForInsertText
static ScheduleForInsertText* scheduleForInsertText;
+(ScheduleForInsertText *)sharedInstance{
    if (!scheduleForInsertText) {
        scheduleForInsertText = [[ScheduleForInsertText alloc] init];
    }
    return scheduleForInsertText;
}

//总时间包含输入字符
+(NSArray *)TotalTime{
    static NSArray *TotalTime = nil;
    if (!TotalTime) {
        TotalTime = @[@"",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    }
    return TotalTime;
}

//分段时间包含输入字符
+(NSArray *)piecewiseString{
    static NSArray *piecewiseTime = nil;
    if (!piecewiseTime) {
        piecewiseTime = @[@"",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@":",@"："];
    }
    return piecewiseTime;
}

//倾斜度和速度包含输入字符
+(NSArray *)GradientString{
    static NSArray *gradientString = nil;
    if (!gradientString) {
        gradientString = @[@"",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"."];
    }
    return gradientString;
}

+(NSArray *)numberString{
    static NSArray *numberString = nil;
    if (!numberString) {
        numberString = @[@"",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    }
    return numberString;
}
//将输入信息转成多少秒   如 10：10  --》610
-(NSString *)SecondsWithSegmentedTime:(NSString *)string{
    NSMutableString *stringtime = [[NSMutableString alloc]initWithString:string];
    NSRange range = [stringtime rangeOfString:@":"];
    if (range.length > 0) {
        NSString *strMinutes = [stringtime substringToIndex:range.location];
        NSString *strSeconds = [stringtime substringWithRange:NSMakeRange((range.location+1),(stringtime.length - range.location-1))];
        //        NSLog(@"strMinutes::%@",strMinutes);
        //        NSLog(@"strSeconds::%@",strSeconds);
        return [NSString stringWithFormat:@"%d",([strMinutes intValue]*60 +[strSeconds intValue])];
        
    }else{
        range = [stringtime rangeOfString:@"："];
        if (range.length > 0) {
            NSString *strMinutes = [stringtime substringToIndex:range.location];
            NSString *strSeconds = [stringtime substringWithRange:NSMakeRange((range.location+1),(stringtime.length - range.location-1))];
            //        NSLog(@"strMinutes::%@",strMinutes);
            //        NSLog(@"strSeconds::%@",strSeconds);
            return [NSString stringWithFormat:@"%d",([strMinutes intValue]*60 +[strSeconds intValue])];
        }else{
            return string;
        }
    }
    
    return string;
}

//
-(NSString *)MinutesAndSecondsWithSegmentedTime:(NSInteger )timeCount{
    NSString *strMinutes = [NSString stringWithFormat:@"%d",timeCount/60];
    NSString *strSeconds = [NSString stringWithFormat:@"%d",timeCount%60];
    
    return [NSString stringWithFormat:@"%@:%@",strMinutes,strSeconds];
}
@end
