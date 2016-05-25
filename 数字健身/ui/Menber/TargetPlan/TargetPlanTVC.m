//
//  TargetPlanTVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-17.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "TargetPlanTVC.h"
#import "AddTargetPlan.h"
#import "TargetAttrList.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "SKSTableViewCell.h"
#import "PiecewiseList.h"

@interface TargetPlanTVC ()
@property(strong, nonatomic)NSMutableArray *tableData;
@property(strong, nonatomic)NSArray *array_Target;

@property (strong, nonatomic)MJRefreshHeaderView *header;
@property (strong, nonatomic)MJRefreshFooterView *footer;
@property (assign, nonatomic)NSInteger PageIndex;

@end

@implementation TargetPlanTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//    self.navigationItem.leftBarButtonItem.title = @"编辑";
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    SKSTableView *skstableview = (SKSTableView *)self.tableView;
    if ([skstableview isKindOfClass:[SKSTableView class]]) {
           skstableview.SKSTableViewDelegate = self;
    }
 
    self.title = @"目标计划";
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    }
    UIBarButtonItem *rightBarAdd = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBarAddAction)];
//    UIBarButtonItem *rightBarUpload = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarUploadAction)];
    self.navigationItem.rightBarButtonItem = rightBarAdd;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarAction)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加目标计划" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarAction)];
    self.PageIndex = 1;
    [self GetList_TargetAttr];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addHeader];
    [self addFooter];
    [self.tableView reloadData];
}
- (IBAction)leftAction:(UIBarButtonItem *)sender {
    
    if ([self.tableView isEditing]) {
        
        [self.tableView setEditing:NO animated:YES];
        [sender setTitle:@"edit"];
        [sender setStyle:UIBarButtonItemStyleBordered];
        
    }else{
        
        [self.tableView setEditing:YES  animated:YES];
        [sender setTitle:@"done"];
        [sender setStyle:UIBarButtonItemStyleDone];
    }
}

//获取目标属性
-(void)GetList_TargetAttr{
    
    NSDictionary *parameters = @{@"gym_id": @2,
                                 @"key":Key_HTTP};
    
    __weak TargetPlanTVC *vc = self;
    [[AFClient sharedCoachClient]getPath:@"GetList_TargetAttr" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
//            NSLog(@"resultDict::%@", resultDict);
            NSArray *array = [resultDict objectForKey:@"info"];
            NSMutableArray *mutarr = [[NSMutableArray alloc]init];
//            NSLog(@"arrayarrayarrayarray:%@",array);
            for (NSDictionary *dic in array) {
             
                TargetAttrList *targetlist = [[TargetAttrList alloc]init];
                targetlist.ID_out = -1;
                targetlist.ID = [[dic objectForKey:@"ID"] integerValue];
                targetlist.TA_CD = [dic objectForKey:@"TA_CD"];
                targetlist.TA_Content = [dic objectForKey:@"TA_Content"];
                [mutarr addObject:targetlist];
            }
            if (mutarr.count>0) {
                vc.array_Target = mutarr;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    }];
}

