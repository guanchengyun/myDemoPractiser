//
//  PhotoCollectVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-24.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "PhotoCollectVC.h"
#import "DatabaseManagerWork.h"
#import "FMDatabase.h"
#import "FitnessTestList.h"
#import "PhotoCollectVC.h"
#import "PhotoSeletCollectCell.h"
#import "MBProgressHUD.h"

NSString * const PhotoSeletCell = @"PhotoSeletCell";
@interface PhotoCollectVC ()
@property (strong, nonatomic)NSMutableArray *CollectData;
@property (strong, nonatomic)NSMutableDictionary *SeletDict;
@property (strong, nonatomic)DatabaseManagerWork *dataworf;
@property (strong, nonatomic)UICollectionViewFlowLayout *myCollectLayout;
@end

@implementation PhotoCollectVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self.myCollectLayout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithCollectionViewLayout:self.myCollectLayout];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataworf = [DatabaseManagerWork sharedInstanse];
    [self.collectionView registerClass:PhotoSeletCollectCell.class forCellWithReuseIdentifier:PhotoSeletCell];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarAction)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarAction)];
    self.SeletDict = [[NSMutableDictionary alloc]init];
}

-(NSMutableArray *)CollectData{
    if (_CollectData == nil) {
        [_dataworf open];
        [_dataworf.dataQueue inDatabase:^(FMDatabase *db) {
            NSString * querySql =[NSString stringWithFormat:@"SELECT * FROM FitnessTestList"];
            NSMutableArray *mutArr = [[NSMutableArray alloc]init];;
            FMResultSet *rs = [_dataworf.db executeQuery:querySql];
            while ([rs next]){
                FitnessTestList *fitlist = [[FitnessTestList alloc]init];
                fitlist._id = [rs intForColumn:@"id"];
                fitlist.name = [rs stringForColumn:@"name"];
                fitlist.type = [rs stringForColumn:@"type"];
                fitlist.filePath = [rs stringForColumn:@"filePath"];
                fitlist.httpPath = [rs stringForColumn:@"httpPath"];
                [mutArr addObject:fitlist];
            }
            [rs close];
            _CollectData = mutArr;
        }];
        [_dataworf close];
    }
    
    return _CollectData;
}

-(void)leftBarAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarAction{
//    NSLog(@"self.SeletDict：：%d",self.SeletDict.count);
    if (self.SeletDict.count > 0) {
        NSMutableArray *arrayMut = [[NSMutableArray alloc]initWithArray:self.SeletDict.allKeys];
        [arrayMut insertObject:self.FitnesList atIndex:0];
        
        
    }else{
        MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        progressHUD.mode=MBProgressHUDModeText;
        progressHUD.margin = 10.f;
        progressHUD.yOffset = 150.f;
        progressHUD.alpha=0.75;
        progressHUD.labelText=@"请选择图片";
        progressHUD.removeFromSuperViewOnHide = YES;
        [progressHUD hide:YES afterDelay:2];
    }
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.CollectData count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoSeletCollectCell *cell = [cv dequeueReusableCellWithReuseIdentifier:PhotoSeletCell forIndexPath:indexPath];
  
    FitnessTestList *fitlist = self.CollectData[indexPath.row];
    if ([fitlist.type isEqualToString:@"name"]) {
        cell.imageView.image = [UIImage imageNamed:fitlist.name];
    }else if([fitlist.type isEqualToString:@"filePath"]){
        cell.imageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",fitlist.filePath,fitlist.name]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoSeletCollectCell *cell = (PhotoSeletCollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.button.selected == NO) {
        if (self.SeletDict.count > 5) {
            MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            progressHUD.mode=MBProgressHUDModeText;
            progressHUD.margin = 10.f;
            progressHUD.yOffset = 150.f;
            progressHUD.alpha=0.75;
            progressHUD.labelText=@"你最多只能选择6个图片";
            progressHUD.removeFromSuperViewOnHide = YES;
            [progressHUD hide:YES afterDelay:2];
            return;
        }
    }
    cell.button.selected = !cell.button.selected;
     NSNumber *number = [NSNumber numberWithInteger:indexPath.row];
    if (cell.button.selected == YES) {
       
        [self.SeletDict setObject:self.CollectData[indexPath.row] forKey:number];
    }else{
        if (self.SeletDict[number]) {
            [self.SeletDict removeObjectForKey:number];
        }
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
