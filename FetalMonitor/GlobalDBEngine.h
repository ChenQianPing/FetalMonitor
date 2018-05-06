#import <Foundation/Foundation.h>
#import "GrardianshipData.h"

@interface GlobalDBEngine : NSObject

+ (GlobalDBEngine *)sharedDB;

- (BOOL)insertGrardianshipData:(GrardianshipData *)grardianshipData;
- (NSArray *)getLocalGrardianshipDataWithType:(NSString *)grardianshipId;
- (BOOL)updateGrardianshipDataWith:(NSString *)grardianshipId andFilename:(NSString *)filename;
- (BOOL)deleGrardianshipDataWithFilename:(NSString *)filename;
- (NSArray *)getUnUploadGrardianshipDataWithType:(NSString *)grardianshipId;

@end
