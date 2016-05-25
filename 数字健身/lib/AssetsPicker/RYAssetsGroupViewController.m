//
//  AssetsGroupViewController.m
//  O了
//
//  Created by 卢鹏达 on 14-1-17.
//  Copyright (c) 2014年 roya. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import "RYAssetsGroupViewController.h"
#import "RYAssetsViewController.h"
#import "RYAssetsPickerController.h"
#import "MBProgressHUD.h"

@interface RYAssetsGroupViewController (){
    ALAssetsLibrary *_assetsLibrary;    ///<资源库
    NSMutableArray *_arrayAssetsGroup;  ///<ALAssetsGroup列表
}

@end

@implementation RYAssetsGroupViewController
#pragma mark - 生命周期
#pragma mark 初始化
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}
#pragma mark 界面加载完成viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=self.parentViewController.title;
    //tableview
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //rightBarButtonItem设置 取消
//    UIButton *buttonRight=[UIButton buttonWithType:UIButtonTypeCustom];
//    buttonRight.titleLabel.font=[UIFont systemFontOfSize:15];
//    buttonRight.bounds=CGRectMake(0, 0, 50, 29);
//    [buttonRight setTitle:@"取消" forState:UIControlStateNormal];
//    [buttonRight setBackgroundImage:[UIImage imageNamed:@"RYAssetsPicker.bundle/cancel.png"] forState:UIControlStateNormal];
//    [buttonRight setBackgroundImage:[UIImage imageNamed:@"RYAssetsPicker.bundle/cancel_highlighted.png"] forState:UIControlStateHighlighted];
//    [buttonRight addTarget:self.parent action:@selector(exit:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barItemRight=[[UIBarButtonItem alloc]initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarAction)];
}

-(void)rightBarAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 界面将要显示viewWillAppear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}
#pragma mark 界面显示完成viewDidAppear
- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    //资源库初始化
    _arrayAssetsGroup=[[NSMutableArray alloc]init];
    _assetsLibrary=[[ALAssetsLibrary alloc]init];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            RYAssetsPickerController *assetsPicker=(RYAssetsPickerController *)self.parent;
            if (assetsPicker.AssetType==RYAssetsPickerAssetPhoto) {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            }
            if (assetsPicker.AssetType==RYAssetsPickerAssetVideo) {
                [group setAssetsFilter:[ALAssetsFilter allVideos]];
            }
            if ([group numberOfAssets]!=0) {
                [_arrayAssetsGroup addObject:group];
            }
        }else{
            [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"错误Error:%@",error);
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark 刷行界面
- (void)reloadTableView
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
	[self.tableView reloadData];
}
#pragma mark - tableView数据源及委托
#pragma mark 返回tableView的组数:section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark 返回组数所对应的行数:row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayAssetsGroup count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark 返回tableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    //资源列表Group
    ALAssetsGroup *group=(ALAssetsGroup *)_arrayAssetsGroup[indexPath.row];
    //资源列表Group摘要图
    cell.imageView.image=[UIImage imageWithCGImage:[group posterImage]];
    //资源列表Group名称
    cell.textLabel.text=[group valueForProperty:ALAssetsGroupPropertyName];
    //资源列表Group所包含的数量
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%ld",[group numberOfAssets]];
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    return cell;
}
#pragma mark 选中函数的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RYAssetsViewController *assets=[[RYAssetsViewController alloc]initWithStyle:UITableViewStylePlain];
    assets.assetsGroup=_arrayAssetsGroup[indexPath.row];
    assets.parent=self.parent;
    [self.navigationController pushViewController:assets animated:YES];
}

@end
