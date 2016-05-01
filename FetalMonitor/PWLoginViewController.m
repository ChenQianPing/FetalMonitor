//
//  PWLoginViewController.m
//  FetalMonitor
//
//  Created by hexin on 16/4/16.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "PWLoginViewController.h"
#import "PWMemberCenterTableViewController.h"
#import "WBWeiboAPI.h"
#import "MBProgressHUD.h"
#import "PWinfo.h"
#import "AppDelegate.h"


#define PW_machineNo @"pw_machineNo"
#define PW_userName      @"pw_userName"

@interface PWLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *machineNo;
@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;


//传值
@property (strong, nonatomic) NSString  *imgURL;
@property (strong, nonatomic) NSString  *htmlString;

@end

@implementation PWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.machineNo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.userName];
    
    //读取上次的配置(单例)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.machineNo.text = [defaults valueForKey:PW_machineNo];
    self.userName.text = [defaults valueForKey:PW_userName];
    
    [self textChange];
    
    //if (self.switchLable.isOn) {
    //    self.keyField.text = [defaults valueForKey:PwdKey];
           //}
}

//只要有输入，length就不再为0
- (void)textChange{
    if (self.machineNo.text.length && self.userName.text.length) {
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
    }
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //让姓名文本框称为第一响应者（呼叫出键盘）
    [self.machineNo becomeFirstResponder];
    NSLog(@"让姓名文本框称为第一响应者（呼叫出键盘) %@",self);
}

//页面跳转之前传参
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc = segue.destinationViewController;
    //
    if ([vc isKindOfClass:[PWMemberCenterTableViewController class]]) {
        PWMemberCenterTableViewController *member_vc = vc;
        
        member_vc.imgURL = self.imgURL;
        member_vc.htmlString = self.htmlString;
    }
}
- (IBAction)btnLogin:(UIBarButtonItem *)sender {

   // NSString *machineNo = self.mach
    NSString *machineNo = [self.machineNo text];
    NSString *userName = [self.userName text];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 
    [[WBWeiboAPI shareWeiboApi] didCheckPwLoginWithCmd:@"Fetus_Member_Login" machineNo:machineNo userName:userName completionCallBack:^(id obj) {
        
        
        NSDictionary *dic = obj;
        NSString *status = [dic objectForKey:@"status"];
       
        NSLog(@"status:%@", status);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if([status isEqualToString:@"1"]){
                //success
                // [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                self.imgURL =[dic objectForKey:@"Userimager"];
                self.htmlString = @"您的孕周是 <span style='color:#f19393'>19</span> 周 <span style='color:#f19393'>2</span> 天<br/>还有 <span style='color:#f19393'>24</span> 周<span style='color:#f19393'> 1</span> 天就要和宝宝见面了<br/>设备类型：<span style='color:#f19393'>胎心检测</span><br/>设备设备编号：<span style='color:#02b0e2'>FD123456</span><br/>胎儿数量：<span style='color:#f19393'>2</span> 胎 先测左后测右";
                
                //存储信息（第一次登陆）
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.machineNo.text forKey:PW_machineNo];
                [defaults setObject:self.userName.text forKey:PW_userName];
                //设置同步
                [defaults synchronize];
                
                //存入userInfoId
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                appDelegate.currentUserId =[dic objectForKey:@"UserInfoId"];

                
                
                [self performSegueWithIdentifier:@"PWLogin2Detail" sender:nil];
                
            }else{
                // error
                NSString *msg = [dic objectForKey:@"msg"];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"登陆失败" message:msg delegate:self
                                                    cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        });
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
