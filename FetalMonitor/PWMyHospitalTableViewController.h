//
//  PWMyHospitalTableViewController.h
//  FetalMonitor
//
//  Created by hexin on 16/4/19.
//  Copyright © 2016年 soar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHospital.h"
#import "WBWeibo.h"

@interface PWMyHospitalTableViewController : UITableViewController
@property (nonatomic, strong) MyHospital   *MyHospital;


@property (nonatomic, weak) IBOutlet UILabel  *Status;

@property (nonatomic, weak) IBOutlet UIImageView
*HospitalImage;

@property (nonatomic, weak) IBOutlet UILabel  *HospitalAddress;

@property (nonatomic, weak) IBOutlet UILabel  *Tel;

@property (nonatomic, weak) IBOutlet UILabel  *ZipCode;

@property (nonatomic, weak) IBOutlet UILabel  *WebsiteUrl;

@property (nonatomic, weak) IBOutlet UILabel  *Description;

@property (weak, nonatomic) IBOutlet UIWebView *WebDescription;

@end
