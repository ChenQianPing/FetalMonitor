//
//  JianHuJiluTableViewController.h
//  FetalMonitor
//
//  Created by hexin on 16/4/22.
//  Copyright © 2016年 soar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface JianHuJiluTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *topview;

@end
