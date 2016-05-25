//
//  SchedulePageDataViewController.m
//  SchedulePage
//
//  Created by 城云 官 on 14-5-7.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "SchedulePageDataViewController.h"
#import "CalendarDateUtil.h"
#import "SchedulePageRootViewController.h"
#import "SchedulePageDateCell.h"
#import "ButtonmMatching.h"
#import "MJRefresh.h"
#import "ContractListByCoach.h"
#import "MatchingBeSenderVC.h"
#import "ScheduleAlertView.h"
#import "SchedulePagePlanTVC.h"
#import "PopoverSendingVC.h"
#import "PopoverGrouClassVC.h"
#import "CoachReservedMemberVC.h"

@interface SchedulePageDataViewController ()<UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,MatchingBeSenderVCDelegate,PopoverSendingVCDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UITableView *TimeTable;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *WeakLabel;
@property (weak, nonatomic) IBOutlet UITableView *CalendarTableView;
@property(assign,nonatomic)NSInteger changeWeek;

@property(strong, nonatomic)NSMutableArray *TableData;;
@property(strong, nonatomic)NSMutableArray *DateMutArray;
@property(weak, nonatomic)NSNotificationCenter *center;

@property (strong, nonatomic)MJRefreshHeaderView *header;

@property(assign, nonatomic)BOOL CanNotTouchButton;
@property(strong, nonatomic)UIView *AddView;
@property (nonatomic, strong) UIPopoverController *SendingPopover;
@property (nonatomic, strong) UIPopoverController *GrouClassPopover;
@property (nonatomic, strong) UIPopoverController *MatchingBeSenderPopover;
@property (nonatomic, strong) UIPopoverController *CoachReservedMemberPopver;
@property (nonatomic, strong) PopoverSendingVC *popoverSendingVC;
@property (nonatomic, strong) PopoverGrouClassVC *popovergrouClassVC;
@property (nonatomic, strong) MatchingBeSenderVC *popoverMatchingBeSenderVC;
@property (nonatomic, strong) CoachReservedMemberVC *popverCoachReservedMember;

@property (nonatomic, strong) MBProgressHUD *progressHUD;
@end

@implementation SchedulePageDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    self.changeWeek = [self.dataObject intValue]*7;
    
    for (UILabel *label in self.WeakLabel) {
//        NSLog(@"label::%d",label.tag);
        NSArray *WeakArray = [SchedulePageDataViewController WeakChina];
        NSInteger index = label.tag-100;
        if ((index >-1)&&(index < WeakArray.count)) {
            NSNumber *number = [NSNumber numberWithInteger:[CalendarDateUtil getDayWithDate:[CalendarDateUtil dateSinceNowWithInterval:_changeWeek + index]]];
            NSInteger chooseInt = ([self weekDate:[CalendarDateUtil dateSinceNowWithInterval:0]] -1 + index)%7;//计数星期几
            label.text = [NSString stringWithFormat:@"%@日周%@",number,WeakArray[chooseInt]];
        }
    }
//    _progressHUD=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];

    [self initTableView];
    [self addHeader];
    [self initPopView];
    _center = [NSNotificationCenter defaultCenter];

}

-(void)initPopView{
    self.popoverSendingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverSendingVC"];
    self.popoverSendingVC.delegate = self;
    
    self.SendingPopover = [[UIPopoverController alloc] initWithContentViewController:self.popoverSendingVC];
//    self.SendingPopover.delegate = self;
//    self.SendingPopover.popoverLayoutMargins = UIEdgeInsetsMake(0, 10, 0, 10);
//    self.SendingPopover.popoverContentSize = CGSizeMake(400.0, 400.0);
//    sendingvc.contentSizeForViewInPopover = CGSizeMake(500.0, 500.0);
    
    self.popovergrouClassVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverGrouClassVC"];
    self.GrouClassPopover = [[UIPopoverController alloc] initWithContentViewController:self.popovergrouClassVC];
//    self.GrouClassPopover.delegate = self;
    
    self.popoverMatchingBeSenderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchingBeSenderVCID"];
    self.MatchingBeSenderPopover = [[UIPopoverController alloc] initWithContentViewController:self.popoverMatchingBeSenderVC];
    
    self.popverCoachReservedMember = [self.storyboard instantiateViewControllerWithIdentifier:@"CoachReservedMemberVC"];
    self.CoachReservedMemberPopver = [[UIPopoverController alloc] initWithContentViewController:self.popverCoachReservedMember];
//    self.GrouClassPopover.delegate = self;
}

