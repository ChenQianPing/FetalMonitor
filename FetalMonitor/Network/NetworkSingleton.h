//
//  NetworkSingleton.h
//  美团
//
//  Created by zhaoyuan on 15/8/12.
//  Copyright (c) 2015年 zhaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//请求超时
#define TIMEOUT 30

typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlock)(NSString *error);


@interface NetworkSingleton : NSObject

+(NetworkSingleton *)sharedManager;
-(AFHTTPSessionManager *)baseHtppRequest;

-(void)getUrl:(NSString *)url id:params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

@end
