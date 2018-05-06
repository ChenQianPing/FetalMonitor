//
//  MyDoctorViewController.m
//  FetalMonitor
//
//  Created by hexin on 16/4/20.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "MyDoctorViewController.h"

@interface MyDoctorViewController ()

@end

@implementation MyDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [self loadString:@"http://www.zgzqjh.com/FetusMember/MyDoctor"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 让浏览器加载指定的字符串,使用m.baidu.com进行搜索
- (void)loadString:(NSString *)str
{
    // 1. URL 定位资源,需要资源的地址
    NSString *urlStr = str;
    /*
     if (![str hasPrefix:@"http://"]) {
     urlStr = [NSString stringWithFormat:@"http://m.baidu.com/s?word=%@", str];
     }
     */
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
    //[webView stringByEvaluatingJavaScriptFromString:headerStr];
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