-(NSMutableArray *)TableData{
    if (!_TableData) {
        _TableData = [[NSMutableArray alloc]init];/*
        for (int a=0; a < 24*7; a++) {
           int i= arc4random() % 9;
//            [_TableData addObject:[NSNumber numberWithInt:i]];
            ContractListByCoach *contrectlist = [[ContractListByCoach alloc]init];
            contrectlist.col_Contrac = @"12";
            contrectlist.createdate_Contrac = nil;
            contrectlist.end_Contrac = nil;
            contrectlist.id_Contrac = @"11";
            contrectlist.start_Contrac = nil;
            contrectlist.state_Contrac = [NSString stringWithFormat:@"%d",i];
            if (i==8) {
                int x= arc4random() % 2;
                if (x == 1) {
                    contrectlist.type_Contrac = @"团课";
                    contrectlist.id_Contrac = @"2";
                }
            }
            
            contrectlist.userid_Contrac = [NSString stringWithFormat:@"%d",12];
            [_TableData addObject:contrectlist];
        }*/
    }
    return _TableData;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

}

-(void)initTableView{

    self.TimeTable.delegate = self;
    self.TimeTable.dataSource = self;
    self.CalendarTableView.delegate = self;
    self.CalendarTableView.dataSource = self;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
    NSString *title = [NSString stringWithFormat:@"%@ - %@",[self dateForLabelTag:0],[self dateForLabelTag:6]];
  
    [_center postNotificationName:SchedulePageRootNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Title",@"NotificationKey1",title,@"Value", nil]];
   
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.CalendarTableView reloadData];
    [self.TimeTable reloadData];
}

//从新匹配
-(void)reloadSchlePageDate{
//    NSLog(@"listmenber::%d",self.lisyMenber.ID);
    [_header beginRefreshing];
    [self Contract_Info_List_byCoach];
}

-(NSString *)dateForLabelTag:(NSInteger)index{
//    NSInteger chooseInt = [self weekDate:[CalendarDateUtil dateSinceNowWithInterval:0]] - 1;
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyy年MM月dd日"];
    NSString* dateStr = [dateformat stringFromDate:[CalendarDateUtil dateSinceNowWithInterval:_changeWeek + index]];
    return dateStr;
}

-(NSString *)dateForLabelTag:(NSInteger)index dataFormat:(NSString *)dataFormat{
    //    NSInteger chooseInt = [self weekDate:[CalendarDateUtil dateSinceNowWithInterval:0]] - 1;
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:dataFormat];
    NSString* dateStr = [dateformat stringFromDate:[CalendarDateUtil dateSinceNowWithInterval:_changeWeek + index]];
    return dateStr;
}

+(NSArray *)WeakChina{
    static NSArray *WeakChina = nil;
    if (!WeakChina) {
        WeakChina = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    }
    return WeakChina;
}

-(NSInteger)weekDate:(NSDate*)date
{
    // 获取当前年月日和周几
    //    NSDate *_date=[NSDate date];
    NSCalendar *_calendar=[NSCalendar currentCalendar];
    NSInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *com=[_calendar components:unitFlags fromDate:date];
//    NSString *_dayNum=@"";
    NSInteger dayInt = 0;
    switch ([com weekday]) {
        case 1:{
//            _dayNum=@"日";
            dayInt = 1;
            break;
        }
        case 2:{
//            _dayNum=@"一";
            dayInt = 2;
            break;
        }
        case 3:{
//            _dayNum=@"二";
            dayInt = 3;
            break;
        }
        case 4:{
//            _dayNum=@"三";
            dayInt = 4;
            break;
        }
        case 5:{
//            _dayNum=@"四";
            dayInt = 5;
            break;
        }
        case 6:{
//            _dayNum=@"五";
            dayInt = 6;
            break;
        }
        case 7:{
//            _dayNum=@"六";
            dayInt = 7;
            break;
        }
            
            
        default:
            break;
    }
    
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyy年MM月dd日"];
    
    return dayInt;
}

