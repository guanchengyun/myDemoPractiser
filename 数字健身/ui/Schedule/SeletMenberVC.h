//
//  SeletMenberVC.h
//  数字健身
//
//  Created by 城云 官 on 14-6-10.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "MenberVC.h"
#import "ListMenber.h"

@protocol SeletMenberVCDelegate <NSObject>

-(void)GetMenberID:(ListMenber *)menber;

@end

@interface SeletMenberVC : MenberVC

@property(weak, nonatomic) id<SeletMenberVCDelegate>delegate;
@end
