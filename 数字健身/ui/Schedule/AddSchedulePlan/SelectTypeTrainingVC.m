//
//  SelectTypeTrainingVC.m
//  数字健身
//
//  Created by 城云 官 on 14-6-19.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "SelectTypeTrainingVC.h"

@interface SelectTypeTrainingVC ()<UIPickerViewDataSource>{
    NSMutableDictionary *dicFirst, *dicSecond, *dicThree;
    NSMutableArray *arrFirst;
    NSArray  *arrSecond, *arrThree, *arrTerms;
    int numberOfPickerViewReturn;
}
@property (weak, nonatomic) IBOutlet UIPickerView *PickSeletType;
@property (weak, nonatomic) IBOutlet UINavigationBar *MyNaviBar;
@property (copy, nonatomic)NSString *TypeSelet;
@property (copy, nonatomic)NSString *TypeSeletKey;
@property (copy, nonatomic)NSString *TypeID;
@property (copy, nonatomic)NSString *TypeName;
@end

@implementation SelectTypeTrainingVC
static NSString *firstKey = @"info0";
static NSString *secondKey = @"info2";
static NSString *threeKey = @"threeKey";
static NSString *firstName = @"Name";
static NSString *secondName = @"Name";
static NSString *threeName = @"type";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
//    if (self.pickArray.count>0) {
//        arrFirst = self.pickArray;
//    }
//    arrFirst = @[@{firstName: @"跑步机",firstKey:@[
//                           @{secondName:@"级别间隔",firstKey:@[
//                                     @{secondName:@"级别间隔"},@{secondName:@"心率间隔",}
//                                     ]},@{secondName:@"心率间隔",}
//                                                ]},
//                 @{firstName: @"全功能训练机",firstKey:@[
//                           @{secondName:@"时间间隔"},@{secondName:@"级别间隔",}
//                           ]},
//                 @{firstName: @"立式健身车",firstKey:@[
//                           @{secondName:@"心率间隔"},@{secondName:@"级别间隔",}
//                           ]},
//                 @{firstName: @"靠背式健身车",firstKey:@[
//                           @{secondName:@"心率间隔"},@{secondName:@"时间间隔",}
//                           ]},
//                 ];
    
    [self.MyNaviBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!arrFirst) {
        arrFirst = [[NSMutableArray alloc]init];
        if (self.ArrayAerobic.count >0) {
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"有氧",firstName,self.ArrayAerobic,firstKey, nil];
            arrSecond = self.ArrayAerobic;
            arrThree = [[self.ArrayAerobic objectAtIndex:0] objectForKey:@"info2"];
            [arrFirst addObject:dic];
        }
        if (self.ArrayAerobic.count >0) {
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"力量",firstName,self.arrayPower,firstKey, nil];
            [arrFirst addObject:dic];
            NSDictionary *dic2 = [[NSDictionary alloc]initWithObjectsAndKeys:@"自定义",firstName, nil];
            [arrFirst addObject:dic2];
        }
        self.TypeSelet = [[arrThree objectAtIndex:0] objectForKey:@"TC_Type"];
        self.TypeSeletKey = @"TC_Type";
        self.TypeID = [[arrSecond objectAtIndex:0] objectForKey:@"ID"];
        
        //    self.TypeSelet = [[arrThree objectAtIndex:0] objectForKey:@"TC_Type"];
        //    NSLog(@"arrFirst::%@",arrFirst);
        [self.PickSeletType reloadAllComponents];
    }
   
}
- (IBAction)cancel:(id)sender {
    [self.delegate pickerDidChaneStatus:nil];
}

- (IBAction)AddAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        if ((!self.TypeSelet)&&(!self.TypeSeletKey)&&(!self.TypeID)&&(!self.TypeName)) {
            return;
        }
       
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.TypeSelet,self.TypeSeletKey,self.TypeID,@"seletID",self.TypeName,@"TypeName", nil];
        if (self.TypeName.length >0) {
            [dict setObject:self.TypeName forKey:@"TypeName"];
        }
       [self.delegate pickerDidChaneStatus:dict];
    }
//    [self.delegate pickerDidChaneStatus:@"yes"];
}


#pragma  mark - PickerView delegate and DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    numberOfPickerViewReturn = 3;
    
 
    return numberOfPickerViewReturn;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            return [arrFirst count];
            break;
            
        case 1:
            return [arrSecond count];
            break;
            
        case 2:
            return [arrThree count];
            
        default:
            return 0;
            break;
    }
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            arrSecond = [[arrFirst objectAtIndex:row]objectForKey:firstKey];
            if (arrSecond) {
                [self.PickSeletType selectRow:0 inComponent:1 animated:YES];
            }
            
            arrThree = [[arrSecond objectAtIndex:0]objectForKey:secondKey];
            if (arrThree) {
                [self.PickSeletType selectRow:0 inComponent:2 animated:YES];
            }

            if (row==0) {
                self.TypeSelet = [[arrThree objectAtIndex:0] objectForKey:@"TC_Type"];
                self.TypeSeletKey = @"TC_Type";
                self.TypeID = [[arrSecond objectAtIndex:0] objectForKey:@"ID"];
            }else if(row==1){
                self.TypeSelet = [[arrSecond objectAtIndex:0] objectForKey:@"TPT_ID"];
                self.TypeSeletKey = @"TPT_ID";
                self.TypeName = [[arrSecond objectAtIndex:0] objectForKey:@"TPT_Name"];
            }else{
                arrSecond = nil;
                arrThree = nil;
                self.TypeSelet = @"自定义";
                self.TypeSeletKey = @"自定义";
            }
            
            
            if (numberOfPickerViewReturn == 2) {
                [self.PickSeletType reloadComponent:1];
            }else if (numberOfPickerViewReturn == 3){
                [self.PickSeletType reloadComponent:1];
                [self.PickSeletType reloadComponent:2];
            }
            
            break;
        case 1:
            
            arrThree = [[arrSecond objectAtIndex:row]objectForKey:secondKey];
            if (arrThree) {
                [self.PickSeletType selectRow:0 inComponent:2 animated:YES];
            }
            if (numberOfPickerViewReturn == 3) {
                [self.PickSeletType reloadComponent:2];
            }
            self.TypeSelet = [[arrThree objectAtIndex:0] objectForKey:@"TC_Type"];
             self.TypeID = [[arrSecond objectAtIndex:row] objectForKey:@"ID"];
            self.TypeSeletKey = @"TC_Type";
            if (self.TypeSelet.length <1) {
                self.TypeSelet = [[arrSecond objectAtIndex:row] objectForKey:@"TPT_ID"];
                self.TypeSeletKey = @"TPT_ID";
                self.TypeName = [[arrSecond objectAtIndex:row] objectForKey:@"TPT_Name"];
            }
            break;
        case 2:
             self.TypeSelet = [[arrThree objectAtIndex:row] objectForKey:@"TC_Type"];
            self.TypeSeletKey = @"TC_Type";
            break;
        default:
            break;
    }
    
  
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strReturn;
    switch (component) {
        case 0:
            strReturn = [[arrFirst objectAtIndex:row] objectForKey:firstName];
            break;
        case 1:
            strReturn = [[arrSecond objectAtIndex:row]objectForKey:secondName];
            if (strReturn.length<1) {
                strReturn = [[arrSecond objectAtIndex:row]objectForKey:@"TPT_Name"];
            }
            break;
        case 2:
            strReturn = [[arrThree objectAtIndex:row]objectForKey:threeName];
            break;
            
        default:
            break;
    }
    return strReturn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
