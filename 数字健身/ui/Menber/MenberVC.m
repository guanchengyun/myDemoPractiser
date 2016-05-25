//
//  MenberVC.m
//  数字健身
//
//  Created by 城云 官 on 14-3-28.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "MenberVC.h"
#import "MenberCollectCell.h"
#import "MenberMainControlSplitVC.h"
#import "UIImageView+AFNetworking.h"
#import "ListMenber.h"
#import "AFClient.h"
#import "MJRefresh.h"

typedef enum{
    TypeMenberPrivate = 1,//私教会员
    TypeMenberCommon,                    //普通会员
    TypeNoNenberPotential,         //潜在会员
    
}menberType;
@interface MenberVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MenberCollectCellDelegate>
@property(nonatomic, weak)IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic)NSMutableArray *array_menberPrivate;//私教会员
@property (strong, nonatomic)NSMutableArray *array_menberCommon;              //普通会员
@property (strong, nonatomic)NSMutableArray *array_menberPotential;         //潜在会员

@property (assign, nonatomic)menberType MyMenberType;

@property (strong, nonatomic)NSMutableArray *tableview_data;
@property (assign, nonatomic)NSInteger PageIndexPrivate;
@property (assign, nonatomic)NSInteger PageIndexCommon;
@property (assign, nonatomic)NSInteger PageIndexPotential;

@property (strong, nonatomic)MJRefreshHeaderView *header;
@property (strong, nonatomic)MJRefreshFooterView *footer;

@end

@implementation MenberVC
@synthesize array_menberPrivate = _array_menberPrivate;
@synthesize array_menberCommon = _array_menberCommon;
@synthesize array_menberPotential = _array_menberPotential;
@synthesize MyMenberType = _MyMenberType;

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"会员";
//    self.navigationController.delegate = self;
    [self.collectionView setAlwaysBounceVertical:YES];
    UIImage *image = [[UIImage imageNamed:@"MenberSeletImage.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    for (UIButton *btn in self.TopSeletView.subviews) {
        if (btn.selected == YES) {
            self.seletedBtn = btn;
        }
        [btn setBackgroundImage:image forState:UIControlStateSelected];
    }
    UIView *lineView_TopSeletView               = [[UIView alloc] initWithFrame:CGRectMake(15, 41.5, 499, 2.5)];
    lineView_TopSeletView.opaque             = YES;
    lineView_TopSeletView.backgroundColor    = [UIColor colorWithRed:186.0/255.0 green:186.0/255.0 blue:188.0/255.0 alpha:0.8];
    [_TopSeletView addSubview:lineView_TopSeletView];

    for (int x=0; x < 3; x++) {
        if (httpISON) {
            break;
        }
        NSMutableArray *mutArray = [[NSMutableArray alloc]init];
        int i;
        for (int y=0; y < 30; y++) {
             i= arc4random() % 4;
            NSString *str = [NSString stringWithFormat:@"Menber%d.png",i+1];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Focus",str,@"image",[NSString stringWithFormat:@"张%d峰",y],@"name", nil];
            [mutArray addObject:dic];
        }
        if (x == 0) {
             _array_menberPrivate = mutArray;
        }else if(x == 1){
             _array_menberCommon = mutArray;
        }else if(x == 2){
            _array_menberPotential = mutArray;
        }
       
    }
    
    self.MyMenberType = 1;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    
    if (httpISON) {
        [self addHeader];
        [self addFooter];
    }
    self.collectionView.backgroundColor = [UIColor clearColor];
}

//获取私教会员
-(void)getPathAttent_Private{
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    if ((!username_pass)||(!username_pass)) {
        return;
    }
    NSDictionary *parameters = @{@"PageSize": @10,
                                 @"PageIndex":[NSNumber numberWithInteger:self.PageIndexPrivate],
                                 @"username":username_str,
                                 @"password":username_pass,
                                 @"key": Key_HTTP,
                                 };
    __weak MenberVC *vc = self;
    [[AFClient sharedCoachClient]getPath:@"GetAttent_Private" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
            NSArray *array = [resultDict objectForKey:@"info"];
            
            if (array.count >0) {
                if (!vc.array_menberPrivate) {
                    vc.array_menberPrivate = [[NSMutableArray alloc]init];
                    vc.PageIndexPrivate = 1;
                }
              
                for (NSDictionary *dic in array) {
//                    NSLog(@"dic:::%@",dic);
                    ListMenber *listmenber = [[ListMenber alloc]init];
                    listmenber.ID = [[dic objectForKey:@"ID"] integerValue];
                    listmenber.UI_CreateDate = [dic objectForKey:@"UI_CreateDate"];
                    listmenber.UI_Face = [dic objectForKey:@"UI_Face"];
                    listmenber.UI_FirstName = [dic objectForKey:@"UI_FirstName"];
                    listmenber.rownum = [[dic objectForKey:@"rownum"] integerValue];
                    [vc.array_menberPrivate addObject:listmenber];
                    vc.PageIndexPrivate++;
                }
                [vc.collectionView reloadData];
            }
        }
        [vc.header endRefreshing];
        [vc.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [vc.header endRefreshing];
        [vc.footer endRefreshing];
    }];
}

