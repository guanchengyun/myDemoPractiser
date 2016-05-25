//
//  SettingRootVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-24.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "SettingRootVC.h"
#import "AppDelegate.h"

@interface SettingRootVC ()<UIAlertViewDelegate>
@property(assign, nonatomic)NSInteger SeletCell;
@property(strong, nonatomic)NSArray *TableViewData;
@end

@implementation SettingRootVC

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
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.TableViewData = @[@"分享中心",@"意见反馈",@"关于我们",@"我的收藏",@"退出账号"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:self.SeletCell inSection:0];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.TableViewData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 4) {
        UIAlertView *aleat = [[UIAlertView alloc]initWithTitle:@"退出" message:@"退出后您将收不到消息,确定要退出？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [aleat show];
        
        return;
    }
    [self.delegate selectedContainVc:indexPath.row];
    self.SeletCell = indexPath.row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"d95644"];
    cell.textLabel.text = [self.TableViewData objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    if(indexPath.row == 0){
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"89a64c"];
    }else if(indexPath.row == 1){
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"5d5494"];
    }else if (indexPath.row == 2){
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"f4b953"];
    }else if(indexPath.row == 3){
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"5489ab"];
    }else if(indexPath.row == 4){
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"d95644"];
    }
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"buttonIndex::%d",buttonIndex);
    if (buttonIndex == 0) {
        AppDelegate *app=[UIApplication sharedApplication].delegate;
        [app LogOut];
    }
}
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
