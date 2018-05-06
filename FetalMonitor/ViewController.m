#import "ViewController.h"
#import "LMTPDecoder.h"
@import CoreBluetooth;
#import "LKCHeart.h"

#import "LKCPlayManager.h"



@interface ViewController ()<UITableViewDataSource,UITableViewDelegate, CBCentralManagerDelegate, CBPeripheralDelegate>


@property (nonatomic, strong) UITableView * deviceTable;
@property (nonatomic, retain) CBCentralManager *manager;//手机的蓝牙设备
@property (nonatomic, retain) CBPeripheral * testPeripheral;//外围的蓝牙设备，connectDeviceAtIndex函数中设置

@property (nonatomic, retain) CBCharacteristic * writeCharacteristic;
@property (nonatomic, retain) NSMutableArray *deviceArray;//搜到多少个蓝牙设备
@property (nonatomic, assign) BOOL isConnected;

@property (strong, nonatomic) dispatch_queue_t bluetoothQueue;

@property (strong , nonatomic) LMTPDecoder * decoder;

@property (nonatomic , strong) UILabel * fhrRate1Lable;
@property (nonatomic , strong) UILabel * tocoLable;
@property (nonatomic , strong) UILabel * batteryLable;
@property (nonatomic , strong) UILabel * singleLable;

