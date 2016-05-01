#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *currentUserId; //当前登录用户（孕妇）
@property (strong, nonatomic) NSString *currentDoctor; //当前登录医生
@property (strong, nonatomic) NSString *currentHospital; //当前登录医院


@end