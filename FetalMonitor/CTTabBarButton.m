#import "CTTabBarButton.h"
#import "UIColor16.h"

@implementation CTTabBarButton

- (instancetype) initWithSpace:(int)space
{
    self = [super init];
    if(self)
    {
        _space = space;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize selfSize = self.frame.size;
    CGSize sef = self.bounds.size;
    CGSize imgSize = self.imageView.frame.size;
    CGRect titleFrame = [self titleLabel].frame;
    
    int paddingTop = (sef.height - imgSize.height - _space - titleFrame.size.height) / 2;
    
    CGPoint center = self.imageView.center;
    center.x = selfSize.width / 2;
    center.y = paddingTop + imgSize.height / 2;
    self.imageView.center = center;
    
    // title
    titleFrame.origin.x = 0;
    titleFrame.origin.y = paddingTop + imgSize.height + _space;
    titleFrame.size.width = selfSize.width;
    self.titleLabel.frame = titleFrame;
    self.titleLabel.textAlignment = UITextAlignmentCenter;
}

- (void) setHighlighted:(BOOL)highlighted
{
    // 取消系统按钮高亮效果
    //[super setHighlighted:<#highlighted#>];
}

@end
