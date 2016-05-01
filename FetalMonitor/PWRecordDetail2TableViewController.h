//
//  PWRecordDetail2TableViewController.h
//  FetalMonitor
//
//  Created by hexin on 16/4/19.
//  Copyright © 2016年 soar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWRecordListModel.h"

@interface PWRecordDetail2TableViewController : UITableViewController


//model
@property(nonatomic,strong) PWRecordListModel *pwRecordModel;

//view
//@property (nonatomic, strong) IBOutlet UILabel *status;
//@property (nonatomic, strong) IBOutlet UILabel *DataId;
//@property (nonatomic, strong) IBOutlet UILabel *IsReply;
//@property (nonatomic, strong) IBOutlet UILabel *monitorStartTime;

@property (weak, nonatomic) IBOutlet UILabel *RealName;
@property (weak, nonatomic) IBOutlet UILabel *YuChanQi;

@property (weak, nonatomic) IBOutlet UILabel *YuChanQi_title;
@property (weak, nonatomic) IBOutlet UILabel *Position_title;
@property (weak, nonatomic) IBOutlet UILabel *Position;

@property (nonatomic, strong) IBOutlet  UILabel *Type;

@property (nonatomic, strong) IBOutlet  UILabel *StartTime;
@property (nonatomic, strong) IBOutlet  UILabel *EndTime;
@property (nonatomic, strong)  IBOutlet UILabel *monitorDate;
@property (weak, nonatomic) IBOutlet UILabel *monitorUseTime;




@property (nonatomic, strong)  IBOutlet UILabel *CheckResult;
@property (nonatomic, strong) IBOutlet  UILabel *Doctor;
@property (nonatomic, strong)  IBOutlet UILabel *ReplyScore;
@property (nonatomic, strong)  IBOutlet UILabel *ReplyTime;
@property (nonatomic, strong)  IBOutlet UILabel *ReplyText;


@end
