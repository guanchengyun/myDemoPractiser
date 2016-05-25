//
//  InbodyTestVC.m
//  数字健身
//
//  Created by 城云 官 on 14-5-13.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "InbodyTestVC.h"
typedef NS_ENUM(NSInteger, MyCollectionType){
    CollectionTypeState = 0,
    CollectionTypeContrast = 1,
    CollectionTypeDelete = 2
};
@interface InbodyTestVC ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (strong, nonatomic)NSMutableArray *CollectData;
@property (strong, nonatomic)NSMutableArray *CollectDataContrast;
@property (assign, nonatomic)MyCollectionType myCollectionType;
@property (weak, nonatomic) IBOutlet UIToolbar *MyToolBar;
@property (strong, nonatomic)UIBarButtonItem *barItemSend;
@property (strong, nonatomic)UIButton *ButtonItemSend;
@end

@implementation InbodyTestVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _CollectData = [[NSMutableArray alloc]initWithArray:@[@"2014-06-09",@"2014-06-10",@"2014-06-11",@"2014-06-12",@"2014-06-13",@"2014-06-14",@"2014-06-15",@"2014-06-16",@"2014-06-17",@"2014-06-16",@"2014-06-16",@"2014-06-16",@"2014-06-16",@"2014-06-16",@"2014-06-25",@"2014-06-26",@"2014-06-16",@"2014-06-16",@"2014-06-16",@"2014-06-16",@"2014-06-18",@"2014-06-09",@"2014-06-10",@"2014-06-11",@"2014-06-12",@"2014-06-13",@"2014-06-14",@"2014-06-15",@"2014-06-16",@"2014-06-17",@"2014-06-16",@"2014-06-16",@"2014-06-16",@"2014-06-16",@"2014-06-16",@"2014-06-25",@"2014-06-26",@"2014-06-16",@"2014-06-16",@"2014-06-16",@"2014-06-16",@"2014-06-18"]];
    [self initToolBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.CollectData count]+1;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CollectCell" forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    UILabel *label = (UILabel *)[cell viewWithTag:102];
    
    if (indexPath.row == 0) {
        imageView.image = [UIImage imageNamed:@"inbodyAdd.png"];
        label.hidden = YES;
    }else{
        label.text = self.CollectData[indexPath.row-1];
        imageView.image = [InbodyTestVC ImageInbody];
        label.hidden = NO;
    }
    
    
    if (_myCollectionType == CollectionTypeContrast) {
        UIButton *button = (UIButton *)[cell viewWithTag:101];
        if (indexPath.row != 0) {
            [button setBackgroundImage:[UIImage imageNamed:@"RYAssetsPicker.bundle/check_no.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"RYAssetsPicker.bundle/check.png"] forState:UIControlStateSelected];
            button.hidden = NO;
            button.enabled = YES;
        }else{
            button.hidden = YES;
            button.enabled = NO;
            button.selected = NO;
        }
        
    }else if(_myCollectionType == CollectionTypeDelete){
        UIButton *button = (UIButton *)[cell viewWithTag:101];
        if (indexPath.row != 0) {
            button.hidden = NO;
            button.enabled = YES;
            button.selected = NO;
            [button setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(DeleteClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            button.hidden = YES;
            button.enabled = NO;
            button.selected = NO;
            
        }
        
    }else{
        
        UIButton *button = (UIButton *)[cell viewWithTag:101];
        button.hidden = YES;
        button.selected = NO;
        button.enabled = NO;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.myCollectionType) {
        case CollectionTypeState:
            if (indexPath.row == 0) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图片对比",@"图片删除", nil];
                //        [actionSheet showInView:self.view];
                [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
                [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
                actionSheet.autoresizesSubviews = YES;
                //        RYAssetsPickerController * rpc = [[RYAssetsPickerController alloc]initPhotosPicker];
                //        [self presentViewController:rpc animated:YES completion:nil];
            }else{
//                [self.splitViewController presentViewController:nav animated:YES completion:nil];
                [self performSegueWithIdentifier:@"ToInbodyDetailTBVC" sender:nil];
            }
            
            break;
        case CollectionTypeContrast:
        {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIButton *button = (UIButton *)[cell viewWithTag:101];
            button.selected = !button.selected;
            if (button.selected == YES) {
                [self.CollectDataContrast addObject:self.CollectData[indexPath.row]];
            }else{
                if ([self.CollectDataContrast containsObject:self.CollectData[indexPath.row]]) {
                    [self.CollectDataContrast removeObject:self.CollectData[indexPath.row]];
                }
            }
            
            if (self.CollectDataContrast.count>1) {
                self.barItemSend.enabled = YES;
            }else{
                self.barItemSend.enabled = NO;
            }
        }
            break;
        case CollectionTypeDelete:
            
            break;
            
            
        default:
            break;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

//- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath{
//
//}

#pragma mark -----UIActionSheet Delegate--------

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //    NSLog(@"buttonIndex::%ld",(long)buttonIndex);
    if(buttonIndex == 0){
        // 图片对比
        [self setCollectType:CollectionTypeContrast];
    }else if(buttonIndex == 1){
        // 图片删除
        [self setCollectType:CollectionTypeDelete];
    }
    
}

-(void)setCollectType:(MyCollectionType )CollectionType{
    if (self.myCollectionType == CollectionType) {
        return;
    }
    self.myCollectionType = CollectionType;
    // 图片对比
    switch (CollectionType) {
        case CollectionTypeState:
            break;
        case CollectionTypeContrast:
            self.MyToolBar.hidden = NO;
            self.ButtonItemSend.hidden = NO;
            break;
        case CollectionTypeDelete:
            self.MyToolBar.hidden = NO;
            self.ButtonItemSend.hidden = YES;
            break;
            
        default:
            break;
    }
    [self.CollectionView reloadData];
}

-(void)initToolBar{
    //toolbar设置 预览
    self.MyToolBar.translucent=YES;
    self.navigationController.toolbar.alpha=0.6;
    [self.MyToolBar setBackgroundImage:[UIImage imageNamed:@"RYAssetsPicker.bundle/bar_background.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    UIButton *buttonPreview=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonPreview.titleLabel.font=[UIFont systemFontOfSize:12];
    buttonPreview.bounds=CGRectMake(0, 0, 50, 29);
    [buttonPreview setTitle:@"取消" forState:UIControlStateNormal];
    [buttonPreview setBackgroundImage:[UIImage imageNamed:@"RYAssetsPicker.bundle/cancel.png"] forState:UIControlStateNormal];
    [buttonPreview setBackgroundImage:[UIImage imageNamed:@"RYAssetsPicker.bundle/cancel_highlighted.png"] forState:UIControlStateHighlighted];
    [buttonPreview addTarget:self action:@selector(CancelAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barItemPreview=[[UIBarButtonItem alloc]initWithCustomView:buttonPreview];
    
    //toolbar设置 发送
    UIButton *buttonSend=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonSend.titleLabel.font=[UIFont systemFontOfSize:12];
    buttonSend.bounds=CGRectMake(0, 0, 50, 29);
    [buttonSend setTitle:@"确定" forState:UIControlStateNormal];
    [buttonSend setBackgroundImage:[UIImage imageNamed:@"RYAssetsPicker.bundle/send.png"] forState:UIControlStateNormal];
    [buttonSend setBackgroundImage:[UIImage imageNamed:@"RYAssetsPicker.bundle/send_highlighted.png"] forState:UIControlStateHighlighted];
    [buttonSend addTarget:self action:@selector(ContrastAction) forControlEvents:UIControlEventTouchUpInside];
    self.ButtonItemSend = buttonSend;
    self.barItemSend=[[UIBarButtonItem alloc]initWithCustomView:buttonSend];
    _barItemSend.enabled=NO;
    
    UIBarButtonItem * space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.MyToolBar.items=@[barItemPreview,space,_barItemSend];
}

-(void)CancelAction{
    self.MyToolBar.hidden = YES;
    self.CollectDataContrast = nil;
    [self setCollectType:CollectionTypeState];
}

-(void)ContrastAction{
    if (self.CollectDataContrast.count>1) {
        
    }
    
}

#pragma mark deletCell
-(IBAction)DeleteClickEvent:(id)sender event:(id)event{
    if (self.myCollectionType == CollectionTypeDelete) {
        
        NSSet *touches = [event allTouches];
        
        UITouch *touch = [touches anyObject];
        
        CGPoint currentTouchPosition = [touch locationInView:_CollectionView];
        
        NSIndexPath *indexPath = [_CollectionView indexPathForItemAtPoint: currentTouchPosition];
        
		[self.CollectData removeObjectAtIndex:indexPath.item];
        [self.CollectionView performBatchUpdates:^{
            [self.CollectionView
             deleteItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    }
}


#pragma mark – UICollectionViewDelegateFlowLayout
// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize retval = CGSizeMake(113, 113);
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}


+(UIImage *)ImageInbody{
    static UIImage *imageinbody = nil;
    if (!imageinbody) {
        imageinbody = [UIImage imageNamed:@"inbodyImage.png"];
    }
    return imageinbody;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
