//
//  InvitationMessageVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-25.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "InvitationMessageVC.h"

@interface InvitationMessageVC ()
@property(weak, nonatomic)IBOutlet UIButton *AcceptButton;
@property(weak, nonatomic)IBOutlet UIButton *RefusedButton;
@end

@implementation InvitationMessageVC

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
    [self.AcceptButton setTitle:@"接受" forState:UIControlStateNormal];
    [self.AcceptButton setTintColor:[UIColor whiteColor]];
    [self.AcceptButton setTitle:@"已接受" forState:UIControlStateSelected];
    [self.AcceptButton setBackgroundColor:[UIColor colorWithHexString:@"5489ab"]];
    
    [self.RefusedButton setTitle:@"拒绝" forState:UIControlStateNormal];
    [self.RefusedButton setTitle:@"已拒绝" forState:UIControlStateSelected];
    [self.RefusedButton setBackgroundColor:[UIColor colorWithHexString:@"d95644"]];
    
}

-(IBAction)BtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
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
