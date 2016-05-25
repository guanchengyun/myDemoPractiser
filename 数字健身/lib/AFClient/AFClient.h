//
//  AFClient.h
//  O了
//
//  Created by 化召鹏 on 14-1-26.
//  Copyright (c) 2014年 QYB. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface AFClient : AFHTTPClient
+ (AFClient *)sharedClient;
+ (AFClient *)sharedCoachClient;
@end
