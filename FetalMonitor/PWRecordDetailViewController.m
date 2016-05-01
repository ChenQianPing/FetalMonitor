//
//  PWRecordDetailViewController.m
//  FetalMonitor
//
//  Created by hexin on 16/4/19.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "PWRecordDetailViewController.h"
#import "PWRecordListModel.h"

@interface PWRecordDetailViewController ()



@end

@implementation PWRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self didShowDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didShowDetail{
    if([self pwRecordModel] != nil){
        //_status.text =_pwRecordModel.status;
        //_DataId.text =_pwRecordModel.DataId;
        //_IsReply.text =_pwRecordModel.IsReply;
       // _monitorStartTime.text =_pwRecordModel.monitorStartTime;
        _RealName.text = [NSString stringWithFormat:@"性名：%@",_pwRecordModel.RealName];
        _YuChanQi.text = [NSString stringWithFormat:@"预产期：%@",_pwRecordModel.YuChanQi];
         _YuChanQi_title.text =_pwRecordModel.YuChanQi;
        _Type.text =  [NSString stringWithFormat:@"设备类型：%@",_pwRecordModel.Type];
        _Position.text = [NSString stringWithFormat:@"检测胎位：%@",_pwRecordModel.Position];
        _Position_title.text =_pwRecordModel.Position;
        _StartTime.text = [NSString stringWithFormat:@"起始时间：%@",_pwRecordModel.StartTime];
        _EndTime.text = [NSString stringWithFormat:@"结束时间：%@",_pwRecordModel.EndTime];
        _monitorDate.text = [NSString stringWithFormat:@"检测日期：%@",_pwRecordModel.monitorDate];
       // _Minute.text =_pwRecordModel.Minute;
        //_Second.text =_pwRecordModel.Second;
        _monitorUseTime.text = [NSString stringWithFormat:@"时长%@分%@秒",_pwRecordModel.Minute,_pwRecordModel.Second];
        _CheckResult.text = [NSString stringWithFormat:@"本次检测结论：%@",_pwRecordModel.CheckResult];
        _Doctor.text =_pwRecordModel.Doctor;
                             _ReplyScore.text = [NSString stringWithFormat:@"得分：%@",_pwRecordModel.ReplyScore];
        _ReplyText.text =_pwRecordModel.ReplyText;
       // _DoctorComment.text =_pwRecordModel.DoctorComment;
        
    }
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