//获取潜在会员
-(void)getPathAttent_Potential{
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    if ((!username_pass)||(!username_pass)) {
        return;
    }
    NSDictionary *parameters = @{@"PageSize": @10,
                                 @"PageIndex":[NSNumber numberWithInteger:self.PageIndexPotential],
                                 @"username":username_str,
                                 @"password":username_pass,
                                 @"key": Key_HTTP,
                                 };
    __weak MenberVC *vc = self;
    [[AFClient sharedCoachClient]getPath:@"GetAttent_Potential" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
            NSArray *array = [resultDict objectForKey:@"info"];
            if (array.count >0) {
                if (!vc.array_menberPotential) {
                    vc.array_menberPotential = [[NSMutableArray alloc]init];
                    vc.PageIndexPotential = 1;
                }
                for (NSDictionary *dic in array) {
                    ListMenber *listmenber = [[ListMenber alloc]init];
                    listmenber.ID = [[dic objectForKey:@"ID"] integerValue];
                    listmenber.UI_CreateDate = [dic objectForKey:@"UI_CreateDate"];
                    listmenber.UI_Face = [dic objectForKey:@"UI_Face"];
                    listmenber.UI_FirstName = [dic objectForKey:@"UI_FirstName"];
                    listmenber.rownum = [[dic objectForKey:@"rownum"] integerValue];
                    [vc.array_menberPotential addObject:listmenber];
                }
                vc.PageIndexPotential ++;
                [vc.collectionView reloadData];
            }
        }
        [vc.header endRefreshing];
        [vc.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [vc.header endRefreshing];
        [vc.footer endRefreshing];
    }];
}

//获取普通会员
-(void)getPathAttent_Common{
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    if ((!username_pass)||(!username_pass)) {
        return;
    }
    NSDictionary *parameters = @{@"PageSize": @10,
                                 @"PageIndex":[NSNumber numberWithInteger:self.PageIndexCommon],
                                 @"username":username_str,
                                 @"password":username_pass,
                                 @"key": Key_HTTP,
                                 };
    __weak MenberVC *vc = self;
    [[AFClient sharedCoachClient]getPath:@"GetAttent_Common" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
            NSArray *array = [resultDict objectForKey:@"info"];
            if (array.count >0) {
                if (!vc.array_menberCommon) {
                    vc.array_menberCommon = [[NSMutableArray alloc]init];
                    vc.PageIndexCommon = 1;
                }
                for (NSDictionary *dic in array) {
                    ListMenber *listmenber = [[ListMenber alloc]init];
                    listmenber.ID = [[dic objectForKey:@"ID"] integerValue];
                    listmenber.UI_CreateDate = [dic objectForKey:@"UI_CreateDate"];
                    listmenber.UI_Face = [dic objectForKey:@"UI_Face"];
                    listmenber.UI_FirstName = [dic objectForKey:@"UI_FirstName"];
                    listmenber.rownum = [[dic objectForKey:@"rownum"] integerValue];
                    [vc.array_menberCommon addObject:listmenber];
                }
                 vc.PageIndexCommon ++;
                [vc.collectionView reloadData];
            }
        }
        [vc.header endRefreshing];
        [vc.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [vc.header endRefreshing];
        [vc.footer endRefreshing];
    }];
}



//会员标记-私教会员
//-(void)GetAttent_Private{
//    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
//    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
//    if ((!username_pass)||(!username_pass)) {
//        return;
//    }
//    NSDictionary *parameters = @{@"PageSize": @10,
//                                 @"PageIndex":[NSNumber numberWithInteger:self.PageIndexCommon],
//                                 @"username":username_str,
//                                 @"password":username_pass,
//                                 @"key": Key_HTTP,
//                                 };
//    [AFClient sharedCoachClient]getPath:@"GetAttent_Private" parameters:<#(NSDictionary *)#> success:<#^(AFHTTPRequestOperation *operation, id responseObject)success#> failure:<#^(AFHTTPRequestOperation *operation, NSError *error)failure#>
//}

