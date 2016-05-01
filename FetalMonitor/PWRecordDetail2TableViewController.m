//
//  PWRecordDetail2TableViewController.m
//  FetalMonitor
//
//  Created by hexin on 16/4/19.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "PWRecordDetail2TableViewController.h"

@interface PWRecordDetail2TableViewController ()

@end

@implementation PWRecordDetail2TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       [self didShowDetail];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}


-(void)didShowDetail{
    if([self pwRecordModel] != nil){
        //_status.text =_pwRecordModel.status;
        //_DataId.text =_pwRecordModel.DataId;
        //_IsReply.text =_pwRecordModel.IsReply;
        // _monitorStartTime.text =_pwRecordModel.monitorStartTime;
        _RealName.text = [NSString stringWithFormat:@"姓名：%@",_pwRecordModel.RealName];
        _YuChanQi.text = [NSString stringWithFormat:@"预产期：%@",_pwRecordModel.YuChanQi];
        _YuChanQi_title.text =_pwRecordModel.monitorDate;
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
        _ReplyTime.text = _pwRecordModel.monitorDate;
        
        // _DoctorComment.text =_pwRecordModel.DoctorComment;
        
    }
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
