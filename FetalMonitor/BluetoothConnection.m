#import "BluetoothConnection.h"

#import "NSDictionary+Utils.h"
#import "User.h"
#import "SVProgressHUD.h"
#import "GlobalDBEngine.h"
#import "LMTPDecoder.h"
#import "LKCPlayManager.h"
#import <AVFoundation/AVFoundation.h>

static BluetoothConnection *bluetooth = nil;

@interface BluetoothConnection ()

@property (strong , nonatomic) LMTPDecoder * decoder;
@property (strong, nonatomic) dispatch_queue_t bluetoothQueue;
@property (nonatomic , assign) short dataIndex;

@property (nonatomic,strong) AVAudioPlayer *player;

@end

@implementation BluetoothConnection
{
    BOOL _cbReady;
    
    NSUserDefaults *userDefault;
    
    NSMutableData *peripheralReturnData;
    
    NSString *plistPath;
    NSMutableDictionary *grardianshipDataList;
    
    User *userInfo;
    
    NSData *maxIndex;
    
    int needToAdd;
    int isAdd;
    
    int heartBeatRecState;
    int grardRecState;
    
    int grardCount;
    
    int currReqPoint;
    
    BOOL isAlarmPlayer;
    
    NSThread *onlineThread;
    BOOL isThreadState;
    NSDate *isPreReceiveDate;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        // 建立中心角色
        _manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_queue_create("ble queue", NULL)];
        _manager.delegate = self;
        
        _deviceArr = [NSMutableArray array];
        _serviceArr = [NSMutableArray array];
        _characteristicArr = [NSMutableArray array];
        _heartBeatPointArr = [NSMutableArray array];
        _uterinePressureArr = [NSMutableArray array];
        _fetalMovementArr = [NSMutableArray array];
        _originDataArr = [NSMutableArray array];
        _needSyncArr = [NSMutableArray array];
        
        peripheralReturnData = [NSMutableData data];
        
        _cbReady = NO;
        
        userDefault = [NSUserDefaults standardUserDefaults];
        
        _deviceInfo = [[DeviceInfo alloc] init];
        
        userInfo = [User sharedUser];
        
        // 添加APP从后台返回通知, 重启动画
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        _decoder = [LMTPDecoder shareInstance];
        self.bluetoothQueue = dispatch_queue_create("com.lmtpdecoder.queue", NULL);
        
        [self.player prepareToPlay];
        self.player.numberOfLoops = 1;
    }
    
    return self;
}

-(void)scanDevice
{
    [_manager stopScan];
    
    [_deviceArr removeAllObjects];
    if(_peripheral != nil && _peripheral.state == CBPeripheralStateConnected)
    {
        [_deviceArr addObject:_peripheral];
    }
    [self.delegate didDeviceDisconnect];
    
    [_manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:UUIDSTR_FFF0_SERVICE], [CBUUID UUIDWithString:UUIDSTR_ISSC_PROPRIETARY_SERVICE]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(stopSearchDevice) userInfo:nil repeats:NO];
}

-(void)stopSearchDevice
{
    [self.delegate didScanFinish];
}

-(void)connectDevice:(int)deviceId
{
    [_manager connectPeripheral:_deviceArr[deviceId] options:nil];
}

-(void)disconnectCurrentDevice
{
    if (_peripheral)
    {
        [_manager cancelPeripheralConnection:_peripheral];
    }
}

-(void)writeGrardianshipDataToLoacl:(NSData *)data
{
    // 创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 获取document路径, 括号中属性为当前应用程序独享
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    
    // 定义记录文件全名以及路径的字符串filePath
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:_deviceInfo.grardianshipCacheFile];
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSData *readData = [NSData dataWithContentsOfFile:filePath];
        NSMutableData *saveData = [NSMutableData dataWithData:[readData subdataWithRange:NSMakeRange(0, readData.length - readData.length % 5)]];
        [saveData appendData:data];
        [saveData writeToFile:filePath atomically:YES];
    }
    else
    {
        BOOL result = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        if (result)
        {
            [data writeToFile:filePath atomically:YES];
        }
    }
}

