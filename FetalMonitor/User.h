#import "Global.h"

@class User;

@interface User : NSObject <NSCoding>

@property(nonatomic, strong) NSString  *uid;        //用户编号
@property(nonatomic, strong) NSString *deviceId;    //设备编号

+ (User *)sharedUser;

- (void)saveToFile;

@end
