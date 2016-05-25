//
//  MenberMoreDetailed.m
//  数字健身
//
//  Created by 城云 官 on 14-4-14.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "MenberMoreDetailed.h"
#import "AddMenberDataVC.h"
#import "MJRefresh.h"

@interface MenberMoreDetailed ()<AddMenberDataVCDelegate,MJRefreshBaseViewDelegate>{
    MJRefreshHeaderView *_header;
}

@property(strong, nonatomic)NSMutableArray *objects;
@property(strong, nonatomic)NSMutableDictionary *dicObjects;


@end

@implementation MenberMoreDetailed

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
    
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBarButtonTouched:)];
//    [self.navigationItem setRightBarButtonItem:rightBtn];

//    _objects = [[NSMutableArray alloc]initWithObjects:@"性别",@"年龄",@"手机号",@"体检信息", nil];
//    _dicObjects = [NSMutableDictionary dictionaryWithDictionary:@{
//                                                                  _objects[0]: @"男",
//                                                                  _objects[1]: @"20",
//                                                                  _objects[2]:@"15618650570",
//                                                                  _objects[3]: @"体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检信息体检结束"
//                                                                  }];
//    [self getPathGetUser_ByCoach];
    [self addHeader];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)addHeader
{
    if (!_header) {
        _header = [[MJRefreshHeaderView alloc] init];
        _header.delegate = self;
        _header.scrollView = self.tableView;
        [_header beginRefreshing];
    }
 
 
}

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
  [self getPathGetUser_ByCoach];
}

-(void)getPathGetUser_ByCoach{
    __weak MenberMoreDetailed *vc = self;
    
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
    
   NSDictionary *parameters = @{
                                @"user_id": userid,
                                @"username":username_str,
                                @"password":userpass_str,
                                @"key": Key_HTTP,
                                };
        [[AFClient sharedCoachClient]getPath:@"GetUser_ByCoach" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *resultDict = nil;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                resultDict = responseObject;
            }else{
                resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            }
            if (resultDict) {
                NSArray *array = [resultDict objectForKey:@"info"];
                if (array.count >0) {
                    vc.dicObjects = [[NSMutableDictionary alloc]init];
                    for (NSDictionary *dic in array) {
                        NSString *name = [dic objectForKey:@"Name"];
                        if ((name)&&(![name isEqualToString:@""])) {
                            [vc.dicObjects setObject:name forKey:@"姓名"];
                        }
                        
                        NSString *Sex = [dic objectForKey:@"Sex"];
                        if ((Sex)&&(![Sex isEqualToString:@""])) {
                            [vc.dicObjects setObject:Sex forKey:@"性别"];
                        }
                        
                        NSString *UI_Birthday = [dic objectForKey:@"UI_Birthday"];
                        if ((UI_Birthday)&&(![UI_Birthday isEqualToString:@""])) {
                            [vc.dicObjects setObject:UI_Birthday forKey:@"生日"];
                        }
                        
                        NSString *UI_Height = [dic objectForKey:@"UI_Height"];
                        if ((UI_Height)&&(![UI_Height isEqualToString:@""])) {
                            [vc.dicObjects setObject:UI_Height forKey:@"身高"];
                        }
                        
                        NSString *UI_Job = [dic objectForKey:@"UI_Job"];
                        if ((UI_Job)&&(![UI_Job isEqualToString:@""])) {
                            [vc.dicObjects setObject:UI_Job forKey:@"职位"];
                        }
                        
                        NSString *UI_Love = [dic objectForKey:@"UI_Love"];
                        if ((UI_Love)&&(![UI_Love isEqualToString:@""])) {
                            [vc.dicObjects setObject:UI_Love forKey:@"兴趣"];
                        }
                        
                    }
                    [vc.tableView reloadData];
                }
            }
            [_header endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_header endRefreshing];
        }];

}

