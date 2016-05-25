//
//  AFClient.m
//  O了
//
//  Created by 化召鹏 on 14-1-26.
//  Copyright (c) 2014年 QYB. All rights reserved.
//

#import "AFClient.h"


@implementation AFClient
+ (AFClient *)sharedClient{
    static AFClient *_sharedClient = nil;
    NSString *AFBaseURLString=[NSString stringWithFormat:@"http://%@:%@/%@",HTTP_IP,HTTP_PORT,SOCKET_PORT];
    NSLog(@"AFBaseURLString::%@",AFBaseURLString);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient=[[AFClient alloc] initWithBaseURL:[NSURL URLWithString:AFBaseURLString]];
    });
    return _sharedClient;
}

+ (AFClient *)sharedCoachClient{
    static AFClient *_sharedClient = nil;
    NSString *AFBaseURLString=@"http://112.124.103.29:8088/GymBase.asmx";
//    NSLog(@"AFBaseURLString::%@",AFBaseURLString);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient=[[AFClient alloc] initWithBaseURL:[NSURL URLWithString:AFBaseURLString]];
    });
    return _sharedClient;
}


- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    
	[self setDefaultHeader:@"Accept" value:@"text/html"];
    
    return self;
}
@end
