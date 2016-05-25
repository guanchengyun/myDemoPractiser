//
//  MainViewController.h
//  数字健身
//
//  Created by 城云 官 on 14-3-27.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarButton.h"

@interface MainViewController : UIViewController<UINavigationControllerDelegate>
extern NSString *const MainViewControllerNotification;//保存密码

@property (strong,nonatomic)IBOutlet UIView *tabbarView;//TabBar视图

@property (nonatomic,strong) NSArray  *previousNavViewController;//导航控制器中的视图数组 就是第一个
@property (nonatomic,strong) NSArray  *viewControllers;//TabBar视图数组
@property (nonatomic,assign) NSInteger      seletedIndex;//TabBar被选中的索引
@property(nonatomic,assign)BOOL isHidenPan;//是否启用手势

@end
