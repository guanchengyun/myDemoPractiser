//
//  CoachDataCell.m
//  数字健身
//
//  Created by 城云 官 on 14-4-17.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "CoachDataCell.h"

@implementation CoachDataCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
//    _collectBtn.highlighted = NO;
//    if (_collectBtn.selected == NO) {
//        [_collectBtn setBackgroundColor:[UIColor colorWithHexString:@"89a64c"]];
//    }else{
//        [_collectBtn setBackgroundColor:[UIColor grayColor]];
//    }

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
//        _collectBtn.highlighted = NO;
//        _collectBtn.selected = !_collectBtn.selected;
    }
}
@end