//获取列表
-(void)GetList_Target_OneUser_byCoach{
    __weak TargetPlanTVC *vc = self;
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    if ((!username_pass)||(!username_pass)) {
        return;
    }
    if (!self.listerMenber.ID) {
        return;
    }
    NSDictionary *parameters = @{@"PageSize": @20,
                                 @"PageIndex":[NSNumber numberWithInteger:self.PageIndex],
                                 @"username":username_str,
                                 @"password":username_pass,
                                 @"key": Key_HTTP,
                                 @"userid":[NSNumber numberWithInteger:self.listerMenber.ID]
                                 };
  [[AFClient sharedCoachClient]getPath:@"GetList_Target_OneUser_byCoach" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSDictionary *resultDict = nil;
      if ([responseObject isKindOfClass:[NSDictionary class]]) {
          resultDict = responseObject;
      }else{
          resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
      }
      if (resultDict) {
//          NSLog(@"resultDicttargetplan::%@",resultDict);
          NSArray *array = [resultDict objectForKey:@"info"];
          for (NSDictionary *dic in array) {
              NSMutableArray *mutArray = [[NSMutableArray alloc]init];
              PiecewiseList *piecewiselist = [[PiecewiseList alloc]init];
              piecewiselist.ID = [[dic objectForKey:@"ID"] intValue];
              piecewiselist.Title = [dic objectForKey:@"TU_CD"];
              if ([dic objectForKey:@"TU_DateStart"]) {
                  piecewiselist.DateStart = [self dateFromString:[dic objectForKey:@"TU_DateStart"]];
              }
              if ([dic objectForKey:@"TU_DateEnd"]) {
                  piecewiselist.DateEnd = [self dateFromString:[dic objectForKey:@"TU_DateEnd"]];
              }
              piecewiselist.FK_CD_ID = [[dic objectForKey:@"FK_CD_ID"] intValue];
              piecewiselist.FK_UI_ID = [[dic objectForKey:@"FK_UI_ID"] intValue];
              NSArray *arrayarrlist = [dic objectForKey:@"info2"];
              [mutArray addObject:piecewiselist];
              for (NSDictionary *dicarrlist in arrayarrlist) {
                  PiecewiseList *piecewiselistclass = [[PiecewiseList alloc]init];
                  piecewiselistclass.ID = [[dicarrlist objectForKey:@"TSU_ID"] intValue];
                  piecewiselistclass.Title = [dicarrlist objectForKey:@"TSU_Title"];
                  if ([dicarrlist objectForKey:@"TSU_DateStart"]) {
                      piecewiselistclass.DateStart = [self dateFromString:[dicarrlist objectForKey:@"TSU_DateStart"]];
                  }
                  if ([dicarrlist objectForKey:@"TSU_DateEnd"]) {
                      piecewiselistclass.DateEnd = [self dateFromString:[dicarrlist objectForKey:@"TSU_DateEnd"]];
                  }
//                  piecewiselist.FK_CD_ID = [[dic objectForKey:@"FK_CD_ID"] intValue];
                  piecewiselistclass.FK_UI_ID = [[dicarrlist objectForKey:@"FK_TU_ID"] intValue];
                  [mutArray addObject:piecewiselistclass];
                  
              }
              if (mutArray.count>0) {
                  NSMutableArray *arrmut = [NSMutableArray arrayWithObject:mutArray];
                  [self.tableData addObject:arrmut];
                  self.PageIndex ++;
              }
             
          }
          if (array.count>0) {
              [vc.tableView reloadData];
          }
          
      }
      [vc.header endRefreshing];
      [vc.footer endRefreshing];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [vc.header endRefreshing];
      [vc.footer endRefreshing];
  }];
}

- (void)addFooter
{
    __weak TargetPlanTVC *vc = self;
    if (!_footer) {
        _footer = [MJRefreshFooterView footer];
        _footer.scrollView = self.tableView;
        _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
            // 模拟延迟加载数据，因此2秒后才调用）
            // 这里的refreshView其实就是footer
            [vc GetList_Target_OneUser_byCoach];
        };
    }
   
}

- (void)addHeader
{
    __weak TargetPlanTVC *vc = self;
    
    if (!_header) {
        _header = [MJRefreshHeaderView header];
        _header.scrollView = self.tableView;
        _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
            vc.PageIndex = 1;
    
            [vc GetList_Target_OneUser_byCoach];
            // 进入刷新状态就会回调这个Block
            // 模拟延迟加载数据，因此2秒后才调用）
            // 这里的refreshView其实就是header
        };
        _header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
            // 刷新完毕就会回调这个Block
            NSLog(@"%@----刷新完毕", refreshView.class);
        };
        _header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
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
        [_header beginRefreshing];
    }
   
}

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

-(IBAction)leftBarAction:(id)sender{
//    UIBarButtonItem *barBtn = (UIBarButtonItem *)sender;
//    barBtn
//    for (UIBarButtonItem *barbutton in self.navigationItem.rightBarButtonItems) {
//        barbutton.enabled = NO;
//    }
}

