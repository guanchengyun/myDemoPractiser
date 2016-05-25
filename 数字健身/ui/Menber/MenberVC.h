//
//  MenberVC.h
//  数字健身
//
//  Created by 城云 官 on 14-3-28.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentClassFirstVC.h"
#import "ListMenber.h"

@interface MenberVC : ParentClassFirstVC

@property (weak, nonatomic) IBOutlet UIView *TopSeletView;
@property (weak, nonatomic) UIButton *seletedBtn;


-(ListMenber *)getListMenber:(NSInteger)index;
@end
