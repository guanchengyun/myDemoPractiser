//
//  SeletTypeLevelVC.m
//  数字健身
//
//  Created by 城云 官 on 14-6-24.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "SeletTypeLevelVC.h"
#import "ScheduleForInsertText.h"

@interface SeletTypeLevelVC ()

@property(strong, nonatomic)NSMutableDictionary *DictSectionFirst;
@property(strong, nonatomic)NSMutableArray *ArrayAdd;
@property(nonatomic, strong)UIAlertView *alertView;
@property(assign, nonatomic)NSInteger RemainingTime;
@property(strong, nonatomic)UILabel *Label_RemainingTime;
@property (weak, nonatomic)UITextField *textFieldName;
@end

@implementation SeletTypeLevelVC

static NSString *IdentifierCellSection0 = @"Cell0";
//static NSString *IdentifierCellSection1RowAdd = @"CellSection1RowAdd";
static NSString *IdentifierCellSection1 = @"Cell2";
static NSString *IdentifierCellSection1Row0 = @"Cell1";

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
    self.title = @"创建级别间隔";
    if (IS_IOS_7) {
        self.tableView.separatorInset = UIEdgeInsetsMake ( 0 , 0 , 0 , 0 );
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(barBtnSave)];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.Level_Id) {
        [self getModifyData];
    }
    
}

-(void)barBtnSave{
    [_DictSectionFirst setObject:self.textFieldName.text forKey:@"name"];

    for (NSString *str in self.DictSectionFirst.allValues) {
        if (str.length <1) {
            [self alertShow:@"内容不能为空"];
            return;
        }
    }
    
    NSMutableString *details = [[NSMutableString alloc]init];
    for (NSDictionary *dic in self.ArrayAdd) {
        for (NSString *str in dic.allValues) {
            if (str.length <1) {
                [self alertShow:@"输入内容不能为空"];
                return;
            }
        }
        [details appendString:[NSString stringWithFormat:@"%@,%@,%@,",dic[@"id"],dic[@"TTLD_Time"],dic[@"TTLD_Level"]]];
        
    }
    
    
    if (self.RemainingTime > 0) {
        [self alertShow:@"您拥有尚未分配给间隔的剩余时间"];
    }
    MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.margin = 10.f;
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.alpha=0.75;
    
    
    progressHUD.removeFromSuperViewOnHide = YES;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithDictionary:self.DictSectionFirst];
    [parameters setObject:details forKey:@"details"];
    __weak SeletTypeLevelVC *vc = self;
    [[AFClient sharedCoachClient]getPath:@"Train_Treadmill_Level_Add" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
//        NSLog(@"resultDict::%@",resultDict);
        if (resultDict) {
            if ([[resultDict objectForKey:@"_return"] integerValue] == 1) {
                [progressHUD hide:YES];
                if ([vc.delegate respondsToSelector:@selector(SeletTypeLevelVCDelegateSaveSuccessful)]) {
                    [vc.delegate SeletTypeLevelVCDelegateSaveSuccessful];
                    
                }
                [progressHUD hide:YES];
            }else{
                progressHUD.labelText = @"保存失败";
                [progressHUD hide:YES afterDelay:2];
                
            }
        }
        [progressHUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        progressHUD.labelText=@"保存失败";
        [progressHUD hide:YES afterDelay:2];
    }];
}

