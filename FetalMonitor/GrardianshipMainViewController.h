#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "UUID.h"
#import "BluetoothConnection.h"

@interface GrardianshipMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BluetoothConnectionDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *scanBtn;

- (IBAction)scanDevice:(UIButton *)sender;

@end
