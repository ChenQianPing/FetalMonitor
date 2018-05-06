#import "Global.h"

NSString* TTPathForDocumentsResource(NSString* relativePath)
{
    static NSString* documentsPath =nil;
    if (nil == documentsPath)
    {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        documentsPath = [dirs objectAtIndex:0];
    }
    return [documentsPath stringByAppendingPathComponent:relativePath];
}
