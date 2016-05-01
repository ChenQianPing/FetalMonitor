//
//  PWRecordCell.h
//  FetalMonitor
//
//  Created by hexin on 16/4/17.
//  Copyright © 2016年 soar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWRecordListModel.h"

@interface PWRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *test_result;
@property (weak, nonatomic) IBOutlet UILabel *test_time;
@property (weak, nonatomic) IBOutlet UILabel *isReply;
@property (weak, nonatomic) IBOutlet UILabel *labelOrder;
@property (weak, nonatomic) IBOutlet UILabel *labelReplay;

-(void)setPWRecordListM:(PWRecordListModel *)recordListM;

@end
