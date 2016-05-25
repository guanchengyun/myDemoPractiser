//
//  PhotoCollectVC.h
//  数字健身
//
//  Created by 城云 官 on 14-4-24.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitnessTestList.h"
@protocol PhotoCollectVCDelegate <NSObject>
-(void)sendArray:(NSArray *)array;
@end
@interface PhotoCollectVC : UICollectionViewController

@property(weak, nonatomic)FitnessTestList *FitnesList;
@property(weak, nonatomic)id<PhotoCollectVCDelegate>delegate;
@end
