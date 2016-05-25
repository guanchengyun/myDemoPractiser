//
//  ConsultMasterVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-26.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "ConsultMasterVC.h"
#import "ConsultMasterCell.h"
#import "MJRefresh.h"
#import "GetInfo_ColList.h"
#import "GetInfo_TitleList.h"
#import "UIImageView+AFNetworking.h"
#import "AFClient.h"
#import "DatabaseManagerWork.h"

@interface ConsultMasterVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *leftButon;
@property (weak, nonatomic) IBOutlet UIButton *RightButton;
@property (strong, nonatomic)NSArray *ColListArray;
@property (assign, nonatomic)NSInteger PageSize;
@property (assign, nonatomic)NSInteger PageIndexLeft;
@property (assign, nonatomic)NSInteger PageIndexRight;
@property (assign, nonatomic)BOOL IsMax;
@property (assign, nonatomic)BOOL IsRight;
@property (strong, nonatomic)MJRefreshHeaderView *header;
@property (strong, nonatomic)MJRefreshFooterView *footer;
@end

@implementation ConsultMasterVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.PageIndexLeft = 1;
        self.PageIndexRight = 1;
        self.PageSize = 10;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTopSeletView:nil];
    [self initTableDelegate];
    [self addHeader];
    [self addFooter];
  
}




//插入标题
-(void)getPathGetInfo_Col{
    NSDictionary *parameters = @{@"key": Key_HTTP};
    __weak ConsultMasterVC *vc = self;
    [[AFClient sharedClient]getPath:@"GetInfo_Col" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
            NSArray *array = [resultDict objectForKey:@"info"];
            //            NSLog(@"array::%@",array);
            if (array.count == 2) {
                GetInfo_ColList *getcollist0 = [[GetInfo_ColList alloc]init];
                GetInfo_ColList *getcollist1 = [[GetInfo_ColList alloc]init];
                getcollist0._ID = [[array[0] objectForKey:@"ID"] integerValue];
                getcollist0.IC_Name = [array[0] objectForKey:@"IC_Name"];
                getcollist1._ID = [[array[1] objectForKey:@"ID"] integerValue];
                getcollist1.IC_Name = [array[1] objectForKey:@"IC_Name"];
                [vc setColListArray:@[getcollist0,getcollist1]];
            }
            [[DatabaseManagerWork sharedInstanse] InsertToTable:SqlitGetInfo_Col dataArray:array];
        }else{
          [vc.header endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [vc GetColListFromSqlite];
        
    }];
}

-(void)setColListArray:(NSArray *)ColListArray{
    if (ColListArray.count == 2) {
        GetInfo_ColList *getcol1 = ColListArray[0];
        GetInfo_ColList *getcol2 = ColListArray[1];
        [_leftButon setTitle:getcol1.IC_Name forState:UIControlStateNormal];
        [_leftButon setTitle:getcol1.IC_Name forState:UIControlStateSelected];
        [_RightButton setTitle:getcol2.IC_Name forState:UIControlStateNormal];
        [self getPathGetInfo_Title:getcol1._ID index:1];
        [self getPathGetInfo_Title:getcol2._ID index:2];
        _ColListArray = ColListArray;
    }
}