-(void)getModifyData{
    MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.margin = 10.f;
    progressHUD.alpha=0.75;
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    NSDictionary *parameters = @{@"id": self.Level_Id,
                                 @"username":username_str,
                                 @"password": username_pass,
                                 @"key":Key_HTTP,
                                 @"type":[self.dicGet objectForKey:@"TC_Type"]
                                 };
    __weak SeletTypeLevelVC *vc = self;
    [[AFClient sharedCoachClient]getPath:@"Train_Treadmill_List" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
//        NSLog(@"resultDict3333333::%@",resultDict);
        if (resultDict) {
            NSArray *array = [resultDict objectForKey:@"info"];
            NSDictionary *dictresu = [array objectAtIndex:0];
            if (dictresu.allKeys.count>0) {
                if ([dictresu objectForKey:@"FK_TC_ID"]) {
                     [_DictSectionFirst setObject:[[dictresu objectForKey:@"FK_TC_ID"] copy] forKey:@"FK_TC_ID"];
                }else{
                     NSLog(@"warn ::::FK_TC_ID is nil");
                }
                if ([dictresu objectForKey:@"TTL_Time"]) {
                     [self.DictSectionFirst setObject:[[dictresu objectForKey:@"TTL_Time"] copy] forKey:@"TTL_Time"];
                }else{
                    NSLog(@"warn ::::TTL_Time is nil");
                }
                if ([dictresu objectForKey:@"TTL_Name"]) {
                   [self.DictSectionFirst setObject:[[dictresu objectForKey:@"TTL_Name"] copy] forKey:@"name"];
                }else{
                    NSLog(@"warn ::::TTL_Name is nil");
                }
                
                if (self.FK_CIN_ID) {
                    [self.DictSectionFirst setObject:self.FK_CIN_ID forKey:@"FK_CIN_ID"];
                }else{
                    NSLog(@"warn ::::self.FK_CIN_ID is nil");
                }
                if ([dictresu objectForKey:@"ID"]) {
                     [self.DictSectionFirst setObject:[[dictresu objectForKey:@"ID"] copy] forKey:@"Level_Id"];
                }
               
                
                
                
                NSArray *arrayInfo2 = [dictresu objectForKey:@"info2"];
                if (arrayInfo2.count > 0) {
                    _ArrayAdd = [[NSMutableArray alloc]init];
                    for (NSDictionary *dict in arrayInfo2) {
                        NSMutableDictionary *mutdic = [[NSMutableDictionary alloc]init];
                        [mutdic setObject:[[dict objectForKey:@"ID"]copy] forKey:@"id"];
                        [mutdic setObject:[[dict objectForKey:@"TTLD_Level"]copy] forKey:@"TTLD_Level"];
                        [mutdic setObject:[[dict objectForKey:@"TTLD_Time"]copy] forKey:@"TTLD_Time"];
                        [_ArrayAdd addObject:mutdic];
                    }
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
        [vc.navigationController popViewControllerAnimated:YES];
        progressHUD.labelText=@"保存失败";
        [progressHUD hide:YES afterDelay:2];
    }];
    
}

-(NSMutableDictionary *)DictSectionFirst{
    if (!_DictSectionFirst) {
        NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
        NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
        _DictSectionFirst = [[NSMutableDictionary alloc]init];
        [_DictSectionFirst setObject:username_str forKey:@"username"];
        [_DictSectionFirst setObject:username_pass forKey:@"password"];
        [_DictSectionFirst setObject:Key_HTTP forKey:@"key"];
        if ([self.dicGet objectForKey:@"seletID"]) {
            [_DictSectionFirst setObject:[self.dicGet objectForKey:@"seletID"] forKey:@"FK_TC_ID"];

        }
        [_DictSectionFirst setObject:@"30" forKey:@"TTL_Time"];
        [_DictSectionFirst setObject:@"" forKey:@"name"];
        [_DictSectionFirst setObject:self.FK_CIN_ID forKey:@"FK_CIN_ID"];
        if (!_Level_Id) {
            [_DictSectionFirst setObject:@"-1" forKey:@"Level_Id"];
        }else{
            [_DictSectionFirst setObject:_Level_Id forKey:@"Level_Id"];
        }
    }
    return _DictSectionFirst;
}

-(NSMutableArray *)ArrayAdd{
    if (!_ArrayAdd) {
        _ArrayAdd = [[NSMutableArray alloc]init];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"-1",@"id",@"30",@"TTLD_Time",@"1",@"TTLD_Level", nil];
        [_ArrayAdd addObject:dic];
    }
    return _ArrayAdd;
}

//计算剩余多少时间
-(int)getRemainingTime:(NSInteger)indexArr{
    int addtotaltime = 0;
    for (int a=0; a<self.ArrayAdd.count; a++) {
        if (indexArr!=a) {
            addtotaltime = addtotaltime +[[self.ArrayAdd[a] objectForKey:@"TTLD_Time"] intValue];
        }
    }
    int totaltime = [[_DictSectionFirst objectForKey:@"TTL_Time"] intValue]*60;
    return (totaltime - addtotaltime);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        if (indexpathbutton.section == 0) {
            if (indexpathbutton.row == 0) {
                if (![[ScheduleForInsertText TotalTime]containsObject:string]) {
                    [self alertShow:@"请输入1-9的数字"];
                    isreturn = NO;
                }else{
                    int mintime = 0;
                    [_DictSectionFirst setObject:ChangeMutString forKey:@"TTL_Time"];
                    for (int a=0; a<self.ArrayAdd.count; a++) {
                        mintime = mintime +[[self.ArrayAdd[a] objectForKey:@"TTLD_Time"] intValue];
                    }
                    int remainingTime = [self getRemainingTime:self.ArrayAdd.count];
                    if (remainingTime<0) {
                        if (mintime%60 > 0) {
                            [_DictSectionFirst setObject:[NSString stringWithFormat:@"%d",(mintime/60+1)] forKey:@"TTL_Time"];
                        }else{
                            [_DictSectionFirst setObject:[NSString stringWithFormat:@"%d",(mintime/60)] forKey:@"TTL_Time"];
                        }
                    }else{
                        [_DictSectionFirst setObject:ChangeMutString forKey:@"TTL_Time"];
                    }
                }
            }else{
                if (ChangeMutString.length >50) {
                    [self alertShow:@"最多输入50字符"];
                    isreturn = NO;
                }else{
                    [_DictSectionFirst setObject:ChangeMutString forKey:@"name"];
                }
                
            }
        }else{
            NSMutableDictionary *mutArrayAddDict = [self.ArrayAdd objectAtIndex:indexpathbutton.row-1];
            //时间
            if (textField.tag == 100) {
                if (![[ScheduleForInsertText piecewiseString]containsObject:string]) {
                    [self alertShow:@"请输入0-9的数字或者:"];
                    isreturn = NO;
                }else{
                    NSString *stringInsert = [[ScheduleForInsertText sharedInstance] SecondsWithSegmentedTime:ChangeMutString];
                    int saveTime = [self getRemainingTime:indexpathbutton.row-1];
                    [mutArrayAddDict setObject:stringInsert forKey:@"TTLD_Time"];
                    int remainingTime = [self getRemainingTime:self.ArrayAdd.count];
                    
                    if (remainingTime <0) {
                        [mutArrayAddDict setObject:[NSString stringWithFormat:@"%d",saveTime] forKey:@"TTLD_Time"];
                        //                        textField.text = [[ScheduleForInsertText sharedInstance] MinutesAndSecondsWithSegmentedTime:saveTime];
                    }else{
                        //                        textField.text = [[ScheduleForInsertText sharedInstance] MinutesAndSecondsWithSegmentedTime:[stringInsert intValue]];
                        //                        isreturn = NO;
                        [mutArrayAddDict setObject:stringInsert forKey:@"TTLD_Time"];
                    }
                }
            }else if(textField.tag == 101){
                //心率79-200
                if (![[ScheduleForInsertText GradientString]containsObject:string]) {
                    [self alertShow:@"请输入0-9的数字"];
                    isreturn = NO;
                }else{
                    float changefg = [ChangeMutString floatValue];
                    if (changefg < 0) {
                        [mutArrayAddDict setObject:@"0" forKey:@"TTLD_Level"];
                        //                        textField.text = @"22.5";
                    }else if(changefg > 25){
                        [mutArrayAddDict setObject:@"25" forKey:@"TTLD_Level"];
                        
                    }else{
                        [mutArrayAddDict setObject:ChangeMutString forKey:@"TTLD_Level"];
                    }
                }
                
            }
        }
    }
    
    return isreturn;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSObject *obj1 = nil;
    if (IS_IOS_7) {
        obj1 = textField.superview.superview.superview;
    }else{
        obj1 = textField.superview.superview ;
    }
    if (obj1 && [obj1 isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell1 = (UITableViewCell *)obj1;
        NSIndexPath *indexpathbutton = [self.tableView indexPathForCell:cell1];
        if (indexpathbutton.section == 0) {
            if (indexpathbutton.row == 0) {
                textField.text = [_DictSectionFirst objectForKey:@"TTL_Time"];
            }else{
                
                textField.text = [_DictSectionFirst objectForKey:@"name"];
            }
        }else{
            NSMutableDictionary *mutArrayAddDict = [self.ArrayAdd objectAtIndex:indexpathbutton.row-1];
            //时间
            if (textField.tag == 100) {
                textField.text = [[ScheduleForInsertText sharedInstance]MinutesAndSecondsWithSegmentedTime:[[mutArrayAddDict objectForKey:@"TTLD_Time"] integerValue]];
            }else if(textField.tag == 101){
                //心率79-200
                textField.text = [mutArrayAddDict objectForKey:@"TTLD_Level"];
            }
        }
    }
    self.Label_RemainingTime.text=[NSString stringWithFormat:@"剩余时间:%d秒         ",self.RemainingTime];
}

-(NSInteger)RemainingTime{
    
    _RemainingTime = [self getRemainingTime:self.ArrayAdd.count];
    return _RemainingTime;
}

-(void)alertShow:(NSString *)string{
    
    if (self.alertView) {
        [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    }
    self.alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [self.alertView show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view data source
#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *sectionview = nil;
    if (section == 1) {
        NSString *sectionTile=[self tableView:tableView titleForFooterInSection:section];
        if(sectionTile==nil){
            return nil;
        }
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0, 0, self.tableView.bounds.size.width-5-18, 50);
        label.textColor=[UIColor redColor];
        label.textAlignment=NSTextAlignmentRight;
        label.text=sectionTile;
        label.backgroundColor=[UIColor clearColor];
        label.autoresizesSubviews = YES;
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.Label_RemainingTime = label;
        self.Label_RemainingTime = label;
        sectionview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width,tableView.bounds.size.height)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(sectionview.bounds.size.width - 250, 50, 224, 35);
        [button setBackgroundImage:[UIImage imageNamed:@"ScheduleAddPlanImage.png"] forState:UIControlStateNormal];
        button.autoresizesSubviews = YES;
        //        button.backgroundColor = [UIColor redColor];
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [button addTarget:self action:@selector(ButtonAddAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [sectionview addSubview:label];
        [sectionview addSubview:button];
        //        sectionview.backgroundColor = [UIColor blueColor];
    }
    
    //    sectionview.backgroundColor = [UIColor redColor];
    
    return sectionview;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return [NSString stringWithFormat:@"剩余时间:%d秒         ",self.RemainingTime];
    }else{
        return nil;
    }
    
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section == 1) {
//        return @"  剩余时间:30";
//    }else{
//        return nil;
//    }
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *sectionTile=[self tableView:tableView titleForHeaderInSection:section];
    if (IS_IOS_7) {
        return nil;
    }else{
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(0, 0, self.tableView.bounds.size.width, 50);
        label.textColor=[UIColor redColor];
        label.textAlignment=NSTextAlignmentLeft;
        label.text=sectionTile;
        label.backgroundColor=[UIColor clearColor];
        
        UIView *sectionview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width,tableView.bounds.size.height)];
        
        
        [sectionview addSubview:label];
        sectionview.backgroundColor = [UIColor clearColor];
        return sectionview;
    }
    
    
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (IS_IOS_7) {
        return 0;
    }else{
        return 30;
    }
    
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if(section == 1){
        return 100;
    }else{
        return 0;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 2;
    }else{
        return (self.ArrayAdd.count + 1);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *cellID = nil;
    if (indexPath.section == 0) {
        cellID = IdentifierCellSection0;
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            cellID = IdentifierCellSection1Row0;
        }
        else{
            cellID = IdentifierCellSection1;
        }
        
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    //    NSLog(@"inddd::%d   %d",indexPath.section, indexPath.row);
    if ([cell.reuseIdentifier isEqualToString:IdentifierCellSection0]) {
        UITextField *textField = (UITextField *)[cell viewWithTag:101];
        UILabel *label = (UILabel *)[cell viewWithTag:100];
        if (indexPath.row == 0) {
            label.text = @"输入总时间(4-99分钟)";
            textField.placeholder = nil;
            textField.text = [self.DictSectionFirst objectForKey:@"TTL_Time"];
            textField.keyboardType = UIKeyboardTypePhonePad;
        }else{
            label.text = @"健身程序名称";
            textField.text = [self.DictSectionFirst objectForKey:@"name"];
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.placeholder = @"最多输入50字符";
            self.textFieldName = textField;
            
        }
    }else if ([cell.reuseIdentifier isEqualToString:IdentifierCellSection1Row0]){
        
    }else if ([cell.reuseIdentifier isEqualToString:IdentifierCellSection1]){
        UITextField *textField100 = (UITextField *)[cell viewWithTag:100];//时间
        UITextField *textField101 = (UITextField *)[cell viewWithTag:101];//心率
        textField100.keyboardType = UIKeyboardTypePhonePad;
        textField101.keyboardType = UIKeyboardTypePhonePad;
        NSMutableDictionary *mutArrayAddDict = [self.ArrayAdd objectAtIndex:indexPath.row-1];
        if ([[mutArrayAddDict objectForKey:@"TTLD_Time"] length]>0) {
            textField100.text = [[ScheduleForInsertText sharedInstance]MinutesAndSecondsWithSegmentedTime:[[mutArrayAddDict objectForKey:@"TTLD_Time"] integerValue]];
        }
        
        textField101.text = [mutArrayAddDict objectForKey:@"TTLD_Level"];
        
    }
    // Configure the cell...
    
    return cell;
}


-(IBAction)BtnLeftAction:(id)sender{
    if (self.RemainingTime>0) {
    }else{
        [self alertShow:@"剩余时间为0，不可添加"];
        return;
    }
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        NSObject *obj1 = nil;
        if (IS_IOS_7) {
            obj1 = btn.superview.superview.superview;
        }else{
            obj1 = btn.superview.superview ;
        }
        
        if (obj1 && [obj1 isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell1 = (UITableViewCell *)obj1;
            
            NSIndexPath *indexpathbutton = [self.tableView indexPathForCell:cell1];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"-1",@"id",@"30",@"TTLD_Time",@"1",@"TTLD_Level", nil];
            [_ArrayAdd insertObject:dic atIndex:(indexpathbutton.row-1)];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexpathbutton] withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView reloadData];
        }
    }
}

