//
//  MessageMasterVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-25.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "MessageMasterVC.h"
#import "MessgaLeftCell.h"

@interface MessageMasterVC ()<UITableViewDelegate, UITableViewDataSource>
@property(assign, nonatomic)NSInteger SeletCell;
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UITableView *MessageTableView;
@property (weak, nonatomic) UIButton *seletedBtn;
@property (weak, nonatomic)NSMutableArray *TableViewData;
@property (strong, nonatomic)NSMutableArray *TableViewDataLeft;
@property (strong, nonatomic)NSMutableArray *TableViewDataRight;

@end

@implementation MessageMasterVC

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
    [self initTopSeletView];
    self.MessageTableView.delegate = self;
    self.MessageTableView.dataSource = self;
    self.TableViewDataLeft = [NSMutableArray arrayWithCapacity:10];
    self.TableViewDataRight = [NSMutableArray arrayWithCapacity:9];
    self.TableViewData = _TableViewDataLeft;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (IS_IOS_7) {
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:self.SeletCell inSection:0];
        
        [self.MessageTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }
   
}

-(void)initTopSeletView{
    UIImage *image = [[UIImage imageNamed:@"MenberSeletImage.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    for (UIButton *btn in _TopView.subviews) {
        if (btn.selected==YES) {
            self.seletedBtn = btn;
        }
        [btn setBackgroundImage:image forState:UIControlStateSelected];
    }
        
    UIView *lineView_TopSeletView            = [[UIView alloc] initWithFrame:CGRectMake(0, 41.5, 320, 2.5)];
    lineView_TopSeletView.opaque             = YES;
    lineView_TopSeletView.backgroundColor    = [UIColor colorWithRed:186.0/255.0 green:186.0/255.0 blue:188.0/255.0 alpha:0.8];
    [_TopView addSubview:lineView_TopSeletView];
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
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    MessgaLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MessgaLeftCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    
    }
    if (_TableViewData == _TableViewDataRight) {
        cell.ImageHead.image = [UIImage imageNamed:[NSString stringWithFormat:@"Menber%d.png",indexPath.row%3+1]];
        cell.LabelName.text = @"悦动健身房";
        cell.LabelDetail.text = @"本健身房推出办月卡享五折优惠";
        cell.LabelTime.text = @"2014/02/08";

    }else{
        cell.ImageHead.image = [UIImage imageNamed:[NSString stringWithFormat:@"Menber%d.png",indexPath.row%3+1]];
        cell.LabelName.text = @"张会员";
        cell.LabelDetail.text = @"预约9月10号11点到12点的课程";
        cell.LabelTime.text = @"2014/02/08";
    }
   
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_TableViewData == _TableViewDataRight) {
        [self.delegate selectedContainVc:1];
    }else{
         [self.delegate selectedContainVc:0];
    }
}

- (IBAction)SeletBtnAction:(id)sender {
    if ([self.seletedBtn isEqual:sender]) {
        return;
    }
    self.seletedBtn = sender;
    for (UIButton *btn in self.TopView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected = NO;
        }
    }
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        btn.selected = !btn.selected;
        if (btn.tag == 100) {
            self.TableViewData = _TableViewDataLeft;
        }else{
            self.TableViewData = _TableViewDataRight;
        }
        [self.MessageTableView reloadData];
    }
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
