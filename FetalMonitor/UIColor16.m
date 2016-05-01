#import "UIColor16.h"

@implementation UIColor16

+ (UIColor *) colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    // 删除字符串中的空格
    NSString *colorString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([colorString length] < 6)
    {
        return [UIColor clearColor];
    }
    
    // 如果是0X开头的, 那么截取字符串, 字符串从索引为2的位置开始, 一直到末尾
    if ([colorString hasPrefix:@"0X"])
    {
        colorString = [colorString substringFromIndex:2];
    }
    // 如果是#开头的, 那么截取字符串, 字符串从索引为1的位置开始, 一直到末尾
    if ([colorString hasPrefix:@"#"])
    {
        colorString = [colorString substringFromIndex:1];
    }
    if ([colorString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [colorString substringWithRange:range];
    range.location = 2;
    NSString *gString = [colorString substringWithRange:range];
    range.location = 4;
    NSString *bString = [colorString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

// 默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}

@end
