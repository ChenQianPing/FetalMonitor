#import "RealTimeGuardianship.h"
#import "UUID.h"

#import <objc/runtime.h>
#import "SVProgressHUD.h"
#import "NSDictionary+Utils.h"
#import "GlobalDBEngine.h"
#import "MLBlackTransition.h"
#import "User.h"
#import "PPIUtils.h"
#import "UploadGrardianshipRequest.h"
#import "AppDelegate.h"
#import "YTKNetwork/YTKNetworkConfig.h"
#import "UIColor16.h"
#import "RightSliderView.h"
#import "MBProgressUtils.h"

#define PW_machineNo @"pw_machineNo"
static NSString * const CellIndentifier = @"CELL";

@interface RealTimeGuardianship ()

@end

@implementation RealTimeGuardianship
{
    ChartView *paint;
    
    BluetoothConnection *bluetoothConn;
    
    //监护状态
    int grardianState;
    
    //最小时长限制
    //BOOL canSaveData;
    
    //是否正在滚动
    BOOL isScrolling;
    
    NSUserDefaults *userDefaults;
    
    User *user;
    
    CGSize viewBoundSize;
    
    UIControl *control;
    
    int showTimeState;
    
    //分页
    int totalPage;
    int currPage;
    BOOL needToShowNewPage;
    
    RightSliderView *rightSlider;
}

