//
//  AddTargetPlan.h
//  数字健身
//
//  Created by 城云 官 on 14-5-23.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListMenber.h"
#import "PiecewiseList.h"

typedef enum {
    AddTotalGoalMethod,//添加总目标
    ModifyTotalGoalMethod,//修改总目标
    AddPhaseMethod,//添加分段目标
    ModifyPhaseMethod//修改分段目标
}AddTarGetPlanMethod;

@protocol AddTargetPlanDelegate <NSObject>
-(void)GetHttpReturnID:(NSInteger)returnID ;
@end

@interface AddTargetPlan : UITableViewController

@property(strong, nonatomic)NSMutableArray *tagetListArr;
@property(weak , nonatomic)ListMenber *listerMenber;
@property(strong, nonatomic)NSString *ID;
@property(strong, nonatomic)NSString *target_id;
@property (assign, nonatomic) AddTarGetPlanMethod AddMetod;
@property (weak, nonatomic) NSMutableArray *Mutarr_targetPlanTableData;
@property (weak, nonatomic)PiecewiseList *PiecewList;//修改

@property(weak, nonatomic)id<AddTargetPlanDelegate>delegate;
@end
