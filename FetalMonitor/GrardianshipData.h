#import <Foundation/Foundation.h>

@interface GrardianshipData : NSObject

@property (nonatomic, strong) NSString *grardianshipID;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *uploadStatus;

-(void)setDict:(NSDictionary *)dict;

@end