-(void)rightBarAddAction{
//    [self performSegueWithIdentifier:@"ToAddPlan" sender:nil];
//    AddTargetPlan *addtarg = [[AddTargetPlan alloc]initWithStyle:UITableViewStylePlain];
//    NSMutableArray *mutArr =[[NSMutableArray alloc]init];
//    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:@{[NSNumber numberWithInt:self.tableData.count]: mutArr}];
//    [self.tableData addObject:mutableDic];
    [self performSegueWithIdentifier:@"ToAddTargetPlan" sender:nil];
//    NSLog(@"listlis:::%d",self.listerMenber.ID);
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    AddTargetPlan *addtargetvc = segue.destinationViewController;
    for (TargetAttrList *target in _array_Target) {
        target.TA_DetailContent = nil;
        target.ID_out = -1;
        target.isIncrease = NO;
        
    }
    addtargetvc.tagetListArr = [self.array_Target copy];
    addtargetvc.listerMenber = self.listerMenber;
    NSIndexPath *indepath = (NSIndexPath *)sender;
    if ([segue.identifier isEqualToString:@"ToAddTargetPlan"]) {
        //添加总目标
      if ([sender isKindOfClass:[NSIndexPath class]]) {
            //添加阶段目标
          
            PiecewiseList *piecelist = self.tableData[indepath.section][indepath.row][0];
            addtargetvc.Mutarr_targetPlanTableData = self.tableData[indepath.section][indepath.row];
//            PiecewiseList *piecelist = self.tableData[indepath.section][indepath.row][ind];
            addtargetvc.target_id = [NSString stringWithFormat:@"%d",piecelist.ID];
            addtargetvc.AddMetod = AddPhaseMethod;
        }else{
            addtargetvc.AddMetod = AddTotalGoalMethod;
            addtargetvc.Mutarr_targetPlanTableData = self.tableData.firstObject;
        }
    }else if([segue.identifier isEqualToString:@"ToModifyTargetPlan"]){
        PiecewiseList *piecelist = self.tableData[indepath.section][indepath.row][0];
        addtargetvc.ID = [NSString stringWithFormat:@"%d",piecelist.ID];
        addtargetvc.PiecewList = piecelist;
        addtargetvc.AddMetod = ModifyTotalGoalMethod;
    }else if ([segue.identifier isEqualToString:@"ToModifyPhaseMethod"]){
        //添加总目标
//          NSLog(@"indadsa:%d   %d  subRow:%d",indepath.section, indepath.row,indepath.subRow);
        PiecewiseList *piecelist = self.tableData[indepath.section][indepath.row][indepath.subRow];
        addtargetvc.ID = [NSString stringWithFormat:@"%d",piecelist.ID];
        addtargetvc.PiecewList = piecelist;
        
        PiecewiseList *piecelisttarget = self.tableData[indepath.section][indepath.row][0];
        addtargetvc.target_id = [NSString stringWithFormat:@"%d",piecelisttarget.ID];
        
        addtargetvc.AddMetod = ModifyPhaseMethod;
    }
}

-(NSMutableArray *)tableData{
    if (!_tableData) {
        _tableData = [[NSMutableArray alloc]init];
//        NSArray *contents = @[@[@[@"Section0_Row0", @"Row0_Subrow1",@"Row0_Subrow2"],
//        @[@"Section0_Row1", @"Row1_Subrow1", @"Row1_Subrow2", @"Row1_Subrow3", @"Row1_Subrow4", @"Row1_Subrow5", @"Row1_Subrow6", @"Row1_Subrow7", @"Row1_Subrow8", @"Row1_Subrow9", @"Row1_Subrow10", @"Row1_Subrow11", @"Row1_Subrow12"],
//        @[@"Section0_Row2"]],
//        @[@[@"Section1_Row0", @"Row0_Subrow1", @"Row0_Subrow2", @"Row0_Subrow3"],
//          @[@"Section1_Row1"],
//          @[@"Section1_Row2", @"Row2_Subrow1", @"Row2_Subrow2", @"Row2_Subrow3", @"Row2_Subrow4", @"Row2_Subrow5"]]];
    }
    return _tableData;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData[section] count];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableData[indexPath.section][indexPath.row] count] - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    PiecewiseList *piecewiselist = self.tableData[indexPath.section][indexPath.row][0];
    cell.textLabel.text = [NSString stringWithFormat:@"         %@-%@   %@",[[TargetPlanTVC cellDate1] stringFromDate:piecewiselist.DateStart],[[TargetPlanTVC cellDate2] stringFromDate:piecewiselist.DateEnd],piecewiselist.Title];
   
    if ([self.tableData[indexPath.section][indexPath.row] count] > 1){
        cell.isExpandable = YES;
        [cell removeIndicatorView];
        [cell addIndicatorView];
    }
    else{
     cell.isExpandable = NO;
     [cell removeIndicatorView];
    }
    
    
    return cell;
}