//获取标题
-(void)getPathGetInfo_Title:(NSInteger)TypeId index:(NSInteger)index{
    NSDictionary *parameters = nil;
    if (_IsRight) {
        parameters = @{@"key": Key_HTTP,
                       @"TypeId":[NSNumber numberWithInteger:TypeId],
                       @"PageSize":[NSNumber numberWithInteger:self.PageSize],
                       @"PageIndex":[NSNumber numberWithInteger:self.PageIndexRight],
                       };
    }else{
        parameters = @{@"key": Key_HTTP,
                       @"TypeId":[NSNumber numberWithInteger:TypeId],
                       @"PageSize":[NSNumber numberWithInteger:self.PageSize],
                       @"PageIndex":[NSNumber numberWithInteger:self.PageIndexLeft],
                       };
    }
  
    __weak ConsultMasterVC *vc = self;
    [[AFClient sharedClient]getPath:@"GetInfo_Title" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
            NSArray *array = [resultDict objectForKey:@"info"];
            if (array.count<1) {
                [vc.header endRefreshing];
                return ;
            }else if (array.count < 10){
                self.IsMax = YES;
            }
//            NSLog(@"array::%@",array);
            NSMutableArray *mutableArray = [[NSMutableArray alloc]init];
            NSMutableArray *mutableArrayTitleList = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in array) {
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [mutDic setObject:[NSNumber numberWithInteger:TypeId] forKey:@"TypeId"];
                [mutableArray addObject:mutDic];
            }
            
            for (NSDictionary *dic in array) {
                GetInfo_TitleList *getcolTitleList = [[GetInfo_TitleList alloc]init];
                getcolTitleList.TypeId = TypeId;
                getcolTitleList._ID = [[dic objectForKey:@"ID"] intValue];
                getcolTitleList.rownum = [[dic objectForKey:@"rownum"] intValue];
                getcolTitleList.II_Name = [dic objectForKey:@"II_Name"];
                getcolTitleList.II_Createdate = [dic objectForKey:@"II_Createdate"];
                getcolTitleList.II_ImgUrl = [dic objectForKey:@"II_ImgUrl"];
                [mutableArrayTitleList addObject:getcolTitleList];
            }
//            NSLog(@"mutableArray::%@",mutableArrayTitleList);
        
            if (index == 1) {
                if (vc.PageIndexLeft == 1) {
                    vc.TableViewDataLeft = mutableArrayTitleList;
                }else{
                    [vc.TableViewDataLeft addObjectsFromArray:mutableArrayTitleList];
                }
                vc.PageIndexLeft++;
            }else if (index == 2){
                if (vc.PageIndexRight == 1) {
                    vc.TableViewDataRight = mutableArrayTitleList;
                }else{
                    [vc.TableViewDataRight addObjectsFromArray:mutableArrayTitleList];
                }
                vc.PageIndexRight++;
            }
            
            [vc.tableview reloadData];
            [vc.header endRefreshing];
            [vc.footer endRefreshing];
            [[DatabaseManagerWork sharedInstanse] InsertToTable:SqlitGetInfo_Title dataArray:mutableArray];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error::%@",error);
        [vc GetTitleListFromSqlite:TypeId index:index];
        [vc.header endRefreshing];
        [vc.footer endRefreshing];
    }];
}


-(void)GetColListFromSqlite{
    __weak ConsultMasterVC *vc = self;
    DatabaseManagerWork *dataworf = [DatabaseManagerWork sharedInstanse];
    [dataworf open];
    [dataworf.dataQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
        NSString *querySql =[NSString stringWithFormat:@"SELECT * FROM %@",SqlitGetInfo_Col];
        FMResultSet *rs = [dataworf.db executeQuery:querySql];
        while ([rs next]) {
            if (array.count >100) {
                return ;
            }
            GetInfo_ColList *getcol = [[GetInfo_ColList alloc]init];
            getcol._ID = [rs intForColumn:@"ID"];
            getcol.IC_Name = [rs stringForColumn:@"IC_Name"];
            [array addObject:getcol];
        }
        if (array.count == 2) {
            GetInfo_ColList *getcol1 = array[0];
            GetInfo_ColList *getcol2 = array[1];
            vc.ColListArray = @[getcol1,getcol2];
        }else{
            [vc.header endRefreshing];
        }
        [dataworf close];
    }];
}

-(void)GetTitleListFromSqlite:(NSInteger)TypeId index:(NSInteger)index{
    __weak ConsultMasterVC *vc = self;
    DatabaseManagerWork *dataworf = [DatabaseManagerWork sharedInstanse];
    [dataworf open];
    [dataworf.dataQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
        NSString * querySql =[NSString stringWithFormat:@"SELECT * FROM %@ WHERE TypeId ==%ld",SqlitGetInfo_Title,(long)TypeId];
        FMResultSet *rs = [dataworf.db executeQuery:querySql];
        while ([rs next]) {
            GetInfo_TitleList *getcolTitleList = [[GetInfo_TitleList alloc]init];
            getcolTitleList._ID = [rs intForColumn:@"ID"];
            getcolTitleList.rownum = [rs intForColumn:@"rownum"];
            getcolTitleList.II_Name = [rs stringForColumn:@"II_Name"];
            getcolTitleList.II_Createdate = [rs stringForColumn:@"II_Createdate"];
            getcolTitleList.II_ImgUrl = [rs stringForColumn:@"II_ImgUrl"];
            [array addObject:getcolTitleList];
        }
        
        if (index == 1) {
            vc.TableViewDataLeft = array;
        }else if (index == 2){
            vc.TableViewDataRight = array;
        }
        vc.IsMax = YES;
        [vc.tableview reloadData];
        [vc.header endRefreshing];
        [dataworf close];
    }];
}

