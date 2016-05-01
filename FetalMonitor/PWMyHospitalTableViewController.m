//
//  PWMyHospitalTableViewController.m
//  FetalMonitor
//
//  Created by hexin on 16/4/19.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "PWMyHospitalTableViewController.h"
#import "WBWeiboAPI.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MyHospital.h"

#import "WBWeiboAPI.h"
#import "NetworkSingleton.h"
#import "SVProgressHUD.h"

@interface PWMyHospitalTableViewController ()

@end

@implementation PWMyHospitalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setUpTableView];
    
        // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -初始化

-(void)initData{
    _MyHospital = [[MyHospital alloc] init];
}

//MJRefresh下拉刷新，跟上一个版本比，有的方法变了，具体用发要参考源码
-(void)setUpTableView{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // self.tableView.header = [JZNuomiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

-(void)loadNewData{
    [self getPWRecordData];
}


-(void)getPWRecordData{
    
    
    NSString *url = @"http://www.zgzqjh.com/ajax.aspx?action=App&cmd=Fetus_Hospital&UserInfoId=fubxf20160325101144";
    
    [[NetworkSingleton sharedManager]getUrl:url id:nil successBlock:^(id responseBody){
        NSLog(@"网络请求：我的医院，成功");
        

        
        //  NSMutableArray *dataArray = [responseBody objectForKey:@"data"];
       _MyHospital = [MyHospital mj_objectWithKeyValues:responseBody];
        
        [_HospitalImage setImage:  [[WBWeiboAPI shareWeiboApi] getImageFromURL:_MyHospital.HospitalImage]];
        //[_HospitalImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
       // _HospitalImage.contentMode =  UIViewContentModeScaleAspectFill;
        //_HospitalImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
       // _HospitalImage.clipsToBounds  = YES;
        
        
        
        _HospitalAddress.text = _MyHospital.HospitalAddress;
        _Tel.text =_MyHospital.Tel;
        
        _ZipCode.text = _MyHospital.ZipCode;
        
       // NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[_MyHospital.Description dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
       // _Description.attributedText = attrStr;
        
        [_WebDescription loadHTMLString:_MyHospital.Description baseURL:nil];

        
        
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSString *error){
        NSLog(@"网络请求：我的医院，失败：%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
    
    
    
    
  

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
