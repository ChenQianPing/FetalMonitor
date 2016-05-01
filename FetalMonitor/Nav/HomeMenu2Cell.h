//
//  HomeMenuCell.h
//  FetalMonitor
//
//  Created by hexin on 16/4/25.
//  Copyright © 2016年 soar. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol HomeMenu2Delegate <NSObject>

-(void)homeMenu2DidSelectedAtIndex:(NSInteger)index;

@end

@interface HomeMenu2Cell : UITableViewCell

@property (nonatomic, assign) id<HomeMenu2Delegate> delegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSArray *)menuArray;

@end
