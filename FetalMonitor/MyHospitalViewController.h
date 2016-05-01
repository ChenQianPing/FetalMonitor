//
//  MyHospitalViewController.h
//  FetalMonitor
//
//  Created by hexin on 16/4/20.
//  Copyright © 2016年 soar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

@interface MyHospitalViewController : UIViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
