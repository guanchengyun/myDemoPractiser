//
//  AddTargetPlan.m
//  数字健身
//
//  Created by 城云 官 on 14-5-23.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "AddTargetPlan.h"
#import "TargetPlanList.h"
#import "PiecewiseList.h"
#import "TargetAttrList.h"
#import "TargetAttrCell.h"

#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kDatePickerTag              99     // view tag identifiying the date picker view

#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value
#define AperiodKey      @"periotile"

// keep track of which rows have date cells
#define kDateStartRow   0
#define kDateEndRow     1

static NSString *kDateCellID = @"dateCell";     // the cells with the start or end date
static NSString *kDatePickerID = @"datePicker"; // the cell containing the date picker
static NSString *kOtherCell = @"otherCell";     // the remaining cells at the end
static NSString *TargertListCell = @"TargertListCell";
static NSString *textViewCellID = @"textViewCell";

@interface AddTargetPlan ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (nonatomic, strong) NSIndexPath *textFieldIndexPath;
@property (nonatomic, strong) UIView *textFieldView;

@property (assign) NSInteger pickerCellRowHeight;

@property (nonatomic, weak) IBOutlet UIDatePicker *pickerView;

@property (nonatomic, strong)UIAlertView *alertView;
@property (nonatomic, weak)UITextField *textFieldName;

@end

@implementation AddTargetPlan

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
    UIBarButtonItem *BarButtonItemSave = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarActionSave)];
  
    self.navigationItem.rightBarButtonItems = @[BarButtonItemSave];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
//    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
//    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerID];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
    
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    if (!self.ID) {
        self.ID=@"-1";
    }
    if (!self.target_id) {
        self.target_id = @"-1,";
    }
    
    switch (self.AddMetod) {
        case AddTotalGoalMethod:{
            self.title = @"添加总目标";
        }
            break;
        case ModifyTotalGoalMethod:{
            self.title = @"修改总目标";
            [self GetList_TargetAndStage];
        }
            break;
        case AddPhaseMethod:{
            self.title = @"添加分段目标";
        }
            break;
        case ModifyPhaseMethod:{
            self.title = @"修改分段目标";
            [self GetList_TargetAndStage];
        }
            break;
            
        default:
            break;
    }
}

//匹配目标阶段目标（也叫分段目标）计划列表

//匹配目标计划列表
-(void)GetList_TargetAndStage{
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:username_str,@"username",username_pass,@"password",Key_HTTP,@"key",[NSString stringWithFormat:@"%d",self.listerMenber.ID],@"userid",nil];
    __weak  MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    //    progressHUD.mode=MBProgressHUDModeText;
    progressHUD.margin = 10.f;
    progressHUD.yOffset = self.view.bounds.origin.y;
    progressHUD.alpha=0.75;
    progressHUD.removeFromSuperViewOnHide = YES;
    NSString *pathString = nil;
    switch (self.AddMetod) {
        case AddTotalGoalMethod:
            break;
        case ModifyTotalGoalMethod:{
            pathString = @"GetList_Target";
            [parameters setObject:self.ID forKey:@"targetid"];
        }
            break;
        case AddPhaseMethod:
            break;
        case ModifyPhaseMethod:{
            pathString = @"GetList_Stage";
             [parameters setObject:self.ID forKey:@"stageid"];
        }
            break;
            
        default:
            break;
    }
    NSLog(@"parameters::%@",parameters);
    __weak AddTargetPlan *vc = self;
    [[AFClient sharedCoachClient]getPath:pathString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
//            NSLog(@"resultDict::%@",resultDict);
            NSDictionary *dicinfo = [[resultDict objectForKey:@"info"] firstObject];
            switch (vc.AddMetod) {
                case AddTotalGoalMethod:
                    break;
                case ModifyTotalGoalMethod:{
                    PiecewiseList *pielist = vc.dataArray.firstObject;
                    pielist.Title = [dicinfo objectForKey:@"TU_CD"];
                    pielist.DateStart = [self dateFromString:[dicinfo objectForKey:@"TU_DateStart"]];
                    pielist.DateEnd = [self dateFromString:[dicinfo objectForKey:@"TU_DateEnd"]];
                    
                    NSArray *arrayinfo2 = [dicinfo objectForKey:@"info2"];
                    for (NSDictionary *dict in arrayinfo2) {
                        for (TargetAttrList *targetlis in self.tagetListArr) {
                            if (targetlis.ID == [[dict objectForKey:@"FK_TA_ID"] intValue]) {
                                targetlis.TA_DetailContent = [dict objectForKey:@"TUD_Number"];
                                targetlis.isIncrease = [[dict objectForKey:@"TUD_Lifting"] boolValue];
                                targetlis.ID_out = [[dict objectForKey:@"TUD_ID"] intValue];
                            }
                        }
                    }
                }
                    break;
                case AddPhaseMethod:
                    break;
                case ModifyPhaseMethod:{
                    PiecewiseList *pielist = vc.dataArray.firstObject;
                    pielist.Title = [dicinfo objectForKey:@"TSU_Title"];
                    pielist.DateStart = [self dateFromString:[dicinfo objectForKey:@"TSU_DateStart"]];
                    pielist.DateEnd = [self dateFromString:[dicinfo objectForKey:@"TSU_DateEnd"]];
                    pielist.Content = [dicinfo objectForKey:@"TSU_Content"];
                    NSArray *arrayinfo2 = [dicinfo objectForKey:@"info2"];
                    for (NSDictionary *dict in arrayinfo2) {
                        for (TargetAttrList *targetlis in self.tagetListArr) {
                            if (targetlis.ID == [[dict objectForKey:@"FK_TA_ID"] intValue]) {
                                targetlis.TA_DetailContent = [dict objectForKey:@"TSUD_Number"];
                                targetlis.isIncrease = [[dict objectForKey:@"TSUD_Lifting"] boolValue];
                                targetlis.ID_out = [[dict objectForKey:@"TSUD_ID"] intValue];
                            }
                        }
                    }
                }
                    break;
                    
                default:
                    break;
            }
          
        }
        [vc.tableView reloadData];
        [progressHUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [progressHUD hide:YES];
        progressHUD.labelText = @"保存失败,请检查网络";
        [vc.navigationController popViewControllerAnimated:YES];
    }];
}

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}


