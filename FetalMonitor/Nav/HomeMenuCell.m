//
//  HomeMenuCell.m
//  meituan
//
//  Created by jinzelu on 15/6/30.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "HomeMenuCell.h"
#import "UIImageView+WebCache.h"
#import "Public.h"

@interface HomeMenuCell ()<UIScrollViewDelegate>
{
    UIView *_backView1;
    UIView *_backView2;
    UIPageControl *_pageControl;
}

@end

@implementation HomeMenuCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSArray *)menuArray{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 160)];
        _backView2 = [[UIView alloc] initWithFrame:CGRectMake(screen_width, 0, screen_width, 160)];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 180)];
        scrollView.contentSize = CGSizeMake(2*screen_width, 180);
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        [scrollView addSubview:_backView1];
       // [scrollView addSubview:_backView2];
        [self addSubview:scrollView];
        
        
        
        //创建6个
        for (int i = 0; i < [menuArray count]; i++) {
          
            if (i < 3) {
                CGRect frame = CGRectMake(i*screen_width/3, 0, screen_width/3, 80);
                NSString *title = menuArray[i][0];
                NSString *imageStr1 = menuArray[i][1];
                NSString *imageStr = @"icon_homepage_entertainmentCategory";
                

                UIView *menubackView = [[UIView alloc] initWithFrame:frame];
                menubackView.tag = i ;
                
                [_backView1 addSubview:menubackView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [menubackView addGestureRecognizer:tap];
                
                CGFloat frameWidth = frame.size.width;
                CGFloat frameHeight = frame.size.height;
                //图
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frameWidth/2-20, 20, 40, 40)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr1] placeholderImage:[UIImage imageNamed:imageStr]];
                [menubackView addSubview:imageView];
                //文字
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), frameWidth, 20)];
                titleLabel.font = [UIFont systemFontOfSize:12];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.text = title;
                [menubackView addSubview:titleLabel];
                
                
                
                
            }else if(i<6){
                CGRect frame = CGRectMake((i-3)*screen_width/3, 80, screen_width/3, 80);
                NSString *title = menuArray[i][0];
                NSString *imageStr1 = menuArray[i][1];
                NSString *imageStr = @"icon_homepage_entertainmentCategory";
                
                //换掉
                UIView *menubackView = [[UIView alloc] initWithFrame:frame];
                
                menubackView.tag =i;
                
                [_backView1 addSubview:menubackView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [menubackView addGestureRecognizer:tap];
                
                CGFloat frameWidth = frame.size.width;
                CGFloat frameHeight = frame.size.height;
                //图
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frameWidth/2-20, 20, 40, 40)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr1] placeholderImage:[UIImage imageNamed:imageStr]];
                [menubackView addSubview:imageView];
                //文字
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), frameWidth, 20)];
                titleLabel.font = [UIFont systemFontOfSize:12];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.text = title;
                [menubackView addSubview:titleLabel];
            }else if(i < 10){
                CGRect frame = CGRectMake((i-6)*screen_width/3, 0, screen_width/3, 80);
                NSString *title = menuArray[i][0];
                NSString *imageStr1 = menuArray[i][1];
                NSString *imageStr = @"icon_homepage_entertainmentCategory";
                
                //换掉
                UIView *menubackView = [[UIView alloc] initWithFrame:frame];
                menubackView.tag = i;
                [_backView2 addSubview:menubackView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [menubackView addGestureRecognizer:tap];
                
                CGFloat frameWidth = frame.size.width;
                CGFloat frameHeight = frame.size.height;
                //图
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frameWidth/2-20, 20, 40, 40)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr1] placeholderImage:[UIImage imageNamed:imageStr]];
                [menubackView addSubview:imageView];
                //文字
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), frameWidth, 20)];
                titleLabel.font = [UIFont systemFontOfSize:12];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.text = title;
                [menubackView addSubview:titleLabel];
            }else{
                CGRect frame = CGRectMake((i-15)*screen_width/5, 80, screen_width/5, 80);
                NSString *title = menuArray[i][0];
                NSString *imageStr1 = menuArray[i][1];
                NSString *imageStr = @"icon_homepage_entertainmentCategory";
                
                //换掉
                UIView *menubackView = [[UIView alloc] initWithFrame:frame];
                menubackView.tag = 10+i;
                [_backView2 addSubview:menubackView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [menubackView addGestureRecognizer:tap];
                
                CGFloat frameWidth = frame.size.width;
                CGFloat frameHeight = frame.size.height;
                //图
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frameWidth/2-20, 20, 40, 40)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr1] placeholderImage:[UIImage imageNamed:imageStr]];
                [menubackView addSubview:imageView];
                //文字
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), frameWidth, 20)];
                titleLabel.font = [UIFont systemFontOfSize:12];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.text = title;
                [menubackView addSubview:titleLabel];
            }
        }
        
        //
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(screen_width/2-20, 160, 0, 20)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 0;
        //        self.backgroundColor = [UIColor redColor];
        [self addSubview:_pageControl];
        [_pageControl setCurrentPageIndicatorTintColor:navigationBarColor];
        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)OnTapBtnView:(UITapGestureRecognizer *)sender{
    NSLog(@"tag:%ld",sender.view.tag);
    [self.delegate homeMenuDidSelectedAtIndex:sender.view.tag];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    _pageControl.currentPage = page;
}


@end