-(void)viewWillAppear:(BOOL)animated
{
    // 禁用滑动返回
    self.view.disableMLBlackTransition = YES;
    self.scrollView.disableMLBlackTransition = YES;
    paint.disableMLBlackTransition = YES;
    _pageView.disableMLBlackTransition = YES;
    for (UIView *subView in _pageView.subviews)
    {
        subView.disableMLBlackTransition = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    needToShowNewPage = YES;
    bluetoothConn.isInRealView = YES;
    //    [self drawAllPoint];
    
    
//    NSString *minValue = [userDefaults objectForKey:@"speed"];
//    
//    float perPointValue = (minValue.intValue * 64.0) / (60.0 * 2);
//    float totalLenth = bluetoothConn.heartBeatPointArr.count * perPointValue;
//    
//    int pages = totalLenth / (viewBoundSize.width - 23.5) + 1;
//    
//    paint.frame = CGRectMake(0, 0, (viewBoundSize.width - 23.5) * pages, _scrollView.frame.size.height - 15);
//    _scrollView.contentSize = CGSizeMake((viewBoundSize.width - 23.5) * pages, _scrollView.frame.size.height);
//    
//    NSMutableArray *heartBeatPointArr = [NSMutableArray array];
//    NSMutableArray *uterinePressureArr = [NSMutableArray array];
//    NSMutableArray *fetalMovementArr = [NSMutableArray array];
//    for (int index = 0; index < 100; index++)
//    {
//    char *cData  = malloc(sizeof(char) * 5);
//    cData[0]  =  (char)(index & 0xff);
//    cData[1]  =  (char)((index >> 8) & 0xff);
//    cData[2] = 100;
//    cData[3] = 20;
//    cData[4] = 0;
//    NSData *origData = [NSData dataWithBytes:cData length:5];
//
//    NSMutableDictionary *dic = [self addPointPart:origData];
//    [heartBeatPointArr addObjectsFromArray:[dic objectForKey:@"heart"]];
//    [uterinePressureArr addObjectsFromArray:[dic objectForKey:@"press"]];
//    [fetalMovementArr addObjectsFromArray:[dic objectForKey:@"move"]];
//    }
//
//    [paint drawByPage:0 andHeartArr:heartBeatPointArr andPressArr:uterinePressureArr andMoveArr:fetalMovementArr];
}
//
//// 增量插点, 采样率：4
//-(NSMutableDictionary *)addPointPart:(NSData *)pointData
//{
//    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
//    
//    NSMutableArray *heartBeatArr = [NSMutableArray array];
//    NSMutableArray *pressArr = [NSMutableArray array];
//    NSMutableArray *moveArr = [NSMutableArray array];
//    
//    uint16_t num;
//    [pointData getBytes:&num range:NSMakeRange(0, 2)];
//    int num_i = (int)num;
//    
//    uint8_t heart;
//    [pointData getBytes:&heart range:NSMakeRange(2, 1)];
//    int heart_i = (int)heart;
//    
//    uint8_t press;
//    [pointData getBytes:&press range:NSMakeRange(3, 1)];
//    int press_i = (int)press;
//    
//    uint8_t move;
//    [pointData getBytes:&move range:NSMakeRange(4, 1)];
//    int move_i = (int)move;
//    
//    if (move_i>0)
//    {
//        //_moveCount++;
//    }
//    
//    int index = num_i;
//    NSNumber *objIndex = [NSNumber numberWithInt:index];
//    
//    
//    NSDictionary *heartPointDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:heart_i],objIndex, nil];
//    NSDictionary *pressPointDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:press_i],objIndex, nil];
//    NSDictionary *movePointDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:move_i],objIndex, nil];
//    
//    [heartBeatArr addObject:heartPointDic];
//    [pressArr addObject:pressPointDic];
//    [moveArr addObject:movePointDic];
//    
//    [resultDic setObject:heartBeatArr forKey:@"heart"];
//    [resultDic setObject:pressArr forKey:@"press"];
//    [resultDic setObject:moveArr forKey:@"move"];
//    
//    // NSLog(@"插值后 : %@",resultDic);
//    
//    return resultDic;
//}

-(void)viewWillDisappear:(BOOL)animated
{
    bluetoothConn.isInRealView = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"胎儿监护";
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem=leftButton;
    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting:)];
    self.navigationItem.rightBarButtonItem=rightButton;
    
    // 禁止进入锁屏状态
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    viewBoundSize = [UIScreen mainScreen].bounds.size;
    
    bluetoothConn = [BluetoothConnection shareBluetooth];
    bluetoothConn.delegate = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    user = [User sharedUser];
    
    if ([bluetoothConn isGrardianship])
    {
        grardianState = 1;
        [_monitorControlBtn setTitle:@"停止监护" forState:UIControlStateNormal];
    }
    else
    {
        grardianState = 0;
        [_monitorControlBtn setTitle:@"开始监护" forState:UIControlStateNormal];
    }
    
    [self fitScreen];
    
    [self initPaint];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    user.uid = appDelegate.currentUserId;
    user.deviceId = [defaults objectForKey:PW_machineNo];
    
    UIImage * bgImage1 = [self imageWithColor: [UIColor16 colorWithHexString:@"#fabfd8"] size:_monitorControlBtn.frame.size radius:3];
    [_monitorControlBtn setBackgroundImage:bgImage1 forState:UIControlStateNormal];
    _monitorControlBtn.frame = CGRectMake(
                                          _monitorControlBtn.frame.origin.x,
                                          _monitorControlBtn.frame.origin.y - 5,
                                          _monitorControlBtn.frame.size.width,
                                          _monitorControlBtn.frame.size.height);
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //[SVProgressHUD setMinimumDismissTimeInterval:5];
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radius:(float)radius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:radius] addClip];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

-(void) setting:(UIButton *)sender
{
    if(rightSlider == nil)
    {
        rightSlider = [[RightSliderView alloc] initWithFrame:self.view.bounds];
    }
    [rightSlider showInView:self.navigationController.view];
}