+(NSArray *)timeHours{
    static NSArray *timeHours = nil;
    if (!timeHours) {
        timeHours = @[@"0点 上午",@"1点 上午",@"2点 上午",@"3点 上午",@"4点 上午",@"5点 上午",@"6点 上午",@"7点 上午",@"8点 上午",@"9点 上午",@"10点 上午",@"11点 上午",@"12点 上午",@"1点 下午",@"2点 下午",@"3点 下午",@"4点 下午",@"5点 下午",@"6点 下午",@"7点 下午",@"8点 下午",@"9点 下午",@"10点 下午",@"11点 下午",@"12点 下午"];
    }
    return timeHours;
}
+(NSArray *)timeHoursEnglish{
    static NSArray *timeHoursEnglish = nil;
    if (!timeHoursEnglish) {
        timeHoursEnglish = @[@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00"];
    }
    return timeHoursEnglish;
}

#pragma mark - add freshview

- (void)addHeader
{
    __weak SchedulePageDataViewController *vc = self;
    
    MJRefreshHeaderView *header = [[MJRefreshHeaderView alloc]init];
    header.scrollView = self.CalendarTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [vc Contract_Info_List_byCoach];
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
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
    [header beginRefreshing];
    _header = header;
}

-(void)Contract_Info_List_byCoach{
    
    NSDate *taday = [CalendarDateUtil dateSinceNowWithInterval:_changeWeek];
    NSDateFormatter *farmerter = [[NSDateFormatter alloc]init];
    farmerter.dateFormat = @"yyyy-MM-dd";
    NSString *datestring = [farmerter stringFromDate:taday];
//    NSLog(@"datestring::%@",datestring);
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    NSString *userpass_str = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    NSDictionary *dic = nil;
    if (self.lisyMenber.ID) {
      dic = @{@"startDate": datestring,//@"2014-05-30",
            @"username":username_str,
            @"password":userpass_str,
            @"key":Key_HTTP,
            @"userid":[NSNumber numberWithInteger:self.lisyMenber.ID]
            };

    }else{
      dic = @{@"startDate": datestring,//@"2014-05-30",
            @"username":username_str,
            @"password":userpass_str,
            @"key":Key_HTTP,
            @"userid":@"-1"
            };
    }
//    NSLog(@"dic::%@",dic.description);
    __weak MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.margin = 10.f;
//    progressHUD.yOffset = 150.f;
    progressHUD.alpha=0.75;
//    progressHUD.userInteractionEnabled=NO;

    __weak SchedulePageDataViewController *vc = self;
    [[AFClient sharedCoachClient]getPath:@"Contract_Info_List_byCoach" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
            NSArray *array = [resultDict objectForKey:@"info"];
//            NSLog(@"arraycount::%d",array.count);
            if (array.count >0) {
//                NSLog(@"array:::::%@",array.description);
                _TableData = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in array) {
                    ContractListByCoach *contrectlist = [[ContractListByCoach alloc]init];
                    contrectlist.col_Contrac = [dic objectForKey:@"col"];
                    contrectlist.createdate_Contrac = [dic objectForKey:@"createdate"];
                    contrectlist.end_Contrac = [dic objectForKey:@"end"];
                    contrectlist.id_Contrac = [dic objectForKey:@"id"];
                    contrectlist.start_Contrac = [dic objectForKey:@"start"];
                    contrectlist.state_Contrac = [dic objectForKey:@"state"];
                    contrectlist.type_Contrac = [dic objectForKey:@"type"];
                    contrectlist.userid_Contrac = [dic objectForKey:@"userid"];
                    [_TableData addObject:contrectlist];
//                    NSLog(@"contrectlist::%@",contrectlist);
                }
            }
            [vc.CalendarTableView reloadData];
        }
        [progressHUD hide:YES];
        [vc.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        progressHUD.mode=MBProgressHUDModeText;
       
        progressHUD.labelText=@"数据获取失败,";

        [progressHUD hide:YES afterDelay:2];
        [vc.header endRefreshing];
    }];
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
    
   
    return 24;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IdentifierTime = @"timeCell";
    static NSString *IdentifierSchedule = @"ScheduleCell";
    if (tableView == self.TimeTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierTime];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(25, 1, 71, 40)];
            label.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label];
            label.textAlignment = NSTextAlignmentRight;
            label.autoresizesSubviews = YES;
            label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            label.tag = 100;
            
        }
        UILabel *label = (UILabel *)[cell viewWithTag:100];
        NSArray *array = [SchedulePageDataViewController timeHours];
        if (indexPath.row < array.count) {
            label.text = array[indexPath.row];
        }
        return cell;
    }else{
        SchedulePageDateCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierSchedule];
