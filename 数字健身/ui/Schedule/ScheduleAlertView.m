//
//  ScheduleAlertView.m
//  数字健身
//
//  Created by 城云 官 on 14-6-13.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "ScheduleAlertView.h"

@implementation ScheduleAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)show {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 290, 50)];
    view.backgroundColor = [UIColor clearColor];
    self.InputView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, 270, 50)];
    [view addSubview:self.InputView];
    [self setValue:view forKey:@"accessoryView"];
    [self.InputView becomeFirstResponder];
    [super show];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
