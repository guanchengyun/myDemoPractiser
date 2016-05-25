//
//  AddMenberDataVC.h
//  数字健身
//
//  Created by 城云 官 on 14-4-15.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListMenber.h"

@protocol AddMenberDataVCDelegate <NSObject>
-(void)SaveTiele:(NSString *)title Contact:(NSString *)contact;
-(void)Delete:(NSInteger)cellRow;
@end

@interface AddMenberDataVC : UITableViewController

@property(weak , nonatomic)ListMenber *listerMenber;

@property(assign, nonatomic) NSInteger CellRow;
@property(weak, nonatomic)NSString *TitleStr;
@property(weak, nonatomic)NSString *ContactStr;
@property(weak, nonatomic) id<AddMenberDataVCDelegate>delegate;
@end
