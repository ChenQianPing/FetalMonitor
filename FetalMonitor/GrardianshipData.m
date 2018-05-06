#import "GrardianshipData.h"

@implementation GrardianshipData

-(void)setDict:(NSDictionary *)dict{
    _grardianshipID = [dict objectForKey:@"id"];
    _fileName = [dict objectForKey:@"filename"];
    _createTime = [dict objectForKey:@"create_time"];
    _duration = [dict objectForKey:@"duration"];
    _uploadStatus = [dict objectForKey:@"upload_status"];
}

@end
