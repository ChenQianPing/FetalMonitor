#import <UIKit/UIKit.h>
#import "ChartView.h"
#import "BluetoothConnection.h"

@interface RealTimeGuardianship : UIViewController<ChartViewDelegate,BluetoothConnectionDelegate,UIActionSheetDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@property (strong, nonatomic) IBOutlet UIView *pageView;
@property (strong, nonatomic) IBOutlet UILabel *pageLabel;
- (IBAction)frontPage:(UIButton *)sender;
- (IBAction)nextPage:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *monitorControlBtn;
- (IBAction)monitorControl:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel *fhrTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tocoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fmTitleLabel;


@property (strong, nonatomic) IBOutlet UILabel *fhrLabel;
@property (strong, nonatomic) IBOutlet UILabel *tocoLabel;
@property (strong, nonatomic) IBOutlet UILabel *fmLabel;

@property (strong, nonatomic) IBOutlet UIImageView *fhrImageView;
@property (strong, nonatomic) IBOutlet UIImageView *tocoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *fmImageView;

@property (strong, nonatomic) IBOutlet UIView *fhrView;
@property (strong, nonatomic) IBOutlet UIView *tocoView;
@property (strong, nonatomic) IBOutlet UIView *fmView;


@end
