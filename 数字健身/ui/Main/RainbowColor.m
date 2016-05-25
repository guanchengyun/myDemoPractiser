//
//  RainbowColor.m
//  数字健身
//
//  Created by 城云 官 on 14-5-9.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "RainbowColor.h"

@implementation RainbowColor

+(NSArray *)RainbowColorArray{
    static NSArray *arrayCollor = nil;
    if (!arrayCollor) {
        arrayCollor = @[@"d95644",@"5489ab",@"5d5494",@"89a64c",@"f4b953",@"f7cb7e",@"62d199",@"d14c50"];
    }
    return arrayCollor;
}
@end
