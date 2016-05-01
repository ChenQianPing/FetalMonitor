//
//  BannerTableViewCell.h
//  FetalMonitor
//
//  Created by hexin on 16/4/25.
//  Copyright © 2016年 soar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface BannerTableViewCell : UITableViewCell<SDCycleScrollViewDelegate>
-(id)loadImages;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
