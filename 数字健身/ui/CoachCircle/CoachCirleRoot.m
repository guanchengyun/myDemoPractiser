//
//  CoachCirleRoot.m
//  数字健身
//
//  Created by 城云 官 on 14-4-16.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "CoachCirleRoot.h"
#import "CoachDataCell.h"
#import "MJRefresh.h"
#import "List_Circle.h"
#import "AFClient.h"
#import "PublishedCoachCircleTVC.h"

@interface CoachCirleRoot ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)MJRefreshHeaderView *header;
@property (strong, nonatomic)MJRefreshFooterView *footer;
@property(strong, nonatomic)UIPopoverController *popoverCT;
@property (strong, nonatomic)PublishedCoachCircleTVC *publishVC;

@property (weak, nonatomic) IBOutlet UIView *TopSeletView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) UIButton *seletedBtn;
@property (strong, nonatomic)NSMutableArray *coachdatas;
@property (strong, nonatomic)NSMutableArray *coachCollectData;
@property (strong, nonatomic)NSMutableDictionary *DictcoachCollectData;
@property (weak, nonatomic)NSMutableArray *TableViewData;

@property (strong, nonatomic)NSMutableArray *TableViewDataLeft;
@property (strong, nonatomic)NSMutableArray *TableViewDataRight;
@property (assign, nonatomic)NSInteger IsRight;
@property (assign, nonatomic)NSInteger PageSize;
@property (assign, nonatomic)NSInteger PageIndexLeft;
@property (assign, nonatomic)NSInteger PageIndexRight;
@property (assign, nonatomic)BOOL IsMax;
@end

@implementation CoachCirleRoot

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
    self.DictcoachCollectData = [[NSMutableDictionary alloc]init];
    self.navigationController.navigationBarHidden = YES;
    [self initTopSeletView];
    [self initCoachData];
    [self addHeader];
    [self addFooter];
    self.PageIndexLeft = 1;
    [self GetList_CirclePath];
    self.TableViewDataLeft = [[NSMutableArray alloc]init];
    self.publishVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PublishedCoachCircleTVC"];
    self.popoverCT = [[UIPopoverController alloc]initWithContentViewController:self.publishVC];
}

- (void)addFooter
{
    __weak CoachCirleRoot *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableview;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        if (vc.IsRight) {
            [vc GetList_MyCirclePath];
        }else{
            [vc GetList_CirclePath];
        }
    };
    _footer = footer;
}

- (void)addHeader
{
    __weak CoachCirleRoot *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableview;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        vc.PageSize = 10;
        vc.IsMax = NO;
        // 进入刷新状态就会回调这个Block
        if (vc.IsRight) {
            vc.PageIndexRight = 1;
            vc.TableViewDataRight = [[NSMutableArray alloc]init];
            [vc GetList_MyCirclePath];
        }else{
            vc.PageIndexLeft = 1;
            vc.TableViewDataLeft = [[NSMutableArray alloc]init];
            [vc GetList_CirclePath];
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

-(void)GetList_MyCirclePath{
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    if ((!username_pass)||(!username_pass)) {
        return;
    }
    NSDictionary *parameters = @{                                 @"PageSize":[NSNumber numberWithInteger:self.PageSize],
                                 @"PageIndex":[NSNumber numberWithInteger:self.PageIndexRight],
                                 @"username":username_str,
                                 @"password":username_pass,
                                 @"key": Key_HTTP,
                                 };
    __weak CoachCirleRoot *vc = self;
    [[AFClient sharedCoachClient]getPath:@"GetList_MyCircle" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
            NSArray *array = [resultDict objectForKey:@"info"];
            if (array.count >0) {
                if (!self.TableViewDataRight) {
                    self.TableViewDataRight = [[NSMutableArray alloc]init];
                }
                for (NSDictionary *dic in array) {
                    List_Circle *listcircle = [[List_Circle alloc]init];
                    listcircle.ID = [[dic objectForKey:@"ID"] integerValue];
                    listcircle.CC_Createdate = [dic objectForKey:@"CC_Createdate"];
                    listcircle.CC_Title = [dic objectForKey:@"CC_Title"];
                    listcircle.Name = [dic objectForKey:@"Name"];
                    listcircle.rownum = [[dic objectForKey:@"rownum"] integerValue];
                    [vc.TableViewDataRight addObject:listcircle];
                    vc.PageIndexRight ++;
                }
                [vc.tableview reloadData];
            }
        }
        [vc.header endRefreshing];
        [vc.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [vc.header endRefreshing];
        [vc.footer endRefreshing];
    }];

}


-(void)GetList_CirclePath{
    NSDictionary *parameters = @{@"key": Key_HTTP,
                                 @"PageSize":[NSNumber numberWithInteger:self.PageSize],
                                 @"PageIndex":[NSNumber numberWithInteger:self.PageIndexLeft],
                                 };
    __weak CoachCirleRoot *vc = self;
    [[AFClient sharedCoachClient]getPath:@"GetList_Circle" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
            NSArray *array = [resultDict objectForKey:@"info"];
            if (array.count >0) {
                for (NSDictionary *dic in array) {
                    List_Circle *listcircle = [[List_Circle alloc]init];
                    listcircle.ID = [[dic objectForKey:@"ID"] integerValue];
                    listcircle.CC_Createdate = [dic objectForKey:@"CC_Createdate"];
                    listcircle.CC_Title = [dic objectForKey:@"CC_Title"];
                    listcircle.Name = [dic objectForKey:@"Name"];
                    listcircle.rownum = [[dic objectForKey:@"rownum"] integerValue];
                    [vc.TableViewDataLeft addObject:listcircle];
                    vc.PageIndexLeft ++;
                }
                [vc.tableview reloadData];
            }
        }
        [vc.footer endRefreshing];
        [vc.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [vc.header endRefreshing];
        [vc.footer endRefreshing];
    }];
}

