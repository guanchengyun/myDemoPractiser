//
//  SKSTableViewCell.m
//  SKSTableView
//
//  Created by Sakkaras on 26/12/13.
//  Copyright (c) 2013 Sakkaras. All rights reserved.
//

#import "SKSTableViewCell.h"
#import "SKSTableViewCellIndicator.h"

#define kIndicatorViewTag 100
#define kAccessoryViewTag 101

@interface SKSTableViewCell ()

@end

@implementation SKSTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initAccessoryView];//
        [self setIsExpanded:NO];
//        [self addIndicatorView];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    if (self.isExpandable) {
//    
//        if (![self containsIndicatorView])
//            [self addIndicatorView];
//        else {
//            [self removeIndicatorView];
//            [self addIndicatorView];
//        }
//    }
}

static UIImage *_image = nil;
- (UIView *)expandableView
{
    if (!_image) {
        _image = [UIImage imageNamed:@"targetOpen.png"];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, _image.size.width, _image.size.height);
    button.frame = frame;
    
    [button setBackgroundImage:_image forState:UIControlStateNormal];
    self.imageView.image = _image;
    [self.imageView addSubview:button];
    return button;
}

//设置添加按钮
-(void)initAccessoryView{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake( 0.0 , 0.0 , 80 , 30 );
    button. frame = frame;
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithHexString:[[RainbowColor RainbowColorArray] firstObject]]];
    button.tag = kAccessoryViewTag;
    self.accessoryView = button;
}

//- (void)setIsExpandable:(BOOL)isExpandable
//{
//    if (isExpandable)
//        [self setAccessoryView:[self expandableView]];
//    
//    _isExpandable = isExpandable;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)addIndicatorView
{
//    CGPoint point = self.imageView.center;
//    CGRect bounds = self.imageView.bounds;
//    
//    CGRect frame = CGRectMake((point.x - CGRectGetWidth(bounds) * 1.5), point.y * 1.4, CGRectGetWidth(bounds) * 3.0, CGRectGetHeight(self.bounds) - point.y * 1.4);
//    SKSTableViewCellIndicator *indicatorView = [[SKSTableViewCellIndicator alloc] initWithFrame:frame];
//    indicatorView.tag = kIndicatorViewTag;
    
    if (!_image) {
        _image = [UIImage imageNamed:@"targetOpen.png"];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(13, 10, _image.size.width, _image.size.height);
    button.frame = frame;
    button.tag = kIndicatorViewTag;
    [button setBackgroundImage:_image forState:UIControlStateNormal];
//    self.imageView.image = _image;
//    [self.imageView addSubview:button];
    [self.contentView addSubview:button];
//    [self.contentView addSubview:indicatorView];
}

- (void)removeIndicatorView
{
    id indicatorView = [self.contentView viewWithTag:kIndicatorViewTag];
//    self.imageView.image = nil;
    [indicatorView removeFromSuperview];
}

- (BOOL)containsIndicatorView
{
    return [self.contentView viewWithTag:kIndicatorViewTag] ? YES : NO;
}

@end
