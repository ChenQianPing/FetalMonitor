//
//  HomeMenuCell.h
//  FetalMonitor
//
//  Created by hexin on 16/4/25.
//  Copyright © 2016年 soar. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol HomeMenuDelegate <NSObject>

-(void)homeMenuDidSelectedAtIndex:(NSInteger)index;

@end

@interface HomeMenuCell : UITableViewCell

@property (nonatomic, assign) id<HomeMenuDelegate> delegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSArray *)menuArray;

@end