-(void)readGrardianshipDataFromLocal
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //获取document路径,括号中属性为当前应用程序独享
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    
    //定义记录文件全名以及路径的字符串filePath
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:_deviceInfo.grardianshipCacheFile];
    
    NSLog(@"%@",filePath);
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [_originDataArr removeAllObjects];
        for (int i = 0 ; i<data.length / 5; i++)
        {
            NSData *subData = [data subdataWithRange:NSMakeRange(i*5, 5)];
            if (subData.length == 5)
            {
                [_originDataArr addObject:subData];
            }
            NSLog(@"readData: %@",subData);
        }
        
        NSString *minValue = [userDefault objectForKey:@"speed"];
        NSMutableDictionary *dic = [self addPointAll:_originDataArr];
        _heartBeatPointArr = [NSMutableArray arrayWithArray:[dic objectForKey:@"heart"]];
        _uterinePressureArr = [NSMutableArray arrayWithArray:[dic objectForKey:@"press"]];
        _fetalMovementArr = [NSMutableArray arrayWithArray:[dic objectForKey:@"move"]];
        
        [self.delegate didLoadLocalData];
    }
}

-(void)deleteGrardianshipDataFromLocal
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //获取document路径,括号中属性为当前应用程序独享
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    
    //定义记录文件全名以及路径的字符串filePath
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"000000000000000000000001"];
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

+(id)shareBluetooth
{
    if (!bluetooth)
    {
        bluetooth = [[BluetoothConnection alloc] init];
        
        return bluetooth;
    }
    
    return bluetooth;
}

#pragma mark - CBCentralManagerDelegate
// 开始查看服务, 蓝牙开启
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self.delegate didUpdateState:central.state];
}

#pragma mark  查到外设后，停止扫描，连接设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"已发现 peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ , name:%@", peripheral, RSSI, peripheral.identifier, advertisementData, peripheral.name);
    
    BOOL replace = NO;
    
    for (int i=0; i < _deviceArr.count; i++)
    {
        CBPeripheral *p = [_deviceArr objectAtIndex:i];
        if ([p isEqual:peripheral])
        {
            [_deviceArr replaceObjectAtIndex:i withObject:peripheral];
            replace = YES;
        }
    }
    if (!replace)
    {
        [_deviceArr addObject:peripheral];
        // [_deviceTable reloadData];
    }
}

#pragma mark  连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"==============================>:连接成功");
    NSLog(@"成功连接 peripheral: %@ with UUID: %@", peripheral, peripheral.identifier);
    _power = -1;
    _peripheral = peripheral;
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    [self.delegate didConnectedDevice:peripheral];
    
    //if(onlineThread == nil)
    {
        onlineThread = [[NSThread alloc] initWithTarget:self selector:@selector(run1) object:nil];
    }
    isThreadState = YES;
    isPreReceiveDate = [NSDate date];
    [onlineThread start];
}

-(void) run1
{
    while(isThreadState)
    {
        NSDate *date = [NSDate date];
        double intervalTime = [date timeIntervalSinceReferenceDate] - [isPreReceiveDate timeIntervalSinceReferenceDate];
        NSLog(@"-------------->AAAA");
        if(intervalTime > 5)
        {
            NSLog(@"-------------->BBBB");
            [_deviceArr removeAllObjects];
            [self disconnectPeripheral];
            //[_peripheral setNotifyValue:NO forCharacteristic:_notifyCharacteristic];
            //[_manager cancelPeripheralConnection:_peripheral];
            
            // 重置manager，否则返回搜索设备页后会搜索不到这台设备
            _manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_queue_create("ble queue", NULL)];
            _manager.delegate = self;
            isThreadState = NO;
            return;
        }
        
        [NSThread sleepForTimeInterval:3];
    }
}

-(void)closeThread
{
    isThreadState = NO;
}

#pragma mark  连接外设失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"==============================>:连接失败");
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [SVProgressHUD showErrorWithStatus:@"连接失败"];
                   });
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self disconnectPeripheral];
}

-(void) disconnectPeripheral
{
    NSLog(@"==============================>:断开链接");
    
    if (_originDataArr.count > 0 && ![self isMinMonitorTimelong])
    {
        [self saveGrardianshipDataWithType];
    }
    //
    Byte byte[] = {0};
    NSData *data = [[NSData alloc] initWithBytes:byte length:1];
    _deviceInfo.grardianshipStatus = data;
    //
    [self closeThread];
    [self disconnectCurrentDevice];
    [self.delegate didDeviceDisconnect];
}

#pragma mark - CBPeripheralDelegate

