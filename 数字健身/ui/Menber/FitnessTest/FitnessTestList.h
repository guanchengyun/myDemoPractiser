//
//  FitnessTestList.h
//  数字健身
//
//  Created by 城云 官 on 14-4-22.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListMenber.h"

@interface FitnessTestList : NSObject
@property(weak , nonatomic)ListMenber *listerMenber;

@property(assign, nonatomic)NSInteger _id;
@property(copy, nonatomic)NSString *name;
@property(copy, nonatomic)NSString *type;
@property(copy, nonatomic)NSString *filePath;
@property(copy, nonatomic)NSString *httpPath;
@end
