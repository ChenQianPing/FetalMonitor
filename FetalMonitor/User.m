#import "User.h"

#import "NSDictionary+Utils.h"

#define kUserFilePath TTPathForDocumentsResource(@"user.bin")

@interface User ()
{
}

@end

@implementation User

@synthesize uid = _uid;

#pragma mark - NSObject
- (id)init
{
    if(self = [super init])
    {
        [self loadFromFile];
    }
    
    return self;
}

#pragma mark - Public
+ (User *)sharedUser
{
    static User *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _instance = [[User alloc] init];
    });
    
    return _instance;
}

- (void)loadFromFile
{
    User* user = [NSKeyedUnarchiver unarchiveObjectWithFile:kUserFilePath];
    if(user)
    {
        _uid = user.uid;
        _deviceId = user.deviceId;
    }
    
    user = nil;
}

- (void)saveToFile
{
    [NSKeyedArchiver archiveRootObject:self toFile:kUserFilePath];
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.deviceId forKey:@"deviceId"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        _uid = [aDecoder decodeObjectForKey:@"uid"];
        _deviceId = [aDecoder decodeObjectForKey:@"deviceId"];
    }
    return self;
}

@end
