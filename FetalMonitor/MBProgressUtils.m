//
//  MBProgressUtils.m
//  FetalMonitor
//
//  Created by soar on 16/8/18.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "MBProgressUtils.h"
#import "MBProgressHUD.h"

@implementation MBProgressUtils

+ (void)showRemind:(NSString*) text addTo:(UIView*) view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3.f];
}

@end
