//
//  AssetsCell.h
//  O了
//
//  Created by 卢鹏达 on 14-1-17.
//  Copyright (c) 2014年 roya. All rights reserved.
//

#define IMAGE_SIZE 76    //图片高宽
#define CELL_SPACE_DISTANCE 2  //Cell间距
#define ASSETS_CHECK_TAG 222    //选中资源标记的tag
#import <UIKit/UIKit.h>
@class RYAsset;

@interface RYAssetsCell : UITableViewCell

@property(nonatomic,assign,readonly) NSInteger columnsCount;

@property(nonatomic,strong) NSArray *arrayRowAssets;

@property(nonatomic,copy) void (^blockPreview)(RYAsset *ryAsset);

@end