-(void)fitScreen
{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    int naviHeight = rectStatus.size.height + rectNav.size.height;
    int rectButtonHeight = 60;
    int marginTop = 10;
    int tableMargin = 30;
    int bottomHeight = 45;
    
    float perRowHeight = (viewBoundSize.height - naviHeight - rectButtonHeight - marginTop * 2 - tableMargin - bottomHeight) / 31;
    
    [self initNumberLayout:naviHeight and:rectButtonHeight];
    
    _scrollView.frame = CGRectMake(5, naviHeight + rectButtonHeight + marginTop, viewBoundSize.width - 10, 31 * perRowHeight + tableMargin);
    _scrollView.contentSize = CGSizeMake(viewBoundSize.width - 10, 31 * perRowHeight + tableMargin
                                         );
    // 分页
    _pageView.frame = CGRectMake(0, viewBoundSize.height, viewBoundSize.width, 50);
    currPage = 1;
    totalPage = 1;
    
    _monitorControlBtn.frame = CGRectMake(5, viewBoundSize.height - bottomHeight + 5, viewBoundSize.width - 10, bottomHeight - 5);
}

-(void) initNumberLayout:(int) naviHeight and:(int) numberRectHeight
{
    _fhrView.frame = CGRectMake(0, naviHeight, viewBoundSize.width / 3, numberRectHeight);
    _tocoView.frame = CGRectMake(viewBoundSize.width / 3, naviHeight, viewBoundSize.width / 3, numberRectHeight);
    _fmView.frame = CGRectMake(viewBoundSize.width / 3 * 2, naviHeight, viewBoundSize.width / 3, numberRectHeight);
    
    int imageWidth = _fhrView.frame.size.height / 3 * 2;
    
    _fhrImageView.frame = CGRectMake(_fhrView.frame.size.height, 0,
                                     imageWidth, _fhrView.frame.size.height);
    _fhrLabel.frame = CGRectMake(0, 0,
                                 _fhrView.frame.size.width - imageWidth, imageWidth);
    _fhrTitleLabel.frame = CGRectMake(0, _fhrLabel.frame.size.height,
                                      _fhrView.frame.size.width - imageWidth, _fhrView.frame.size.height / 3);
    _fhrTitleLabel.font = [UIFont systemFontOfSize:12];
    _fhrTitleLabel.textAlignment = UITextAlignmentCenter;
    
    
    _tocoImageView.frame = CGRectMake(_tocoView.frame.size.height, 0,
                                      imageWidth, _tocoView.frame.size.height);
    _tocoLabel.frame = CGRectMake(0, 0,
                                  _tocoView.frame.size.width - imageWidth, imageWidth);
    _tocoTitleLabel.frame = CGRectMake(0, _tocoLabel.frame.size.height,
                                       _tocoView.frame.size.width - imageWidth, _tocoView.frame.size.height / 3);
    _tocoTitleLabel.font = [UIFont systemFontOfSize:12];
    _tocoTitleLabel.textAlignment = UITextAlignmentCenter;
    
    _fmImageView.frame = CGRectMake(_fmView.frame.size.height, 0,
                                    imageWidth, _fmView.frame.size.height);
    _fmLabel.frame = CGRectMake(0, 0,
                                _fmView.frame.size.width -imageWidth, imageWidth);
    _fmTitleLabel.frame = CGRectMake(0, _fmLabel.frame.size.height,
                                     _fmView.frame.size.width - imageWidth, _fmView.frame.size.height / 3);
    _fmTitleLabel.font = [UIFont systemFontOfSize:12];
    _fmTitleLabel.textAlignment = UITextAlignmentCenter;
    
    [_tocoView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openSettings:)]];
    [_fmView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openSettings:)]];
}

-(void)openSettings:(id)sender
{
    if(rightSlider == nil)
    {
        rightSlider = [[RightSliderView alloc] initWithFrame:self.view.bounds];
    }
    [rightSlider showInView:self.navigationController.view];
}

