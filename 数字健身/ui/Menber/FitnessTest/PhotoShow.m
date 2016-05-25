//
//  PhotoShow.m
//  数字健身
//
//  Created by 城云 官 on 14-4-24.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "PhotoShow.h"
#import "MRZoomScrollView.h"
#import "PhotoCollectVC.h"

@interface PhotoShow ()<UIScrollViewDelegate,PhotoCollectVCDelegate>
//@property (weak, nonatomic) IBOutlet MRZoomScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (strong, nonatomic) IBOutlet MRZoomScrollView *ScrollView;

@end

@implementation PhotoShow

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
    // Do any additional setup after loading the view from its nib.
    if (IS_IOS_7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarAction)];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加图片" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarAction)];

    [self initScrollView];
}

-(void)viewWillDisappear:(BOOL)animated{
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

-(void)initScrollView{
   
    UIInterfaceOrientation orientation=[UIApplication sharedApplication].statusBarOrientation;
    CGFloat screenWidht=0;
    CGFloat screenHeight=0;
    if (orientation==UIInterfaceOrientationLandscapeLeft||orientation==UIInterfaceOrientationLandscapeRight) {
        screenWidht=[UIScreen mainScreen].bounds.size.height;
        screenHeight=[UIScreen mainScreen].bounds.size.width;
    }else{
        screenWidht=[UIScreen mainScreen].bounds.size.width;
        screenHeight=[UIScreen mainScreen].bounds.size.height;
    }
    
//    NSLog(@"sel::%@",NSStringFromCGRect(self.view.frame));
   
    if (self.ScrollView == nil) {
        self.ScrollView = [[MRZoomScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidht, screenHeight)];
    }

    [self.view addSubview:_ScrollView];
    
    if ([self.FitnesList.type isEqualToString:@"name"]) {
        _ScrollView.imageView.image = [UIImage imageNamed:self.FitnesList.name];
    }else if([self.FitnesList.type isEqualToString:@"filePath"]){
        _ScrollView.imageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",self.FitnesList.filePath,self.FitnesList.name]];
    }
    self.ImageView.image = [UIImage imageNamed:@"Default-Landscape.png"];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapaction:)];
    [self.view addGestureRecognizer:tapGest];
}

-(void)leftBarAction{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
//    [self.navigationController popViewControllerAnimated:NO];
//    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
-(void)rightBarAction{
    PhotoCollectVC *photoseletvc = [[PhotoCollectVC alloc]init];
    photoseletvc.delegate = self;
    photoseletvc.FitnesList = self.FitnesList;
    [self.navigationController pushViewController:photoseletvc animated:YES];
}

#pragma mark === PhotoCollectVCDelegate=====

-(void)sendArray:(NSArray *)array{

}
#pragma mark 旋转方向发生改变时
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.ScrollView removeFromSuperview];
    self.ScrollView = nil;
    [self initScrollView];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    UIImageView *imageview = (UIImageView *)[scrollView viewWithTag:101];
    imageview.center = scrollView.center;
}

-(void)tapaction:(UITapGestureRecognizer *)sender{
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
