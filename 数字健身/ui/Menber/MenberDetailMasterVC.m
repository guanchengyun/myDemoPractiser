//
//  MenberDetailMasterVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-17.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "MenberDetailMasterVC.h"
#import "MJRefresh.h"

@interface MenberDetailMasterVC ()
@property (weak, nonatomic) IBOutlet UIButton *FocusBtn;
@property(assign, nonatomic)NSInteger SeletCell;
@property(strong, nonatomic)NSArray *array_selet;
@property (weak, nonatomic) IBOutlet UILabel *LabelUserName;
@property (weak, nonatomic) IBOutlet UILabel *LabelSex;
@property (weak, nonatomic) IBOutlet UILabel *LabelAge;

@property (strong, nonatomic)MJRefreshHeaderView *header;
@end

@implementation MenberDetailMasterVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.array_selet = [[NSArray alloc]initWithObjects:@"详细资料", @"体能测试",@"目标计划",@"Inbody评估报告",@"提醒事件", nil];
    self.FocusBtn.backgroundColor = [UIColor colorWithHexString:@"d95644"];
    [self.FocusBtn setTitle:@"标记" forState:UIControlStateNormal];
    [self.FocusBtn setTitle:@"标记" forState:UIControlStateSelected];
    self.FocusBtn.selected = NO;
    NSLog(@"MenberDetailMasterVC1");
    
    NSLog(@"MenberDetailMasterVC2");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self addHeader];
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:self.SeletCell inSection:0];
    
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self getPathGetUser_ByCoach];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}

- (void)addHeader
{
    
    __weak MenberDetailMasterVC *vc = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;

    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
//        [vc getPathGetUser_ByCoach];
        [vc.header endRefreshing];
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
     
    };

    [header beginRefreshing];
    _header = header;
}


-(void)getPathGetUser_ByCoach{
    __weak MenberDetailMasterVC *vc = self;
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    NSString *userpass_str = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    NSString *userid = [NSString stringWithFormat:@"%d",self.listerMenber.ID];
    if (!userid) {
        return;
    }
    if (!username_str) {
        return;
    }
    if (!userpass_str) {
        return;
    }
    NSDictionary *parameters = @{@"user_id": userid,
                                 @"username":username_str,
                                 @"password":userpass_str,
                                 @"key": Key_HTTP,
                                 };
    [[AFClient sharedCoachClient]getPath:@"GetUser_ByCoach" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"dicObjee6hwrthcts::");
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
//                    NSLog(@"dic::%@",dic);
                    [vc.LabelUserName setText:[dic objectForKey:@"Name"]];
                    vc.LabelUserName.hidden = NO;
                    [vc.LabelSex setText:[dic objectForKey:@"Sex"]];
                    vc.LabelSex.hidden = NO;
                }
            }
        }
//        [vc.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [vc.header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)FocusAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    if (btn.selected == YES) {
        self.FocusBtn.backgroundColor = [UIColor grayColor];
    }else{
        self.FocusBtn.backgroundColor = [UIColor colorWithHexString:@"d95644"];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array_selet.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *StrIdentifierImage = @"ImageCell";
    static NSString *StrIdentifierSelet = @"SeletCell";
    
    
    UITableViewCell *cell_Selet = [tableView dequeueReusableCellWithIdentifier:StrIdentifierSelet];
    cell_Selet.selectedBackgroundView = [[UIView alloc] initWithFrame:cell_Selet.frame];
    if (indexPath.row == 0) {
//        cell_Selet.contentView.backgroundColor = [UIColor colorWithHexString:@"5489ab"];
        cell_Selet.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"5489ab"];
    }else if(indexPath.row == 1){
        cell_Selet.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"89a64c"];
    }else if(indexPath.row == 2){
        cell_Selet.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"5d5494"];
    }else if (indexPath.row == 3){
        cell_Selet.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"f4b953"];
    }else if (indexPath.row == 4){
        cell_Selet.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"d95644"];
    }
    cell_Selet.textLabel.font = [UIFont systemFontOfSize:20];
    cell_Selet.textLabel.text = [self.array_selet objectAtIndex:(indexPath.row)];
    return cell_Selet;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate selectedContainVc:indexPath.row];
    self.SeletCell = indexPath.row;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