-(void)rightBarActionSave{
    PiecewiseList *pielist = [_dataArray objectAtIndex:0];
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    NSString *username_pass = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:username_str,@"username",username_pass,@"password",Key_HTTP,@"key",[NSString stringWithFormat:@"%d",self.listerMenber.ID],@"userid", nil];
    pielist.Title = self.textFieldName.text;
    if ([pielist.Title length]>0) {
        [parameters setObject:pielist.Title forKey:@"title"];
    }else{
        [self alertShow:@"目标不能为空"];
        return;
    }
  
    if ([[pielist.DateStart earlierDate:pielist.DateEnd] isEqual:pielist.DateStart]) {
        NSString *str_starttime = [self.dateFormatter stringFromDate:pielist.DateStart];
        NSString *str_endtime = [self.dateFormatter stringFromDate:pielist.DateEnd];
        [parameters setObject:str_starttime forKey:@"dateStart"];
        [parameters setObject:str_endtime forKey:@"dateEnd"];
    }else{
        [self alertShow:@"结束时间必须大于开始时间"];
        return;
    }

    NSString *StringMetod=nil;
    switch (self.AddMetod) {
        case AddTotalGoalMethod:{
            StringMetod = @"Target_update";
            //    [parameters setObject:self.target_id forKey:@"target_id"];
            [parameters setObject:self.ID forKey:@"id"];
        }
            break;
        case ModifyTotalGoalMethod:{
            StringMetod = @"Target_update";
            [parameters setObject:self.ID forKey:@"id"];
        }
            break;
        case AddPhaseMethod:{
            StringMetod = @"Target_Stage_update";
             [parameters setObject:self.ID forKey:@"id"];
            [parameters setObject:self.target_id forKey:@"target_id"];
            if([pielist.Content length]>0){
                [parameters setObject:pielist.Content forKey:@"content"];
            }else{
                [self alertShow:@"计划不能为空"];
                return;
            }
        }
            break;
        case ModifyPhaseMethod:{
            StringMetod = @"Target_Stage_update";
            [parameters setObject:self.ID forKey:@"id"];
//            stringAttrListID = [NSString stringWithFormat:@"%@,",self.ID];
             [parameters setObject:self.target_id forKey:@"target_id"];
            if([pielist.Content length]>0){
                [parameters setObject:pielist.Content forKey:@"content"];
            }else{
                [self alertShow:@"计划不能为空"];
                return;
            }
        }
            break;
            
        default:
            break;
    }
    
    NSMutableString *stringAttrList = [[NSMutableString alloc]init];
    if (_dataArray.count >1) {
        NSArray *array = [_dataArray objectAtIndex:1];
        for (TargetAttrList *target in array) {
            if (target.TA_DetailContent) {
                if (!target.ID_out) {
                    target.ID_out = -1;
                }
                NSString *str = [NSString stringWithFormat:@"%d,%d,%d,%@;",target.ID_out,target.ID,target.isIncrease,target.TA_DetailContent];
                [stringAttrList appendString:str];
            }
        }
    }
    if (stringAttrList.length >0) {
        [parameters setObject:stringAttrList forKey:@"attrs"];
    }else{
     [self alertShow:@"至少填写一个属性目标"];
        return;
    }
    NSLog(@"stringAttrList::%d",stringAttrList.length);
    __weak AddTargetPlan *vc = self;
    __weak  MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
  
