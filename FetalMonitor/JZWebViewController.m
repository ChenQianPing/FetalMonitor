//
//  JZWebViewController.m
//  nuomi
//
//  Created by jinzelu on 15/9/29.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "JZWebViewController.h"
#import "Public.h"
#import "JSObjectText.h"
#import "AVFoundation/AVFoundation.h"

@interface JZWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic,strong) NSTimer *avTimer;

@end

@implementation JZWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.webView.scalesPageToFit = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
    
    [self initViews];
    
    
   // _webView = [[UIWebView alloc] init];
   // _webView.frame = self.view.bounds;
    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"htm"];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
   // _webView.delegate = self;
   // [_webView loadRequest:request];
    //[self.view addSubview:_webView];
    
    self.avTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initViews{
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(screen_width/2-15, screen_height/2-15, 30, 30)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityView.hidesWhenStopped = YES;
    [self.view addSubview:_activityView];
    [self.view bringSubviewToFront:_activityView];
}



#pragma mark - **************** UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"开始加载webview");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载webview完成");
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = theTitle;
    
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSObject *text=[JSObject new];
    text.delegate = self;
    context[@"oc"]=text;
    
    [self loadAudio];
    
    
    /*
    NSString *headerStr = @"javascript:function remTitle(){var oldnode=document.getElementsByTagName('header')[0];oldnode.parentNode.removeChild(oldnode);var oldnode2=document.getElementsByClassName('maintop_bg')[0];oldnode2.parentNode.removeChild(oldnode2);}remTitle();";
    */
    
    NSString *headerStr = @"javascript:function remTitle(){var oldnode=document.getElementsByTagName('header')[0];oldnode.style.backgroundColor='#000';oldnode.style.backgroundImage='none';var nodep = document.getElementsByClassName('a1')[0];}remTitle();";
    
    
    
    //[webView stringByEvaluatingJavaScriptFromString:headerStr];
    
    [_activityView stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"加载webview失败");
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = theTitle;
    NSLog(@"shouldStartLoadWithRequest:   %@",theTitle);
    /*
    NSString *headerStr = @"javascript:function remTitle(){var oldnode=document.getElementsByTagName('header')[0];oldnode.parentNode.removeChild(oldnode);var oldnode2=document.getElementsByClassName('maintop_bg')[0];oldnode2.parentNode.removeChild(oldnode2);}remTitle();";
     
     */
    
    NSString *headerStr = @"javascript:function remTitle(){var oldnode=document.getElementsByTagName('header')[0];oldnode.style.backgroundColor='#000';oldnode.style.backgroundImage='none';}remTitle();";
    
    //[webView stringByEvaluatingJavaScriptFromString:headerStr];
    
    [_activityView startAnimating];
    return YES;
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
    [_webView  stringByEvaluatingJavaScriptFromString:c];
}

-(void)loadAudio
{
    NSLog(@"download sucess.");
    [self audioState:@"正在加载wav文件..."];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    NSString *fileName = @"2016-08-11_08-58_fubxf20160325101144.wav";
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *savePath=[cachePath stringByAppendingPathComponent:fileName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:savePath];
    if (!blHave)
    {
        NSString *urlStr= [NSString stringWithFormat:@"%@%@", @"http://www.zgzqjh.com/uploads/mp3/" , fileName];
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
