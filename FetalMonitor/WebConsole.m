#import "WebConsole.h"

@implementation WebConsole

+ (void) enable
{
    [NSURLProtocol registerClass:[WebConsole class]];
}

+ (BOOL) canInitWithRequest:(NSURLRequest *)request
{
    if ([[[request URL] host] isEqualToString:@"debugger"])
    {
        NSLog(@"%@", [[[request URL] path] substringFromIndex: 1]);
    }
    
    return FALSE;
}

@end
