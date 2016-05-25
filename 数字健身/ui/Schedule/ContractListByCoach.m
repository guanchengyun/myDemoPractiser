//
//  ContractListByCoach.m
//  数字健身
//
//  Created by 城云 官 on 14-6-11.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "ContractListByCoach.h"

@implementation ContractListByCoach

-(NSString *)description{
    return [NSString stringWithFormat:@"<ContractListByCoach col_Contrac:%@ type_Contrac:%@ state_Contrac:%@, id_Contrac:%@, start_Contrac:%@ end_Contrac:%@ createdate_Contrac:%@ userid_Contrac:%@>",_col_Contrac,_type_Contrac,_state_Contrac,_id_Contrac,_start_Contrac,_end_Contrac,_createdate_Contrac,_userid_Contrac];
}
@end
