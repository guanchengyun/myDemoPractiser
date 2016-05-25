//
//  FitnessTestVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-17.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "FitnessTestVC.h"
#import "NSString+FilePath.h"
#import "DatabaseManagerWork.h"
#import "FMDatabase.h"
#import "FitnessTestList.h"
#import "PhotoShow.h"
#import "RYAssetsPickerController.h"
#import "PhotoContrast.h"
#import "LandscapeNavigation.h"
#import "AFClient.h"
#import "NSData+Base64.h"
typedef NS_ENUM(NSInteger, MyCollectionType){
    CollectionTypeState = 0,
    CollectionTypeContrast = 1,
    CollectionTypeDelete = 2
};

@interface FitnessTestVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,RYAssetsPickerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>{
    DatabaseManagerWork *dataworf;
}
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (strong, nonatomic)NSMutableArray *CollectData;
@property (strong, nonatomic)NSMutableArray *CollectDataContrast;
@property (assign, nonatomic)MyCollectionType myCollectionType;
@property (weak, nonatomic) IBOutlet UIToolbar *MyToolBar;
@property (strong, nonatomic)UIBarButtonItem *barItemSend;
@property (strong, nonatomic)UIButton *ButtonItemSend;
@property (weak, nonatomic) IBOutlet UINavigationBar *naviItem;
@end