//    progressHUD.mode=MBProgressHUDModeText;
    progressHUD.margin = 10.f;
    progressHUD.yOffset = self.view.bounds.origin.y;
    progressHUD.labelText = @"保存中,请稍等";
    progressHUD.alpha=0.75;
    progressHUD.removeFromSuperViewOnHide = YES;
 
      NSLog(@"parameters::%@",parameters);
    [[AFClient sharedCoachClient]postPath:StringMetod parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
//            NSLog(@"resultDict111::%@",resultDict);
            NSInteger tagetID = [[resultDict objectForKey:@"_return"] integerValue];
//            NSLog(@"tagetID::%ld",(long)tagetID);
            if (tagetID > 0) {
                
                switch (vc.AddMetod) {
                    case AddTotalGoalMethod:{
                        pielist.ID = tagetID;
                        NSMutableArray *array = [NSMutableArray arrayWithObject:pielist];
                        [vc.Mutarr_targetPlanTableData insertObject:array atIndex:0];
                    }
                        break;
                    case ModifyTotalGoalMethod:{
                       PiecewiseList *pielist = vc.dataArray.firstObject;
                        vc.PiecewList.Title = pielist.Title;
                        vc.PiecewList.DateStart = pielist.DateStart;
                        vc.PiecewList.DateEnd = pielist.DateEnd;
                        
                    }
                        break;
                    case AddPhaseMethod:{
                        pielist.ID = tagetID;
                        if (vc.Mutarr_targetPlanTableData.count >1) {
                            [vc.Mutarr_targetPlanTableData insertObject:pielist atIndex:1];
                        }else{
                            [vc.Mutarr_targetPlanTableData addObject:pielist];
                        }
                       
                    }
                        break;
                    case ModifyPhaseMethod:{
                        PiecewiseList *pielist = vc.dataArray.firstObject;
                        vc.PiecewList.Title = pielist.Title;
                        vc.PiecewList.DateStart = pielist.DateStart;
                        vc.PiecewList.DateEnd = pielist.DateEnd;
                    }
                        break;
                        
                    default:
                        break;
                }

                [vc.navigationController popViewControllerAnimated:YES];
                [progressHUD hide:YES];
            }else{
                [progressHUD hide:YES afterDelay:2];
                progressHUD.labelText = @"保存失败,请检查数据";
            }
            
        }else{
           
            [progressHUD hide:YES afterDelay:2];
            progressHUD.labelText = @"保存失败,请检查网络";
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error::%@",error);
        [progressHUD hide:YES afterDelay:2];
        progressHUD.labelText = @"保存失败,请检查网络";
    }];
//    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)alertShow:(NSString *)string{
    
    if (self.alertView) {
        [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    }
    self.alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [self.alertView show];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        PiecewiseList *pielist = [[PiecewiseList alloc]init];
        pielist.Title = @"";
        pielist.DateEnd = [NSDate date];
        pielist.DateEndTitle = @"结束时间";
        pielist.DateStart = [NSDate date];
        pielist.DateStartTitle = @"开始时间";
        
        _dataArray = [[NSMutableArray alloc]init];
        [_dataArray addObject:pielist];
        if (self.tagetListArr) {
            NSArray *array = [[NSArray alloc]initWithArray:self.tagetListArr];
            [_dataArray addObject:array];
        }
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSCurrentLocaleDidChangeNotification object:nil];
}

