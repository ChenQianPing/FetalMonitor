#import "MonitorHistoryRecordViewController.h"
#import "AppDelegate.h"
#import "NetworkSingleton.h"
#import "PWRecordListModel.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "GlobalDBEngine.h"
#import "CTChart.h"
#import "SVProgressHUD.h"
#import "UploadGrardianshipRequest.h"
#import "NSDictionary+Utils.h"
#import "Global.h"
#import "MBProgressUtils.h"

#define PW_machineNo @"pw_machineNo"

@interface MonitorHistoryRecordViewController()

@end

@implementation MonitorHistoryRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"历史记录";
    
    [self initTableArray];
    [self initCategoryArray];
    [self addCategoryView];
    [self addTableView];
    
    [self requestData];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

- (void)initTableArray
{
    if(self.uploadsTableArray == nil)
    {
        self.uploadsTableArray = [[NSMutableArray alloc] init];
        self.unUploadTableArray = [[NSMutableArray alloc] init];
        dictionary = [[NSMutableDictionary alloc] init];
    }
}

- (void)initCategoryArray
{
    currentCategory = 1;
    previousCategory = 1;
    if (categoryArray == nil)
    {
        categoryArray = [[NSMutableArray alloc] initWithObjects:@"已上传",@"未上传", nil];
    }
}

- (void)addCategoryView
{
    categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    [self.view addSubview:categoryView];
    
    CGFloat buttonW = self.view.frame.size.width / categoryArray.count;
    for (int i = 0; i < categoryArray.count; i++ )
    {
        UIButton *categoryButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonW*i, 0, buttonW, 44)];
        categoryButton.tag = 200 + i;
        [categoryButton setTitle:categoryArray[i] forState:UIControlStateNormal];
        [categoryButton setTitleColor:[UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [categoryButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [categoryButton addTarget:self action:@selector(clickedSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [categoryView addSubview:categoryButton];
        if (i != 0)
        {
            // 分隔线
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonW*i, (44-20)/2, 1, 20)];
            lineImageView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
            [categoryView addSubview:lineImageView];
        }
        else
        {
            [categoryButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:96.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [categoryButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        }
    }
    // 添加下划线
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44-1, self.view.frame.size.width, 1)];
    lineImageView.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
    [categoryView addSubview:lineImageView];
}

// 添加列表
- (void)addTableView
{
    if (tableView == nil)
    {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44, self.view.frame.size.width, self.view.frame.size.height-64-44) style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        
        // 默认分隔线设置为无
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        
        UISwipeGestureRecognizer *swipeGestureToRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToRight)];
        swipeGestureToRight.direction=UISwipeGestureRecognizerDirectionRight;
        [tableView addGestureRecognizer:swipeGestureToRight];
        
        UISwipeGestureRecognizer *swipeGestureToLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToLeft)];
        swipeGestureToLeft.direction=UISwipeGestureRecognizerDirectionLeft;
        [tableView addGestureRecognizer:swipeGestureToLeft];
    }
}

#pragma mark ------------------点击事件----------------------

- (void)writeDictionary
{
    NSNumber *y = [NSNumber numberWithFloat:tableView.contentOffset.y];
    if (currentCategory == 1)
    {
        [dictionary setObject:y forKey:@"uploaded"];
    }
    else if (currentCategory == 2)
    {
        [dictionary setObject:y forKey:@"unUpload"];
    }
}

- (void)clickedSelectButton:(UIButton *)sender
{
    UIButton *button = sender;
    // 先记录当前tableview的位置再切换到下一个分类去
    [self writeDictionary];
    if (button.tag == 200)
    {
        currentCategory = 1;
    }
    else if (button.tag == 201)
    {
        if(currentCategory != 2)
        {
            if(![self getNoUpdateRemindState])
            {
                if(remindAlertView == nil)
                {
                    remindAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"长按未上传数据，可重新上传" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:@"下次不提醒", nil];
                    remindAlertView.tag = 501;
                    remindAlertView.alertViewStyle = UIAlertViewStyleDefault;
                }
                [remindAlertView show];
            }
        }
        currentCategory = 2;
    }
    [self changeUIAndReloadData];
}

