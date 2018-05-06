#import "RightSliderView.h"
#import "UIColor16.h"
#import "BluetoothConnection.h"

@interface RightSliderView ()

@property (nonatomic ,weak) UIView *sliderView;
@property (strong, nonatomic) UILabel *labelPower;
@property (strong, nonatomic) UIButton *buttonFM;
@property (strong, nonatomic) UIButton *buttonTocoReset;
@property (strong, nonatomic) UISwitch *switchAlarmControl;

@end

@implementation RightSliderView
{
    BluetoothConnection *bluetoothConn;
    NSDate *preFMTime;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    UIButton *backAcitonButton = [[UIButton alloc] initWithFrame:self.bounds];
    [backAcitonButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backAcitonButton];
    
    // 设置侧边栏
    CGRect sliderFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 0.6, CGRectGetHeight(self.bounds));
    sliderFrame.origin.x = self.bounds.size.width;
    UIView *sliderView = [[UIView alloc] initWithFrame:sliderFrame];
    sliderView.backgroundColor = [UIColor whiteColor];
    [self addSubview:sliderView];
    self.sliderView = sliderView;
    
    bluetoothConn = [BluetoothConnection shareBluetooth];
    
    self.labelPower = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, sliderFrame.size.width  - 20, 30)];
    int power = [bluetoothConn getPower];
    [self setPower:power];
    [self.sliderView addSubview:self.labelPower];
    
    UILabel *labelAlarmControl = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, 40, 30)];
    labelAlarmControl.text = @"报警";
    [self.sliderView addSubview:labelAlarmControl];
    
    BOOL alarmState = [bluetoothConn getAlarmState];
    self.switchAlarmControl = [[UISwitch alloc] initWithFrame:CGRectMake(60, 85, sliderFrame.size.width - 60, 30)];
    [self.switchAlarmControl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.switchAlarmControl setOn:alarmState];
    [self.sliderView addSubview:self.switchAlarmControl];
    
    self.buttonFM = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.buttonFM.frame = CGRectMake(10, 130, 100, 40);
    UIImage * bgImage = [self imageWithColor: [UIColor16 colorWithHexString:@"#fabfd8"] size:self.buttonFM.frame.size radius:3];
    self.buttonFM.titleLabel.font = [UIFont systemFontOfSize: 20.0];
    [self.buttonFM setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.buttonFM setBackgroundImage:bgImage forState:UIControlStateNormal];
    [self.buttonFM addTarget:self action:@selector(setFM:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonFM setTitle:@"胎动" forState:UIControlStateNormal];
    [self.sliderView addSubview:self.buttonFM];
    
    self.buttonTocoReset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.buttonTocoReset.frame = CGRectMake(10, 185, 100, 40);
    self.buttonTocoReset.titleLabel.font = [UIFont systemFontOfSize: 20.0];
    [self.buttonTocoReset setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.buttonTocoReset setBackgroundImage:bgImage forState:UIControlStateNormal];
    [self.buttonTocoReset addTarget:self action:@selector(setTocoReset:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonTocoReset setTitle:@"宫缩复位" forState:UIControlStateNormal];
    [self.sliderView addSubview:self.buttonTocoReset];
    
    return self;
}

-(void)setPower:(int)power
{
    if(power > -1)
    {
        _labelPower.text = [NSString stringWithFormat:@"电量: %@%@", @(power * 25), @"%"];
    }
    else
    {
        _labelPower.text = @"电量: --";
    }
}

-(void)setFM:(UIButton*)sender
{
    if(bluetoothConn != nil)
    {
        if(bluetoothConn.isGrardianship)
        {
            NSDate *dt = [NSDate date];
            if(preFMTime == nil || [dt timeIntervalSinceDate: preFMTime] > 3)
            {
                preFMTime = dt;
                bluetoothConn.setFM;
            }
            else
            {
                [self showAlert:@"胎动点击过于频繁."];
            }
        }
    }
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)showAlert:(NSString*) message

{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:NO];
    
    [promptAlert show];
}

-(void)setTocoReset:(UIButton*)sender
{
    if(bluetoothConn != nil)
    {
        if(bluetoothConn.isGrardianship)
        {
            bluetoothConn.setTocoReset;
        }
    }
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

- (void)showInView:(UIView *)view
{
    // 将自身添加到view
    self.backgroundColor = [UIColor clearColor];
    CGRect sliderFrame = self.sliderView.frame;
    sliderFrame.origin.x = self.bounds.size.width-CGRectGetWidth(sliderFrame);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^
    {
        self.backgroundColor = [[UIColor alloc] initWithWhite:0 alpha:0.6];
        self.sliderView.frame = sliderFrame;
    }];
}

- (void)dismiss
{
    CGRect sliderFrame = self.sliderView.frame;
    sliderFrame.origin.x = self.bounds.size.width;
    
    [UIView animateWithDuration:0.25 animations:^
    {
        self.backgroundColor = [UIColor clearColor];
        self.sliderView.frame = sliderFrame;
    } completion:^(BOOL finished)
    {
        [self removeFromSuperview];
    }];
}

-(void)switchAction:(UISwitch*)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isAlarm = [switchButton isOn];
    [bluetoothConn setAlarmPlayer:isAlarm];
}

@end
