//
//  PWRecordListModel.h
//  FetalMonitor
//
//  Created by hexin on 16/4/18.
//  Copyright © 2016年 soar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PWRecordListModel :NSObject



@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *DataId;
@property (nonatomic, strong) NSNumber *IsReply;
@property (nonatomic, strong) NSString *monitorStartTime;
@property (nonatomic, strong) NSString *RealName;
@property (nonatomic, strong) NSString *YuChanQi;
@property (nonatomic, strong) NSString *Type;
@property (nonatomic, strong) NSString *Position;
@property (nonatomic, strong) NSString *StartTime;
@property (nonatomic, strong) NSString *EndTime;
@property (nonatomic, strong) NSString *monitorDate;
@property (nonatomic, strong) NSNumber *Minute;
@property (nonatomic, strong) NSNumber *Second;
@property (nonatomic, strong) NSString *CheckResult;
@property (nonatomic, strong) NSString *Doctor;
@property (nonatomic, strong) NSNumber *ReplyScore;
@property (nonatomic, strong) NSString *ReplyText;
@property (nonatomic, strong) NSString *DoctorComment;

@end