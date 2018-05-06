#import <Foundation/Foundation.h>
#import "AFNetworking.h"

// 请求超时
#define TIMEOUT 30

typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlock)(NSString *error);


@interface NetworkSingleton : NSObject

+(NetworkSingleton *)sharedManager;
-(AFHTTPSessionManager *)baseHtppRequest;

-(void)getUrl:(NSString *)url id:params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

@end
