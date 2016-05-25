//
//  ButtonmMatching.m
//  数字健身
//
//  Created by 城云 官 on 14-5-9.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "ButtonmMatching.h"
#import "UIButton+Bootstrap.h"


@implementation ButtonmMatching

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.viewLine = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.origin.x , 0, 1,self.bounds.size.height)];
        self.viewLine.backgroundColor = [UIColor lightGrayColor];
//        self.viewLine.autoresizesSubviews = YES;
//        self.viewLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.viewLine];
        self.contentMode =UIViewContentModeScaleAspectFit;
//        self.myimageview = [[UIImageView alloc]initWithFrame:self.bounds];
//        [self addSubview:self.myimageview];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    if (self.bounds.origin.x !=0) {
//            self.viewLine.frame = CGRectMake(self.bounds.origin.x , 0, 1,self.bounds.size.height);
//    }
//    CGRect frame = self.bounds;
//    if (frame.size.width !=96) {
////        frame.size.width = 96;
////        frame.size.height = 96;
////        btnMath.frame = frame;
//        NSLog(@"%@",NSStringFromCGRect(self.bounds));
//    }
    
//    CGRect frame = self.bounds;
//    if ((frame.size.width < 128)&&(frame.size.height <128)) {
//        frame.size.width = 96;
//        frame.size.height = 96;
//        frame.origin.x = 0;
//        frame.origin.y = 0;
//        self.bounds = frame;
//    }
    self.myimageview.frame = self.bounds;
    self.viewLine.frame = CGRectMake(self.bounds.origin.x, 0, 1,self.bounds.size.height);
}

-(void)setButtonType:(MatchingButtonType)ButtonType{
//     [self setBackgroundImage:[ButtonmMatching imagebutton] forState:UIControlStateNormal];

   
//    if (_ButtonType!=ButtonType) {
        _ButtonType = ButtonType;
        switch (ButtonType) {
            case TypeMatchingNone:
//                self.backgroundColor = [UIColor whiteColor];
//                [self.myimageview setImage:[ButtonmMatching TypeMatchingNoneImage]];
                [self setBackgroundImage:[ButtonmMatching TypeMatchingNoneImage] forState:UIControlStateNormal];
                break;
            case TypeMatchingAgreed://同意
//                [self.myimageview setImage:[ButtonmMatching TypeMatchingSuccessfulImage]];
                 [self setBackgroundImage:[ButtonmMatching TypeMatchingSuccessfulImage] forState:UIControlStateNormal];
                break;
                
            case TypeMatchingRefused://拒绝
//                [self.myimageview setImage:[ButtonmMatching TypeMatchingFailureImage]];
                 [self setBackgroundImage:[ButtonmMatching TypeMatchingNoneImage] forState:UIControlStateNormal];
                break;
            case TypeMatchingModify://修改
//                 [self.myimageview setImage:[ButtonmMatching TypeMatchingNoneImage]];
                 [self setBackgroundImage:[ButtonmMatching TypeMatchingNoneImage] forState:UIControlStateNormal];
                break;
            case TypeMatchingCancel://取消
//                [self.myimageview setImage:[ButtonmMatching TypeMatchingNoneImage]];
                [self setBackgroundImage:[ButtonmMatching TypeMatchingNoneImage] forState:UIControlStateNormal];
                break;
            case TypeMatchingComplete://完成
            {
//                [self.myimageview setImage:[ButtonmMatching TypeMatchingCompleteImage]];
                [self setBackgroundImage:[ButtonmMatching TypeMatchingCompleteImage] forState:UIControlStateNormal];
//                [self setBackgroundColor:[UIColor grayColor]];
            }
                break;
            case TypeMatchingOverdue://过期
//                [self.myimageview setImage:[ButtonmMatching TypeMatchingNoneImage]];
                [self setBackgroundImage:[ButtonmMatching TypeMatchingNoneImage] forState:UIControlStateNormal];
                break;
            case TypeMatchingTakeUp://被其他会员占用
//                [self.myimageview setImage:[ButtonmMatching TypeMatchingFailureImage]];
                [self setBackgroundImage:[ButtonmMatching TypeMatchingFailureImage] forState:UIControlStateNormal];
                break;
            case TypeMatchingInitiate://发起
            {
//                [self.myimageview setImage:[ButtonmMatching TypeMatchingBeSenderImage]];
                if ([self.contrectlistbycoach.type_Contrac isEqualToString:@"团课"]){
                   [self setBackgroundImage:[ButtonmMatching TypeMatchingBeSenderGroupImage] forState:UIControlStateNormal];
                }else{
                   [self setBackgroundImage:[ButtonmMatching TypeMatchingBeSenderImage] forState:UIControlStateNormal];
                }
            }
                break;
            default:
//                [self.myimageview setImage:[ButtonmMatching TypeMatchingNoneImage]];
                [self setBackgroundImage:[ButtonmMatching TypeMatchingNoneImage] forState:UIControlStateNormal];
        }
//    }
//    [self setBackgroundImage:[ButtonmMatching TypeMatchingFailureImage] forState:UIControlStateNormal];
//    [self setBackgroundColor:[UIColor redColor]];
}

+(UIImage *)TypeMatchingNoneImage{
    static UIImage *MatchingNoneImage = nil;
    if (!MatchingNoneImage) {
        MatchingNoneImage = [UIImage imageNamed:@"TypeMatchingNoneImage.png"];
    }
    return MatchingNoneImage;
}

+(UIImage *)TypeMatchingCompleteImage{
    static UIImage *MatchingCompleteImage = nil;
    if (!MatchingCompleteImage) {
        MatchingCompleteImage = [UIImage imageNamed:@"TypeMatchingCompleteImage96.png"];
    }
    return MatchingCompleteImage;
}

+(UIImage *)TypeMatchingBeSenderImage{
    static UIImage *MatchingBeSenderImage = nil;
    if (!MatchingBeSenderImage) {
        MatchingBeSenderImage = [UIImage imageNamed:@"TypeMatchingBeSenderImage96.png"];
    }
    return MatchingBeSenderImage;
}

+(UIImage *)TypeMatchingBeSenderGroupImage{
    static UIImage *MatchingBeSenderGroupImage = nil;
    if (!MatchingBeSenderGroupImage) {
        MatchingBeSenderGroupImage = [UIImage imageNamed:@"TypeMatchingBeSenderGroupImage96.png"];
    }
    return MatchingBeSenderGroupImage;
}

+(UIImage *)TypeMatchingFailureImage{
    static UIImage *MatchingFailureImage = nil;
    if (!MatchingFailureImage) {
        MatchingFailureImage = [[UIImage imageNamed:@"TypeMatchingFailureImage96.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];;
    }
    return MatchingFailureImage;
}

+(UIImage *)TypeMatchingSuccessfulImage{
    static UIImage *MatchingSuccessfulImage = nil;
    if (!MatchingSuccessfulImage) {
        MatchingSuccessfulImage = [UIImage imageNamed:@"TypeMatchingSuccessfulImage96.png"];
    }
    return MatchingSuccessfulImage;
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