@implementation FitnessTestVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSMutableArray *)CollectDataContrast{
    if (_CollectDataContrast == nil) {
        _CollectDataContrast = [[NSMutableArray alloc]init];
    }
    return _CollectDataContrast;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myCollectionType = CollectionTypeState;
//    写入数据库
    dataworf = [DatabaseManagerWork sharedInstanse];
    [dataworf open];
    NSMutableArray *mutarr = [NSMutableArray array];
    for (int i=0; i < 20; i++) {
      
            int a = i%8;
            NSDictionary *dic = @{
                                  @"type": @"name",
                                  @"name": [NSString stringWithFormat:@"inbody%d.png",a+1],
                                   @"id": [NSString stringWithFormat:@"inbody%d.png",a+1]
                                  };
            
            [mutarr addObject:dic];
                //            [self.CollectData addObject:[NSString stringWithFormat:@"inbody%d.png",a+1]];
        
    }
    [dataworf InsertToTable:@"FitnessTestList" dataArray:mutarr];
    [dataworf close];
    [self initToolBar];
    
//    [self saveImage:image Data:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)CollectData{
    if (_CollectData == nil) {
        [dataworf open];
        [dataworf.dataQueue inDatabase:^(FMDatabase *db) {
            NSString * querySql =[NSString stringWithFormat:@"SELECT * FROM FitnessTestList"];
            FitnessTestList *fitlister = [[FitnessTestList alloc]init];
            
            fitlister.name = @"inbodyAdd.png";
            fitlister.type = @"name";


            NSMutableArray *mutArr = [[NSMutableArray alloc]initWithObjects:fitlister, nil];;
            FMResultSet *rs = [dataworf.db executeQuery:querySql];
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
         [dataworf close];
        }

    return _CollectData;
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
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CollectCell" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
//    NSURL *url = [NSURL URLWithString:];
//    [imageView setImageWithURL:url];
    FitnessTestList *fitlist = self.CollectData[indexPath.row];
    if ([fitlist.type isEqualToString:@"name"]) {
        imageView.image = [UIImage imageNamed:fitlist.name];
    }else if([fitlist.type isEqualToString:@"filePath"]){
        imageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",fitlist.filePath,fitlist.name]];
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
        case 0:
            if (indexPath.row == 0) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"添加本地图片",@"图片对比",@"图片删除", nil];
                //        [actionSheet showInView:self.view];
                [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
                [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
                actionSheet.autoresizesSubviews = YES;
                //        RYAssetsPickerController * rpc = [[RYAssetsPickerController alloc]initPhotosPicker];
                //        [self presentViewController:rpc animated:YES completion:nil];
            }else{
                //        [self performSegueWithIdentifier:@"ToPhotoViewController" sender:[self.CollectData objectAtIndex:indexPath.row]];
                
                PhotoShow *photo = [[PhotoShow alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:photo];
                photo.FitnesList = [self.CollectData objectAtIndex:indexPath.row];
                //        [self presentViewController:nav animated:YES completion:nil];
                //        [self.navigationController pushViewController:photo animated:YES];
                [self.splitViewController presentViewController:nav animated:YES completion:nil];
            }

            break;
        case 1:
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
        case 2:
            
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

//-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
////    NSLog(@"toInterfaceOrientation::%ld",toInterfaceOrientation);
//}

#pragma mark ------ZYQAssetPickerControllerDelegate----

-(void)assetsPicker:(RYAssetsPickerController *)assetsPicker didFinishPickingMediaWithInfo:(NSArray *)info{
    for (int i=0; i<info.count; i++) {
        NSDictionary *dic=[info objectAtIndex:i];
        NSData *imageData=UIImageJPEGRepresentation(dic[AssetsPickerImageOriginal], 0.1);
        
        if (imageData) {
            [self saveImage:nil Data:imageData];
        }
        
    }
    [self.CollectionView reloadData];
}


#pragma mark =========UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self saveImage:image Data:nil];
    [self.CollectionView reloadData];
}

- (void)saveImage:(UIImage *)tempImage Data:(NSData *)ImageData
{
    NSData* imageData;
    if (ImageData) {
        imageData = ImageData;
    }else{
        imageData = UIImageJPEGRepresentation(tempImage,0.1);//UIImagePNGRepresentation(tempImage);
    }
    
    //指定文件保存路径
    NSString *ImagePath=[@"/FitnessTestVCImages" filePathOfCaches];
    //图片名字
//    NSString *dataName=[NSString stringWithFormat:@"%@.png",[self getTimeNow]];
//
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
   NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    NSString *dataName=[NSString stringWithFormat:@"%@.jpg",cfuuidString];
    
    NSString *newFilePath=[NSString stringWithFormat:@"%@/%@",ImagePath,dataName];
    
    //判断文件夹是否存在，不存在着创建一个文件夹
    NSString *fileDictionary = [newFilePath stringByDeletingLastPathComponent];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fileDictionary]) {
        [fileManager createDirectoryAtPath:fileDictionary withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *base64Encoded=nil;
    if (IS_IOS_7) {
        base64Encoded = [imageData base64EncodedStringWithOptions:0];
    }else{
        base64Encoded = [imageData base64EncodingCate];
    }
   
    NSDictionary *dicPara = @{@"fileName": dataName,
                              @"fileBytes":base64Encoded
                              };
    [[AFClient sharedCoachClient]postPath:@"UploadFile" parameters:dicPara success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
//            NSLog(@"resultDict::%@",resultDict);
        }
        if (0) {
            NSMutableArray *mutarr = [[NSMutableArray alloc]init];
            if ([imageData writeToFile:newFilePath atomically:YES]) {
                
                
                //        NSString *path=[NSString stringWithFormat:@"/FitnessTestVCImages/%@",dataName];
                //
                //        NSDictionary *assetsDict = [NSDictionary dictionaryWithObjectsAndKeys:@"filePath",@"type",dataName,@"name",[path filePathOfCaches],@"filePath",nil];
                NSDictionary *dic = @{@"name": dataName,
                                      @"filePath":fileDictionary,
                                      @"id":dataName,
                                      @"type":@"filePath",
                                      };
                
                [mutarr addObject:dic];
                //        [self.CollectData addObject:assetsDict];
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"写入文件失败\n请重新尝试操作!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            NSLog(@"dataName::%@",mutarr);
            [dataworf open];
            [dataworf InsertToTable:@"FitnessTestList" dataArray:mutarr];
            [dataworf close];
            _CollectData = nil;

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error::%@",error);
    }];
    
//    NSData *imageData=UIImageJPEGRepresentation(tempImage, 1);
     // and then we write it out
//    [imageData writeToFile:ImaePath atomically:NO];
}

#pragma mark -----UIActionSheet Delegate--------

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
//    NSLog(@"buttonIndex::%ld",(long)buttonIndex);
    if (buttonIndex == 0) {
        self.myCollectionType = CollectionTypeState;
        //       选择拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //从摄像头获取图片
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"照相机不可用" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alertView show];
        }
        
    }else if(buttonIndex == 1){
        //        本地取照片
        self.myCollectionType = CollectionTypeState;
        RYAssetsPickerController *assetsVC = [[RYAssetsPickerController alloc]initPhotosPicker];
        
        assetsVC.titleButtonSure = @"确定";
        assetsVC.delegate = self;
        assetsVC.maxSelectCount = 6;//最多可选择图片
        [self presentViewController:assetsVC animated:YES completion:NULL];
    }else if(buttonIndex == 2){
        // 图片对比
        [self setCollectType:CollectionTypeContrast];
    }else if(buttonIndex == 3){
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
    self.MyToolBar.items=@[barItemPreview,space,_barItemSend,_barItemSend];
}

-(void)CancelAction{
    self.MyToolBar.hidden = YES;
    self.CollectDataContrast = nil;
    [self setCollectType:CollectionTypeState];
}

-(void)ContrastAction{
    if (self.CollectDataContrast.count>1) {
        PhotoContrast *photocontrast = [[PhotoContrast alloc]init];
        photocontrast.images = self.CollectDataContrast;
        LandscapeNavigation *nav = [[LandscapeNavigation alloc]initWithRootViewController:photocontrast];
        [self.splitViewController presentViewController:nav animated:YES completion:nil];
        
    }
   
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"ToPhotoViewController"]) {
//        UINavigationController *navi = segue.destinationViewController;
//        PhotoViewController *vc = navi.viewControllers[0];
//        vc.FitnesList = sender;
    }
}


@end