-(void)initCoachData{
    self.coachdatas = [NSMutableArray array];
    self.coachCollectData = [NSMutableArray array];
//    NSArray *array=@[@"menber1.png",@"menber2.png",@"menber4.png",@"menber2.png",@"menber1.png",@"menber3.png",@"menber1.png",];
//    NSDictionary *dic =@{@"titnain": @"张教练好帅",
//                         @"woailuo": @"张教练好丑",
//                         @"美女": @"张教练不是东西",
//                         @"帅哥": @"张教练是什么东西",
//                         @"天才": @"张教练我爱你",
//                         };
//    
//    [_coachdatas addObject:[CoachData newCoachDataWithName:@"张教练" contacts:@"冰心(1900－1999)原名谢婉莹，福建长乐人 ，中国诗人、作家、翻译家、儿童文学家、社会活动家。1900年10月5日出生于福州一个海军军官家庭。" image:@"menber1.png" images:array dicComments:dic]];
//    [_coachdatas addObject:[CoachData newCoachDataWithName:@"留教练" contacts:@"冰心(1900－1999)原名谢婉莹，福建长乐人 ，中国诗人、作家、翻译家、儿童文学家、社会活动家。1900年10月5日出生于福州一个海军军官家庭。" image:@"menber1.png" images:array dicComments:dic]];
//    [_coachdatas addObject:[CoachData newCoachDataWithName:@"刘教练" contacts:@"4月16日，江西武宁县政府组织专业人员和机械，在船滩乡船滩村对千年乌木进行开挖，使千年古木得以重见天日。上午七点半开始，千年乌木开始逐步开挖，为了方便下一步运输，目前临时道路已基本打通。附近几个村庄的村民也纷纷赶到开挖现场，大家都想一睹乌木的真面目" image:@"menber1.png" images:array dicComments:dic]];
//    [_coachdatas addObject:[CoachData newCoachDataWithName:@"王教练" contacts:@"16日上午，当地政府部门组织专业人员和机械在船滩乡船滩村河滩中对乌木进行开挖，现场共调来了1抬大型挖掘机、1台臂长50米的起吊机以及1辆加长大货车等。为方便运输，现场还特意新修了一条长约200米的砂石路通到河边。" image:@"menber1.png" images:array dicComments:dic]];
//    [_coachdatas addObject:[CoachData newCoachDataWithName:@"唐教练" contacts:@"4月16日，江西武宁县政府组织专业人员和机械，在船滩乡船滩村对千年乌木进行开挖，使千年古木得以重见天日。上午七点半开始，千年乌木开始逐步开挖，为了方便下一步运输，目前临时道路已基本打通。附近几个村庄的村民也纷纷赶到开挖现场，大家都想一睹乌木的真面目" image:@"menber1.png" images:array dicComments:dic]];
//    [_coachdatas addObject:[CoachData newCoachDataWithName:@"李教练" contacts:@"4月16日，江西武宁县政府组织专业人员和机械，在船滩乡船滩村对千年乌木进行开挖，使千年古木得以重见天日。上午七点半开始，千年乌木开始逐步开挖，为了方便下一步运输，目前临时道路已基本打通。附近几个村庄的村民也纷纷赶到开挖现场，大家都想一睹乌木的真面目" image:@"menber1.png" images:array dicComments:dic]];
//    [_coachdatas addObject:[CoachData newCoachDataWithName:@"李教练" contacts:@"4月16日，江西武宁县政府组织专业人员和机械，在船滩乡船滩村对千年乌木进行开挖，使千年古木得以重见天日。上午七点半开始，千年乌木开始逐步开挖，为了方便下一步运输，目前临时道路已基本打通。附近几个村庄的村民也纷纷赶到开挖现场，大家都想一睹乌木的真面目" image:@"menber1.png" images:array dicComments:dic]];
//    [_coachdatas addObject:[CoachData newCoachDataWithName:@"李教练" contacts:@"4月16日，江西武宁县政府组织专业人员和机械，在船滩乡船滩村对千年乌木进行开挖，使千年古木得以重见天日。上午七点半开始，千年乌木开始逐步开挖，为了方便下一步运输，目前临时道路已基本打通。附近几个村庄的村民也纷纷赶到开挖现场，大家都想一睹乌木的真面目" image:@"menber1.png" images:array dicComments:dic]];
//    [_coachdatas addObject:[CoachData newCoachDataWithName:@"李教练" contacts:@"4月16日，江西武宁县政府组织专业人员和机械，在船滩乡船滩村对千年乌木进行开挖，使千年古木得以重见天日。上午七点半开始，千年乌木开始逐步开挖，为了方便下一步运输，目前临时道路已基本打通。附近几个村庄的村民也纷纷赶到开挖现场，大家都想一睹乌木的真面目" image:@"menber1.png" images:array dicComments:dic]];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.TableViewData = _coachdatas;
}

