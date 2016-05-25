//
//  RYAssetsBrowerViewController.h
//  O了
//
//  Created by 卢鹏达 on 14-1-22.
//  Copyright (c) 2014年 roya. All rights reserved.
//
#define TAG_START 200   //默认开始tag
#define TAG_DELEGATE 199    //是否触发委托的tag标记
#import <UIKit/UIKit.h>
#import "RYAssetSelectionDelegate.h"

@interface RYAssetsBrowerViewController : UIViewController{
    UIScrollView *_scrollView;
    UIButton *_buttonOriginal;  ///<原图按钮
    UIButton *_buttonSend;      ///<发送按钮
    UIButton *_buttonSelect;    ///<选择按钮
    
    BOOL _original;             ///<YES发送原图，NO不发送
    BOOL _scrollFlag;           ///<是否执行滚动
    CGFloat _beginDraggingContentOffsetX;  ///<开始拖拽的X坐标
}

@property(nonatomic,assign) long long originalSize;
@property(nonatomic,weak) id<RYAssetSelectionDelegate> parent;
///浏览资源列表
@property(nonatomic,strong) NSArray *arrayAsset;
///当前显示索引
@property(nonatomic,assign) NSInteger currentIndex;
///资源数量
@property(nonatomic,assign) NSInteger selectCount;
///确定按钮的标题
@property(nonatomic,strong) NSString *titleButtonSure;

- (void)createScrollView:(UIScrollView *)scrollView withFrame:(CGRect)frame withSVIndex:(NSInteger)svIndex withAssetIndex:(NSInteger)assetIndex;
@end
