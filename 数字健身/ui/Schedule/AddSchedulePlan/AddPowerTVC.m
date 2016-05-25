//
//  AddPowerTVC.m
//  数字健身
//
//  Created by 城云 官 on 14-6-30.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "AddPowerTVC.h"

@interface AddPowerTVC ()

@property(strong, nonatomic)NSMutableDictionary *DictPath;
@property(strong, nonatomic)NSArray *tableLeftData;
@property(strong, nonatomic)NSArray *tableLeftKeyData;
@property (strong, nonatomic) UIButton *LeftButton;
@property (strong, nonatomic) UIButton *RightButton;
@property(nonatomic, strong)UIAlertView *alertView;
@property (weak, nonatomic)UITextField *textFieldName;
@end

@implementation AddPowerTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSMutableDictionary *)DictPath{
    if (!_DictPath) {
        _DictPath = [[NSMutableDictionary alloc] init];
        if (self.Power_id) {
            [_DictPath setObject:self.Power_id forKey:@"pow_id"];
        }else{
            [_DictPath setObject:@"-1" forKey:@"pow_id"];
        }
        
        if (self.contract_id) {
            [_DictPath setObject:self.contract_id forKey:@"contract_id"];
        }
        if ([self.dicGet objectForKey:@"TPT_ID"]) {
             [_DictPath setObject:[self.dicGet objectForKey:@"TPT_ID"] forKey:@"type"];
        }
       
        [_DictPath setObject:@"" forKey:@"title"];
        [_DictPath setObject:@"1" forKey:@"method"];
        [_DictPath setObject:@"" forKey:@"weight"];
        [_DictPath setObject:@"" forKey:@"group"];
        [_DictPath setObject:@"" forKey:@"number"];
        [_DictPath setObject:@"" forKey:@"time"];
        [_DictPath setObject:@"" forKey:@"restTime"];
        
        NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
        NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
        [_DictPath setObject:username_str forKey:@"username"];
        [_DictPath setObject:username_pass forKey:@"password"];
        [_DictPath setObject:Key_HTTP forKey:@"key"];
    }
    return _DictPath;
}

-(NSArray *)tableLeftData{
    if (!_tableLeftData) {
        _tableLeftData = @[@"标题",@"方式：1正时0倒时",@"重量(单位磅)",@"组次",@"次数",@"时间(单位秒)",@"休息时间(单位秒)"];
    }
    return _tableLeftData;
}

-(NSArray *)tableLeftKeyData{
    if (!_tableLeftKeyData) {
        _tableLeftKeyData = @[@"title",@"method",@"weight",@"group",@"number",@"time",@"restTime"];
    }
    return _tableLeftKeyData;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *rightbarBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(rightbarBtnAction)];
    self.navigationItem.rightBarButtonItem = rightbarBtn;
    self.title = [self.dicGet objectForKey:@"TypeName"];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.Power_id) {
        [self getModifyData];
    }
}

-(void)getModifyData{
   
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    NSDictionary *parameters = @{@"id": self.Power_id,
                                 @"username":username_str,
                                 @"password": username_pass,
                                 @"key":Key_HTTP,
                                };
    __weak AddPowerTVC *vc = self;
    MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.margin = 10.f;
    progressHUD.alpha=0.75;
    [[AFClient sharedCoachClient]getPath:@"Train_Power_List" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                if ([dictresu  objectForKey:@"FK_TPT_ID"]) {
                    [vc.DictPath setObject:[dictresu objectForKey:@"FK_TPT_ID"] forKey:@"type"];
                }
                if([dictresu objectForKey:@"TPT_Name"]) {
                    vc.title = [dictresu objectForKey:@"TPT_Name"];
                }
                if([dictresu objectForKey:@"TP_Title"]) {
                    [vc.DictPath setObject:[dictresu objectForKey:@"TP_Title"] forKey:@"title"];
                }
                if([dictresu objectForKey:@"TP_Group"]) {
                    [vc.DictPath setObject:[dictresu objectForKey:@"TP_Group"] forKey:@"group"];
                }
                if([dictresu objectForKey:@"TP_Method"]) {
                    [vc.DictPath setObject:[dictresu objectForKey:@"TP_Method"] forKey:@"method"];
                }
                if([dictresu objectForKey:@"TP_Number"]) {
                    [vc.DictPath setObject:[dictresu objectForKey:@"TP_Number"] forKey:@"number"];
                }
                if([dictresu objectForKey:@"TP_RestTime"]) {
                    [vc.DictPath setObject:[dictresu objectForKey:@"TP_RestTime"] forKey:@"restTime"];
                }
                if([dictresu objectForKey:@"TP_Time"]) {
                    [vc.DictPath setObject:[dictresu objectForKey:@"TP_Time"] forKey:@"time"];
                }
                if([dictresu objectForKey:@"TP_Weight"]) {
                    [vc.DictPath setObject:[dictresu objectForKey:@"TP_Weight"] forKey:@"weight"];
                }
//                [vc.dic setObject:@"" forKey:@"title"];
                [vc.tableView reloadData];
            }else{
                [vc.navigationController popViewControllerAnimated:YES];
            }
            
        }else{
            [vc.navigationController popViewControllerAnimated:YES];
        }
        [progressHUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [progressHUD hide:YES];
        progressHUD.labelText=@"请求失败";
        [progressHUD hide:YES afterDelay:2];
        [vc.navigationController popViewControllerAnimated:YES];
    }];
    

}