@property (nonatomic , strong) NSString * audioFilePath;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deviceArray = [[NSMutableArray alloc] init];
    
    _decoder = [LMTPDecoder shareInstance];
    
    self.bluetoothQueue = dispatch_queue_create("com.lmtpdecoder.queue", NULL);
    
    UIButton * replay = [UIButton buttonWithType:UIButtonTypeCustom];
    replay.backgroundColor = [UIColor orangeColor];
    [replay addTarget: self action:@selector(replySound) forControlEvents:UIControlEventTouchUpInside];
    [replay setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [replay setTitle:@"重播" forState:UIControlStateNormal];
    replay.frame = CGRectMake(130,20, 100, 50);
    [self.view addSubview:replay];
    
    UIButton * scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scanBtn.backgroundColor = [UIColor orangeColor];
    [scanBtn addTarget: self action:@selector(scanPeripheral) forControlEvents:UIControlEventTouchUpInside];
    [scanBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [scanBtn setTitle:@"搜索设备" forState:UIControlStateNormal];
    scanBtn.frame = CGRectMake(50,80, 100, 50);
    [self.view addSubview:scanBtn];
    
    
    UIButton * stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopBtn.backgroundColor = [UIColor orangeColor];
    [stopBtn addTarget: self action:@selector(stopRealSound) forControlEvents:UIControlEventTouchUpInside];
    [stopBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    [stopBtn setTitle:@"停止实时声音" forState:UIControlStateNormal];
    stopBtn.frame = CGRectMake(self.view.bounds.size.width - 170, 80, 130, 50);
    [self.view addSubview:stopBtn];
    
    
    _deviceTable = [[UITableView alloc] initWithFrame:CGRectMake(0,160 , self.view.bounds.size.width, 240)];
    _deviceTable.backgroundColor = [UIColor yellowColor];
    _deviceTable.delegate = self;
    _deviceTable.dataSource = self;
    [self.view addSubview:self.deviceTable];
    
    _fhrRate1Lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 420, 200, 20)];
    _fhrRate1Lable.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:_fhrRate1Lable];
    _tocoLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 440, 200, 20)];
    _tocoLable.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:_tocoLable];
    _batteryLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 460, 200, 20)];
    _batteryLable.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:_batteryLable];
    _singleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 480, 200, 20)];
    _singleLable.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:_singleLable];
    
    UIButton * montiorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    montiorBtn.backgroundColor = [UIColor orangeColor];
    [montiorBtn addTarget: self action:@selector(startMonitorFHRandSound) forControlEvents:UIControlEventTouchUpInside];
    [montiorBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [montiorBtn setTitle:@"监听声音数据" forState:UIControlStateNormal];
    montiorBtn.frame = CGRectMake(10,self.view.bounds.size.height - 80, 120, 50);
    [self.view addSubview:montiorBtn];
    
    UIButton * stopMontiorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopMontiorBtn.backgroundColor = [UIColor orangeColor];
    [stopMontiorBtn addTarget: self action:@selector(stopMontiorFHRandSound) forControlEvents:UIControlEventTouchUpInside];
    [stopMontiorBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    [stopMontiorBtn setTitle:@"停止监听声音" forState:UIControlStateNormal];
    stopMontiorBtn.frame = CGRectMake(self.view.bounds.size.width - 130,self.view.bounds.size.height - 80, 120, 50);
    [self.view addSubview:stopMontiorBtn];
    
    UIButton * tocoResetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tocoResetBtn.backgroundColor = [UIColor orangeColor];
    [tocoResetBtn addTarget: self action:@selector(tocoReset) forControlEvents:UIControlEventTouchUpInside];
    [tocoResetBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [tocoResetBtn setTitle:@"宫缩复位" forState:UIControlStateNormal];
    tocoResetBtn.frame = CGRectMake(150,self.view.bounds.size.height - 80, 80, 50);
    [self.view addSubview:tocoResetBtn];
    
    UIButton * afmFlagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    afmFlagBtn.backgroundColor = [UIColor orangeColor];
    [afmFlagBtn addTarget: self action:@selector(afmFlagBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [afmFlagBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [afmFlagBtn setTitle:@"手动胎动" forState:UIControlStateNormal];
    afmFlagBtn.frame = CGRectMake(self.view.bounds.size.width - 130,self.view.bounds.size.height - 160, 80, 50);
    [self.view addSubview:afmFlagBtn];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)afmFlagBtnClick{
    [self.decoder setFM];
}
- (void)tocoReset{
    [self.decoder sendTocoReset:1 WithTocoResetValue:2 forCBPeripheral:self.testPeripheral WithCharacteristic:self.writeCharacteristic];
}
-(void)replySound{
    
    
    LKCPlayManager *playManager = [LKCPlayManager sharedPlayManager];
    NSURL *audioURL = [NSURL fileURLWithPath:_audioFilePath];
    [playManager createPlayerWithURL:audioURL];
    
    [LKCPlayManager playSeekTime:0];
    
}
-(void)startMonitorFHRandSound{
    [self.decoder startMonitor];
}
-(void)stopRealSound{
    [self.decoder stopRealTimeAudioPlyer];
}
-(void)stopMontiorFHRandSound{
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *recordDataDir = [docDir stringByAppendingPathComponent:@"audios"];
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:recordDataDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:recordDataDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    
    NSDate * nowDate = [NSDate date] ;
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* startTime = [df stringFromDate:nowDate];
    NSString *audioName = [NSString stringWithFormat:@"%@.wav",startTime];//生成声音文件保存路径
    
    
    NSString *audioFilePath = [recordDataDir stringByAppendingPathComponent:audioName];
    
    _audioFilePath = audioFilePath;
    
    NSLog(@"  %@",audioFilePath);
    
    [self.decoder stopMoniterWithAudioFilePath:audioFilePath];//结束监听，同时给出将要保存的声音文件的路径
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *registerID = @"registerID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:registerID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:registerID];
    }
    NSString *deviceName = [self getDeviceNameAtIndex:indexPath.row];
    cell.textLabel.text = deviceName;
    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self connectDeviceAtIndex:indexPath.row];
    
    
}


//创建中心角色，扫描外设
-(void)scanPeripheral{
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

#pragma mark CBCentralManagerDelegate
// 手机蓝牙状态改变，或是程序刚执行时调用
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state)
    {
            // 手机开启蓝牙
        case CBCentralManagerStatePoweredOn:
        {
            NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
            [self.manager scanForPeripheralsWithServices:nil options:options];//搜到设备后会有回调哦
        }
            break;
            // 手机关机蓝牙
        case CBCentralManagerStatePoweredOff:
        {
            self.isConnected = NO;
            [self.deviceArray removeAllObjects];
            
        }
            break;
            
        default:
            NSLog(@"Central Manager did change state");
            break;
    }
}

//发现设备，
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@">>>>>PeripheralName:%@<<<<<< and services:%@", peripheral, peripheral.services);
    
    
    BOOL exists = NO;
    for (CBPeripheral *peripheralInArray in self.deviceArray) {
        if ([peripheralInArray.identifier isEqual:peripheral.identifier]) {
            exists = YES;
            break;
        }
    }
    
    if (!exists)
    {
        if(peripheral.name != nil)
        {
            [self.deviceArray addObject:peripheral];// 搜索到新的设备添加到设备列表中并发送“发现新设备”的通知
            [self.deviceTable reloadData];
        }
    }
}