// 左右滑动事件
- (void)swipeToRight
{
    [self writeDictionary];
    if (currentCategory == 1)
    {
        return;
    }
    else
    {
        currentCategory = currentCategory - 1;
    }
    
    [self changeUIAndReloadData];
}
- (void)swipeToLeft
{
    [self writeDictionary];
    if (currentCategory == 2)
    {
        return;
    }
    else
    {
        currentCategory = currentCategory + 1;
    }
    [self changeUIAndReloadData];
}

- (void)changeUIAndReloadData
{
    NSInteger buttonTag = 200;
    if (currentCategory == 1)
    {
        buttonTag = 200;
        [tableView setContentOffset:CGPointMake(0, [dictionary[@"jiuJiuY"] floatValue]) animated:NO];
        
        [self requestData];
    }
    else if (currentCategory == 2)
    {
        buttonTag = 201;
        [tableView setContentOffset:CGPointMake(0, [dictionary[@"shiJiuY"] floatValue]) animated:NO];
        
        [self requestData];
    }
    
    // 修改分栏的状态
    for (int i = 200; i < 200 + categoryArray.count; i++)
    {
        UIButton *categoryButton = (UIButton *)[categoryView viewWithTag:i];
        if (i == buttonTag)
        {
            [categoryButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:96.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [categoryButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        }
        else
        {
            [categoryButton setTitleColor:[UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [categoryButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }
    }
    
    // 添加动画
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush;
    if (previousCategory == currentCategory)
    {
        return;
    }
    else if (previousCategory < currentCategory)
    {
        transition.subtype = kCATransitionFromRight;
    }
    else
    {
        transition.subtype = kCATransitionFromLeft;
    }
    previousCategory = currentCategory;
    [tableView reloadData];
    
    [tableView.layer addAnimation:transition forKey:@"animation"];
}

#pragma mark --------------tableviewDataSource---------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(currentCategory == 1)
    {
        return self.uploadsTableArray.count;
    }
    else
    {
        return self.unUploadTableArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellString = @"cellString"; // cell的重用
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellString];
        // 设置点选效果为无
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    PWRecordListModel *poiM;
    if(currentCategory == 1)
    {
        poiM = self.uploadsTableArray[indexPath.row];
    }
    else
    {
        poiM = self.unUploadTableArray[indexPath.row];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", poiM.StartTime];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [self formatTime:poiM.Minute.intValue * 60 + poiM.Second.intValue]];
    
    int cellHeight = 50;
    // 分隔线
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, cellHeight-1, self.view.frame.size.width-20, 1)];
    [lineImageView setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
    [cell addSubview:lineImageView];
    
    return cell;
}

#pragma mark ---------------tableviewDelegate------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTChart *vc = [[CTChart alloc] init];
    monitorData = nil;
    if(currentCategory == 1)
    {
        PWRecordListModel *model = self.uploadsTableArray[indexPath.row];
        vc.monitorData = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        
        monitorData = self.unUploadTableArray[indexPath.row];
        [self unUploadDataProcess];
    }
}

#pragma mark ----------------UIScrollViewDelegate-----------------

-(void)requestData
{
    //[self.tableArray removeAllObjects];
    //[self.tableArray addObjectsFromArray:array];
    //刷新列表
    //[tableView reloadData];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *uid = appDelegate.currentUserId;
    //NSLog(@"----->UID: %@", uid);
    
    if(currentCategory == 1)
    {
        NSString *url = [NSString stringWithFormat:@"http://www.zgzqjh.com/ajax.aspx?action=App&cmd=Fetus_User_Record&UserInfoId=%@", uid];
        //NSLog(@"----->URL: %@", url);
        
        [[NetworkSingleton sharedManager]getUrl:url id:nil successBlock:^(id responseBody)
         {
             //NSLog(@"---->%@", responseBody);
             //NSMutableArray *dataArray = [responseBody objectForKey:@"data"];
             NSMutableArray *dataArray = responseBody;
             
             [self.uploadsTableArray removeAllObjects];
             for (int i = 0; i < dataArray.count; ++i)
             {
                 PWRecordListModel *homeM = [PWRecordListModel mj_objectWithKeyValues:dataArray[i]];
                 [self.uploadsTableArray addObject:homeM];
             }
             
             [tableView reloadData];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
         } failureBlock:^(NSString *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSLog(@"----->网络请求：我的记录失败：%@", error);
         }];
    }
    else
    {
        [self.unUploadTableArray removeAllObjects];
        GlobalDBEngine *dbEngine = [GlobalDBEngine sharedDB];
        NSArray *list = [dbEngine getUnUploadGrardianshipDataWithType:uid];
        if (list != nil && list.count > 0)
        {
            for(int i = 0; i < list.count; i++)
            {
                GrardianshipData *data = list[i];
                PWRecordListModel *homeM = [[PWRecordListModel alloc] init];
                homeM.DataId = data.grardianshipID;
                homeM.FileName = data.fileName;
                homeM.StartTime = data.createTime;
                homeM.Second = data.duration;
                [self.unUploadTableArray addObject:homeM];
            }
        }
        [tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

-(NSString*) formatTime:(int)secondTotal
{
    long hh = secondTotal / 60 / 60;
    long mm = (secondTotal - hh * 60 * 60) > 0 ? (secondTotal - hh * 60 * 60) / 60 : 0;
    long ss = secondTotal < 60 ? secondTotal : secondTotal % 60;
    return [NSString stringWithFormat:@"%@%@%@",
            (hh == 0 ? @"" : [NSString stringWithFormat:@"%lo小时", hh]),
            (mm == 0 ? @"" : [NSString stringWithFormat:@"%lo分", mm]),
            (ss == 0 ? @"" : [NSString stringWithFormat:@"%lo秒", ss])];
}

-(void) unUploadDataProcess
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:@"您可以上传或删除."
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"上传", @"删除", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 501)
    {
        if(buttonIndex == 1)
        {
            [self setNoUpdateRemind];
        }
        return;
    }
    
    if(buttonIndex == 1)
    {
        [self upload];
    }
    else if(buttonIndex == 2)
    {
        // delete
        GlobalDBEngine *dbEngine = [GlobalDBEngine sharedDB];
        if([dbEngine deleGrardianshipDataWithFilename: monitorData.FileName] == YES)
        {
            [self requestData];
        }
    }
}

-(BOOL) getNoUpdateRemindState
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"noUpdateRemindState"];
}

-(void) setNoUpdateRemind
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"noUpdateRemindState"];
}

