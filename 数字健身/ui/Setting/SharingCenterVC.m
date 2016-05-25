//
//  SharingCenterVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-25.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "SharingCenterVC.h"
#import <ShareSDK/ShareSDK.h>

@interface SharingCenterVC (){
    NSMutableArray *_oneKeyShareListArray;
}
@property(strong, nonatomic)NSArray *TableViewData;
@end

@implementation SharingCenterVC

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
//    self.TableViewData = @[@"Share1.png",@"Share2.png",@"Share3.png"];
    _oneKeyShareListArray = [[NSMutableArray alloc] initWithObjects:
                             [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                              @"type",
                              [NSNumber numberWithBool:NO],
                              @"selected",
                              nil],
                             [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              SHARE_TYPE_NUMBER(ShareType163Weibo),
                              @"type",
                              [NSNumber numberWithBool:NO],
                              @"selected",
                              nil],
                             [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                              @"type",
                              [NSNumber numberWithBool:NO],
                              @"selected",
                              nil],
                             nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchAction:(UISwitch *)sender{
    BOOL isButtnOn = [sender isOn];
    NSInteger index = sender.tag;
    
    NSMutableDictionary *item = [_oneKeyShareListArray objectAtIndex:index];
    ShareType shareType = (ShareType)[[item objectForKey:@"type"] integerValue];
    
    if ([ShareSDK hasAuthorizedWithType:shareType])
    {
        BOOL selected = ! [[item objectForKey:@"selected"] boolValue];
        [item setObject:[NSNumber numberWithBool:selected] forKey:@"selected"];
        
        
    }
    else
    {
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:YES
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        
        //在授权页面中添加关注官方微博
        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                        nil]];
        
        [ShareSDK getUserInfoWithType:shareType
                          authOptions:authOptions
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   
                                   if (result)
                                   {
                                       [item setObject:[NSNumber numberWithBool:YES] forKey:@"selected"];
                                       sender.on = YES;
                                       
                                   }
                                   else
                                   {
                                       sender.on = NO;
                                       if ([error errorCode] != -103)
                                       {
                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")  message:NSLocalizedString(@"TEXT_BING_FAI", @"绑定失败!")  delegate:nil cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了") otherButtonTitles:nil];
                                           [alertView show];
                                           
                                       }
                                   }
                               }];
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
    return _oneKeyShareListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSharing" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    NSDictionary *item = [_oneKeyShareListArray objectAtIndex:indexPath.row];
    UIImage *icon = [ShareSDK getClientIconWithType:(ShareType)[[item objectForKey:@"type"] integerValue]];

    imageView.image = icon;
    UISwitch *swich = (UISwitch *)[cell viewWithTag:101];
    if ([swich isKindOfClass:[swich class]]) {
        swich.on = [[item objectForKey:@"selected"] boolValue];
        swich.tag = indexPath.row;
        [swich addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    // Configure the cell...
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0;
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
