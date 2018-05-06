#import "GrardianshipMainViewController.h"
#import "RealTimeGuardianship.h"
#import <objc/runtime.h>
#import "SVProgressHUD.h"
#import "Global.h"
#import "NSDictionary+Utils.h"
#import "User.h"
#import "GlobalDBEngine.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "UIColor16.h"
#import "PWRecordTableViewController.h"
#import "MonitorHistoryRecordViewController.h"

static NSString * const CellIndentifier  = @"CELL";

@interface GrardianshipMainViewController ()<UIActionSheetDelegate>

@end

@implementation GrardianshipMainViewController
{
    BluetoothConnection *bluetoothConn;
    int recDeviceInfoCount;
    User *user;
}

-(void)viewWillAppear:(BOOL)animated
{
    bluetoothConn = [BluetoothConnection shareBluetooth];
    bluetoothConn.delegate = self;
    
    [_tableView reloadData];
    
    recDeviceInfoCount = 0;
}

-(void)viewDidAppear:(BOOL)animated
{
    bluetoothConn.isInConnectView = YES;
    _tableView.contentInset = UIEdgeInsetsZero;
    // [self drawAllPoint];
}

-(void)viewWillDisappear:(BOOL)animated
{
    bluetoothConn.isInConnectView = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    user = [User sharedUser];
    
    bluetoothConn = [BluetoothConnection shareBluetooth];
    bluetoothConn.delegate = self;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@"3" forKey:@"speed"];
    [userDefaults setValue:@"0" forKey:@"time"];
    [userDefaults setValue:@"" forKey:@"createTime"];
    
    UIImage * bgImage1 = [self imageWithColor: [UIColor16 colorWithHexString:@"#fabfd8"] size:_scanBtn.frame.size radius:3];
    [_scanBtn setBackgroundImage:bgImage1 forState:UIControlStateNormal];
    
    self.title = @"胎儿监护";
    UIBarButtonItem *barRightButton = [[UIBarButtonItem alloc]initWithTitle:@"历史" style:UIBarButtonItemStylePlain target:self action:@selector(history:)];
    self.navigationItem.rightBarButtonItem=barRightButton;
}

-(void)history:(UIButton *)sender
{
    MonitorHistoryRecordViewController *vc = [[MonitorHistoryRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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

- (IBAction)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) didUpdateState:(int)state
{
    switch (state)
    {
        case CBCentralManagerStatePoweredOn:
            _tipsLabel.text = @"蓝牙已打开, 请搜索设备.";
            break;
            
        case CBCentralManagerStatePoweredOff:
            _tipsLabel.text = @"蓝牙已关闭.";
            break;
            
        case CBCentralManagerStateResetting:
            _tipsLabel.text = @"蓝牙正在重置.";
            break;
            
        case CBCentralManagerStateUnsupported:
            _tipsLabel.text = @"手机不支持.";
            break;
            
        case CBCentralManagerStateUnauthorized:
            _tipsLabel.text = @"请在设置中启用APP对蓝牙的使用权限.";
            break;
            
        default:
            _tipsLabel.text = @"未知状态, 无法正常使用蓝牙.";
            break;
    }
}

- (IBAction)scanDevice:(UIButton *)sender
{
    [bluetoothConn scanDevice];
    
    _tipsLabel.text = @"正在搜索附近的设备...";
    [_activity startAnimating];
    _scanBtn.enabled = NO;
    
//    self.hidesBottomBarWhenPushed = YES;
//    RealTimeGuardianship *realTime = [[RealTimeGuardianship alloc] init];
//    [self.navigationController pushViewController:realTime animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bluetoothConn.deviceArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    CBPeripheral *per = bluetoothConn.deviceArr[indexPath.row];
    
    if (per.state == CBPeripheralStateConnected)
    {
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",per.name];
        cell.detailTextLabel.text = @"已连接";
    }
    else if(per.state == CBPeripheralStateConnecting)
    {
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",per.name];
        cell.detailTextLabel.text = @"正在连接";
    }
    else
    {
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",per.name];
        cell.detailTextLabel.text = @"未连接";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_activity stopAnimating];
    _tipsLabel.text = @"搜索结束";
    _scanBtn.enabled = YES;
    
    CBPeripheral *per = (CBPeripheral *)bluetoothConn.deviceArr[indexPath.row];
    
    if (![per isEqual:bluetoothConn.peripheral])
    {
        [bluetoothConn disconnectCurrentDevice];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (per.state == CBPeripheralStateConnected)
    {
        self.hidesBottomBarWhenPushed = YES;
        RealTimeGuardianship *realTime = [[RealTimeGuardianship alloc] init];
        [self.navigationController pushViewController:realTime animated:YES];
    }
    else if(per.state == CBPeripheralStateConnecting)
    {
        cell.detailTextLabel.text = @"正在连接";
    }
    else if(per.state == CBPeripheralStateDisconnecting)
    {
        cell.detailTextLabel.text = @"正在断开";
    }
    else
    {
        cell.detailTextLabel.text = @"正在连接";
        [bluetoothConn connectDevice:(int)indexPath.row];
    }
}

#pragma mark - BluetoothConnectionDelegate

// 扫描设备结束
-(void)didScanFinish
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [_activity stopAnimating];
        _tipsLabel.text = @"搜索结束";
        _scanBtn.enabled = YES;
        [_tableView reloadData];
        _tableView.userInteractionEnabled = YES;
    });
}

// 已连接设备并接收到的设备信息
-(void)didConnectedDevice:(CBPeripheral *)peripheral
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.hidesBottomBarWhenPushed = YES;
        RealTimeGuardianship *realTime = [[RealTimeGuardianship alloc] init];
        [self.navigationController pushViewController:realTime animated:YES];
    });
}

// 已接收到的设备信息
-(void)didRecDeviceInfo:(DeviceInfo *)deviceInfo
{
    
}

-(void)didRecGrardianshipData:(NSData *)data
{
    
}

-(void)didDeviceDisconnect
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [_tableView reloadData];
    });
}

-(void)didStopGrardianship
{
    
}

// 已加载本地文件数据
-(void)didLoadLocalData
{
    bluetoothConn.canRecGrardianshipData = YES;
    RealTimeGuardianship *realTime = [[RealTimeGuardianship alloc] init];
    [self.navigationController pushViewController:realTime animated:YES];
}

#pragma mark - actionView

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
