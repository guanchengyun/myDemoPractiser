//
//  AddCustomSchedulePlanVC.m
//  数字健身
//
//  Created by 城云 官 on 14-7-2.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "AddCustomSchedulePlanVC.h"

@interface AddCustomSchedulePlanVC ()

@property(weak, nonatomic)UITextField *TitleTextField;
@property(weak, nonatomic)UITextView *ContactTextView;
@property(strong, nonatomic)NSMutableDictionary *tabledataDic;
@end

@implementation AddCustomSchedulePlanVC

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(rightAction)];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];


    if (self.define_id) {
        [self getModifyData];
    }else{
        [self.TitleTextField becomeFirstResponder];
    }
}

-(void)getModifyData{
    
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    NSDictionary *parameters = @{@"id": self.define_id,
                                 @"username":username_str,
                                 @"password": username_pass,
                                 @"key":Key_HTTP,
                                 };
    __weak AddCustomSchedulePlanVC *vc = self;
    MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.margin = 10.f;
    progressHUD.alpha=0.75;
    [[AFClient sharedCoachClient]getPath:@"Train_Define_List" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        NSLog(@"resultDict333333333::%@",resultDict);
        if (resultDict) {
            NSArray *array = [resultDict objectForKey:@"info"];
            NSDictionary *dictresu = [array objectAtIndex:0];
            if (dictresu.allKeys.count>0) {
//                if ([dictresu  objectForKey:@"FK_TPT_ID"]) {
//                    [vc.DictPath setObject:[dictresu objectForKey:@"FK_TPT_ID"] forKey:@"type"];
//                    
//                }
                if ([dictresu objectForKey:@"TD_Title"]) {
                    [vc.tabledataDic setValue:[dictresu objectForKey:@"TD_Title"] forKey:@"title"];

                }
                if ([dictresu objectForKey:@"TD_Content"]) {
                    [vc.tabledataDic setValue:[dictresu objectForKey:@"TD_Content"] forKey:@"content"];
                    
                }

                [vc.tableView reloadData];
            }else{
                [vc.navigationController popViewControllerAnimated:YES];
            }
            
        }else{
            [vc.navigationController popViewControllerAnimated:YES];
        }
        [progressHUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        progressHUD.labelText=@"请求失败";
        [progressHUD hide:YES afterDelay:2];
        [vc.navigationController popViewControllerAnimated:YES];
    }];
    
    
}

-(NSMutableDictionary *)tabledataDic{
    if (!_tabledataDic) {
        _tabledataDic = [[NSMutableDictionary alloc]init];
        NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
        NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
        [_tabledataDic setValue:username_str forKey:@"username"];
        [_tabledataDic setValue:username_pass forKey:@"password"];
        [_tabledataDic setValue:Key_HTTP forKey:@"key"];
        [_tabledataDic setValue:@"" forKey:@"title"];
        [_tabledataDic setValue:@"" forKey:@"content"];
        if (self.define_id) {
            [_tabledataDic setValue:self.define_id forKey:@"define_id"];
        }else{
            [_tabledataDic setValue:@"-1" forKey:@"define_id"];
        }
        
        if (self.contract_id) {
            [_tabledataDic setValue:self.contract_id forKey:@"contract_id"];
        }
     
    }
    return _tabledataDic;
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
    UITableViewCell *cell;
    static NSString *IdentiCel1 = @"Cell1";
    static NSString *IdentiCel2 = @"Cell2";
    
    if (indexPath.row == 0) {
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:IdentiCel1 forIndexPath:indexPath];
        UITextField *textfield = (UITextField *)[cell1 viewWithTag:301];
        self.TitleTextField = textfield;
        if ([self.tabledataDic objectForKey:@"title"]) {
            self.TitleTextField.text = [self.tabledataDic objectForKey:@"title"];
           
        }
        cell = cell1;
    }else if(indexPath.row == 1){
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:IdentiCel2 forIndexPath:indexPath];
        UITextView *textView = (UITextView *)[cell2 viewWithTag:302];
        self.ContactTextView = textView;
        if ([self.tabledataDic objectForKey:@"content"]) {
            self.ContactTextView.text = [self.tabledataDic objectForKey:@"content"];
        }
        cell = cell2;
    }
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"删除内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我就是要删除", nil];
        [alert show];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 56;
    }else if (indexPath.row == 1){
        return 300;
    }
    return 44;
}

#pragma mark textfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //    [self loginAction];
    return YES;
}

#pragma mark 监听View点击事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:NO];
}

-(void)rightAction{
    if (self.TitleTextField.text.length <1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"标题不能为空"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (self.TitleTextField.text.length >50) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"标题不能超过50个字符"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.ContactTextView.text.length <1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"内容不能为空"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (self.ContactTextView.text.length >200) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"内容不能超过200个字符"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self.tabledataDic setObject:self.TitleTextField.text forKey:@"title"];
    [self.tabledataDic setObject:self.ContactTextView.text forKey:@"content"];
    __weak AddCustomSchedulePlanVC *vc = self;
    __weak MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.margin = 10.f;
    progressHUD.alpha=0.75;
   [[AFClient sharedCoachClient]getPath:@"Train_Defaine_Add" parameters:self.tabledataDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSDictionary *resultDict = nil;
       if ([responseObject isKindOfClass:[NSDictionary class]]) {
           resultDict = responseObject;
       }else{
           resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
       }
       if (resultDict) {
           if ([[resultDict objectForKey:@"_return"] integerValue] == 1) {
               [progressHUD hide:YES];
               if ([vc.delegate respondsToSelector:@selector(AddCustomSchedulePlanVCSuccessfulDelegate)]) {
                   [vc.delegate AddCustomSchedulePlanVCSuccessfulDelegate];
               }
               [progressHUD hide:YES];
           }else{
               progressHUD.labelText = @"保存失败";
               [progressHUD hide:YES afterDelay:2];
               
           }
       }
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       progressHUD.labelText = @"保存失败";
       [progressHUD hide:YES afterDelay:2];
   }];
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
