//
//  AddMenberDataVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-15.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "AddMenberDataVC.h"

@interface AddMenberDataVC ()<UIAlertViewDelegate>
@property(weak, nonatomic)UITextField *TitleTextField;
@property(weak, nonatomic)UITextView *ContactTextView;
@property(strong, nonatomic)NSArray *tabledata;
@end

@implementation AddMenberDataVC

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
    if ((self.TitleStr != nil)||(self.ContactStr != nil)) {
        self.tabledata = [NSArray arrayWithObjects:self.TitleStr,self.ContactStr,@"删除", nil];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"buttonIndex::%d",buttonIndex);
    if (buttonIndex == 1) {
        [self.delegate Delete:_CellRow];
    }
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
    if (self.tabledata.count > 1) {
        return self.tabledata.count;
    }
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *IdentiCel1 = @"Cell1";
    static NSString *IdentiCel2 = @"Cell2";
    static NSString *IdentiCel3 = @"Cell3";

    if (indexPath.row == 0) {
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:IdentiCel1 forIndexPath:indexPath];
        UITextField *textfield = (UITextField *)[cell1 viewWithTag:301];
        self.TitleTextField = textfield;
        if ([self.tabledata objectAtIndex:indexPath.row]) {
            self.TitleTextField.text = [self.tabledata objectAtIndex:indexPath.row];
        }
        cell = cell1;
    }else if(indexPath.row == 1){
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:IdentiCel2 forIndexPath:indexPath];
        UITextView *textView = (UITextView *)[cell2 viewWithTag:302];
        self.ContactTextView = textView;
        if (self.tabledata[indexPath.row]) {
            self.ContactTextView.text = self.tabledata[indexPath.row];
        }
        cell = cell2;
    }else if(indexPath.row == 2){
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:IdentiCel3 forIndexPath:indexPath];
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
        return 474;
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

- (IBAction)done:(id)sender
{
    if (self.TitleTextField.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"标题不能为空"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.ContactTextView.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"内容不能为空"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self.delegate SaveTiele:self.TitleTextField.text Contact:self.TitleTextField.text];
}

- (IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
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