//连接设备成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    [peripheral discoverServices:nil];
    
    // 开始播放声音
    [self.decoder startRealTimeAudioPlyer];
    
}


//获取第几个设备的设备名，LKCBluetoothConnectView.m 的- (UITableViewCell *)tableView:中调用
- (NSString *)getDeviceNameAtIndex:(NSInteger)index
{
    CBPeripheral *peripheral = [self.deviceArray objectAtIndex:index];
    return peripheral.name;
    
}
//连接选中的蓝牙，被LKCBluetoothConnectView中的tableView 接口函数执行
- (void)connectDeviceAtIndex:(NSInteger)index
{
    
    [self.manager stopScan];
    
    CBPeripheral *peripheral = [self.deviceArray objectAtIndex:index];
    NSLog(@"----> connect to device [%@]", peripheral);
    self.testPeripheral = peripheral;
    [self.manager connectPeripheral:self.testPeripheral options:nil];//连接某个设备
    self.testPeripheral.delegate = self;
    //这里设置了delegate，下面就可以回调CBPeripheralDelegate的各个函数了
    
}


#pragma mark --CBPeripheralDelegate
//搜索蓝牙服务,点击某个蓝牙设备后，开始搜索他的信息
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
    for (CBService *service in peripheral.services)
    {
        NSString *ustring = [self CBUUIDToString:service.UUID];
        [peripheral discoverCharacteristics:nil forService:service];
    }
}
#pragma mark --BLEUtility
- (NSString *) CBUUIDToString:(CBUUID *)inUUID
{
    unsigned char i[16];
    [inUUID.data getBytes:i];
    if (inUUID.data.length == 2) {
        return [NSString stringWithFormat:@"%02hhx%02hhx",i[0],i[1]];
    }
    else {
        uint32_t g1 = ((i[0] << 24) | (i[1] << 16) | (i[2] << 8) | i[3]);
        uint16_t g2 = ((i[4] << 8) | (i[5]));
        uint16_t g3 = ((i[6] << 8) | (i[7]));
        uint16_t g4 = ((i[8] << 8) | (i[9]));
        uint16_t g5 = ((i[10] << 8) | (i[11]));
        uint32_t g6 = ((i[12] << 24) | (i[13] << 16) | (i[14] << 8) | i[15]);
        return [NSString stringWithFormat:@"%08x-%04hx-%04hx-%04hx-%04hx%08x",g1,g2,g3,g4,g5,g6];
    }
    return nil;
}
//搜索蓝牙特征，是在选中某个蓝牙之后    UUID  service代表服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"discover bluetooth");
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"Service: %@ :::::characteristic:%@", service.UUID, characteristic.UUID);
        
        if ([[self CBUUIDToString:characteristic.UUID] isEqualToString:@"fff1"])
        {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        
        if ([[self CBUUIDToString:characteristic.UUID] isEqualToString:@"fff2"])
            //if ([characteristic.UUID isEqual:_writeUUID])
        {
            NSLog(@"Discovered write Characteristic");
            _writeCharacteristic = characteristic;
        }
    }
}
// 读取蓝牙数据   CBCharacteristic代表特征
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!characteristic) {
        return;
    }
    
    NSData *data = characteristic.value;
    
    LKCHeart * heart =  [self.decoder startDecoderWithCharacterData:data];
    if (heart) {
        _fhrRate1Lable.text = [NSString stringWithFormat:@" 胎心率 ： %ld       是否有fhr1： %ld",(long)heart.rate,(long)heart.isRate];
        _tocoLable.text = [NSString stringWithFormat:    @"宫缩压力 ： %ld      是否有toco： %ld",(long)heart.tocoValue,(long)heart.isToco];
        _batteryLable.text = [NSString stringWithFormat: @"电池电量 ： %ld      宫缩复位标记： %ld",(long)heart.battValue,(long)heart.tocoFlag];
        _singleLable.text = [NSString stringWithFormat:  @"信号质量 ： %ld      手动胎动标记： %ld",(long)heart.signal,(long)heart.fmFlag];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
