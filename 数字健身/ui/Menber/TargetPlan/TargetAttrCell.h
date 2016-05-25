//
//  TargetAttrCell.h
//  数字健身
//
//  Created by 城云 官 on 14-6-4.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargetAttrCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UIButton *BtnBool;
@property (weak, nonatomic) IBOutlet UILabel *LabelContent;
@property (weak, nonatomic) IBOutlet UILabel *LabelDetailContent;

@end
