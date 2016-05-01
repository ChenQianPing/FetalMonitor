//
//  MyWebViewController.h
//  FetalMonitor
//
//  Created by hexin on 16/4/21.
//  Copyright © 2016年 soar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWebViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic,  strong)NSString *url;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
