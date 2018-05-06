#import "CTTabBarController.h"
#import "CTTabBarButton.h"
#import "CTTabBar.h"
#import "UIColor16.h"

@interface CTTabBarController () <CTTabBarDelegate>

@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation CTTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = self.tabBar.bounds;
    
    CTTabBar *customTabBar = [[CTTabBar alloc] init];
    customTabBar.delegate = self;
    customTabBar.frame = rect;
    [customTabBar setBackgroundColor:[UIColor16 colorWithHexString:@"#000000"]];
    [self.tabBar addSubview:customTabBar];
    
    NSArray *imageNames = [NSArray arrayWithObjects:
                            @"tabbar-website-nor", @"tabbar-website-press",
                            @"tabbar-monitor-nor", @"tabbar-monitor-press",
                            @"tabbar-monitor-record-nor", @"tabbar-monitor-record-press",
                            @"tabbar-setting-nor", @"tabbar-setting-press"
                           ,nil];
    NSArray *texts = [NSArray arrayWithObjects:@"服务", @"监护", @"站点", @"设置", nil];
    
    NSInteger i = 0, count = self.viewControllers.count;
    for(; i < count; i++)
    {
        NSString *imageName = [imageNames objectAtIndex:(i * 2)];
        NSString *imageNameSelected = [imageNames objectAtIndex:(i * 2 + 1)];
        
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *imageSelected = [UIImage imageNamed:imageNameSelected];
        
        [customTabBar addButtonWithImage:image selectedImage:imageSelected labelText:[texts objectAtIndex:i] textColor:[UIColor16 colorWithHexString:@"#ffffff"] selectedTextColor:[UIColor16 colorWithHexString:@"#758fc8"] drawablePadding:2];
    }
}

- (void)tabBar:(CTTabBar *)tabBar selectedFrom:(NSInteger)fromIndex To:(NSInteger)toIndex
{
    self.selectedIndex = toIndex;
}

@end
