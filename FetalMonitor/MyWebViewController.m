//
//  MyWebViewController.m
//  FetalMonitor
//
//  Created by hexin on 16/4/21.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "MyWebViewController.h"

#import "Public.h"
#import "JSObjectText.h"
#import "AVFoundation/AVFoundation.h"

@interface MyWebViewController ()


@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic,strong) NSTimer *avTimer;

@end

@implementation MyWebViewController

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [super viewDidLoad];
    
   
    
    [self didLoadUrl];
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didLoadUrl{
    
    // 1. URL 定位资源,需要资源的地址
    NSString *urlStr = _url;

    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [self.webView loadRequest:request];
    self.view.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    
    
    

 //

}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    /*
    NSString *headerStr = @"javascript:function remTitle(){var oldnode=document.getElementsByTagName('header')[0];oldnode.parentNode.removeChild(oldnode);var oldnode2=document.getElementsByClassName('maintop_bg')[0];oldnode2.parentNode.removeChild(oldnode2);}remTitle();";
    
    */
    
    NSString *headerStr = @"javascript:function remTitle(){var oldnode=document.getElementsByTagName('header')[0];oldnode.style.backgroundColor='#000';oldnode.style.backgroundImage='none';var nodep = document.getElementsByClassName('a1')[0];}remTitle();";
    

    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSObject *text=[JSObject new];
    text.delegate = self;
    context[@"oc"]=text;
    
    NSString *wavfile =  [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('j_audio').src"];
    
    if( [wavfile length]>0)
        [self loadAudio:wavfile];
    else
        [self didStopAudio];
    
    
    
    
    //[webView stringByEvaluatingJavaScriptFromString:headerStr];
}



- (void)timer
{
    CMTime currentTime = self.player.currentItem.currentTime;
    int currentPlayTime = (int)(currentTime.value/currentTime.timescale);
    CMTime totalTime = self.player.currentItem.duration;
    int totalPlayTime = (int)(totalTime.value/totalTime.timescale);
    
    NSString *text = [NSString stringWithFormat:@"进度: %d秒/%d秒", currentPlayTime, totalPlayTime];
    [self audioState:text];
}

-(void) audioState:(NSString*)text
{
    NSString *c = [NSString stringWithFormat:@"audioState(\"%@\");", text];
   // [[self webView]  stringByEvaluatingJavaScriptFromString:c];
}

-(void)loadAudio:(NSString*)wavfile
{
    NSLog(@"download sucess.");
    [self audioState:@"正在加载wav文件..."];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
   NSString *fileName = @"tempfile.wav";
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *savePath=[cachePath stringByAppendingPathComponent:fileName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:savePath];
    if(blHave)[[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
    if (true)
    {
        NSString *urlStr= wavfile;// [NSString stringWithFormat:@"%@%@", @"http://www.zgzqjh.com/uploads/mp3/" , fileName];
        urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:urlStr];
        
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        
        NSURLSession *session=[NSURLSession sharedSession];
        
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error)
                                                  {
                                                      if (!error)
                                                      {
                                                          NSError *saveError;
                                                          NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                                                          NSString *savePath=[cachePath stringByAppendingPathComponent:fileName];
                                                          NSLog(@"%@",savePath);
                                                          NSURL *saveUrl=[NSURL fileURLWithPath:savePath];
                                                          [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveUrl error:&saveError];
                                                          if (!saveError)
                                                          {
                                                              NSLog(@"download sucess.");
                                                              [self audioState:@"加载wav文件成功."];
                                                              
                                                              _player = [[AVPlayer alloc] initWithURL:saveUrl];
                                                              [_player setVolume:1];
                                                              [_player play];
                                                          }
                                                          else
                                                          {
                                                              NSLog(@"error is :%@",saveError.localizedDescription);
                                                              NSLog(@"download sucess.");
                                                              [self audioState:@"加载wav文件失败."];
                                                          }
                                                      }
                                                      else
                                                      {
                                                          NSLog(@"error is :%@",error.localizedDescription);
                                                          NSLog(@"download sucess.");
                                                          [self audioState:@"加载wav文件失败."];
                                                      }
                                                  }];
        
        [downloadTask resume];
    }
    else
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
        
        
        NSURL *url = [NSURL fileURLWithPath:savePath];
        _player = [[AVPlayer alloc] initWithURL:url];
        [_player setVolume:1];
        [_player play];
        NSLog(@"player: %@", url);
        
        NSLog(@"download sucess.");
        [self audioState:@"正在播放..."];
    }
}

-(void)didStartAudio
{
    if(_player != nil)
    {
        [_player play];
    }
}

-(void)didResetAudio
{
    //    if(_player != nil)
    //    {
    //        [_player play];
    //    }
}

-(void)didStopAudio
{
    if(_player != nil)
    {
        [_player pause];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
