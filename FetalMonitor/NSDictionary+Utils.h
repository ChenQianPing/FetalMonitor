#import <Foundation/Foundation.h>

@interface NSDictionary (Utils)

- (NSInteger)integerValueForKey:(id)key;
- (int)intValueForKey:(id)key;

- (BOOL)boolValueForKey:(id)key;

- (float)floatValueForKey:(id)key;

- (NSString *)stringValueForKey:(id)key;
- (NSArray *)arrayValueForKey:(id)key;
- (NSMutableArray*)mutableArrayValueForKey:(NSString *)key;
- (NSDictionary *)dictionaryValueForKey:(id)key;


- (NSDictionary* )parseHTML;
- (NSDictionary *)urlEncoded;

@end
