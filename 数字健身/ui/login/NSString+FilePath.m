//
//  NSString+FilePath.m
//  O了
//
//  Created by 卢鹏达 on 14-1-23.
//  Copyright (c) 2014年 QYB. All rights reserved.
//

#import "NSString+FilePath.h"

@implementation NSString (FilePath)
#pragma mark 获取项目沙盒中Documents所在路径
- (NSString *)filePathOfDocuments
{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    path=[path stringByAppendingPathComponent:self];
    return path;
}
#pragma mark 获取项目沙盒中Caches所在路径
- (NSString *)filePathOfCaches
{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    path=[path stringByAppendingPathComponent:self];
    return path;
}
#pragma mark 获取项目沙盒中Library所在路径
- (NSString *)filePathOfLibrary
{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject];
    path=[path stringByAppendingPathComponent:self];
    return path;
}
#pragma mark 获取项目沙盒中Tmp所在路径
- (NSString *)filePathOfTmp
{
    NSString *path=NSTemporaryDirectory();
    path=[path stringByAppendingPathComponent:self];
    return path;
}
@end
