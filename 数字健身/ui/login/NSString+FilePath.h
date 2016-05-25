//
//  NSString+FilePath.h
//  O了
//
//  Created by 卢鹏达 on 14-1-23.
//  Copyright (c) 2014年 QYB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FilePath)
/**
 *  获取项目沙盒中Documents所在路径
 *
 *  @return Documents路径
 */
- (NSString *)filePathOfDocuments;
/**
 *  获取项目沙盒中Caches所在路径
 *
 *  @return Caches路径
 */
- (NSString *)filePathOfCaches;
/**
 *  获取项目沙盒中Library所在路径
 *
 *  @return Library路径
 */
- (NSString *)filePathOfLibrary;
/**
 *  获取项目沙盒中Tmp所在路径
 *
 *  @return Tmp路径
 */
- (NSString *)filePathOfTmp;
@end
