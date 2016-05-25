//
//  SeletMenberVC.m
//  数字健身
//
//  Created by 城云 官 on 14-6-10.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "SeletMenberVC.h"

@interface SeletMenberVC ()

@end

@implementation SeletMenberVC

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
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarAction)];
}

//-(void)rightBarAction{
//
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBarButton{
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    [self performSegueWithIdentifier:@"PushToMenberMainDetailVC" sender:indexPath];
    ListMenber *listmenber = [self getListMenber:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(GetMenberID:)]) {
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//        }];
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate GetMenberID:listmenber];
    }
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
