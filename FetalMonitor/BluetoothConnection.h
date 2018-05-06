#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "UUID.h"
#import "DeviceInfo.h"
#import <AVFoundation/AVFoundation.h>

typedef enum
{
    OneCM = 1,
    TwoCm = 2,
    ThreeCM = 3
} TimeStyle;

@protocol BluetoothConnectionDelegate <NSObject>

-(void)didUpdateState:(int)state;
-(void)didScanFinish;
-(void)didConnectedDevice:(CBPeripheral *)peripheral;
-(void)didRecDeviceInfo:(DeviceInfo *)deviceInfo;
-(void)didRecGrardianshipData:(NSData *)data;
-(void)didSaveLocalFile;
-(void)didDeviceDisconnect;
-(void)didStopGrardianship;
-(void)didLoadLocalData;
-(void)didPowerChanged:(int)power;

@end

@protocol BlueToothInfoDelegate <NSObject>

-(void)didGetBatteryInfo:(NSData *)batteryInfo;

@end

@interface BluetoothConnection : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate,AVAudioPlayerDelegate>

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong) CBCharacteristic *notifyCharacteristic;
@property (nonatomic, strong) NSMutableArray *deviceArr;
@property (nonatomic, strong) NSMutableArray *serviceArr;
@property (nonatomic, strong) NSMutableArray *characteristicArr;

@property (nonatomic, strong) NSMutableArray *heartBeatPointArr;
@property (nonatomic, strong) NSMutableArray *uterinePressureArr;
@property (nonatomic, strong) NSMutableArray *fetalMovementArr;
@property (nonatomic, strong) NSMutableArray *originDataArr;
@property (nonatomic, strong) DeviceInfo *deviceInfo;
@property (nonatomic, strong) NSString *currSavedFile;
@property (nonatomic, strong) NSString *currSavedAudioFile;
@property (nonatomic) BOOL canRecGrardianshipData;

@property (nonatomic, strong) NSMutableArray *needSyncArr;

@property (nonatomic) int paperSpeed;   // 纸速
@property (nonatomic) int xTime;        // 相对时间、绝对时间

@property (nonatomic, strong) NSObject<BluetoothConnectionDelegate> *delegate;

@property (nonatomic, strong) NSObject<BlueToothInfoDelegate> *infoDelegate;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, strong) dispatch_source_t timerForRequest;

@property (nonatomic) int moveCount;

@property (nonatomic) BOOL isInRealView;
@property (nonatomic) BOOL isInConnectView;
 @property (nonatomic) BOOL isAbandon;

@property (nonatomic) BOOL isOutSideDisconnect;

@property (nonatomic) int power;

-(BOOL)isGrardianship;
-(void)updateDeviceId;
-(void)scanDevice;
-(void)connectDevice:(int)deviceId;
-(void)beginGrardianship;
-(void)stopGrardianship;
-(void)openAlarm;
-(void)closeAlarm;
-(float)maxAlarmValue;
-(float)minAlarmValue;
-(void)chooseAlarmDelay:(UInt8)value;
-(float)volume;
-(void)changeVolume:(int)value;
-(void)addFetalMovement;
-(void)saveGrardianshipDataWithType;
-(void)reset;
-(void)getBatteryInfo;

-(void)writeGrardianshipDataToLoacl:(NSData *)data;
-(void)readGrardianshipDataFromLocal;
-(void)deleteGrardianshipDataFromLocal;

-(void)disconnectCurrentDevice;

-(int)getPower;
-(void)setFM;
-(void)setTocoReset;
-(void)setAlarmPlayer:(BOOL)state;
-(BOOL) isMinMonitorTimelong;
-(BOOL)getAlarmState;

+(id)shareBluetooth;

@end
