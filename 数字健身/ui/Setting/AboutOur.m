//
//  AboutOur.m
//  数字健身
//
//  Created by 城云 官 on 14-4-25.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "AboutOur.h"
#import "DatabaseManagerWork.h"
#import "UIImageView+AFNetworking.h"

@interface AboutOur ()
@property (strong, nonatomic)NSDictionary *DictData;
@end

@implementation AboutOur

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
   [self GetData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSDictionary *parameters = @{@"key": Key_HTTP
                                 };
    DatabaseManagerWork *dataworf = [DatabaseManagerWork sharedInstanse];
    [[AFClient sharedClient]getPath:@"GetInfo_AboutUs" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        
        if (resultDict) {
            NSArray *array = [resultDict objectForKey:@"info"];
//            NSLog(@"array::%@",array);
            [dataworf InsertToTable:@"AboutOur" dataArray:array];
            [self GetData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error::%@",error);
    }];
}

-(void)GetData{
    DatabaseManagerWork *dataworf = [DatabaseManagerWork sharedInstanse];
    [dataworf open];
    [dataworf.dataQueue inDatabase:^(FMDatabase *db) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        NSString * querySql =[NSString stringWithFormat:@"SELECT * FROM AboutOur"];
        FMResultSet *rs = [dataworf.db executeQuery:querySql];
        while ([rs next]){
            if ([rs stringForColumn:@"AU_Content"]) {
                [dict setObject:[rs stringForColumn:@"AU_Content"] forKey:@"AU_Content"];
            }
            if ([rs stringForColumn:@"AU_Address"]) {
                [dict setObject:[rs stringForColumn:@"AU_Address"] forKey:@"AU_Address"];
            }

            if ([rs stringForColumn:@"AU_Img"]) {
                [dict setObject:[rs stringForColumn:@"AU_Img"] forKey:@"AU_Img"];
            }
        }
       
        [rs close];
        if (dict.count ==3) {
            self.DictData = dict;
//            [self.tableView reloadData];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //回到主线程
                self.DictData = dict;
                [self.tableView reloadData];
//            });
        }
        
    }];
    [dataworf close];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
        NSURL *url = [NSURL URLWithString:[self.DictData objectForKey:@"AU_Img"]];
        if (url) {
            [imageView setImageWithURL:url];
        }

    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        if (indexPath.row == 1) {
            UILabel *label = (UILabel *)[cell viewWithTag:100];
            UITextView *textView = (UITextView *)[cell viewWithTag:101];
            label.text = @"关于我们";
//            textView.text = @"悦生活—身心健康解决方案集成供应商我们围绕客户的需求持续创新，与合作伙伴开放合作，持续提升客户体验，为客户创造最大价值。悦生活提供面向组织集体的健康（身）产业链的综合业务外包服务，业务囊括七大板块：“健康促进教育、规划设计、康体设备、健身教练、EAP 心理辅导、运动会、云健康应用”；致力于打造“硬件+管理+平台+应用”的业务体系，秉持“客户培育+客户服务+平台增值”三位一体化的商业模式，为企业、写字楼、产业园区提供全方位的身心健康解决方案。";
            if ([self.DictData objectForKey:@"AU_Content"]) {
                textView.text = [self.DictData objectForKey:@"AU_Content"];
            }else{
                textView.text = @"数据加载中。。。。。";
            }
        }else{
            UILabel *label = (UILabel *)[cell viewWithTag:100];
            UITextView *textView = (UITextView *)[cell viewWithTag:101];
            label.text = @"联系我们";
            NSString *string = [self.DictData objectForKey:@"AU_Address"];
            if (string) {
                textView.text = [string stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            }else{
                textView.text = @"数据加载中。。。。。";
            }
        }
        
    }
   
    
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    

    return cell.frame.size.height;
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
