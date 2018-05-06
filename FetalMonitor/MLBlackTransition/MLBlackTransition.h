#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    MLBlackTransitionGestureRecognizerTypePan, // 拖动模式
	MLBlackTransitionGestureRecognizerTypeScreenEdgePan, // 边界拖动模式
} MLBlackTransitionGestureRecognizerType;

@interface MLBlackTransition : NSObject

+ (void)validatePanPackWithMLBlackTransitionGestureRecognizerType:(MLBlackTransitionGestureRecognizerType)type;

@end

@interface UIView(__MLBlackTransition)

// 使得此view不响应拖返
@property (nonatomic, assign) BOOL disableMLBlackTransition;

@end

@interface UINavigationController(DisableMLBlackTransition)

- (void)enabledMLBlackTransition:(BOOL)enabled;

@end
