#import "DeviceInfo.h"

@implementation DeviceInfo

-(void)print
{
    NSLog(@"alarmSwitch : %@ \nmaxAlarm : %@ \nminAlarm : %@ \nalarmDelay : %@ \nvolume : %@ \npowerInfo : %@ \ndeviceId : %@ \ngrardianshipStatus : %@ \ngrardianshipCacheFile : %@ \ngrardianshipCacheFileMaxIndex : %@",_alarmSwitch,_maxAlarm,_minAlarm,_alarmDelay,_volume,_powerInfo,_deviceId,_grardianshipStatus,_grardianshipCacheFile,_grardianshipCacheFileMaxIndex);
}

@end
