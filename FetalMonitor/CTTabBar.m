#import "CTTabBar.h"
#import "CTTabBarButton.h"
#import "UIColor16.h"

@interface CTTabBar()

@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation CTTabBar

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    
    for(int i = 0; i < count; i++)
    {
        UIButton *button = self.subviews[i];
        button.tag = i;
        
        CGFloat x = i * self.bounds.size.width / count;
        CGFloat y = 0;
        CGFloat width = self.bounds.size.width / count;
        CGFloat height = self.bounds.size.height;
        button.frame = CGRectMake(x, y, width, height);
    }
}

//// 无法设置成功
//- (void) drawRect:(CGRect)rect
//{
//    [self setBackgroundColor:[UIColor16 colorWithHexString:@"#758fc8"]];
//    [super drawRect:rect];
//}

// 可以支持超过5个Item, 但背景设置和More不显示问题还未解决
- (void) addButtonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage labelText:(NSString *) text textColor:(UIColor *)color selectedTextColor:(UIColor *)selectedColor drawablePadding:(int)padding
{
    CTTabBarButton *button = [[CTTabBarButton alloc] initWithSpace:padding];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button setTitle:text forState:UIControlStateNormal];
    //[button setTitle:text forState:UIControlStateSelected];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:button];
    
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.subviews.count == 1)
    {
        [self clickButton: button];
    }
}

- (void) clickButton:(UIButton *) button
{
    // 将之前的按钮设置为未选中
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    if([self.delegate respondsToSelector:@selector(tabBar:selectedFrom:To:)])
    {
        [self.delegate tabBar:self selectedFrom:self.selectedButton.tag To:button.tag];
    }
}

@end
