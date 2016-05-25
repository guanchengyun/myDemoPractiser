//
//  MatchingBeSenderVC.h
//  数字健身
//
//  Created by 城云 官 on 14-5-9.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonmMatching.h"

@protocol MatchingBeSenderVCDelegate <NSObject>
-(void)MatchingBeSenderString:(NSString *)string;
@end

@interface MatchingBeSenderVC : UIViewController

@property(strong, nonatomic)NSDictionary *DictionaryGet;
@property(copy, nonatomic)NSString *CIN_ID;
@property(weak, nonatomic)ButtonmMatching *buttonMatching;
@property(weak, nonatomic)id<MatchingBeSenderVCDelegate> delegate;
@end