+(NSDateFormatter *)cellDate1{
    static NSDateFormatter *celldate1 = nil;
    if (!celldate1) {
        celldate1 = [[NSDateFormatter alloc] init];
        celldate1.dateFormat = @"yyyy/MM/dd";
    }
    return celldate1;
}

+(NSDateFormatter *)cellDate2{
    static NSDateFormatter *celldate2 = nil;
    if (!celldate2) {
        celldate2 = [[NSDateFormatter alloc] init];
        celldate2.dateFormat = @"MM/dd";
    }
    return celldate2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.tableData[indexPath.section][indexPath.row][indexPath.subRow]];
   
    PiecewiseList *piecewiselist = self.tableData[indexPath.section][indexPath.row][indexPath.subRow];
    cell.textLabel.text = [NSString stringWithFormat:@" %@-%@   %@",[[TargetPlanTVC cellDate1] stringFromDate:piecewiselist.DateStart],[[TargetPlanTVC cellDate2] stringFromDate:piecewiselist.DateEnd],piecewiselist.Title];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"indadsa:%d   %d",indexPath.section, indexPath.row);
    //修改总目标
   [self performSegueWithIdentifier:@"ToModifyTargetPlan" sender:indexPath];
}

-(void)tableView:(SKSTableView *)tableView didSelectForSubRowAtIndexPath:(NSIndexPath *)indexPath{
// NSLog(@"indadsa:%d   %d  subRow:%d",indexPath.section, indexPath.row,indexPath.subRow);
    //修改阶段目标
    [self performSegueWithIdentifier:@"ToModifyPhaseMethod" sender:indexPath];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //对数据原操作
        PiecewiseList *piecewiselist = self.tableData[indexPath.section][indexPath.row][0];
        
        NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
        NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
        NSDictionary *parameters = @{@"Target_id": [NSString stringWithFormat:@"%d",piecewiselist.ID],
                                     @"username":username_str,
                                     @"password":username_pass,
                                     @"key":Key_HTTP};
        __weak  MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        __weak TargetPlanTVC *vc = self;
        //    progressHUD.mode=MBProgressHUDModeText;
        progressHUD.margin = 10.f;
        progressHUD.yOffset = self.view.bounds.origin.y;
        progressHUD.alpha=0.75;
        progressHUD.removeFromSuperViewOnHide = YES;
        [[AFClient sharedCoachClient]getPath:@"Target_delete" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [progressHUD hide:YES];
             SKSTableView *skstable = (SKSTableView *)vc.tableView;
            [vc.tableData removeObjectAtIndex:indexPath.section];
            [skstable removeforSection:indexPath.section];
            [skstable deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
    
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [progressHUD hide:YES afterDelay:2];
            progressHUD.labelText = @"删除失败";
        }];
        
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forSubRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //对数据原操作
        PiecewiseList *piecewiselist = self.tableData[indexPath.section][indexPath.row][indexPath.subRow];

        NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
        NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
        NSDictionary *parameters = @{@"Stage_id": [NSString stringWithFormat:@"%d",piecewiselist.ID],
                                     @"username":username_str,
                                     @"password":username_pass,
                                     @"key":Key_HTTP};
        __weak  MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak TargetPlanTVC *vc = self;
        //    progressHUD.mode=MBProgressHUDModeText;
        progressHUD.margin = 10.f;
        progressHUD.yOffset = self.view.bounds.origin.y;
        progressHUD.alpha=0.75;
        [[AFClient sharedCoachClient]getPath:@"Target_Stage_delete" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [progressHUD hide:YES];
             [vc.tableData[indexPath.section][indexPath.row] removeObjectAtIndex:indexPath.subRow];
            NSMutableArray *indexPaths = [NSMutableArray array];
            NSInteger row = indexPath.subRow;
            NSInteger section = indexPath.section;
            //
            SKSTableView *skstable = (SKSTableView *)vc.tableView;
            NSIndexPath *expIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [indexPaths addObject:expIndexPath];
            //
            [skstable removeExpandedIndexPaths:indexPaths forSection:indexPath.section];
            [skstable deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            
    
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [progressHUD hide:YES afterDelay:2];
            progressHUD.labelText = @"删除失败";
        }];
       
    }
}

-(void)tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath{
[self performSegueWithIdentifier:@"ToAddTargetPlan" sender:indexPath];
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
