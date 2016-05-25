//
//  SchedulePagePlanTVC.m
//  数字健身
//
//  Created by 城云 官 on 14-6-13.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "SchedulePagePlanTVC.h"
#import "SelectTypeTrainingVC.h"
#import "AddAerobicPlanTVC.h"
#import "SeletTypeHeartRateVC.h"
#import "SeletTypeLevelVC.h"
#import "AddPowerTVC.h"
#import "AddCustomSchedulePlanVC.h"
#import "SchedulePagePlanSenderMessageVC.h"

@interface SchedulePagePlanTVC ()<SelectTypeTrainingDelegate,AddPowerTVCDelegate,AddAerobicPlanTVCDelegate,SeletTypeHeartRateVCDelegate,SeletTypeLevelVCDelegate,AddCustomSchedulePlanVCDelegate>{
    UIBarButtonItem *addbarbutton;
}

@property (strong, nonatomic)NSDictionary *DicPathTrain_List;
@property (strong, nonatomic)SelectTypeTrainingVC *seletTypeVC;
@property (strong, nonatomic)UIPopoverController *seletTypePoper;
@property (strong, nonatomic)UIPopoverController *popviewSenderMessageVC;
@property (strong, nonatomic)NSMutableArray *tableData;
@property (strong, nonatomic)NSArray *images;

@end

@implementation SchedulePagePlanTVC

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
    self.title = @"训练计划";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *ComposebarBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(ComposebarBtnAction)];
    addbarbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAction)];
    UIBarButtonItem *deletbarbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deletbarbuttonAction)];

    self.navigationItem.rightBarButtonItems = @[addbarbutton,deletbarbutton,ComposebarBtn];
    addbarbutton.enabled = NO;
    self.seletTypeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectTypeTrainingVC"];
    self.seletTypeVC.delegate = self;
    self.seletTypePoper = [[UIPopoverController alloc]initWithContentViewController:self.seletTypeVC];
    
    SchedulePagePlanSenderMessageVC *schsenderbvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SchedulePagePlanSenderMessageVC"];
    schsenderbvc.CIN_ID = self.FK_CIN_ID;
    self.popviewSenderMessageVC = [[UIPopoverController alloc]initWithContentViewController:schsenderbvc];
    schsenderbvc.popverCT = self.popviewSenderMessageVC;
    
    [self PathTrain_List];
    [self Train_Title_List];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView setEditing:NO animated:YES];
}

-(void)ComposebarBtnAction{
    if (self.popviewSenderMessageVC) {
        CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.bounds.size.height/2, 1, 1);
        
        
        [self.popviewSenderMessageVC presentPopoverFromRect:rect inView:self.navigationController.view permittedArrowDirections:0 animated:YES];
    }
   
}

#pragma mark - Rotation support

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	// If the detail popover is presented, dismiss it.
	if (self.popviewSenderMessageVC != nil)
    {
		[self.popviewSenderMessageVC dismissPopoverAnimated:YES];
	}
  
}


-(void)deletbarbuttonAction{
    
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
    }else{
        [self.tableView setEditing:YES  animated:YES];
    }

}

