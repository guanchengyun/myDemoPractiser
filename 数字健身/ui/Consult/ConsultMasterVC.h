//
//  ConsultMasterVC.h
//  数字健身
//
//  Created by 城云 官 on 14-4-26.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ConsultMasterVCDelegate <NSObject>
@required
-(void)selectedContainVcWeb:(NSString *)urlString;
@end
@interface ConsultMasterVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *TopSeletView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) UIButton *seletedBtn;
@property (strong, nonatomic)NSMutableArray *TableViewDataLeft;
@property (strong, nonatomic)NSMutableArray *TableViewDataRight;
@property(weak, nonatomic)id<ConsultMasterVCDelegate>delegate;

@end