//会员标记-普通会员

//会员标记-潜在会员


- (void)addFooter
{
    __weak MenberVC *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.collectionView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        switch (vc.MyMenberType) {
            case TypeMenberPrivate:
            {
                [vc getPathAttent_Private];
            }
                break;
            case TypeMenberCommon:{
                [vc getPathAttent_Common];
            }
                break;
            case TypeNoNenberPotential:
                [vc getPathAttent_Potential];
                break;
                
            default:
                break;
        }

    };
    _footer = footer;
}

- (void)addHeader
{
    __weak MenberVC *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.collectionView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
      
        // 进入刷新状态就会回调这个Block
        switch (vc.MyMenberType) {
            case TypeMenberPrivate:
            {
                vc.PageIndexPrivate = 1;
                vc.array_menberPrivate = nil;
                [vc getPathAttent_Private];
            }
                break;
            case TypeMenberCommon:{
                vc.PageIndexCommon = 1;
                vc.array_menberCommon = nil;
                [vc getPathAttent_Common];
            }
                break;
            case TypeNoNenberPotential:
            {
                vc.PageIndexPotential = 1;
                vc.array_menberPotential = nil;
                [vc getPathAttent_Potential];
            }
                break;
                
            default:
                break;
        }
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        
        
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
}

- (IBAction)SeletMenbertypeAction:(id)sender {
    if ([self.seletedBtn isEqual:sender]) {
        return;
    }
    self.seletedBtn = sender;
    for (UIButton *btn in self.TopSeletView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
                 btn.selected = NO;
        }
    }
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        btn.selected = !btn.selected;
        [self SeletMenbertype:btn.tag];
    }
    
}

-(ListMenber *)getListMenber:(NSInteger)index{
    ListMenber *listmenber=nil;
    switch (self.MyMenberType) {
        case TypeMenberPrivate:
        {
            if (index < _array_menberPrivate.count) {
                listmenber = _array_menberPrivate[index];
            }
        }
            break;
        case TypeMenberCommon:{
            if (index < _array_menberCommon.count) {
                listmenber = _array_menberCommon[index];
            }
        }
            break;
        case TypeNoNenberPotential:
            if (index < _array_menberPotential.count) {
                listmenber = _array_menberPotential[index];
            }
            break;
            
        default:
            break;
    }
    return listmenber;
}

