//
//  CoachDataCell.h
//  数字健身
//
//  Created by 城云 官 on 14-4-17.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoachDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ContactLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *CreatedateLabel;
//@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@end
