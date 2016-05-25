//
//  LoginViewController.h
//  数字健身
//
//  Created by 城云 官 on 14-3-24.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *popLoginView;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldUser;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldPass;
@property (weak, nonatomic) IBOutlet UIView *GrawBackGroundView;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic)CGPoint PopViewPoint;
@property (assign,nonatomic) BOOL KeyShow;

@property (nonatomic,copy) void (^blockEnterMain)(NSDictionary *info);
@end