-(void)SeletMenbertype:(NSInteger)indexTag{
   self.MyMenberType = indexTag;
    switch (indexTag) {
        case TypeMenberPrivate:
        {
            if (httpISON) {
                if (!self.array_menberPrivate) {
                    [self.header beginRefreshing];
                }
            }else{
                self.tableview_data = _array_menberPrivate;
            }
        }
            break;
        case TypeMenberCommon:{
            if (httpISON) {
                if (!self.array_menberCommon) {
                    [self.header beginRefreshing];
                }
                
            }else{
                self.tableview_data = _array_menberCommon;
            }
        }
            break;
        case TypeNoNenberPotential:
            if (httpISON) {
                if (!self.array_menberPotential) {
                    [self.header beginRefreshing];
                }
                
            }else{
                self.tableview_data = _array_menberPotential;
            }
            
            break;
            
        default:
            break;
    }
    [self.collectionView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    UIImageView *imgeview = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    [imgeview setImage:[UIImage imageNamed:@"教练圈+导航.png"]];
//    [self.view addSubview:imgeview];

}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (httpISON) {
        switch (self.MyMenberType) {
            case TypeMenberPrivate:
            {
                return _array_menberPrivate.count;
            }
                break;
            case TypeMenberCommon:{
                return _array_menberCommon.count;
            }
                break;
            case TypeNoNenberPotential:
                return _array_menberPotential.count;
                break;
                
            default:
                break;
        }

    }else{
        return [self.tableview_data count];
    }
   //
}
// 2
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    MenberCollectCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"menberCollectCell" forIndexPath:indexPath];
    if (httpISON) {
        ListMenber *listmenber = [self getListMenber:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.Name_Menber.text = listmenber.UI_FirstName;
        cell.delegate = self;
        cell.IndexPathID = indexPath;
        NSURL *url = [NSURL URLWithString:listmenber.UI_Face];
        [cell.ImageViewMenber setImageWithURL:url placeholderImage:[UIImage imageNamed:@"6.png"]];
        cell.Btn_Focus.selected = listmenber.isFocus;
        [cell reloadCollectCell];
        return cell;
    }
   
//    cell.backgroundColor = [UIColor whiteColor];
    NSString *str_image = [[self.tableview_data objectAtIndex:indexPath.row] objectForKey:@"image"];
    cell.ImageViewMenber.image = [UIImage imageNamed:str_image];
    NSString *stringText = [[self.tableview_data objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.Name_Menber.text = stringText;
    cell.IndexPathID = indexPath;
     cell.delegate = self;
    NSNumber *number = [[self.tableview_data objectAtIndex:indexPath.row] objectForKey:@"Focus"];
    cell.Btn_Focus.selected = [number boolValue];
    [cell reloadCollectCell];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    [self performSegueWithIdentifier:@"PushToMenberMainDetailVC" sender:indexPath];
    MenberMainControlSplitVC *vc = [[MenberMainControlSplitVC alloc]init];
    if (httpISON) {
        ListMenber *listmenber = [self getListMenber:indexPath.row];
        vc.listerMenber = listmenber;
    }
    
    vc.title =[[self.tableview_data objectAtIndex:indexPath.row] objectForKey:@"name"];
    [self.navigationController pushViewController:vc animated:YES];
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
   
    CGSize retval = CGSizeMake(221, 238);
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

#pragma mark ====MenberCollectCellDelegate= =========
-(void)menssegeCell:(NSIndexPath *)indexPath Button:(UIButton *)button{
    if (httpISON) {
        ListMenber *listmenber = [self getListMenber:indexPath.row];
        listmenber.isFocus = !button.selected;
      
               if (button.selected == NO) {
            switch (self.MyMenberType) {
                case TypeMenberPrivate:
                {
                    [self.array_menberPrivate removeObjectAtIndex:indexPath.row];
                    [self.array_menberPrivate insertObject:listmenber atIndex:0];
                }
                    break;
                case TypeMenberCommon:{
                    [self.array_menberCommon removeObjectAtIndex:indexPath.row];
                    [self.array_menberCommon insertObject:listmenber atIndex:0];
                }
                    break;
                case TypeNoNenberPotential:
                    [self.array_menberPotential removeObjectAtIndex:indexPath.row];
                    [self.array_menberPotential insertObject:listmenber atIndex:0];
                    break;
                    
                default:
                    break;
            }
           
        }else{
            int inserIndex= 0;
            
            switch (self.MyMenberType) {
                case TypeMenberPrivate:
                {
                    for (ListMenber *listmen in self.array_menberPrivate) {
                        if (listmen.isFocus == YES) {
                            inserIndex ++;
                        }
                    }
                    [self.array_menberPrivate removeObjectAtIndex:indexPath.row];
                    [self.array_menberPrivate insertObject:listmenber atIndex:inserIndex];
                }
                    break;
                case TypeMenberCommon:{
                    for (ListMenber *listmen in self.array_menberCommon) {
                        if (listmen.isFocus == YES) {
                            inserIndex ++;
                        }
                    }
                    [self.array_menberCommon removeObjectAtIndex:indexPath.row];
                    [self.array_menberCommon insertObject:listmenber atIndex:inserIndex];
                }
                    break;
                case TypeNoNenberPotential:{
                    for (ListMenber *listmen in self.array_menberPotential) {
                        if (listmen.isFocus == YES) {
                            inserIndex ++;
                        }
                    }
                    [self.array_menberPotential removeObjectAtIndex:indexPath.row];
                    [self.array_menberPotential insertObject:listmenber atIndex:inserIndex];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        [self.collectionView reloadData];
    }else{
        NSMutableDictionary *Dic = [NSMutableDictionary dictionaryWithDictionary:self.tableview_data[indexPath.row]];
        [self.tableview_data removeObjectAtIndex:indexPath.row];
        [Dic setValue:[NSNumber numberWithBool:!button.selected] forKey:@"Focus"];
        if (button.selected == NO) {
            [self.tableview_data insertObject:Dic atIndex:0];
        }else{
            int inserIndex= 0;
            for (NSDictionary *dic in self.tableview_data) {
                if ([[dic objectForKey:@"Focus"] boolValue] == YES) {
                    inserIndex ++;
                }
            }
            [self.tableview_data insertObject:Dic atIndex:inserIndex];
        }
        [self.collectionView reloadData];
    }
   
}

//-(void)btnAction{
//    
//    [self performSegueWithIdentifier:@"PushToMenberDetailVC" sender:self];
//}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    NSIndexPath *indexpath = sender;
//    
//    if ([segue.identifier isEqualToString:@"PushToMenberMainDetailVC"]) {
//        //        UIButton *btn = sender;
//        UIViewController *vc = segue.destinationViewController;
//        vc.title =[[self.tableview_data objectAtIndex:indexpath.row] objectForKey:@"name"];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