#pragma mark  已发现服务
- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *s in peripheral.services)
    {
        [_serviceArr addObject:s];
    }
    
    for (CBService *s in peripheral.services)
    {
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

#pragma mark  已搜索到Characteristics
- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *c in service.characteristics)
    {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_ISSC_PROPRIETARY_SERVICE]])
        {
            if ([c.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_AIR_PATCH_CHAR]])
            {
                
            }
            if ([c.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_CONNECTION_PARAMETER_CHAR]])
            {
            }
        }
        if ([service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_FFF0_SERVICE]])
        {
            if ([c.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_FFF1_CHAR]])
            {
                [_peripheral setNotifyValue:YES forCharacteristic:c];
                _notifyCharacteristic = c;
            }
            if ([c.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_FFF2_CHAR]])
            {
                _writeCharacteristic = c;
            }
        }
        
        [_characteristicArr addObject:c];
    }
}

#pragma mark  获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!characteristic)
    {
        NSLog(@"==============================>:数据异常");
        return;
    }
    
    NSData *data = characteristic.value;
    [self dualDataProcess:data];
}

#pragma mark 特征状态改变后的通知
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    if (characteristic.isNotifying)
    {
        [peripheral readValueForCharacteristic:characteristic];
    }
    else
    {
        [_manager cancelPeripheralConnection:_peripheral];
    }
}

#pragma mark  用于检测中心向外设写数据是否成功
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"指令发送失败:%@", error.userInfo);
    }
    else
    {
        NSLog(@"发送数据成功");
    }
}

