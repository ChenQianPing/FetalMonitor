//
//  MyWebViewController.m
//  FetalMonitor
//
//  Created by hexin on 16/4/21.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "MyWebViewController.h"

@interface MyWebViewController ()

@end

@implementation MyWebViewController

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [super viewDidLoad];
    
    [self didLoadUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didLoadUrl{
    
    // 1. URL 定位资源,需要资源的地址
    NSString *urlStr = _url;

    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [self.webView loadRequest:request];
    self.view.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *headerStr = @"var oldnode=document.getElementsByTagName('header')[0];oldnode.parentNode.removeChild(oldnode);;";
    [webView stringByEvaluatingJavaScriptFromString:headerStr];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
