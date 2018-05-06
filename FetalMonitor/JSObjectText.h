#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSAudioDelegate <NSObject>

-(void)didStopAudio;

-(void)didResetAudio;

-(void)didStartAudio;

@end

@protocol JSObjectText <JSExport>

-(void) startAudio;

-(void) stopAudio;

-(void) resetAudio;

@end

@interface JSObject : NSObject<JSObjectText>

@property (nonatomic, strong) NSObject<JSAudioDelegate> *delegate;

@end
