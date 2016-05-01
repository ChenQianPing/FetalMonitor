//
//  NSString+convertImgStr.h
//  FetalMonitor
//
//  Created by hexin on 16/4/25.
//  Copyright © 2016年 soar. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (convertImgStr)

//$$$转imgurl
+(NSString *)convertImgStr:(NSString *)imgStr;

+(NSString *)getSpecialId:(NSString *)special;

+(NSString *)getWebUrl:(NSString *)cont;

+(NSString *)getComponentUrl:(NSString *)cont;

@end