-(void) initPaint
{
    NSString *minValue = [userDefaults objectForKey:@"speed"];
    
    paint = [[ChartView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) andBottomHeight:0];
    float scale = [[UIScreen mainScreen] scale];
    paint.sizePerMin = minValue.intValue * [PPIUtils getPointForOneCm: scale];
    paint.rate = 4;
    
    paint.delegate = self;
    
    [_scrollView addSubview:paint];
    
    [paint addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTime:)]];
    
    paint.maxAlarm = 160;
    paint.minAlarm = 110;
    
    //刷新安全范围
    [paint refreshView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)drawAllPoint
{
    NSString *minValue = [userDefaults objectForKey:@"speed"];
    
    float perPointValue = (minValue.intValue * 64.0) / (60.0 * 2);
    float totalLenth = bluetoothConn.heartBeatPointArr.count * perPointValue;
    
    int pages = totalLenth / (viewBoundSize.width - 23.5) + 1;
    
    paint.frame = CGRectMake(0, 0, (viewBoundSize.width - 23.5) * pages, _scrollView.frame.size.height - 15);
    _scrollView.contentSize = CGSizeMake((viewBoundSize.width - 23.5) * pages, _scrollView.frame.size.height);
    
    [paint drawAll:bluetoothConn.heartBeatPointArr andPressArr:bluetoothConn.uterinePressureArr andMoveArr:bluetoothConn.fetalMovementArr];
}

- (IBAction)begin:(UIButton *)sender
{
    if (grardianState == 0)
    {  //开始监护
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定开始监护？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 11;
        [alertView show];
        
    }
    else
    {  //停止监护
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定停止监护？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 22;
        [alertView show];
    }
}

- (IBAction)reset:(UIButton *)sender
{
    [bluetoothConn reset];
}

// 清空页面
-(void)refreshPaint
{
    [bluetoothConn.originDataArr removeAllObjects];
    [bluetoothConn.heartBeatPointArr removeAllObjects];
    [bluetoothConn.uterinePressureArr removeAllObjects];
    [bluetoothConn.fetalMovementArr removeAllObjects];
    bluetoothConn.moveCount = 0;
    
    [paint drawAll:bluetoothConn.heartBeatPointArr andPressArr:bluetoothConn.uterinePressureArr andMoveArr:bluetoothConn.fetalMovementArr];
}

-(void)uploadData:(NSString *)filePath andAudioPath: (NSString *) audioPath
{
    //测试上传数据
    [SVProgressHUD showWithStatus:@"上传中"];
    
    NSMutableString *deviceId = [[NSMutableString alloc] initWithData:bluetoothConn.deviceInfo.deviceId encoding:NSUTF8StringEncoding];
    
    UploadGrardianshipRequest *upload = [[UploadGrardianshipRequest alloc] initWithGravidaId:[[NSString alloc] initWithFormat:@"%@",user.uid] andDeviceId:deviceId andFilePath:filePath andAudioFilePath: audioPath];
    NSLog(@"requestUrl : %@",upload.baseUrl);
    [upload startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request)
     {
         NSError *responseError = nil;
         id responseData = [NSJSONSerialization JSONObjectWithData:[request.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&responseError];
         NSMutableDictionary *jsonObject = (NSMutableDictionary *)responseData;
         NSString *result1 = [NSString stringWithFormat:@"%@", [jsonObject stringValueForKey:@"status"]];
         
         NSLog(@"upload result : %@",result1);
         
         if ([result1 isEqualToString:kSuccessCode])
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                [SVProgressHUD dismiss];
                                [self resetPaint];
                                [self uploadSucceedRemind];
                                //[SVProgressHUD showSuccessWithStatus:@"监护数据已成功上传"];
                            });
             
             [[GlobalDBEngine sharedDB] updateGrardianshipDataWith:[[NSString alloc] initWithFormat:@"%@",user.uid] andFilename:[[filePath componentsSeparatedByString:@"/"] lastObject]];
             
         }
         else if ([result1 isEqualToString:kUploadMonitoringDataPauseServiceErrorCode])
         {
             [self refreshPaint];
             [SVProgressHUD showErrorWithStatus:@"上传失败"];
         }
         else
         {
             [self refreshPaint];
             [SVProgressHUD showErrorWithStatus:@"上传失败"];
         }
         
     } failure:^(YTKBaseRequest *request)
     {
         NSLog(@"fail : request %@",request.responseJSONObject);
         [SVProgressHUD dismiss];
         [SVProgressHUD showErrorWithStatus:request.responseJSONObject];
     }];
}

