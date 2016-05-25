//
//  ContractListByCoach.h
//  数字健身
//
//  Created by 城云 官 on 14-6-11.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContractListByCoach : NSObject

@property(copy,nonatomic)NSString *col_Contrac;
@property(copy,nonatomic)NSString *type_Contrac;

@property(copy,nonatomic)NSString *state_Contrac;//成功：购买记录（节）表中扣除未用节数、０发起1同意２拒绝３修改４取消５完成  (其它：6过期7被其他会员占用,手机上josh 0改为8)
@property(copy,nonatomic)NSString *id_Contrac;

@property(copy,nonatomic)NSString *start_Contrac;
@property(copy,nonatomic)NSString *end_Contrac;
@property(copy,nonatomic)NSString *createdate_Contrac;
@property(copy,nonatomic)NSString *userid_Contrac;
@end
