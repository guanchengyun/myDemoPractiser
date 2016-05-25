//
//  MenberCollectCell.m
//  数字健身
//
//  Created by 城云 官 on 14-4-11.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "MenberCollectCell.h"

@implementation MenberCollectCell
@synthesize Btn_Focus = _Btn_Focus;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
           }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.Btn_Focus setTitle:@"标记" forState:UIControlStateNormal];
        [self.Btn_Focus setTitle:@"取消标记" forState:UIControlStateSelected];
        [self.Btn_Focus setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.Btn_Focus setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [self.Btn_Focus.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.Btn_Focus.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        self.Btn_Focus.titleLabel.numberOfLines=0;
        self.Btn_Focus.backgroundColor = [UIColor redColor];
        _Btn_Focus.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:24];

    }
    return self;
}

-(void)reloadCollectCell{
    _Btn_Focus.titleLabel.textColor = [UIColor whiteColor];
    if (_Btn_Focus.selected == YES) {
        [self.Btn_Focus setTitle:@"取消标记" forState:UIControlStateNormal];
        [self.Btn_Focus.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.Btn_Focus.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        self.Btn_Focus.titleLabel.numberOfLines=0;
        self.Btn_Focus.backgroundColor = [UIColor lightGrayColor];
        _Btn_Focus.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:20];
    }else{
        [self.Btn_Focus setTitle:@"标记" forState:UIControlStateNormal];
        [self.Btn_Focus.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.Btn_Focus.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        self.Btn_Focus.titleLabel.numberOfLines=0;
        self.Btn_Focus.backgroundColor = [UIColor colorWithHexString:@"d95644"];
        _Btn_Focus.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:22];
    }
}

- (IBAction)BtnFocus:(id)sender {
    [self.delegate menssegeCell:self.IndexPathID Button:sender];
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