//        if (!cell) {
//            cell = [[SchedulePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierSchedule];
//            cell.autoresizesSubviews = YES;
//            cell.autoresizesSubviews = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
//        }
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"SchedulePageDateCell" bundle:nil] forCellReuseIdentifier:IdentifierSchedule];
            cell = [tableView dequeueReusableCellWithIdentifier:IdentifierSchedule];
//        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SchedulePageDateCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
        }
        for (NSInteger x =0; x <cell.Buttons.count; x++) {
            ButtonmMatching *btnMath = cell.Buttons[x];
            NSInteger y = indexPath.row;
            NSInteger index = y + x*24;
            if (index < self.TableData.count) {
                btnMath.contrectlistbycoach = self.TableData[index];
//                NSLog(@"btnMath::%@",btnMath.contrectlistbycoach.description);
                //                    ContractListByCoach *contraclist = self.TableData[index];
                //                    NSLog(@"contraclist::%d",[contraclist.state_Contrac integerValue]);
                btnMath.ButtonType = [btnMath.contrectlistbycoach.state_Contrac integerValue];
                if (btnMath.ButtonType == 8) {
                    
                }
                btnMath.tag = index;
//                NSArray *array = [SchedulePageDataViewController timeHours];
//                btnMath.StringDate = [NSString stringWithFormat:@"%@%@ 至%@%@",[self dateForLabelTag:x],array[y],[self dateForLabelTag:x],array[y +1]];
            }
            [btnMath addTarget:self action:@selector(btnMathAction:) forControlEvents:UIControlEventTouchUpInside];
        }

//
        if (indexPath.row < (self.TableData.count-1)) {
            cell.TopLine.hidden = NO;
            cell.BottomLine.hidden = YES;
        }else{
            cell.TopLine.hidden = YES;
            cell.BottomLine.hidden = NO;
        }
         return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat heigt = 0;
    heigt = self.view.bounds.size.width/8;
    return heigt;
}

-(void)btnMathAction:(UIButton *)btton{
   
    if ([btton isKindOfClass:[ButtonmMatching class]]) {
        ButtonmMatching *BtnMatch = (ButtonmMatching *)btton;
//         NSLog(@"btton::%@",BtnMatch.contrectlistbycoach.description);
        switch (BtnMatch.ButtonType) {
            case TypeMatchingNone:
                //                self.backgroundColor = [UIColor whiteColor];
            {
                //点击继续预约 白色
                [self btnMathActionTypeSending:BtnMatch];
            }
                break;
            case TypeMatchingAgreed://同意
                //安排训练计划，跟目标计划差不多，打钩
            {
                [self performSegueWithIdentifier:@"ToSchedulePagePlanTVC" sender:BtnMatch.contrectlistbycoach];
            }
                break;
                
            case TypeMatchingRefused://拒绝
            {
               //点击继续预约 白色
               [self btnMathActionTypeSending:BtnMatch];
            }
                break;
            case TypeMatchingModify://修改,暂时不用
                [self btnMathActionTypeSending:BtnMatch];
                break;
            case TypeMatchingCancel://取消
               //点击继续预约 白色
                [self btnMathActionTypeSending:BtnMatch];
                break;
            case TypeMatchingComplete://完成
               //安排训练计划，跟目标计划差不多 打钩 加图标
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"安排训练计划已完成" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
                break;
            case TypeMatchingOverdue://过期 //点击继续预约 白色
                [self btnMathActionTypeSending:BtnMatch];
                break;
            case TypeMatchingTakeUp://被其他会员占用 差
            {
                UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"该时段已经被占用，不可预约" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertview show];
            }
                break;
            case TypeMatchingInitiate://发起 。。。
            {
                [self PersonalTrainingSessions:BtnMatch];
            }
                break;
            default:
                 [self btnMathActionTypeSending:BtnMatch];
                break;
        }
    }
 
   
}