-(void)rightAction{
    if (self.DicPathTrain_List) {
        self.seletTypeVC.ArrayAerobic =[self.DicPathTrain_List objectForKey:@"info"];
        self.seletTypeVC.arrayPower =[self.DicPathTrain_List objectForKey:@"info3"];
        [self.seletTypePoper presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
       
//        CGRect rect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 1, 1);
//        [self.seletTypePoper presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
   
}

-(NSArray *)images{
    if (!_images) {
        _images = @[@"靠背式健身车png",@"立式健身车.png",@"跑步机.png",@"全功能训练机.png"];
    }
    return _images;
}

#pragma mark ------- SelectTypeTrainingDelegate -----------
-(void)pickerDidChaneStatus:(NSDictionary *)picker{
     [self.seletTypePoper dismissPopoverAnimated:YES];
    if (picker == nil) {
    }else{
        NSString *tc_type = [picker objectForKey:@"TC_Type"];
        if ([picker objectForKey:@"TC_Type"]) {
           
            if([tc_type isEqualToString:@"1"]){
                [self performSegueWithIdentifier:@"ToAddAerobicPlanTVC" sender:picker];
            }else if([tc_type isEqualToString:@"2"]){
                [self performSegueWithIdentifier:@"ToSeletTypeHeartRateVC" sender:picker];
            }else if ([tc_type isEqualToString:@"3"]){
                [self performSegueWithIdentifier:@"ToSeletTypeLevelVC" sender:picker];
            }
        }else if ([picker objectForKey:@"TPT_ID"]){
            [self performSegueWithIdentifier:@"PushAddPowerTVC" sender:picker];
        }else if ([picker objectForKey:@"自定义"]){
            [self performSegueWithIdentifier:@"PushAddCustomSchedulePlanVC" sender:nil];
        }
//        NSLog(@"pick::%@",picker);
    }
//    if ([picker isEqualToString:@"no"]) {
//        [self.seletTypePoper dismissPopoverAnimated:YES];
//
//    }else{
//        [self.seletTypePoper dismissPopoverAnimated:YES];
////        NSLog(@"picker::%@",picker);
//        if([picker isEqualToString:@"1"]){
//           [self performSegueWithIdentifier:@"ToAddAerobicPlanTVC" sender:nil];
//        }else if([picker isEqualToString:@"2"]){
//            [self performSegueWithIdentifier:@"ToSeletTypeHeartRateVC" sender:nil];
//        }else if ([picker isEqualToString:@"3"]){
//            [self performSegueWithIdentifier:@"ToSeletTypeLevelVC" sender:nil];
//        }
////
//    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ToAddAerobicPlanTVC"]) {
        AddAerobicPlanTVC *addaerobicvc = segue.destinationViewController;
        addaerobicvc.FK_CIN_ID = self.FK_CIN_ID;
        addaerobicvc.delegate = self;
        if ([sender isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dic = (NSDictionary *)sender;
            if ([dic objectForKey:@"ID"]) {
                addaerobicvc.Speed_Id = [dic objectForKey:@"ID"];

            }else{
               
            }
             addaerobicvc.dicGet = dic;
        }
       
    }else if([segue.identifier isEqualToString:@"ToSeletTypeHeartRateVC"]){
        SeletTypeHeartRateVC *seletheartvc = segue.destinationViewController;
        seletheartvc.FK_CIN_ID = self.FK_CIN_ID;
        seletheartvc.delegate = self;
        if ([sender isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)sender;
            if ([dic objectForKey:@"ID"]) {
                seletheartvc.Heart_Id = [dic objectForKey:@"ID"];

            }else{
                seletheartvc.dicGet = dic;
            }
            seletheartvc.dicGet = dic;
        }
        
        
    }else if([segue.identifier isEqualToString:@"ToSeletTypeLevelVC"]){
        SeletTypeLevelVC *seletlevelvc = segue.destinationViewController;
        seletlevelvc.FK_CIN_ID = self.FK_CIN_ID;
        seletlevelvc.delegate = self;
        if ([sender isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)sender;
            if ([dic objectForKey:@"ID"]) {
                seletlevelvc.Level_Id = [dic objectForKey:@"ID"];

            }else{
               
            }
            seletlevelvc.dicGet = dic;
        }
       
    }else if([segue.identifier isEqualToString:@"PushAddPowerTVC"]){
        AddPowerTVC *addpowervc = segue.destinationViewController;
        addpowervc.delegate = self;
        addpowervc.contract_id = self.FK_CIN_ID;
        if ([sender isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)sender;
            if ([dic objectForKey:@"TP_ID"]) {
                addpowervc.Power_id = [dic objectForKey:@"TP_ID"];
                addpowervc.title = [dic objectForKey:@"TPT_Name"];
                addpowervc.dicGet = dic;
            }else{
                addpowervc.dicGet = dic;
                addpowervc.title = [dic objectForKey:@"TypeName"];
            }
        }
    }else if([segue.identifier isEqualToString:@"PushAddCustomSchedulePlanVC"]){
        AddCustomSchedulePlanVC *addcustom = segue.destinationViewController;
        addcustom.contract_id = self.FK_CIN_ID;
        addcustom.delegate = self;
        if ([sender isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)sender;
            if ([dic objectForKey:@"TD_ID"]) {
                addcustom.define_id = [dic objectForKey:@"TD_ID"];
            }
        
        }
    }

}

#pragma mark refresh tableviewdata  http===========
//添加选择列表
-(void)PathTrain_List{
    
    __weak SchedulePagePlanTVC *vc=self;
    //    __weak MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:username_str,@"username",username_pass,@"password", Key_HTTP, @"key",nil];
    //    progressHUD.removeFromSuperViewOnHide = YES;
    [[AFClient sharedCoachClient]getPath:@"Train_List" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict.count>0) {
            //NSLog(@"resultDict111::%@",resultDict);
            vc.DicPathTrain_List = resultDict;
            addbarbutton.enabled = YES;
        }else{
            [vc.navigationController popViewControllerAnimated:YES];
        }
        //        [progressHUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [vc.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)Train_Title_List{
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    if (!username_str) {
        return;
    }
    
    if (!username_pass) {
        return;
    }
    
    if (!self.FK_CIN_ID) {
        return;
    }
    
    NSDictionary *parameters = @{@"contract_id": self.FK_CIN_ID,
                                 @"username":username_str,
                                 @"password":username_pass,
                                 @"key":Key_HTTP
                                 };
    
    __weak MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    progressHUD.removeFromSuperViewOnHide = YES;
    __weak SchedulePagePlanTVC *vc = self;

    [[AFClient sharedCoachClient]getPath:@"Train_Title_List" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict.count >0) {
            NSLog(@"resultDict::%@",resultDict);
            self.tableData = [[NSMutableArray alloc]init];
            NSMutableArray *inf1array = [[NSMutableArray alloc]init];
            NSMutableArray *inf2array = [[NSMutableArray alloc]init];
            NSMutableArray *inf3morearray = [[NSMutableArray alloc]init];
            for (NSArray *array in resultDict.allValues) {
                for (NSDictionary *dic in array) {
                    switch (dic.count) {
                        case 2:{
                            [inf1array addObject:[dic copy]];
                        }
                            break;
                        case 3:
                        {
                            [inf2array addObject:[dic copy]];
                        }
                            break;
                        default:{
                            [inf3morearray addObject:[dic copy]];
                        }
                            break;
                    }
                }
             
            }
//            if ([resultDict[@"info1"] count]>0) {
//                NSMutableArray *mutarray = [NSMutableArray arrayWithArray:resultDict[@"info1"]];
//                [vc.tableData addObject:mutarray];
//            }
//            
//            if ([resultDict[@"info2"] count]>0) {
//                NSMutableArray *mutarray = [NSMutableArray arrayWithArray:resultDict[@"info2"]];
//                [vc.tableData addObject:mutarray];
//            }
            if (inf2array.count >0) {
                [self.tableData addObject:inf2array];
            }
            if (inf1array.count >0) {
                [self.tableData addObject:inf1array];
            }
            
            if (inf3morearray.count >0) {
                [self.tableData addObject:inf3morearray];
            }
           
            [vc.tableView reloadData];
        }
        
        [progressHUD hide:YES];
        
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        progressHUD.labelText = @"失败";
        [progressHUD hide:YES afterDelay:2];
    }];

}

