//
//  BannerTableViewCell.m
//  FetalMonitor
//
//  Created by hexin on 16/4/25.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "BannerTableViewCell.h"
#import "SDCycleScrollView.h"
#import "Public.h"

@implementation BannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithMyStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"http://www.zgzqjh.com/uploads/image/20160309/14574941835902.jpg",
                                  @"http://www.zgzqjh.com/uploads/image/20160118/14531043665335.png",
                                  @"http://www.zgzqjh.com/uploads/image/20160410/14602546356181.jpg"
                                  ];
    
    // 情景三：图片配文字
    NSArray *titles = @[@"",
                        @"",
                        @""
                        ];
    
    
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, screen_width, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView2.imageURLStringsGroup = imagesURLStrings;

    [self addSubview:cycleScrollView2];
    
    //         --- 模拟加载延迟
  //  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
  //  });
    }
        return self;
}
-(id)loadImages{
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"http://www.zgzqjh.com/uploads/image/20160309/14574941835902.jpg",
                                  @"http://www.zgzqjh.com/uploads/image/20160118/14531043665335.png",
                                  @"http://www.zgzqjh.com/uploads/image/20160410/14602546356181.jpg"
                                  ];
    
    // 情景三：图片配文字
    NSArray *titles = @[@"",
                        @"",
                        @""
                        ];
    
    
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, screen_width, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    
    [self addSubview:cycleScrollView2];
    
    //         --- 模拟加载延迟
    //  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    //  });

return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
