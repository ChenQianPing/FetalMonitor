#import "CTChart.h"
#import "WebConsole.h"
#import "NetworkSingleton.h"
#import <AVFoundation/AVFoundation.h>
#import "PPIUtils.h"
#import "LKCPlayManager.h"

@interface CTChart ()

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, copy) NSString *chartData;

@property (nonatomic, assign) BOOL dataLoadState;
@property (nonatomic, assign) BOOL pageLoadState;

@end

@implementation CTChart

-(void) viewDidLoad
{
    [super viewDidLoad];
 
    [WebConsole enable];
    
    self.title = @"图谱";
    
    [self loadWebView];
}

-(void) loadWebView
{
    _webView = [[UIWebView alloc] init];
    _webView.frame = self.view.bounds;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"chart.htm" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _webView.delegate = self;
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    [self getChartData];
    [self loadChartAudio];
}

-(void)loadChartAudio
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    NSString *fileName = _monitorData.Mp3Path;
    //NSString *fileName = @"Temp_fubxf20160325101144_2016-05-21_15-57-58.wav";
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
                                                              
                                                              _player = [[AVPlayer alloc] initWithURL:saveUrl];
                                                              [_player setVolume:1];
                                                              [_player play];
                                                          }
                                                          else
                                                          {
                                                              NSLog(@"error is :%@",saveError.localizedDescription);
                                                          }
                                                      }
                                                      else
                                                      {
                                                          NSLog(@"error is :%@",error.localizedDescription);
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
    }
}

-(void) getChartData
{
    NSString *url = [NSString stringWithFormat:@"http://www.zgzqjh.com/ajax.aspx?action=App&cmd=get_fetus_monitorData&fileName=%@", _monitorData.FileName];
    [[NetworkSingleton sharedManager]getUrl:url id:nil successBlock:^(id responseBody)
    {
        if([responseBody isKindOfClass:[NSArray class]])
        {
            NSMutableString * result = [[NSMutableString alloc] init];
            [result appendString:@"["];
            for (NSObject * obj in responseBody)
            {
                if ([obj isKindOfClass:[NSNumber class]])
                {
                    [result appendString:[NSString stringWithFormat:@"%@,", [obj description]]];
                }
                else
                {
                    [result appendString:[NSString stringWithFormat:@"\"%@\",", [obj description]]];
                }
            }
            NSRange range;
            range.location = result.length - 1;
            range.length = 1;
            [result deleteCharactersInRange:range];
                        [result appendString:@"]"];
            
            _chartData = result;
            _dataLoadState = YES;
            if(_pageLoadState)
            {
                [self loadChart];
            }
        }
        
    } failureBlock:^(NSString *error)
     {
         NSLog(@"请求图谱数据成功失败.");
    }];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"UIWebView load succeed.");
    
    [self loadChart];
    _pageLoadState = YES;
    if(_dataLoadState)
    {
        [self loadChart];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"UIWebView load fail.");
}

- (void) loadChart
{
    float scale = [[UIScreen mainScreen] scale];
    int oneCMPoints = [PPIUtils getPointForOneCm: scale];
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    float height = self.view.frame.size.height - rectStatus.size.height - rectNav.size.height;
    
    NSString *func = [NSString stringWithFormat:@"fetalHeartChart.start(%@, %d, %f, %f);", _chartData, oneCMPoints,
                      self.view.frame.size.width, height];
    [_webView stringByEvaluatingJavaScriptFromString:func];
}

@end
