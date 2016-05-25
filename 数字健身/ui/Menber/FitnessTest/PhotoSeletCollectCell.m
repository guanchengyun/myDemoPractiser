//
//  PhotoSeletCollectCell.m
//  数字健身
//
//  Created by 城云 官 on 14-4-24.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "PhotoSeletCollectCell.h"

@implementation PhotoSeletCollectCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.imageView];
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(0, 0, 50, 29);
        self.button.selected = NO;
//        [self.button setImage:[UIImage imageNamed:@"RYAssetsPicker.bundle/check.png"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"RYAssetsPicker.bundle/check.png"] forState:UIControlStateSelected];
//        self.button.backgroundColor = [UIColor redColor];
        [self addSubview:self.button];
       
    }
    return self;
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