#pragma mark - 设备状态
-(BOOL)isGrardianship
{
    UInt8 grardianshipStatus;
    [self.deviceInfo.grardianshipStatus getBytes:&grardianshipStatus length:self.deviceInfo.grardianshipStatus.length];
    if (grardianshipStatus == 0x01)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - 设备数据处理方法
-(void)dualDataProcess:(NSData *)data
{
    isPreReceiveDate = [NSDate date];
    LKCHeart * heart =  [self.decoder startDecoderWithCharacterData:data];
    if(heart != nil && _power != heart.battValue)
    {
        _power = heart.battValue;
        if(self.delegate != nil)
        {
            [self.delegate didPowerChanged:_power];
        }
    }
    
    if(![self isGrardianship]) return;
    
    if (heart)
    {
        // 打印
        NSString *fhr = [NSString stringWithFormat:@" 胎心率 ： %ld       是否有fhr1： %ld",(long)heart.rate,(long)heart.isRate];
        NSString *toco = [NSString stringWithFormat:    @"宫缩压力 ： %ld      是否有toco： %ld",(long)heart.tocoValue,(long)heart.isToco];
        NSString *batt = [NSString stringWithFormat: @"电池电量 ： %ld      宫缩复位标记： %ld",(long)heart.battValue,(long)heart.tocoFlag];
        NSString *signal = [NSString stringWithFormat:  @"信号质量 ： %ld      手动胎动标记： %ld",(long)heart.signal,(long)heart.fmFlag];
        //NSLog(@"----->%@", fhr);
        //NSLog(@"----->%@", toco);
        //NSLog(@"----->%@", batt);
        //NSLog(@"----->%@", signal);
        //NSLog(@"报警开关%@", isAlarmPlayer ? @"ON": @"OFF");
        
        if((heart.rate < 110 || heart.rate > 160) && isAlarmPlayer)
        {
            [self playAlarm];
        }
        
        _dataIndex++;
        char *cData  = malloc(sizeof(char) * 5);
        cData[0]  =  (char)(_dataIndex & 0xff);
        cData[1]  =  (char)((_dataIndex >> 8) & 0xff);
        cData[2] = heart.rate;
        cData[3] = heart.tocoValue;
        cData[4] = heart.fmFlag;
        NSData *origData = [NSData dataWithBytes:cData length:5];
        
        // 保存原始点
        [_originDataArr addObject:origData];
        // 保存原始点到本地文件
        [self writeGrardianshipDataToLoacl:origData];
        // 保存动态点
        NSMutableDictionary *dic = [self addPointPart:origData];
        [_heartBeatPointArr addObjectsFromArray:[dic objectForKey:@"heart"]];
        [_uterinePressureArr addObjectsFromArray:[dic objectForKey:@"press"]];
        [_fetalMovementArr addObjectsFromArray:[dic objectForKey:@"move"]];
        // 通知外部
        [self.delegate didRecGrardianshipData:origData];
    }
}

-(void)beginGrardianship
{
    [_originDataArr removeAllObjects];
    
    NSDate *beginTime = [NSDate date];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //    NSString *beginGrardianTime = [formatter stringFromDate:beginTime];
    
    [userDefault setObject:beginTime forKey:@"createTime"];
    
    _canRecGrardianshipData = YES;
    
    //    NSString *cacheFilename = [[NSString alloc] initWithData:self.deviceInfo.deviceId encoding:NSASCIIStringEncoding];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //    cacheFilename = [cacheFilename stringByAppendingString:[dateFormatter stringFromDate:[NSDate date]]];
    
    self.deviceInfo.grardianshipCacheFile = @"000000000000000000000001";
    
    _dataIndex = 0;
    // 开始播放声音
    [self.decoder startMonitor];
    [self.decoder startRealTimeAudioPlyer];
}

-(void)stopGrardianship
{
    [self.decoder stopRealTimeAudioPlyer];
    
    [self saveGrardianshipAudio];
    
    if(![self isMinMonitorTimelong])
    {
        [self saveGrardianshipDataWithType];
    }
}

-(BOOL) isMinMonitorTimelong
{
    NSData *lastData = _originDataArr.lastObject;
    
    UInt16 index_t;
    [lastData getBytes:&index_t length:2];
    int index = (int)index_t;
    if (index/4/60 < 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void) saveGrardianshipAudio
{
    NSDate *createTime = [userDefault objectForKey:@"createTime"];
    NSString *uid = [[NSString alloc] initWithFormat:@"%@",userInfo.uid];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_hh-mm"];
    NSString *formatDataStr = [formatter stringFromDate:createTime];
    NSString *fileName = [[NSString alloc] initWithFormat:@"%@_%@.wav",formatDataStr, uid];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *recordDataDir = [docDir stringByAppendingPathComponent:@"audios"];
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:recordDataDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:recordDataDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    NSString *audioFilePath = [recordDataDir stringByAppendingPathComponent:fileName];
    [self.decoder stopMoniterWithAudioFilePath:audioFilePath];
    _currSavedAudioFile = audioFilePath;
}

-(void)discoverMyService
{
    [_peripheral setDelegate:self];
    [_peripheral discoverServices:nil];
}

// 全量插点, 采样率：4
-(NSMutableDictionary *)addPointAll:(NSMutableArray *)pointDataArr
{
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    
    NSMutableArray *heartBeatArr = [NSMutableArray array];
    NSMutableArray *pressArr = [NSMutableArray array];
    NSMutableArray *moveArr = [NSMutableArray array];
    
    for (int i=0; i<pointDataArr.count; i++)
    {
        NSData *pointData = pointDataArr[i];
        
        uint16_t num;
        [pointData getBytes:&num range:NSMakeRange(0, 2)];
        int num_i = (int)num;
        
        uint8_t heart;
        [pointData getBytes:&heart range:NSMakeRange(2, 1)];
        int heart_i = (int)heart;
        
        uint8_t press;
        [pointData getBytes:&press range:NSMakeRange(3, 1)];
        int press_i = (int)press;
        
        uint8_t move;
        [pointData getBytes:&move range:NSMakeRange(4, 1)];
        int move_i = (int)move;
        
        if (move_i>0)
        {
            _moveCount++;
        }
        
        int index = num_i;
        NSNumber *objIndex = [NSNumber numberWithInt:index];
        
        NSDictionary *heartPointDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:heart_i],objIndex, nil];
        NSDictionary *pressPointDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:press_i],objIndex, nil];
        NSDictionary *movePointDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:move_i],objIndex, nil];
        
        [heartBeatArr addObject:heartPointDic];
        [pressArr addObject:pressPointDic];
        [moveArr addObject:movePointDic];
    }
    
    [resultDic setObject:heartBeatArr forKey:@"heart"];
    [resultDic setObject:pressArr forKey:@"press"];
    [resultDic setObject:moveArr forKey:@"move"];
    
    // NSLog(@"插值后 : %@",resultDic);
    
    return resultDic;
}