-(void)viewWillDisappear:(BOOL)animated{
//    [_header free];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dicObjects.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier_str = @"MoreDetailedCell";
    static NSString *Identifier_str1 = @"MoreDetailedCell1";
    static NSString *Identifier_Add = @"AddCell";
    if (indexPath.row == _dicObjects.count) {
        UITableViewCell *cellAdd = [tableView dequeueReusableCellWithIdentifier:Identifier_Add];
        cellAdd.selectionStyle = UITableViewCellSelectionStyleGray;
        return cellAdd;
    }else{
        UITableViewCell *cell;
        if (([self determineLengthName:_objects[indexPath.row]])||([self determineLengthContact:_dicObjects[_objects[indexPath.row]]])) {
            cell = [tableView dequeueReusableCellWithIdentifier:Identifier_str1];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:Identifier_str];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UILabel *labelLeft = (UILabel *)[cell viewWithTag:101];
        UILabel *labelRight = (UILabel *)[cell viewWithTag:100];
        labelRight.numberOfLines = 0;
        labelLeft.text = _dicObjects.allKeys[indexPath.row];
        labelRight.text = _dicObjects.allValues[indexPath.row];
        [labelRight sizeToFit];
        return cell;
    }
    
}

-(BOOL)determineLengthName:(NSString *)string{
    UILabel *label = [[UILabel alloc]init];
    label.text = string;
    [label sizeToFit];
    if (label.frame.size.width >191) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)determineLengthContact:(NSString *)string{
    UILabel *label = [[UILabel alloc]init];
    label.text = string;
    [label sizeToFit];
    if (label.frame.size.width >526) {
        return YES;
    }else{
        return NO;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.row == _dicObjects.count) {
        return 56;
    }else{
//        NSNumber *number = [NSNumber numberWithInteger:indexPath.row];
        static NSString *Identifier_str = @"MoreDetailedCell";
        static NSString *Identifier_str1 = @"MoreDetailedCell1";
        
        UITableViewCell *cell;
      
        if (([self determineLengthName:_dicObjects.allKeys[indexPath.row]])||([self determineLengthContact:_dicObjects.allValues[indexPath.row]])) {
            
//            NSLog(@"%@",_objects[indexPath.row]);
//             NSLog(@"%@",_dicObjects[number]);
            cell = [tableView dequeueReusableCellWithIdentifier:Identifier_str1];
            UILabel *labelLeft = (UILabel *)[cell viewWithTag:101];
            UILabel *labelRight = (UILabel *)[cell viewWithTag:100];
            labelLeft.text =  _dicObjects.allKeys[indexPath.row];
            labelRight.text = _dicObjects.allValues[indexPath.row];
            labelRight.numberOfLines = 0;
            [labelRight sizeToFit];
            return labelRight.frame.size.height  + 10 + labelLeft.frame.size.height;
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:Identifier_str];
            UILabel *labelLeft = (UILabel *)[cell viewWithTag:101];
            UILabel *labelRight = (UILabel *)[cell viewWithTag:100];
            labelLeft.text = _dicObjects.allKeys[indexPath.row];
            labelRight.text = _dicObjects.allValues[indexPath.row];
            
            [labelRight sizeToFit];
            labelRight.numberOfLines = 0;
            return labelRight.frame.size.height + 10;
        }

    }

   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"indexPath.row::%d",indexPath.row);
//    NSLog(@"indexPath.row::%d",_objects.count);
    if (indexPath.row == _dicObjects.count) {
        return;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"FormAddData" sender:[NSNumber numberWithInteger:indexPath.row]];
  
}


-(IBAction)AddData:(id)sender{
 [self performSegueWithIdentifier:@"FormAddData" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"FormAddData"]) {
       
        AddMenberDataVC *addmenberdatavc = (AddMenberDataVC *)segue.destinationViewController;
        addmenberdatavc.delegate = self;
        
        if (sender == nil) {
            return;
        }else{
            NSNumber *number = sender;
            NSInteger index = [number integerValue];
            addmenberdatavc.CellRow = index;
            addmenberdatavc.TitleStr = _dicObjects.allKeys[index];
            addmenberdatavc.ContactStr = _dicObjects.allValues[index];
        }
    }
}

#pragma mark - AddMenberDataVCDelegate

-(void)SaveTiele:(NSString *)title Contact:(NSString *)contact{
    [self dismissViewControllerAnimated:YES completion:nil];
    [_objects addObject:title];
    [_dicObjects setObject:contact forKey:_objects[_objects.count-1]];
    [self.tableView reloadData];
}
-(void)Delete:(NSInteger)cellRow{
      [self dismissViewControllerAnimated:YES completion:nil];
    [_dicObjects removeObjectForKey:[NSNumber numberWithInteger:cellRow]];
    [_objects removeObjectAtIndex:cellRow];

    [self.tableView reloadData];
}


//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
//    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//    [self.tableView reloadData];
//}

@end
