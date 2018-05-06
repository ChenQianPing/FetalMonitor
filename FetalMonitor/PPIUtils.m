#import "PPIUtils.h"
#import "sys/utsname.h"

@implementation PPIUtils

+ (int) getPointForOneCm: (float)scale
{
    NSInteger ppi = [self machine];
    return  ppi / 2.54 / scale;
}

+ (int) machine
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", code);
    
    static NSDictionary* deviceNamesByPPI = nil;
    if (!deviceNamesByPPI) {
        deviceNamesByPPI = @{
                             @"i386"      :@(326), // 32-bit Simulator
                             @"x86_64"    :@(326), // 64-bit Simulator
                             @"iPod1,1"   :@(163), // iPod Touch
                             @"iPod2,1"   :@(163), // iPod Touch Second Generation
                             @"iPod3,1"   :@(163), // iPod Touch Third Generation
                             @"iPod4,1"   :@(163), // iPod Touch Fourth Generation
                             @"iPhone1,1" :@(163), // iPhone
                             @"iPhone1,2" :@(163), // iPhone 3G
                             @"iPhone2,1" :@(163), // iPhone 3GS
                             @"iPad1,1"   :@(132), // iPad
                             @"iPad2,1"   :@(132), // iPad 2
                             @"iPad3,1"   :@(264), // 3rd Generation iPad
                             @"iPhone3,1" :@(326), // iPhone4(GSM)
                             @"iPhone3,3" :@(326), // iPhone4(CDMA/Verizon/Sprint)
                             @"iPhone4,1" :@(326), // iPhone4S
                             @"iPhone5,1" :@(326), // iPhone5(model A1428, AT&T/Canada)
                             @"iPhone5,2" :@(326), // iPhone5(model A1429, everything else)
                             @"iPad3,4"   :@(264), // 4th Generation iPad
                             @"iPad2,5"   :@(163), // iPad Mini
                             @"iPhone5,3" :@(326), // iPhone 5c (model A1456, A1532 | GSM)
                             @"iPhone5,4" :@(326), // iPhone 5c (model A1507, A1516, A1526 (China), A1529 | Global)
                             @"iPhone6,1" :@(326), // iPhone 5s (model A1433, A1533 | GSM)
                             @"iPhone6,2" :@(326), // iPhone 5s (model A1457, A1518, A1528 (China), A1530 | Global)
                             @"iPad4,1"   :@(264), // 5th Generation iPad (iPad Air) - Wifi
                             @"iPad4,2"   :@(264), // 5th Generation iPad (iPad Air) - Cellular
                             @"iPad2,5"   :@(163), // iPad Mini
                             @"iPad2,6"   :@(163) ,// iPad Mini
                             @"iPad2,7"   :@(163), // iPad Mini
                             @"iPad4,4"   :@(163), // 2nd Generation iPad Mini - Wifi
                             @"iPad4,5"   :@(163) ,// 2nd Generation iPad Mini - Cellular
                             @"iPad4,6"   :@(163), // iPad Mini
                             @"iPad4,7"   :@(163), // iPad Mini
                             @"iPad4,8"   :@(163), // iPad Mini
                             @"iPad4,9"   :@(163), // iPad Mini
                             @"iPhone7,1" :@(401), // iPhone 6 Plus
                             @"iPhone7,2" :@(326), // iPhone 6
                             @"iPhone8,1" :@(326), // iPhone 6s
                             @"iPhone8,2" :@(401), // iPhone 6s Plus
                             @"iPhone8,4" :@(326), // iPhone SE
                             };
    }
    
    NSNumber *ppi = [deviceNamesByPPI objectForKey:code];
    
    return [ppi integerValue];
}

@end