- (void)uploadSucceedRemind
{
    [MBProgressUtils showRemind:@"监护数据已成功上传" addTo:self.view];
}

#pragma mark - 蓝牙引擎代理
-(void)didRecGrardianshipData:(NSMutableData *)data
{
    uint16_t index;
    [data getBytes:&index length:2];
    int index_i = (int)index;
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       self.title = [self changeIndexToTimeString:index_i];
                   });
    
    uint8_t heart;
    [data getBytes:&heart range:NSMakeRange(2, 1)];
    int heart_i = (int)heart;
    
    uint8_t press;
    [data getBytes:&press range:NSMakeRange(3, 1)];
    int press_i = (int)press;
    
    CGFloat sizePerSec = paint.sizePerMin / 60.0;
    
    totalPage = index_i / paint.rate * sizePerSec / paint.frame.size.width + 1;
    
    NSLog(@"totalPage : %d", totalPage);
    NSLog(@"index_i : %d", index_i);
    NSLog(@"index_i / %d : %d", paint.rate, index_i/paint.rate);
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       // 刷新频幕数据
                       _fhrLabel.text = [[NSString alloc] initWithFormat:@"%d", heart_i];
                       _tocoLabel.text = [[NSString alloc] initWithFormat:@"%d", press_i];
                       _fmLabel.text = [[NSString alloc] initWithFormat:@"%d", bluetoothConn.moveCount];
                       
                       _pageLabel.text = [[NSString alloc] initWithFormat:@"%d / %d", currPage, totalPage];
                       
                       // 画图谱
                       if (needToShowNewPage)
                       {
                           currPage = totalPage;
                           [paint drawByPage:currPage-1 andHeartArr:bluetoothConn.heartBeatPointArr andPressArr:bluetoothConn.uterinePressureArr andMoveArr:bluetoothConn.fetalMovementArr];
                       }
                   });
}

-(void)didRecDeviceInfo:(DeviceInfo *)deviceInfo
{
    UInt8 status;
    [deviceInfo.grardianshipStatus getBytes:&status length:1];
    
    if (paint)
    {
        UInt8 maxAlarm;
        [bluetoothConn.deviceInfo.maxAlarm getBytes:&maxAlarm length:1];
        int maxAlarm_i = (int)maxAlarm;
        
        UInt8 minAlarm;
        [bluetoothConn.deviceInfo.minAlarm getBytes:&minAlarm length:1];
        int minAlarm_i = (int)minAlarm;
        
        [userDefaults setObject:[[NSString alloc] initWithFormat:@"%d",maxAlarm_i] forKey:@"maxAlarm"];
        [userDefaults setObject:[[NSString alloc] initWithFormat:@"%d",minAlarm_i] forKey:@"minAlarm"];
        
        paint.maxAlarm = maxAlarm_i;
        paint.minAlarm = minAlarm_i;
        
        //刷新安全范围
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [paint refreshView];
                       });
    }
}

-(void)didStopGrardianship
{
    
}

-(void)didDeviceDisconnect
{
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"设备已断连，是否保存数据" delegate:self cancelButtonTitle:@"不保存" destructiveButtonTitle:@"保存" otherButtonTitles:nil, nil];
    //            actionSheet.tag = 33;
    //            [actionSheet showInView:self.view];
    //        });
    //
    //    });
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [self.navigationController popViewControllerAnimated:YES];
                   });
}

-(void)didScanFinish
{
    
}

-(void)didSaveLocalFile
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传数据？" delegate:self cancelButtonTitle:@"一会再说" destructiveButtonTitle:@"现在上传" otherButtonTitles:nil, nil];
                       actionSheet.tag = 11;
                       [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
                   });
}

