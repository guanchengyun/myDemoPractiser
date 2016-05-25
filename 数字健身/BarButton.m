//
//  BarButton.m
//  O了
//
//  Created by 化召鹏 on 14-1-23.
//  Copyright (c) 2014年 QYB. All rights reserved.
//

#import "BarButton.h"

@implementation BarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(void)setRemindImage:(UIImageView *)remindImage{
    _remindImage=[[UIImageView alloc] initWithFrame:CGRectMake(45, 5, 15, 15)];
    _remindImage.image=[UIImage imageNamed:@"remind.png"];
    _remindImage.backgroundColor=[UIColor clearColor];
    [self addSubview:_remindImage];
    
    
    
    [self bringSubviewToFront:_remindImage];
}
-(void)setRemindNum:(NSInteger)remindNum{
    [_remindImage removeFromSuperview];
    [self setRemindImage:nil];
    if (remindNum==0) {
        _remindImage.alpha = 0;
    }else{
        _remindImage.alpha = 1;
        if(remindNum < 0 ){
            _remindImage.frame = CGRectMake(55, 5, 8, 8);
        }else{
            UILabel *numberLabel=[[UILabel alloc] initWithFrame:CGRectMake(3, 2, 10, 10)];
            numberLabel.backgroundColor=[UIColor clearColor];
            numberLabel.textAlignment=NSTextAlignmentCenter;
            numberLabel.font=[UIFont systemFontOfSize:8];
            numberLabel.textColor=[UIColor whiteColor];
            numberLabel.text=[NSString stringWithFormat:@"%ld",(long)remindNum];
            [_remindImage addSubview:numberLabel];
        }
    }
    
}

-(void)setTabbarTitleLabel:(NSString *)tabbarTitleLabel{
    tabbarLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.frame.size.width, 30)];
    tabbarLabel.backgroundColor=[UIColor clearColor];
    tabbarLabel.textAlignment=NSTextAlignmentCenter;
    tabbarLabel.font=[UIFont systemFontOfSize:19];
    
    tabbarLabel.text=tabbarTitleLabel;
    tabbarLabel.textColor=[UIColor colorWithRed:0.44 green:0.44 blue:0.45 alpha:1];

    [self addSubview:tabbarLabel];

}
-(void)setBarButtonTitleColor:(NSInteger)isSelect{
    if (isSelect==1) {
        tabbarLabel.textColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        
    }else{
        tabbarLabel.textColor=[UIColor colorWithRed:0.44 green:0.44 blue:0.45 alpha:1];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setIsRemind:(BOOL)isRemind{
    if (isRemind && _remindNum == 0) {
        _remindImage=[[UIImageView alloc] initWithFrame:CGRectMake(55, 5, 8, 8)];
        _remindImage.image=[UIImage imageNamed:@"remind.png"];
        _remindImage.backgroundColor=[UIColor clearColor];
        _remindImage.alpha = 1;
        [self addSubview:_remindImage];
        [self bringSubviewToFront:_remindImage];
    }
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    UIImage *imagescale = [self scaleToSize:image size:CGSizeMake(50, 50)];
    [super setImage:imagescale forState:state];
}
-(UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