- (void)addFooter
{
    __weak ConsultMasterVC *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableview;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
    
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        if (!vc.IsRight) {
            if (vc.PageIndexLeft >1) {
                GetInfo_ColList *getcol1 = vc.ColListArray[0];
                [vc getPathGetInfo_Title:getcol1._ID index:1];
            }else{
                [vc.footer endRefreshing];
            }
          
        }else{
            if (vc.PageIndexRight >1) {
                GetInfo_ColList *getcol2 = vc.ColListArray[1];
                [vc getPathGetInfo_Title:getcol2._ID index:2];
            }else{
                [vc.footer endRefreshing];
            }
        }
    };
    _footer = footer;
}

- (void)addHeader
{
    __weak ConsultMasterVC *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableview;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        if (vc.IsRight) {
            vc.PageIndexRight = 1;
        }else{
            vc.PageIndexLeft = 1;
        }
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        
//        vc.TableViewDataLeft = [[NSMutableArray alloc]init];


        [vc getPathGetInfo_Col];
//        NSLog(@"%@----开始进入刷新状态", refreshView.class);
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}


-(void)initTableDelegate{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
}

-(void)initTopSeletView:(NSDictionary *)dic{
    UIImage *image = [[UIImage imageNamed:@"MenberSeletImage.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    for (UIButton *btn in self.TopSeletView.subviews) {
        if (btn.selected==YES) {
            self.seletedBtn = btn;
        }
        [btn setBackgroundImage:image forState:UIControlStateSelected];
    }
    
    UIView *lineView_TopSeletView            = [[UIView alloc] initWithFrame:CGRectMake(0, 41.5, 320, 2.5)];
    lineView_TopSeletView.opaque             = YES;
    lineView_TopSeletView.backgroundColor    = [UIColor colorWithRed:186.0/255.0 green:186.0/255.0 blue:188.0/255.0 alpha:0.8];
    [_TopSeletView addSubview:lineView_TopSeletView];
}

- (IBAction)SeletBtnAction:(id)sender {
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
        if (btn.tag == 100) {
            self.IsRight = NO;
            [_header endRefreshing];
            [_footer endRefreshing];
//            [self.tableview reloadData];
        }else{
            self.IsRight = YES;
            [_header endRefreshing];
            [_footer endRefreshing];
//            [self.tableview reloadData];
        }
        [self.tableview reloadData];
    }
}

#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
}

#pragma mark 刷新完毕
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"%@----刷新完毕", refreshView.class);
}

#pragma mark 监听刷新状态的改变
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
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
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_IsRight) {
        return _TableViewDataRight.count;
    }else{
        return _TableViewDataLeft.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ConsultMasterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ConsultMasterCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    GetInfo_TitleList *TitleList;
    if (_IsRight) {
       TitleList = [_TableViewDataRight objectAtIndex:indexPath.row];
    }else{
        TitleList = [_TableViewDataLeft objectAtIndex:indexPath.row];
    }
    NSURL *url = [NSURL URLWithString:TitleList.II_ImgUrl];
    [cell.ImageHead setImageWithURL:url placeholderImage:[ConsultMasterVC HerdMenberImage]];
    // Configure the cell...
    
    cell.LabelContact.text = TitleList.II_Name;
//    [self alignTop:cell.LabelContact];
    cell.TimeLabel.text = TitleList.II_Createdate;
    return cell;
}
//
//- (void)alignTop:(UILabel *)label {
//    CGSize fontSize = [label.text sizeWithFont:label.font];
//    double finalHeight = fontSize.height * label.numberOfLines;
//    double finalWidth = label.frame.size.width;    //expected width of label
//    CGSize theStringSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:label.lineBreakMode];
//    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
//    for(int i=0; i<newLinesToPad; i++)
//        label.text = [label.text stringByAppendingString:@"\n "];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82.0;
}

+(UIImage *)HerdMenberImage{

    static UIImage *image = nil;
    if (!image) {
        image = [UIImage imageNamed:@"HeadMenberDefaut.png"];
    }
    return image;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GetInfo_TitleList *TitleList;
    if (_IsRight) {
        TitleList = [_TableViewDataRight objectAtIndex:indexPath.row];
    }else{
        TitleList = [_TableViewDataLeft objectAtIndex:indexPath.row];
    }

    NSString *string = [NSString stringWithFormat:@"%@%ld",Web_yuedong,(long)TitleList._ID];
    [self.delegate selectedContainVcWeb:string];
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