#pragma mark - PaintViewDelegate
-(void)pointToScreenEdge:(int)currPage
{
    if (currPage + 1 == totalPage)
    {
        totalPage++;
    }
    
    //    _scrollView.contentSize = CGSizeMake((viewBoundSize.width - 23.5) * page, _scrollView.frame.size.height);
    //    totalPage = page;
    //    _pageLabel.text = [[NSString alloc] initWithFormat:@"%d / %d",page, page];
    //    currPage = page;
    //    _scrollView.scrollEnabled = YES;
    //    [UIView animateWithDuration:0.5 animations:^
    //    {
    //        _scrollView.contentOffset = CGPointMake((page - 1) * (viewBoundSize.width - 23.5), _scrollView.contentOffset.y);
    //    }];
}

- (IBAction)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case 111:
            [self startMonitor];
            break;
            
        case 222:
            [self stopMonitor];
            break;
    }
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag)
    {
        case 11:
        {
            if (buttonIndex == actionSheet.destructiveButtonIndex)
            {
                if (bluetoothConn.currSavedFile)
                {
                    [self uploadData:bluetoothConn.currSavedFile andAudioPath:bluetoothConn.currSavedAudioFile];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       [SVProgressHUD showProgress:0.5 status:@"文件保存失败"];
                                   });
                }
                
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [self resetPaint];
                           });
            
        }
            break;
        case 22:
        {
            if (buttonIndex == actionSheet.destructiveButtonIndex)
            {
                bluetoothConn.isAbandon = YES;
                [bluetoothConn stopGrardianship];
                UInt8 s = 0x00;
                bluetoothConn.deviceInfo.grardianshipStatus = [NSData dataWithBytes:&s length:sizeof(s)];
                [_monitorControlBtn setTitle:@"开始监护" forState:UIControlStateNormal];
                grardianState = 0;
                [bluetoothConn.originDataArr removeAllObjects];
                [bluetoothConn.heartBeatPointArr removeAllObjects];
                [bluetoothConn.uterinePressureArr removeAllObjects];
                [bluetoothConn.fetalMovementArr removeAllObjects];
                [bluetoothConn deleteGrardianshipDataFromLocal];
                _fhrLabel.text = @"--";
                _tocoLabel.text = @"--";
                _fmLabel.text = @"--";
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   [self resetPaint];
                               });
            }
        }
            break;
        case 33:
        {
            if (buttonIndex == actionSheet.cancelButtonIndex)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   [self.navigationController popViewControllerAnimated:YES];
                               });
            }
            else if (buttonIndex == actionSheet.destructiveButtonIndex)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   [SVProgressHUD show];
                               });
                [bluetoothConn saveGrardianshipDataWithType];
            }
        }
            break;
        default:
            break;
    }
}

-(NSString *)changeIndexToTimeString:(int)index
{
    int second = index / paint.rate;
    NSString *timeStr;
    if (second < 60)
    {
        if(second < 10)
        {
            timeStr = [[NSString alloc] initWithFormat:@"00:0%d", second];
        }
        else
        {
            timeStr = [[NSString alloc] initWithFormat:@"00:%d", second];
        }
    }
    else
    {
        int min = second / 60;
        int sec = second % 60;
        timeStr = [[NSString alloc] initWithFormat:@"%@:%@",
                   (min < 10 ?
                    [NSString stringWithFormat:@"0%d", min] : [NSString stringWithFormat:@"%d", min]),
                   
                   (sec < 10 ?
                    [NSString stringWithFormat:@"0%d", sec] : [NSString stringWithFormat:@"%d", sec])];
    }
    
    return timeStr;
}