-(void)initTopSeletView{
    UIImage *image = [[UIImage imageNamed:@"MenberSeletImage.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    for (UIButton *btn in self.TopSeletView.subviews) {
        if (btn.selected==YES) {
            self.seletedBtn = btn;
        }
        [btn setBackgroundImage:image forState:UIControlStateSelected];
    }
    
    UIView *lineView_TopSeletView            = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, 320, 2.5)];
    lineView_TopSeletView.opaque             = YES;
    lineView_TopSeletView.backgroundColor    = [UIColor colorWithRed:186.0/255.0 green:186.0/255.0 blue:188.0/255.0 alpha:0.8];
    [_TopSeletView addSubview:lineView_TopSeletView];
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
        if (btn.tag == 100) {
            self.IsRight = NO;
//            self.TableViewData = _coachdatas;
        }else{
//            self.TableViewData = _coachCollectData;
            self.IsRight = YES;
            if (self.TableViewDataRight == nil) {
                [_header beginRefreshing];
//                [self GetList_MyCirclePath];
            }
        }
        [self.tableview reloadData];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (_IsRight) {
        return _TableViewDataRight.count;
    }else{
        return _TableViewDataLeft.count;
    }
//   return self.TableViewData.count;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     static NSString *CellIdentifier = @"coachdataCell";
//     CoachData *coachdata = _TableViewData[indexPath.row];
     List_Circle *listcircle = nil;
     if (_IsRight) {
         listcircle = _TableViewDataRight[indexPath.row];
     }else{
         listcircle = _TableViewDataLeft[indexPath.row];
     }
     CoachDataCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
         NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CoachDataCell" owner:self options:nil];
         cell = [nib objectAtIndex:0];
//         [cell.collectBtn addTarget:self action:@selector(collectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
////
//         [cell.collectBtn setBackgroundColor:[UIColor colorWithHexString:@"89a64c"]];
//         [cell.collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
//         [cell.collectBtn setTitle:@"已收藏" forState:UIControlStateSelected];
     }
    
//     cell.collectBtn.selected = coachdata.isSelet;
//     cell.collectBtn.tag = indexPath.row;
//     cell.NameLabel.text = coachdata.name;
//     cell.ContactLabel.text = coachdata.contact;
//     cell.imageV.image = [UIImage imageNamed:coachdata.image];
// 
 // Configure the cell...
     cell.NameLabel.text = listcircle.Name;
     cell.ContactLabel.text = listcircle.CC_Title;
     cell.CreatedateLabel.text = listcircle.CC_Createdate;
 
     return cell;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_IsRight) {
        return 44;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_IsRight) {
        if (indexPath.row <_TableViewDataRight.count) {
            [self.delegate selectedCoachCirleMonster:_TableViewDataRight[indexPath.row]];
        }
    }else{
        if (indexPath.row <_TableViewDataLeft.count) {
            [self.delegate selectedCoachCirleMonster:_TableViewDataLeft[indexPath.row]];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = [UIColor clearColor];
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationBar setBackgroundColor:[UIColor clearColor]];
    //创建一个左边按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clickLeftButton)];
    
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRightButton)];
    
    
    //把导航栏集合添加入导航栏中，设置动画关闭
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    //把左右两个按钮添加入导航栏集合中
    [navigationItem setLeftBarButtonItem:leftButton];
    [navigationItem setRightBarButtonItem:rightButton];
    
    //把导航栏添加到视图中
    [view addSubview:navigationBar];
    return navigationBar;
}

-(void)clickLeftButton{
    
}

-(void)clickRightButton{
     CGRect rect = CGRectMake(self.splitViewController.view.bounds.size.width/2, self.splitViewController.view.bounds.size.height/2, 1, 1);
    [self.popoverCT presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
