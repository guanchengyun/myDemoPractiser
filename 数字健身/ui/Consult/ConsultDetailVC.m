//
//  ConsultDetailVC.m
//  数字健身
//
//  Created by 城云 官 on 14-4-26.
//  Copyright (c) 2014年 yuedong. All rights reserved.
//

#import "ConsultDetailVC.h"

@interface ConsultDetailVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *WebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ConsultDetailVC

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
    self.WebView.delegate = self;
//    self.WebView.scalesPageToFit = YES;
    self.activityIndicatorView.hidden = YES;
    self.WebView.scrollView.pagingEnabled = NO;
    self.WebView.scrollView.scrollEnabled = NO;
}

- (void)loadWebPageWithString:(NSString*)urlString
{
    [self.WebView stopLoading];
    
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.WebView loadRequest:request];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating] ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //修改服务器页面的meta的值
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
//    [webView stringByEvaluatingJavaScriptFromString:meta];
//    NSString *str = @"document.getElementById(‘ccc’)[0].style.webkitTextSizeAdjust= '1420%'";
    
//    [webView stringByEvaluatingJavaScriptFromString:str];
//    webView.scrollView.contentSize = CGSizeMake(800, 1800);
    self.WebView.scrollView.scrollEnabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
//    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    [alterview show];
    [self.WebView stopLoading];
}

#pragma mark --------ConsultMasterVCDelegate
-(void)selectedContainVcWeb:(NSString *)urlString{
    
    self.activityIndicatorView.hidden = NO;
    self.activityIndicatorView.color = [UIColor colorWithHexString:@"d95644"];
    [self loadWebPageWithString:urlString];
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
