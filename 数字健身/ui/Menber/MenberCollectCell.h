//
//  MenberCollectCell.h
//  数字健身
//
//  Created by 城云 官 on 14-4-11.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MenberCollectCellDelegate <NSObject>
@optional
-(void)menssegeCell:(NSIndexPath *)indexPath Button:(UIButton *)button;
@end


@interface MenberCollectCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewMenber;
@property (weak, nonatomic) IBOutlet UIButton *Btn_Focus;
@property (weak, nonatomic) IBOutlet UILabel *Name_Menber;
@property (nonatomic, strong)NSIndexPath *IndexPathID;
@property (weak, nonatomic)id<MenberCollectCellDelegate> delegate;

-(void)reloadCollectCell;
@end