//Personal training sessions私教课程
-(void)PersonalTrainingSessions:(ButtonmMatching *)BtnMatch{
   
    __weak MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //                progressHUD.userInteractionEnabled=NO;
    //                progressHUD.mode=MBProgressHUDModeText;
    progressHUD.margin = 10.f;
    progressHUD.yOffset = 50;
    progressHUD.alpha=0.75;
    progressHUD.removeFromSuperViewOnHide = YES;
    
    NSString *username_str = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    NSString *userpass_str = [[NSUserDefaults standardUserDefaults]objectForKey:PassValue];
    
    NSDictionary *paramter = [[NSDictionary alloc]initWithObjectsAndKeys:BtnMatch.contrectlistbycoach.id_Contrac,@"circleid",username_str,@"username",userpass_str,@"password",Key_HTTP,@"key", nil];
    __weak SchedulePageDataViewController *vc = self;
    
    NSString *stringPath = nil;
    
    __weak ButtonmMatching *btnMatch = BtnMatch;
    
    if ([BtnMatch.contrectlistbycoach.type_Contrac isEqualToString:@"团课"]) {
        stringPath = @"Contract_Info_Wait_Group_ByCoach";
    }else if ([BtnMatch.contrectlistbycoach.type_Contrac isEqualToString:@"教练预约会员"]){
        stringPath = @"Contract_Info_Wait_CoachToUser";
    }else{
        stringPath = @"Contract_Info_Wait_ByCoach";//私教课程
    }
    [[AFClient sharedCoachClient]getPath:stringPath parameters:paramter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if (resultDict) {
            NSArray *array = [resultDict objectForKey:@"info"];
            if (array.count > 0 ) {
                if ([array[0] isKindOfClass:[NSDictionary class]]) {
                    
                    if ([stringPath isEqualToString:@"Contract_Info_Wait_ByCoach"]) {
                        CGRect rect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 1, 1);
//                        NSLog(@"array::%@",array.firstObject);
                         vc.popoverMatchingBeSenderVC.CIN_ID = btnMatch.contrectlistbycoach.id_Contrac;
                        vc.popoverMatchingBeSenderVC.buttonMatching = btnMatch;
                        vc.popoverMatchingBeSenderVC.DictionaryGet = array[0];
                        [vc.MatchingBeSenderPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
                    }else if ([BtnMatch.contrectlistbycoach.type_Contrac isEqualToString:@"教练预约会员"]){
                        CGRect rect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 1, 1);
                        //                        NSLog(@"array::%@",array.firstObject);
                        vc.popverCoachReservedMember.buttonMatching = btnMatch;
                        vc.popverCoachReservedMember.DictionaryGet = array[0];
                        [vc.CoachReservedMemberPopver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
                    }else{
//                         NSLog(@"array::%@",array.firstObject);
                        CGRect rect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 1, 1);
                        vc.popovergrouClassVC.DictionaryGet = array[0];
                        [vc.GrouClassPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
                     
                    }
                   
//                    [self performSegueWithIdentifier:@"ToMatchingBeSenderVC" sender:array[0]];
                }else{
                    [vc Contract_Info_List_byCoach];
                    progressHUD.labelText=@"请求失败";
                    [progressHUD hide:YES afterDelay:2];
                }
                
                [progressHUD hide:YES];
            }else{
                 [vc Contract_Info_List_byCoach];
                progressHUD.labelText=@"请求失败";
                [progressHUD hide:YES afterDelay:2];
            }
        }else{
            progressHUD.labelText=@"请求失败";
            [progressHUD hide:YES afterDelay:2];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        progressHUD.labelText=@"请求失败,请检查网络后重试";
        [progressHUD hide:YES afterDelay:2];
    }];
    
}

#pragma mark  MatchingBeSenderVCDelegate -------
-(void)MatchingBeSenderString:(NSString *)string{
    if ([string isEqualToString:@"cancel"]) {
        [self.MatchingBeSenderPopover dismissPopoverAnimated:YES];
    }else if([string isEqualToString:@"yes"]){
        [self Contract_Info_List_byCoach];
        [self.MatchingBeSenderPopover dismissPopoverAnimated:YES];
    }
}

