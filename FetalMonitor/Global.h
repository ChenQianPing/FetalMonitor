#import <Foundation/Foundation.h>

// 屏幕尺寸
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// Image Name
#undef TTIMAGE
#define TTIMAGE(URL) [UIImage imageNamed:URL]

// Font Size
#define fontWithBoldSize(size) [UIFont boldSystemFontOfSize:size]
#define fontWithSize(size) [UIFont systemFontOfSize:size]

// RGB颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// 清除背景色
#define CLEARCOLOR [UIColor clearColor]

// 返回状态码
#define kSuccessCode @"1"   //成功
#define kFailureCode @"0"   //失败
#define kErrorCode   @"-1"  //系统错误
#define kUploadMonitoringDataPauseServiceErrorCode @"-7" //上传数据暂停错误

NSString* TTPathForDocumentsResource(NSString* relativePath);

#define MONITORDATA_AUDIO_SERVER_ADDRESS @"http://www.zgzqjh.com/uploads/mp3/"