// 增量插点, 采样率：4
-(NSMutableDictionary *)addPointPart:(NSData *)pointData
{
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    
    NSMutableArray *heartBeatArr = [NSMutableArray array];
    NSMutableArray *pressArr = [NSMutableArray array];
    NSMutableArray *moveArr = [NSMutableArray array];
    
    uint16_t num;
    [pointData getBytes:&num range:NSMakeRange(0, 2)];
    int num_i = (int)num;
    
    uint8_t heart;
    [pointData getBytes:&heart range:NSMakeRange(2, 1)];
    int heart_i = (int)heart;
    
    uint8_t press;
    [pointData getBytes:&press range:NSMakeRange(3, 1)];
    int press_i = (int)press;
    
    uint8_t move;
    [pointData getBytes:&move range:NSMakeRange(4, 1)];
    int move_i = (int)move;
    
    if (move_i>0)
    {
        _moveCount++;
    }
    
    int index = num_i;
    NSNumber *objIndex = [NSNumber numberWithInt:index];
    
    
    NSDictionary *heartPointDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:heart_i],objIndex, nil];
    NSDictionary *pressPointDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:press_i],objIndex, nil];
    NSDictionary *movePointDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:move_i],objIndex, nil];
    
    [heartBeatArr addObject:heartPointDic];
    [pressArr addObject:pressPointDic];
    [moveArr addObject:movePointDic];
    
    [resultDic setObject:heartBeatArr forKey:@"heart"];
    [resultDic setObject:pressArr forKey:@"press"];
    [resultDic setObject:moveArr forKey:@"move"];
    
    // NSLog(@"插值后 : %@",resultDic);
    
    return resultDic;
}

// 格式化设备信息
-(void)formatDeviceInfo:(NSData *)data
{
    _deviceInfo.alarmSwitch = [data subdataWithRange:NSMakeRange(3, 1)];
    _deviceInfo.maxAlarm = [data subdataWithRange:NSMakeRange(4, 1)];
    _deviceInfo.minAlarm = [data subdataWithRange:NSMakeRange(5, 1)];
    _deviceInfo.alarmDelay = [data subdataWithRange:NSMakeRange(6, 1)];
    _deviceInfo.volume = [data subdataWithRange:NSMakeRange(7, 1)];
    _deviceInfo.powerInfo = [data subdataWithRange:NSMakeRange(8, 1)];
    _deviceInfo.deviceId = [data subdataWithRange:NSMakeRange(9, 15)];
    //_deviceInfo.deviceId = [@"0A2015010100008" dataUsingEncoding:NSASCIIStringEncoding];
    _deviceInfo.grardianshipStatus = [data subdataWithRange:NSMakeRange(25, 1)];
    _deviceInfo.grardianshipCacheFile = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(26, 24)] encoding:NSUTF8StringEncoding];
    _deviceInfo.grardianshipCacheFileMaxIndex = [data subdataWithRange:NSMakeRange(50, 2)];
    
    [self.delegate didRecDeviceInfo:_deviceInfo];
}