-(void)Train_Detail_Delete:(NSDictionary *)parameters indexpath:(NSIndexPath *)indexpath{
    __weak MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    progressHUD.removeFromSuperViewOnHide = YES;
    __weak SchedulePagePlanTVC *vc = self;
    
    [[AFClient sharedCoachClient]getPath:@"Train_Detail_Del" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
        }
       
        if ([[resultDict objectForKey:@"_return"] integerValue] == 1) {
//            NSLog(@"indexPath.section::%d",indexpath.row);
            NSMutableArray *mutarray = self.tableData[indexpath.section];
            [mutarray removeObjectAtIndex:indexpath.row];
            if (mutarray.count == 0) {
                [vc.tableData removeObjectAtIndex:indexpath.section];
                [vc.tableView reloadData];
            }else{
                [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
            }

        }
        [progressHUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        progressHUD.labelText = @"删除失败";
        [progressHUD hide:YES afterDelay:2];
    }];
    

}

#pragma mark AddPowerTVCDelegate ===========
-(void)AddPowerTVCSaveSuccessfulDelegate{
    [self.navigationController popViewControllerAnimated:YES];
    [self Train_Title_List];
}

#pragma mark AddAerobicPlanTVCDelegate ==========
-(void)AddAerobicPlanTVCDelegateSaveSuccessful{
    [self.navigationController popViewControllerAnimated:YES];
    [self Train_Title_List];
}

#pragma mark SeletTypeHeartRateVCDelegate ==========
-(void)SeletTypeHeartRateVCDelegateSaveSuccessful{
 [self.navigationController popViewControllerAnimated:YES];
    [self Train_Title_List];
}

#pragma mark SeletTypeLevelVCDelegate ===========
-(void)SeletTypeLevelVCDelegateSaveSuccessful{
 [self.navigationController popViewControllerAnimated:YES];
    [self Train_Title_List];
}