-(void)rightbarBtnAction{
//    NSLog(@"DictPath::%@",self.DictPath);
    
    __weak AddPowerTVC *vc = self;
    [self.DictPath setObject:self.textFieldName.text forKey:[self.tableLeftKeyData objectAtIndex:0]];
    for (NSObject *obj in self.DictPath.allValues) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *str=(NSString *)obj;
            if (str.length <1) {
                [self alertShow:@"内容不能为空"];
                return;
            }
        }
       
    }
   
    __weak MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.margin = 10.f;
    progressHUD.alpha=0.75;
    [[AFClient sharedCoachClient]getPath:@"Train_Power_Add" parameters:self.DictPath success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
            if ([[resultDict objectForKey:@"_return"] integerValue] == 1) {
                [progressHUD hide:YES];
                if ([vc.delegate respondsToSelector:@selector(AddPowerTVCSaveSuccessfulDelegate)]) {
                      [vc.delegate AddPowerTVCSaveSuccessfulDelegate];
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

-(void)alertShow:(NSString *)string{
    
    if (self.alertView) {
        [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    }
    self.alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [self.alertView show];
}

#pragma mark - uitextfield delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL isreturn = YES;
    NSMutableString *ChangeMutString = nil;
    if (string.length > 0) {
        ChangeMutString = [[NSMutableString alloc] initWithString:textField.text];
        [ChangeMutString insertString:string atIndex:range.location];
        //        NSLog(@"MutString ::%@",MutString);
    }else{
        ChangeMutString = [[NSMutableString alloc] initWithString:textField.text];
        [ChangeMutString replaceCharactersInRange:range withString:string];
        //        NSLog(@"MutString ::%@",MutString);
    }
    
    NSObject *obj1 = nil;
    if (IS_IOS_7) {
        obj1 = textField.superview.superview.superview;
    }else{
        obj1 = textField.superview.superview ;
    }
    if (obj1 && [obj1 isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell1 = (UITableViewCell *)obj1;
        NSIndexPath *indexpathbutton = [self.tableView indexPathForCell:cell1];
        if (indexpathbutton.row == 0) {
            if (ChangeMutString.length >50) {
                isreturn = NO;
            }else{
                [self.DictPath setObject:ChangeMutString forKey:[self.tableLeftKeyData objectAtIndex:indexpathbutton.row]];
            }
            
        }else if (indexpathbutton.row == 2) {
            if (![@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"",@"."]containsObject:string]) {
                isreturn = NO;
            }else{
                [self.DictPath setObject:ChangeMutString forKey:[self.tableLeftKeyData objectAtIndex:indexpathbutton.row]];
            }

        }else{
            if (![@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@""]containsObject:string]) {
                isreturn = NO;
            }else{
                [self.DictPath setObject:ChangeMutString forKey:[self.tableLeftKeyData objectAtIndex:indexpathbutton.row]];
            }
        }
        
    }
    
    return isreturn;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
    NSInteger count = self.tableLeftKeyData.count;
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier0 = @"Cell0";
    static NSString *Identifier1 = @"Cell1";
    NSString *identifier;
    if (indexPath.row == 1) {
        identifier = Identifier0;
    }else{
        identifier = Identifier1;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if ([cell.reuseIdentifier isEqualToString:Identifier0]) {
        UIButton *button101 = (UIButton *)[cell viewWithTag:101];
        UIButton *button102 = (UIButton *)[cell viewWithTag:102];
        
        self.LeftButton = button101;
        self.RightButton = button102;
        self.LeftButton.selected =[[self.DictPath objectForKey:[self.tableLeftKeyData objectAtIndex:indexPath.row]] boolValue];
        self.RightButton.selected =![[self.DictPath objectForKey:[self.tableLeftKeyData objectAtIndex:indexPath.row]] boolValue];
        
    }else{
       
        UITextField *textField = (UITextField *)[cell viewWithTag:101];
        if (indexPath.row == 0) {
            self.textFieldName = textField;
        }
        textField.text = [self.DictPath objectForKey:[self.tableLeftKeyData objectAtIndex:indexPath.row]];
        if (indexPath.row == 0) {
            textField.keyboardType = UIKeyboardTypeDefault;
        }else{
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
     UILabel *label = (UILabel *)[cell viewWithTag:100];
     label.text = [self.tableLeftData objectAtIndex:indexPath.row];
    // Configure the cell...
    
   
    return cell;
}

- (IBAction)RightButtonAction:(id)sender {
    self.RightButton.selected = !self.RightButton.selected;
    self.LeftButton.selected = !self.RightButton.selected;
    
    [self.DictPath setObject:[NSNumber numberWithBool:self.LeftButton.selected] forKey:@"method"];
}

- (IBAction)LeftButtonAction:(id)sender {
    self.LeftButton.selected = !self.LeftButton.selected;
    self.RightButton.selected = !self.LeftButton.selected;
    [self.DictPath setObject:[NSNumber numberWithBool:self.LeftButton.selected] forKey:@"method"];
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
