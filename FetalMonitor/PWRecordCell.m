//
//  PWRecordCell.m
//  FetalMonitor
//
//  Created by hexin on 16/4/17.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "PWRecordCell.h"

@implementation PWRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPWRecordListM:(PWRecordListModel *)recordListM{
    self.test_result.text =[NSString stringWithFormat:@"%@ %@",recordListM.RealName,recordListM.monitorStartTime];
    self.test_time.text = [NSString stringWithFormat:@"%@ %@", recordListM.Type ,recordListM.Position];
    self.isReply.text = [recordListM.IsReply isEqualToNumber:[NSNumber numberWithInteger:1]] ? @"医生已回复" : @"未回复";
    self.labelReplay.text = recordListM.DoctorComment;
    
    self.labelOrder.text = recordListM.Doctor;
}

@end
