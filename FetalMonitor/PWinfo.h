//
//  PWinfo.h
//  FetalMonitor
//
//  Created by hexin on 16/4/16.
//  Copyright © 2016年 soar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWinfo : NSObject

@property(nonatomic,copy)NSString *pregnant_week;           //怀孕周数
@property(nonatomic,copy)NSString *pregnant_day;              //怀孕天数
@property(nonatomic,copy)NSString *meet_week;           //宝宝见面周数
@property(nonatomic,copy)NSString *meet_day;              //宝宝见面天数
@property(nonatomic,copy)NSString *device_type;              //设备类型
@property(nonatomic,copy)NSString *device_no;              //设备编号
@property(nonatomic,copy)NSString *pregnant_times;              //胎儿数量

@end
