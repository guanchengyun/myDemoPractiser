//
//  SelectTypeTrainingVC.h
//  数字健身
//
//  Created by 城云 官 on 14-6-19.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectTypeTrainingDelegate <NSObject>

@optional
-(void)pickerDidChaneStatus:(NSDictionary *)picker;

@end

@interface SelectTypeTrainingVC : UIViewController
@property(weak, nonatomic)NSArray *ArrayAerobic;
@property(weak, nonatomic)NSArray *arrayPower;

@property (assign, nonatomic) id <SelectTypeTrainingDelegate> delegate;
@end
