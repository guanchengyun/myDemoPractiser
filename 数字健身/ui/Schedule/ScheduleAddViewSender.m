//
//  ScheduleAddViewSender.m
//  数字健身
//
//  Created by 城云 官 on 14-6-13.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "ScheduleAddViewSender.h"
#define whiteviewwith

@implementation ScheduleAddViewSender

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

//-(ScheduleAddViewSender *)iniWithTitle:(NSString *)title placeholder:(NSString *) placeholder{
//    ScheduleAddViewSender *scheduleAddView = nil;
//    scheduleAddView = [self initWithFrame:CGRectMake(0, 10, 0, 0)];
//    scheduleAddView = 
//}
//
//-(UIView *)WhiteView{
//    if (_WhiteView) {
//        _WhiteView = [UIView alloc]initWithFrame:CGRectMake(self.bounds, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//    }
//}

-(UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc]init];
        [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    return _leftButton;
}

-(UIButton *)RightButton{
    if (!_RightButton) {
        _RightButton = [[UIButton alloc]init];
        [_RightButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    return _RightButton;
}

-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
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
