#import "JSObjectText.h"

@implementation JSObject

-(void) startAudio
{
    [self.delegate didStartAudio];
}

-(void) stopAudio
{
    [self.delegate didStopAudio];
}
    
-(void) resetAudio
{
    [self.delegate didResetAudio];
}

@end
