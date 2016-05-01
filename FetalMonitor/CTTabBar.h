#import <UIKit/UIKit.h>

@class CTTabBar;

@protocol CTTabBarDelegate <NSObject>

- (void) tabBar:(CTTabBar *)tabBar selectedFrom:(NSInteger) fromIndex To:(NSInteger) toIndex;

@end

@interface CTTabBar : UIView

@property(nonatomic, weak) id<CTTabBarDelegate> delegate;

- (void) addButtonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage labelText:(NSString *) text textColor:(UIColor *)color selectedTextColor:(UIColor *)selectedColor drawablePadding:(int)padding;

@end