- (void)showTime:(id)sender
{
    if (grardianState == 1)
    {
        if (showTimeState == 0)
        {
            [UIView animateWithDuration:0.3 animations:^
             {                _pageView.frame = CGRectMake(0, viewBoundSize.height - 50, viewBoundSize.width, 50);
             }];
            showTimeState = 1;
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^
             {
                 _pageView.frame = CGRectMake(0, viewBoundSize.height, viewBoundSize.width, 50);
             }];
            showTimeState = 0;
        }
        
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             _pageView.frame = CGRectMake(0, viewBoundSize.height, viewBoundSize.width, 50);
         }];
        showTimeState = 0;
    }
}

- (IBAction)frontPage:(UIButton *)sender
{
    currPage--;
    if (currPage < 1)
    {
        currPage = 1;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           _pageLabel.text = [[NSString alloc] initWithFormat:@"%d / %d",currPage,totalPage];
                           [paint drawByPage:currPage-1 andHeartArr:bluetoothConn.heartBeatPointArr andPressArr:bluetoothConn.uterinePressureArr andMoveArr:bluetoothConn.fetalMovementArr];
                       });
    }
    
    if (currPage == totalPage)
    {
        needToShowNewPage = YES;
    }
    else
    {
        needToShowNewPage = NO;
    }
}

- (IBAction)nextPage:(UIButton *)sender
{
    currPage++;
    if (currPage > totalPage)
    {
        currPage = totalPage;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           _pageLabel.text = [[NSString alloc] initWithFormat:@"%d / %d",currPage,totalPage];
                           [paint drawByPage:currPage-1 andHeartArr:bluetoothConn.heartBeatPointArr andPressArr:bluetoothConn.uterinePressureArr andMoveArr:bluetoothConn.fetalMovementArr];
                       });
    }
    
    if (currPage == totalPage)
    {
        needToShowNewPage = YES;
    }
    else
    {
        needToShowNewPage = NO;
    }
}


-(void)resetPaint
{
    [self refreshPaint];
    _fhrLabel.text = @"--";
    _tocoLabel.text = @"--";
    _fmLabel.text = @"--";
    [bluetoothConn deleteGrardianshipDataFromLocal];
}

- (IBAction)addMove:(UIButton *)sender
{
    if ([bluetoothConn isGrardianship])
    {
        [bluetoothConn addFetalMovement];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"您还没有开始监护."];
    }
}

- (IBAction)monitorControl:(UIButton *)sender
{
//    if(!grardianState)
//    {
//        [self startMonitor];
//    }
//    else
//    {
//        [self stopMonitor];
//    }
    
    if (grardianState == 0)
    {  //开始监护
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"开始监护？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 111;
        [alertView show];
        
    }
    else
    {  //停止监护
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"停止监护？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 222;
        [alertView show];
    }
}

-(void) startMonitor
{
    [bluetoothConn beginGrardianship];
    [_monitorControlBtn setTitle:@"停止监护" forState:UIControlStateNormal];
    grardianState = 1;
    UInt8 s = 0x01;
    bluetoothConn.deviceInfo.grardianshipStatus = [NSData dataWithBytes:&s length:sizeof(s)];
}

-(void) stopMonitor
{
    if ([bluetoothConn isMinMonitorTimelong])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请至少监护1分钟." delegate:self cancelButtonTitle:@"继续" destructiveButtonTitle:@"放弃" otherButtonTitles:nil, nil];
        actionSheet.tag = 22;
        [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    }
    else
    {
        //[SVProgressHUD show];
        [bluetoothConn stopGrardianship];
        UInt8 s = 0x00;
        bluetoothConn.deviceInfo.grardianshipStatus = [NSData dataWithBytes:&s length:sizeof(s)];
        [_monitorControlBtn setTitle:@"开始监护" forState:UIControlStateNormal];
        grardianState = 0;
    }
}

-(void)didPowerChanged:(int)power
{
    if(rightSlider != nil)
    {
        [rightSlider setPower:power];
    }
}

-(void)didUpdateState:(int)state
{
    
}

@end