-(UIView *)textFieldView{
    if (!_textFieldView) {
        CGFloat withText=0;
        if (IS_IOS_7) {
            withText = 380;
        }else{
            withText = 300;
        }
        _textFieldView = [[UIView alloc]init];
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(5.0f, 15.0f, withText-10, 30.0f)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:_textFieldView.bounds];
        imageView.autoresizesSubviews = YES;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(5, 33.0, withText-10, 8)];
        imageLine.autoresizingMask = YES;
        imageLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIImage *image = [[UIImage imageNamed:@"textFieldViewLineImage.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 10, 0)];
        [imageLine setImage:image];
        [imageView setImage:[UIImage imageNamed:@"textFieldViewImage.png"]];
        
        [_textFieldView addSubview:imageView];
        [_textFieldView addSubview:imageLine];
        _textFieldView.frame = CGRectMake(60, -20, withText, 60);
        _textFieldView.backgroundColor = [UIColor clearColor];
        textField.tag = 900;
//        textField.returnKeyType = UIReturnKeyDone;
        [textField setBorderStyle:UITextBorderStyleNone];
        [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [textField setTextAlignment:NSTextAlignmentCenter];
        if (IS_IOS_7) {
            [textField setTintColor:[UIColor whiteColor]];
        }

        textField.delegate = self;
        textField.textColor = [UIColor whiteColor];
        
        [_textFieldView addSubview:textField];
    }
    return _textFieldView;
}

#pragma mark -====== uiextview delegate=====
- (void)textViewDidChange:(UITextView *)textView{
//    NSLog(@"textView::%@",textView.text);
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL boolretun = YES;
    if ([text isEqualToString:@"\n"])  {
        [textView resignFirstResponder];
        return NO;
    }
    NSString *str_textview = [textView.text stringByAppendingString:text];

//    NSLog(@"textview::%@",textView.text);
    if (text.length>0) {
        
        if (str_textview.length>400) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"亲，输入的太多了吧" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            boolretun = NO;
        }else{
        [self insertTargetArr:str_textview tag:10001];
            boolretun = YES;
        }

    }else{
    [self insertTargetArr:str_textview tag:10001];
    }

    return boolretun;
}

#pragma mark textField  delegate===================

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self hideTextFieldView];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag > 9999) {
        NSString *str_textfield = [textField.text stringByAppendingString:string];
        if ([str_textfield length]>50) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"亲，输入的太多了吧" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return NO;
        }else{
            [self insertTargetArr:str_textfield tag:textField.tag];
        }
        
        return YES;
    }
    BOOL isHaveDian=YES;
    
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        isHaveDian=NO;
    }
//    NSLog(@"[string length]::%d",[textField.text length]);
    if ([string length]>0)
    {
        NSString *str_textfield = [textField.text stringByAppendingString:string];
        if ([str_textfield length]>20) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"亲，输入的太多了吧" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length]==0){
                if(single == '.'){
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"亲，第一个数字不能为小数点" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                    
                }
            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    [self insertTargetArr:str_textfield tag:0];
                    return YES;
                }else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"亲，您已经输入过小数点了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    NSUInteger tt=range.location-ran.location;
                    if (tt <= 2){
                        [self insertTargetArr:str_textfield tag:0];
                        return YES;
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"亲，您最多输入两位小数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alert show];
                        return NO;
                    }
                }
                else
                {
                    [self insertTargetArr:str_textfield tag:0];
                    return YES;
                }
            }
            
        }else{//输入的数据格式不正确
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"亲，您输入的格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
       
    }
    else
    {
        return YES;
    }  
    
}


-(void)insertTargetArr:(NSString *)string tag:(NSInteger )tag{
    if (tag == 10000) {
        PiecewiseList *piecewise = self.dataArray.firstObject;
        piecewise.Title = string;
//         [self.tableView reloadData];
     
    }else if (tag == 10001){
        PiecewiseList *piecewise = self.dataArray.firstObject;
        piecewise.Content = string;
//         [self.tableView reloadData];
      
    }
    if ([self.textFieldIndexPath isKindOfClass:[NSIndexPath class]]) {
        NSArray *array = self.dataArray[self.textFieldIndexPath.section];
        TargetAttrList *targetarr = array[self.textFieldIndexPath.row];
        targetarr.TA_DetailContent = string;
        [self.tableView reloadData];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}

#pragma mark - Locale

/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self.tableView reloadData];
}

- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:indexPath.section]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
    if (self.datePickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            //
//            NSInteger indexArr = self.datePickerIndexPath.row+self.datePickerIndexPath.section*3 - 1;
//            if ((indexArr < self.dataArray.count)&&(indexArr >=0)) {
//                NSDictionary *itemData = self.dataArray[indexArr];
//                [targetedDatePicker setDate:[itemData valueForKey:kDateKey] animated:NO];
//
//            }
            PiecewiseList *pielist = self.dataArray[self.datePickerIndexPath.section];
            if (self.datePickerIndexPath.row == kDateStartRow +1) {
                [targetedDatePicker setDate:pielist.DateStart animated:NO];
            }else if (self.datePickerIndexPath.row == kDateEndRow+1){
                [targetedDatePicker setDate:pielist.DateEnd animated:NO];
            }
        }
    }
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row &&self.datePickerIndexPath.section == indexPath.section);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    if ((indexPath.row == kDateStartRow) ||
        (indexPath.row == kDateEndRow || ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1)&&(self.datePickerIndexPath.section == indexPath.section))))
    {
        hasDate = YES;
    }
    
    return hasDate;
}

- (BOOL)indexPathHastextView:(NSIndexPath *)indexPath
{
    BOOL hastextView = NO;
    if (indexPath.section == 0) {
        if ([self hasInlineDatePicker]) {
            if (indexPath.row == 4) {
                hastextView = YES;
            }
        }else{
            if (indexPath.row == 3) {
                hastextView = YES;
            }
        }
    }
    return hastextView;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self indexPathHastextView:indexPath]) {
        return 74.0;
    }
    return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 ) {
        return 50;
    }else{
        return 30;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section > 0) {
        return  [self.dataArray[section] count];
    }
    
    int rowcount = 0;
    switch (self.AddMetod) {
        case AddTotalGoalMethod:
            rowcount = 3;
            break;
        case ModifyTotalGoalMethod:
            rowcount = 3;
            break;
        case AddPhaseMethod:
            rowcount = 4;
            break;
        case ModifyPhaseMethod:
            rowcount = 4;
            break;
            
        default:
            break;
    }
    if ([self hasInlineDatePicker])
    {
        // we have a date picker, so allow for it in the number of rows in this section
//        NSInteger numRows = self.dataArray.count;
        if (self.datePickerIndexPath.section == section) {
            
            return rowcount+1;
        }
        return rowcount;//++numRows;
    }
    
    return rowcount;//self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    NSString *cellID = kOtherCell;
    
    if (indexPath.section >0) {
        cellID = TargertListCell;
        TargetAttrCell *celltaget = [tableView dequeueReusableCellWithIdentifier:TargertListCell];
        NSArray *array = self.dataArray[indexPath.section];
        TargetAttrList *targetarr = array[indexPath.row];
        celltaget.Title.text = targetarr.TA_CD;
        celltaget.LabelContent.text = targetarr.TA_Content;
        celltaget.LabelDetailContent.text = targetarr.TA_DetailContent;
//        [celltaget.BtnBool setImage:[UIImage imageNamed:@"减.png"] forState:UIControlStateNormal];
//        [celltaget.BtnBool setImage:[UIImage imageNamed:@"增减.png"] forState:UIControlStateSelected];
        celltaget.BtnBool.selected = targetarr.isIncrease;
        [celltaget.BtnBool addTarget:self action:@selector(BtnBoolAction:) forControlEvents:UIControlEventTouchUpInside];
        return celltaget;
    }
    
    if ([self indexPathHasPicker:indexPath])
    {
        // the indexPath is the one containing the inline date picker
        cellID = kDatePickerID;     // the current/opened date picker cell
    }
    else if ([self indexPathHasDate:indexPath])
    {
        // the indexPath is one that contains the date information
        cellID = kDateCellID;       // the start/end date cells
    }else if([self indexPathHastextView:indexPath]){
        cellID = textViewCellID;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    // if we have a date picker open whose cell is above the cell we want to update,
    // then we have one more cell than the model allows
    //

    PiecewiseList *itemData = self.dataArray[indexPath.section];
//    if (self.datePickerIndexPath == indexPath) {
    if ([cellID isEqualToString:kDateCellID]){
            // we have either start or end date cells, populate their date field
        if (indexPath.row == kDateStartRow) {
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:itemData.DateStart];
            cell.textLabel.text = itemData.DateStartTitle;
        }else{
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:itemData.DateEnd];
            cell.textLabel.text = itemData.DateEndTitle;
        }
    }else if([cellID isEqualToString:textViewCellID]){
           UITextView *textView = (UITextView *)[cell viewWithTag:10001];
            textView.text = itemData.Content;
    }else if ([cellID isEqualToString:kOtherCell]) {
        UITextField *textField = (UITextField *)[cell viewWithTag:10000];
//        textField.textColor = [UIColor colorWithHexString:@"5d5494"];
        self.textFieldName = textField;
        textField.placeholder = @"添加目标";
        textField.text = itemData.Title;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        
    }
	return cell;
}

