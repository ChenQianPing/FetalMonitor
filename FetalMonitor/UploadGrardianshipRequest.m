
#import "UploadGrardianshipRequest.h"
#import "Global.h"


@implementation UploadGrardianshipRequest
{
    NSString *_userId;
    NSString *_deviceId;
    NSString *_filePath;
    NSString *_audioFilePath;
}

-(id)initWithGravidaId:(NSString *)userId andDeviceId:(NSString *)deviceId andFilePath:(NSString *)filePath andAudioFilePath: (NSString *) audioPath
{
    self = [super init];
    if (self)
    {
        _userId = userId;
        _deviceId = deviceId;
        _filePath = filePath;
        _audioFilePath = audioPath;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"http://www.zgzqjh.com/ajax.aspx?action=App&cmd=upload_fetus_monitorData";
}

- (YTKRequestSerializerType)requestSerializerType
{
    return YTKRequestSerializerTypeHTTP;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (AFConstructingBlock)constructingBodyBlock
{
    return ^(id<AFMultipartFormData> formData)
    {
        NSArray *strArr = [_filePath componentsSeparatedByString:@"/"];
        NSString *uploadFileName = strArr.lastObject;
        
        NSData *data = [NSData dataWithContentsOfFile:_filePath];
        NSString *name = uploadFileName;
        NSString *formKey = @"MonitorData";
        NSString *type = @"text/ftd";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        
        NSArray *strAudioArr = [_audioFilePath componentsSeparatedByString:@"/"];
        NSString *uploadAudioFileName = strAudioArr.lastObject;
        
        NSData *audioData = [NSData dataWithContentsOfFile:_audioFilePath];
        NSString *audioName = uploadAudioFileName;
        [formData appendPartWithFileData:audioData name:@"AudioData" fileName:audioName mimeType:@"text/wav"];
    };
}
- (id)requestArgument
{    
    return nil;
}

@end
