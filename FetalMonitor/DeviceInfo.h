#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

@property (nonatomic, strong) NSData *alarmSwitch;  //报警开关
@property (nonatomic, strong) NSData *maxAlarm;     //报警上限
@property (nonatomic, strong) NSData *minAlarm;     //报警下限
@property (nonatomic, strong) NSData *alarmDelay;   //报警延时
@property (nonatomic, strong) NSData *volume;       //音量
@property (nonatomic, strong) NSData *powerInfo;    //电源信息
@property (nonatomic, strong) NSData *deviceId;     //设备号
@property (nonatomic, strong) NSData *grardianshipStatus;           //监护状态
@property (nonatomic, strong) NSString *grardianshipCacheFile;      //监护缓存文件标识
@property (nonatomic, strong) NSData *grardianshipCacheFileMaxIndex;//监护缓存最大索引

-(void)print;

@end