-(void)BtnBoolAction:(UIButton *)button{
//    button.selected = !button.selected;
    UITableViewCell *cell = nil;
    if (IS_IOS_7) {
         cell = (UITableViewCell *)[[[button superview] superview]superview];
    }else{
         cell = (UITableViewCell *)[[button superview] superview];
    }
   
    if (cell &&[cell isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
          NSArray *array = self.dataArray[indexPath.section];
          TargetAttrList *targetarr = array[indexPath.row];
        targetarr.isIncrease = !targetarr.isIncrease;
        [self.tableView reloadData];
    }
  
}

/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDatePicker])
    {
        before = self.datePickerIndexPath.row < indexPath.row && self.datePickerIndexPath.section==indexPath.section;
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row&& self.datePickerIndexPath.section==indexPath.section);
    
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker])
    {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:self.datePickerIndexPath.section]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:indexPath.section];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:indexPathToReveal.section];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}

/*! Reveals the UIDatePicker as an external slide-in view, iOS 6.1.x and earlier, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath used to display the UIDatePicker.
 */
- (void)displayExternalDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // first update the date picker's date value according to our model
    PiecewiseList *itemData = self.dataArray[indexPath.section];
    if (indexPath.row == kDateStartRow) {
        [self.pickerView setDate:itemData.DateStart animated:YES];
    }else if (indexPath.row == kDateEndRow){
        [self.pickerView setDate:itemData.DateEnd animated:YES];

    }
    // the date picker might already be showing, so don't add it to our view
    if (self.pickerView.superview == nil)
    {
        CGRect startFrame = self.pickerView.frame;
        CGRect endFrame = self.pickerView.frame;
        
        // the start position is below the bottom of the visible frame
        startFrame.origin.y = self.view.frame.size.height;
        
        // the end position is slid up by the height of the view
        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
        
        self.pickerView.frame = startFrame;
        
        [self.view addSubview:self.pickerView];
        
        // animate the date picker into view
//        [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.pickerView.frame = endFrame; }
//                         completion:^(BOOL finished) {
//                             // add the "Done" button to the nav bar
//                             self.navigationItem.rightBarButtonItem = self.doneButton;
//                         }];
    }
}

-(void)ShowTextFieldView:(NSIndexPath *)indexpath cell:(UITableViewCell *)cell{
    self.textFieldIndexPath = indexpath;
    [self.tableView addSubview:self.textFieldView];
    self.textFieldView.center = cell.center;
    self.textFieldView.autoresizesSubviews = YES;
    self.textFieldView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self.textFieldView.layer setMasksToBounds:YES];
    UITextField *textField = (UITextField *)[self.textFieldView viewWithTag:900];
    textField.text = nil;
    textField.returnKeyType = UIReturnKeyDone;
    [textField becomeFirstResponder];
    if (!IS_IOS_7) {
        NSIndexPath *indexpathtextview = [self.tableView indexPathForCell:cell];
        [self.tableView selectRowAtIndexPath:indexpathtextview animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }
}

-(void)hideTextFieldView{
    if (self.textFieldIndexPath) {
        [self.textFieldView removeFromSuperview];
        self.textFieldIndexPath = nil;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![self.textFieldIndexPath isEqual:indexPath]) {
        [self hideTextFieldView];
    }

    if (cell.reuseIdentifier == kDateCellID)
    {
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
    }else if(cell.reuseIdentifier==TargertListCell){
        if (self.textFieldIndexPath == nil) {
               [self ShowTextFieldView:indexPath cell:cell];
        }
     
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
- (IBAction)dateAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
//        NSLog(@"self.datePickerIndexPath.section::%d",self.datePickerIndexPath.section);
//        NSLog(@"self.datePickerIndexPath.row::%d",self.datePickerIndexPath.row);
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:self.datePickerIndexPath.section];
    }
    else
    {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    // update our data model
    PiecewiseList *itemData = self.dataArray[self.datePickerIndexPath.section];
    if (self.datePickerIndexPath.row == kDateStartRow +1) {
        itemData.DateStart = targetedDatePicker.date;
    }else if(self.datePickerIndexPath.row == kDateEndRow +1){
        itemData.DateEnd = targetedDatePicker.date;
    }
//    NSLog(@"[self.dateFormatter stringFromDate:targetedDatePicker.date]:%@",[self.dateFormatter stringFromDate:targetedDatePicker.date]);
    // update the cell's date string
//    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    [self.tableView reloadData];
}


@end
