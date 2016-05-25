//
//  PhotoContrast.m
//  数字健身
//
//  Created by 城云 官 on 14-4-24.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "PhotoContrast.h"
#import "MRZoomScrollView.h"
#import "FitnessTestList.h"

@interface PhotoContrast ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) MRZoomScrollView  *zoomScrollView;
@end

@implementation PhotoContrast

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
    

    if (IS_IOS_7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarAction)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapaction:)];
    [self.view addGestureRecognizer:tapGest];
    [self initScollView];
}

-(void)initScollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    _scrollView.delegate = self;
//    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

    
    [_scrollView setContentSize:CGSizeMake(1024/2 * self.images.count, 768)];
    
    for (int i = 0; i < self.images.count; i++) {
        _zoomScrollView = [[MRZoomScrollView alloc]initWithFrame:CGRectMake(1024/2*i, 0, 1024/2, 768)];

        _zoomScrollView.imageView.contentMode = UIViewContentModeScaleToFill;
        FitnessTestList *fitness = self.images[i];
        if ([fitness.type isEqualToString:@"name"]) {
            _zoomScrollView.imageView.image = [UIImage imageNamed:fitness.name];
        }else if([fitness.type isEqualToString:@"filePath"]){
            _zoomScrollView.imageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",fitness.filePath,fitness.name]];
        }

        [self.scrollView addSubview:_zoomScrollView];
    }

}

-(void)tapaction:(UITapGestureRecognizer *)sender{
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

////禁止竖屏
-(NSUInteger)supportedInterfaceOrientations
{

    return UIInterfaceOrientationMaskLandscape;
}


- (BOOL)shouldAutorotate
{
    return YES;
}
//
//
//- (void)orientationChanged
//{
//    //UIView *ftView = [self.view viewWithTag:200];
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)//判断左右
//    {
//        //界面的新布局
//    }
//    if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait )//我有个方向不支持，如果想都支持那就不要这个if条件就行了
//    {
//        //界面的新布局
//    }
//}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait|UIInterfaceOrientationPortraitUpsideDown|UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight];
  
}

-(void)leftBarAction{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    //    [self.navigationController popViewControllerAnimated:NO];
    //    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
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
