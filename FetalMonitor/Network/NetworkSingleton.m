//
//  NetworkSingleton.m
//  美团
//
//  Created by zhaoyuan on 15/8/12.
//  Copyright (c) 2015年 zhaoyuan. All rights reserved.
//

#import "NetworkSingleton.h"

@implementation NetworkSingleton

+(NetworkSingleton *)sharedManager{
    static NetworkSingleton *sharedNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkSingleton = [[self alloc] init];
    });
    return sharedNetworkSingleton;
}
-(AFHTTPSessionManager *)baseHtppRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];

    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    return manager;
}

#pragma mark - 上门服务
-(void)getUrl:(NSString *)url id:params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlStr parameters:params success:^(NSURLSessionDataTask *operation, id responseObject){
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
}





@end
