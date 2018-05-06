#import "YTKRequest.h"

@interface UploadGrardianshipRequest : YTKRequest

-(id)initWithGravidaId:(NSString *)userId andDeviceId:(NSString *)deviceId andFilePath:(NSString *)path andAudioFilePath:(NSString *) path;

@end