-(void) upload
{
    NSString *fileName = monitorData.FileName;
    NSString *audioFileName = [fileName substringToIndex:fileName.length - 4];
    audioFileName = [NSString stringWithFormat:@"%@.wav", audioFileName];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *recordDataDir = [docDir stringByAppendingPathComponent:@"audios"];
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:recordDataDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:recordDataDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *audioFilePath = [recordDataDir stringByAppendingPathComponent:audioFileName];
    NSString *filePath = [docDir stringByAppendingPathComponent:fileName];
    //
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = appDelegate.currentUserId;
    NSString *deviceId = [defaults objectForKey:PW_machineNo];
    
    //测试上传数据
    [SVProgressHUD showWithStatus:@"上传中"];
    
    UploadGrardianshipRequest *upload = [[UploadGrardianshipRequest alloc] initWithGravidaId:[[NSString alloc] initWithFormat:@"%@",uid] andDeviceId:deviceId andFilePath:filePath andAudioFilePath: audioFilePath];
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
                                [[GlobalDBEngine sharedDB] updateGrardianshipDataWith:[[NSString alloc] initWithFormat:@"%@", uid] andFilename:[[filePath componentsSeparatedByString:@"/"] lastObject]];
                                [SVProgressHUD dismiss];
                                [MBProgressUtils showRemind:@"监护数据已成功上传" addTo:self.view];
                                [self requestData];
                            });
         }
         else if ([result1 isEqualToString:kUploadMonitoringDataPauseServiceErrorCode])
         {
             //[tableView reloadData];
             [MBProgressUtils showRemind:@"上传失败" addTo:self.view];
             [self requestData];
         }
         else
         {
             //[tableView reloadData];
             [MBProgressUtils showRemind:@"上传失败" addTo:self.view];
             [self requestData];
         }
     } failure:^(YTKBaseRequest *request)
     {
         NSLog(@"fail : request %@",request.responseString);
         [SVProgressHUD dismiss];
         [MBProgressUtils showRemind:@"上传失败" addTo:self.view];
         [self requestData];
     }];
}

@end