#pragma mark  PopoverSendingVCDelegate -------
-(void)PopoverSendingVCDelegateSender{
    if (self.SendingPopover) {
        [self.SendingPopover dismissPopoverAnimated:YES];
    }
    [self Contract_Info_List_byCoach];
}

#pragma mark - Rotation support

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	// If the detail popover is presented, dismiss it.
	if (self.SendingPopover != nil)
    {
		[self.SendingPopover dismissPopoverAnimated:YES];
	}
    if (self.GrouClassPopover != nil)
    {
		[self.GrouClassPopover dismissPopoverAnimated:YES];
	}
    if (self.MatchingBeSenderPopover != nil)
    {
		[self.MatchingBeSenderPopover dismissPopoverAnimated:YES];
	}
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//	// If the detail popover is presented, dismiss it.
//	if (self.SendingPopover != nil)
//    {
//		[self.SendingPopover dismissPopoverAnimated:YES];
//	}
//}


-(void)btnMathActionTypeSending:(ButtonmMatching *)BtnMatch{

    //        NSLog(@"ButtonType::%lu",BtnMatch.ButtonType);
    if (!self.lisyMenber.ID) {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择会员后预约" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertview show];
        return;
    }
    NSInteger x = BtnMatch.tag/24;
    NSInteger y = BtnMatch.tag%24;
    NSArray *array = [SchedulePageDataViewController timeHoursEnglish];
    
//    NSString *strDate = [NSString stringWithFormat:@"%@%@至%@%@？",[self dateForLabelTag:x dataFormat:@"MM月dd日 hh:mm"],array[y],[self dateForLabelTag:x dataFormat:@"MM月dd日 hh:mm"],array[y +1]];
    NSString *strDate = [NSString stringWithFormat:@"%@%@---%@%@",[self dateForLabelTag:x dataFormat:@"MM月dd日"],array[y],[self dateForLabelTag:x dataFormat:@"MM月dd日"],array[y +1]];
    CGRect rect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 1, 1);
    
    self.popoverSendingVC.textString = strDate;
    self.popoverSendingVC.buttonMatching = BtnMatch;
    self.popoverSendingVC.popverCT = self.SendingPopover;
    self.popoverSendingVC.lisyMenber = self.lisyMenber;
    self.popoverSendingVC.startDate = [NSString stringWithFormat:@"%@ %@",[self dateForLabelTag:x dataFormat:@"YYYY-MM-dd"],array[y]];
    self.popoverSendingVC.endDate = [NSString stringWithFormat:@"%@ %@",[self dateForLabelTag:x dataFormat:@"YYYY-MM-dd"],array[y+1]];
    [self.SendingPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
//    [self.SendingPopover presentPopoverFromRect:BtnMatch.frame inView:BtnMatch.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//    [self.navigationController presentViewController:self.SendingPopover animated:YES completion:^{
//        
//    }];
}

#pragma mark - Popover controller delegates

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	// If a popover is dismissed, set the last button tapped to nil.
	
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    // Give them another go at entering correct password
    if (buttonIndex != alertView.cancelButtonIndex) {

    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ToMatchingBeSenderVC"]) {
        MatchingBeSenderVC *matchvc = segue.destinationViewController;
        matchvc.DictionaryGet = sender;
    }else if([segue.identifier isEqualToString:@"ToSchedulePagePlanTVC"]) {
        SchedulePagePlanTVC *schplanvc = segue.destinationViewController;
        ContractListByCoach *contrctlist = sender;
        schplanvc.FK_CIN_ID = contrctlist.id_Contrac;
      
    }
}


#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if([scrollView isEqual:_TimeTable]) {
        CGPoint offset = _CalendarTableView.contentOffset;
        offset.y = _TimeTable.contentOffset.y;
        [_CalendarTableView setContentOffset:offset];
    }else{
        CGPoint offset = _TimeTable.contentOffset;
        offset.y = _CalendarTableView.contentOffset.y;
        [_TimeTable setContentOffset:offset];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