#pragma mark AddCustomSchedulePlanVCDelegate ======
-(void)AddCustomSchedulePlanVCSuccessfulDelegate{
[self.navigationController popViewControllerAnimated:YES];
    [self Train_Title_List];
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
    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.tableData[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IdentifierCell0 = @"Cell0";
    //static NSString *IdentifierCellSection1RowAdd = @"CellSection1RowAdd";
    static NSString *IdentifierCell1 = @"Cell1";
    static NSString *IdentifierCell2 = @"Cell2";
    NSString *cellIdentifier = IdentifierCell0;
    NSArray *array = self.tableData[indexPath.section];
    switch ([[array[indexPath.row] allKeys] count]) {
        case 2:
            cellIdentifier = IdentifierCell1;
            break;
        case 3:
            cellIdentifier = IdentifierCell0;
            break;
        default:
            cellIdentifier = IdentifierCell2;

            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ([cell.reuseIdentifier isEqualToString:IdentifierCell0]) {
        cell.textLabel.text = array[indexPath.row][@"TP_Title"];
        cell.detailTextLabel.text = array[indexPath.row][@"TPT_Name"];
    }else if([cell.reuseIdentifier isEqualToString:IdentifierCell1]){
        cell.textLabel.text = array[indexPath.row][@"TD_Title"];
    }else{
        
        UILabel *labelTR_Name = (UILabel *)[cell viewWithTag:100];
        UILabel *labelTC_Type_Name = (UILabel *)[cell viewWithTag:101];
        UILabel *labelTTL_Time = (UILabel *)[cell viewWithTag:103];
        UILabel *labelTTS_Name = (UILabel *)[cell viewWithTag:105];
        labelTR_Name.text = array[indexPath.row][@"TR_Name"];
        labelTC_Type_Name.text = array[indexPath.row][@"TC_Type_Name"];
        
        labelTTS_Name.text = array[indexPath.row][@"Name"];
        labelTTL_Time.text = array[indexPath.row][@"Time"];
        NSInteger imageNumber = [array[indexPath.row][@"TR_ID"] integerValue];
        UIImageView *imageview = (UIImageView *)[cell viewWithTag:106];
        if (imageNumber < self.images.count) {
             imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.images[imageNumber]]];
        }
       
    }
    // Configure the cell...
    
    return cell;
}


-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
   NSArray *array = self.tableData[indexPath.section];
    switch ([[array[indexPath.row] allKeys] count]) {
        case 2:
            return 44;
            break;
        case 3:
            return 44;
            break;
        default:
            return 139;
            
            break;
    }
        
    return 139;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *array = self.tableData[section];
    switch ([[array[0] allKeys] count]) {
        case 2:
            return @"  自定义";
            break;
        case 3:
            return @"  力量";
            break;
        default:
            return @"  有氧";
            
            break;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = self.tableData[indexPath.section];
    switch ([[array[indexPath.row] allKeys] count]) {
        case 2:
            [self performSegueWithIdentifier:@"PushAddCustomSchedulePlanVC" sender:array[indexPath.row]];
            break;
        case 3:
            [self performSegueWithIdentifier:@"PushAddPowerTVC" sender:array[indexPath.row]];
            break;
        default:{
            NSInteger numberType = [array[indexPath.row][@"TC_Type"] integerValue];
            if(numberType == 1){
                [self performSegueWithIdentifier:@"ToAddAerobicPlanTVC" sender:array[indexPath.row]];
            }else if(numberType ==2 ){
                [self performSegueWithIdentifier:@"ToSeletTypeHeartRateVC" sender:array[indexPath.row]];
            }else if (numberType == 3){
                [self performSegueWithIdentifier:@"ToSeletTypeLevelVC" sender:array[indexPath.row]];
            }
        }
            break;
    }
    

}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
//        NSLog(@"indexPath.section::%d",indexPath.row);
        NSArray *array = self.tableData[indexPath.section];
        NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
        
        NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
        if (!username_str) {
            return;
        }
        
        if (!username_pass) {
            return;
        }
       
        switch ([[array[indexPath.row] allKeys] count]) {
            case 2:{
                if ([array[indexPath.row] objectForKey:@"TD_ID"]) {
                    
                }
                NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:username_str,@"username",username_pass,@"password", Key_HTTP, @"key",[array[indexPath.row] objectForKey:@"TD_ID"],@"id",@"5",@"type",nil];
                [self Train_Detail_Delete:parameters indexpath:indexPath];
            }
                break;
            case 3:{
                if ([array[indexPath.row] objectForKey:@"TP_ID"]) {
                    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:username_str,@"username",username_pass,@"password", Key_HTTP, @"key",[array[indexPath.row] objectForKey:@"TP_ID"],@"id",@"4",@"type",nil];
                    [self Train_Detail_Delete:parameters indexpath:indexPath];
                }
            }
                break;
            default:{
                if (([array[indexPath.row] objectForKey:@"ID"])&&([array[indexPath.row] objectForKey:@"TC_Type"])) {
                    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:username_str,@"username",username_pass,@"password", Key_HTTP, @"key",[array[indexPath.row] objectForKey:@"ID"],@"id",[array[indexPath.row] objectForKey:@"TC_Type"],@"type",nil];
                    [self Train_Detail_Delete:parameters indexpath:indexPath];
                }
            }
                break;
        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


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
