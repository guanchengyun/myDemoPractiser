//
//  FeedBackVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-25.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "FeedBackVC.h"

@interface FeedBackVC ()<UIAlertViewDelegate>
@property(weak, nonatomic)UITextView *textView;
@end

@implementation FeedBackVC

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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        UITextView *textView = (UITextView *)[cell1 viewWithTag:100];
        
        self.textView = textView;
        return cell1;
    }else{
         UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        UIButton *btn = (UIButton *)[cell2 viewWithTag:100];
        [btn addTarget:self action:@selector(senderAction) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor colorWithHexString:@"d95644"];
        return cell2;
    }
    
    
    
    // Configure the cell...

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
//        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        
        return 336;
    }else{
//        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        return 44;
    }
    
}

-(void)senderAction{
    [self.textView resignFirstResponder];
    if (self.textView.text.length >0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"点击确定发送消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"发送内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
        NSString *passvalue_str = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
        [[NSUserDefaults standardUserDefaults] synchronize];
        MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.removeFromSuperViewOnHide=YES;
        progressHUD.labelFont=[UIFont systemFontOfSize:12];
        progressHUD.minSize=CGSizeMake(140, 130);
        progressHUD.labelText=@"消息发送中...";
        if (self.textView.text.length > 0) {
            if ((username_str)&&(passvalue_str)) {
                NSDictionary *parameters = @{@"content": self.textView.text,
                                             @"username":username_str,
                                             @"password":passvalue_str
                                             };
                [[AFClient sharedClient]postPath:@"Message_Coach_Add" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *resultDict = nil;
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        resultDict = responseObject;
                    }else{
                        resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                    }
                    if (resultDict) {
                        NSString *str = [resultDict objectForKey:@"_return"];
                        if ([str intValue]) {
                            progressHUD.labelText=@"发送成功";
                            [progressHUD hide:YES afterDelay:2];
                        }
                    }else{
                         progressHUD.labelText=@"发送失败";
                        [progressHUD hide:YES];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [progressHUD hide:YES];
                }
                ];
            }
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"发送内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
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
