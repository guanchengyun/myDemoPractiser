//
//  CoachCircleDetailVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-25.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "CoachCircleDetailVC.h"

@interface CoachCircleDetailVC ()<UITextFieldDelegate>
@property(strong, nonatomic)MBProgressHUD *progressHUD;
@end


@implementation CoachCircleDetailVC

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
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DetailVCCell1"];
    }else if(indexPath.row == 3){
        cell = [tableView dequeueReusableCellWithIdentifier:@"DetailVCCell3"];
        UITextField *textField = (UITextField *)[cell viewWithTag:300];
        if ([textField isKindOfClass:[UITextField class]]) {
            textField.delegate = self;
        }

    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"DetailVCCell2"];
        
    }
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DetailVCCell1"];
    }else if(indexPath.row == 3){
        cell = [tableView dequeueReusableCellWithIdentifier:@"DetailVCCell3"];
        UITextField *textField = (UITextField *)[cell viewWithTag:300];
       
        if ([textField isKindOfClass:[UITextField class]]) {
            textField.delegate = self;
        }
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"DetailVCCell2"];
        
    }

    return cell.frame.size.height;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark =====CoachCircleRootDelegate=======================
-(void)selectedCoachCirleMonster:(List_Circle *)newCoachdata{
   
    if (!_progressHUD) {
        _progressHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        _progressHUD.userInteractionEnabled=YES;
    }
    NSDictionary *parameters = @{@"id": [NSString stringWithFormat:@"%d",newCoachdata.ID],
                                 @"key":Key_HTTP
                                 };
    [[AFClient sharedCoachClient]getPath:@"GetDetail_Circle" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        }else{
            resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        [_progressHUD hide:YES];
        NSLog(@"GetDetail_Circle::%@",resultDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_progressHUD hide:YES];
    }];
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