-(IBAction)BtnRightAction:(id)sender{
    
    if (self.ArrayAdd.count<2) {
        return;
    }
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        NSObject *obj1 = nil;
        if (IS_IOS_7) {
            obj1 = btn.superview.superview.superview;
        }else{
            obj1 = btn.superview.superview ;
        }
        
        if (obj1 && [obj1 isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell1 = (UITableViewCell *)obj1;
            
            NSIndexPath *indexpathbutton = [self.tableView indexPathForCell:cell1];
            
            // NSLog(@"indepath====%@", indexpathtextfield);
            //            NSLog(@"indexpathtextfield::%d   %d",indexpathbutton.section,indexpathbutton.row);
            
            [_ArrayAdd removeObjectAtIndex:(indexpathbutton.row-1)];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpathbutton] withRowAnimation:UITableViewRowAnimationTop];;
            
            [self.tableView reloadData];
        }
        
    }
    
}

-(IBAction)ButtonAddAction:(UIButton *)buton{
    if (self.RemainingTime>0) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"-1",@"id",@"30",@"TTLD_Time",@"1",@"TTLD_Level", nil];
        [_ArrayAdd addObject:dic];
        [self.tableView reloadData];
    }else{
        [self alertShow:@"剩余时间为0，不可添加"];
    }
    
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
