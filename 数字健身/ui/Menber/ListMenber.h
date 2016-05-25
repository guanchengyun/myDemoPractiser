//
//  ListMenber.h
//  数字健身
//
//  Created by 城云 官 on 14-5-27.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListMenber : NSObject

@property(assign, nonatomic)NSInteger ID;
@property(assign, nonatomic)NSInteger rownum;
@property(copy, nonatomic)NSString *UI_CreateDate;
@property(copy, nonatomic)NSString *UI_Face;
@property(copy, nonatomic)NSString *UI_FirstName;

@property(assign, nonatomic)BOOL isFocus;

+(ListMenber *)initWithListmenber:(ListMenber *)listmenberinsert;
@end
