//
//  CoachCirleRoot.h
//  数字健身
//
//  Created by 城云 官 on 14-4-16.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List_Circle.h"

@protocol CoachCircleRootDelegate <NSObject>

@required
-(void)selectedCoachCirleMonster:(List_Circle *)newCoachdata;

@end
@interface CoachCirleRoot : UIViewController
@property (weak, nonatomic)id<CoachCircleRootDelegate>delegate;
@end
