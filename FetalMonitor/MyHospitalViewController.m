//
//  MyHospitalViewController.m
//  FetalMonitor
//
//  Created by hexin on 16/4/20.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "MyHospitalViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface MyHospitalViewController ()

@end

@implementation MyHospitalViewController{
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self loadString:@"http://www.zgzqjh.com/FetusMember/MyHospital"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 让浏览器加载指定的字符串,使用m.baidu.com进行搜索
- (void)loadString:(NSString *)str
{
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    //
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.zgzqjh.com/"]];
    [_webView loadRequest:request];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
   
    
    NSString *headerStr = @"var oldnode=document.getElementsByTagName('header')[0];oldnode.parentNode.removeChild(oldnode);;";
    [self.webView stringByEvaluatingJavaScriptFromString:headerStr];
    
}



/*

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *headerStr = @"var oldnode=document.getElementsByTagName('header')[0];oldnode.parentNode.removeChild(oldnode);;";
    //[webView stringByEvaluatingJavaScriptFromString:headerStr];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