#pragma mark - 保存监护数据
-(void)saveGrardianshipDataWithType
{
    NSDate *createTime = [userDefault objectForKey:@"createTime"];
    
    NSString *uid = [[NSString alloc] initWithFormat:@"%@",userInfo.uid];
    
    NSMutableData *grardianshipData = [NSMutableData data];
    
    uint8_t deviceId_t[16];
    for (int i=0; i<self.deviceInfo.deviceId.length; i++)
    {
        NSData *d = [self.deviceInfo.deviceId subdataWithRange:NSMakeRange(i, 1)];
        UInt8 t;
        [d getBytes:&t length:1];
        deviceId_t[i] = t;
    }
    
    deviceId_t[15] = 0;
    
    NSData *gravidaData = [uid dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t gravida[20] = {0};
    
    for (int i=0; i<gravidaData.length; i++)
    {
        NSData *d = [gravidaData subdataWithRange:NSMakeRange(i, 1)];
        UInt8 t;
        [d getBytes:&t length:1];
        gravida[i] = t;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *grardianDate = [formatter stringFromDate:createTime];
    NSLog(@"grardianDate : %@",grardianDate);
    uint8_t date_t[20];
    NSData *date_d = [grardianDate dataUsingEncoding:NSUTF8StringEncoding];
    for (int i=0; i<date_d.length; i++)
    {
        NSData *d = [date_d subdataWithRange:NSMakeRange(i, 1)];
        UInt8 t;
        [d getBytes:&t length:1];
        date_t[i] = t;
    }
    date_t[19] = 0;
    
    NSString *duration_s = [[NSString alloc] initWithFormat:@"%d",(int)_originDataArr.count/4];
    NSData *du = [duration_s dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t duration[20] = {0};
    for (int i=0; i<du.length; i++)
    {
        NSData *d = [du subdataWithRange:NSMakeRange(i, 1)];
        UInt8 t;
        [d getBytes:&t length:1];
        duration[i] = t;
    }
    
    uint8_t rate[1] = {4};
    
    [grardianshipData appendBytes:deviceId_t length:sizeof(deviceId_t)];
    [grardianshipData appendBytes:gravida length:sizeof(gravida)];
    [grardianshipData appendBytes:date_t length:sizeof(date_t)];
    [grardianshipData appendBytes:duration length:sizeof(duration)];
    [grardianshipData appendBytes:rate length:sizeof(rate)];
    
    NSLog(@"grardianshipData : %@",grardianshipData);
    
    for (NSData *tmpData in _originDataArr)
    {
        UInt16 index_f = 0x0000;
        NSMutableData *index = [NSMutableData data];
        [index appendData:[tmpData subdataWithRange:NSMakeRange(1, 1)]];
        [index appendData:[tmpData subdataWithRange:NSMakeRange(0, 1)]];
        NSData *heart = [tmpData subdataWithRange:NSMakeRange(2, 1)];
        UInt8 heart2 = 0x00;
        NSData *press = [tmpData subdataWithRange:NSMakeRange(3, 1)];
        NSData *move = [tmpData subdataWithRange:NSMakeRange(4, 1)];
        
        
        [grardianshipData appendBytes:&index_f length:sizeof(index_f)];
        [grardianshipData appendData:index];
        [grardianshipData appendData:heart];
        [grardianshipData appendBytes:&heart2 length:sizeof(heart2)];
        [grardianshipData appendData:press];
        [grardianshipData appendData:move];
    }
    
    NSLog(@"上传数据: %@",grardianshipData);
    
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //获取document路径,括号中属性为当前应用程序独享
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    
    [formatter setDateFormat:@"yyyy-MM-dd_hh-mm"];
    NSString *formatDataStr = [formatter stringFromDate:createTime];
    NSString *fileName = [[NSString alloc] initWithFormat:@"%@_%@.ftd",formatDataStr, uid];
    
    //定义记录文件全名以及路径的字符串filePath
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    //查找文件，如果不存在，就创建一个文件
    if (![fileManager fileExistsAtPath:filePath])
    {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        BOOL result = [grardianshipData writeToFile:filePath atomically:YES];
        
        if (result)
        {
            GrardianshipData *gData = [[GrardianshipData alloc] init];
            gData.grardianshipID = uid;
            gData.fileName = fileName;
            gData.createTime = grardianDate;
            gData.duration = duration_s;
            gData.uploadStatus = @"0";
            
            GlobalDBEngine *dbEngine = [GlobalDBEngine sharedDB];
            BOOL insertResult = [dbEngine insertGrardianshipData:gData];
            if (insertResult)
            {
                //                dispatch_async(dispatch_get_main_queue(), ^
                //                {
                //                    [SVProgressHUD showSuccessWithStatus:@"已保存数据"];
                //                });
                NSLog(@"保存到数据库成功: %@",filePath);
                if (_isInRealView)
                {
                    [self.delegate didSaveLocalFile];
                }
                _currSavedFile = filePath;
                //清理数据
                [_originDataArr removeAllObjects];
                [_heartBeatPointArr removeAllObjects];
                [_uterinePressureArr removeAllObjects];
                [_fetalMovementArr removeAllObjects];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   [SVProgressHUD showErrorWithStatus:@"数据保存失败"];
                               });
            }
        }
    }
}

-(void)startMonitorFHRandSound
{
    [self.decoder startMonitor];
}

-(int)getPower
{
    return _power;
}

-(void) setFM
{
    [self.decoder setFM];
}

- (void) setTocoReset
{
    [self.decoder sendTocoReset:1 WithTocoResetValue:2 forCBPeripheral:_peripheral WithCharacteristic:self.writeCharacteristic];
}

-(void)setAlarmPlayer:(BOOL)state
{
    isAlarmPlayer = state;
}

-(void)playAlarm
{
    if(self.player != nil && !self.player.isPlaying)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)),dispatch_get_main_queue(), ^
                       {
                           if(self.player != nil && !self.player.isPlaying && isAlarmPlayer)
                           {
                               [self.player play];
                           }
                       });
    }
}

-(AVAudioPlayer *)player
{
    if (!_player)
    {
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"monitor_alarm.wav" withExtension:nil];
        
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        _player.delegate = self;
        
    }
    return _player;
}

-(BOOL)getAlarmState
{
    return isAlarmPlayer;
}

@end
