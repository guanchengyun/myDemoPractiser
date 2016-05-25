//
//  MessageDetailVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-25.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "MessageDetailVC.h"

@interface MessageDetailVC ()
@property(strong, nonatomic)NSMutableArray *ViewControllers;
@property(assign,nonatomic)NSInteger index;
@property(weak, nonatomic)UIViewController *previousViewController;
@end

@implementation MessageDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
         self.ViewControllers = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.previousViewController) {
        self.previousViewController.view.hidden = NO;
        self.previousViewController.view.frame = self.view.bounds;
        [self.view addSubview:self.previousViewController.view];
        [self addChildViewController:self.previousViewController];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   
    [self.ViewControllers addObject:segue.destinationViewController];
    if ([segue.identifier isEqualToString:@"ToInvitationMessageVC"]) {
        self.index = 0;
        self.previousViewController = segue.destinationViewController;
    }else if([segue.identifier isEqualToString:@"ToNoticeMessageVC"]){
    
    }
}

#pragma mark - MessageMasterVCDelegate
-(void)selectedContainVc:(NSInteger )ContainNumber{
    if (self.index == ContainNumber) {
        return;
    }  
    self.index = ContainNumber;
    self.previousViewController.view.hidden = YES;
    [self.previousViewController.view removeFromSuperview];
    self.previousViewController = [self.ViewControllers objectAtIndex:ContainNumber];
    if (self.previousViewController) {
        self.previousViewController.view.hidden = NO;
        [self.view addSubview:self.previousViewController.view];
        [self addChildViewController:self.previousViewController];
    }
   

}

@end
