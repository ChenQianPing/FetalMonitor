//
//  PWRecordTableViewController.m
//  FetalMonitor
//
//  Created by hexin on 16/4/17.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "PWRecordTableViewController.h"
#import "PWRecordCell.h"
#import "MyModel.h"
#import "PWRecordDetailViewController.h"

#import "MJRefresh.h"
#import "MJExtension.h"


#import "WBWeiboAPI.h"
#import "NetworkSingleton.h"
#import "SVProgressHUD.h"


@interface PWRecordTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation PWRecordTableViewController

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
    _dataSource = [[NSMutableArray alloc] init];
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
    static NSString *cellIdentifier = @"PWRecordCell";
    PWRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (_dataSource.count>0) {
        PWRecordListModel *poiM = _dataSource[indexPath.row];
        //JZNearTuanListModel *tuanListM = poiM.tuan_list[indexPath.row];
        [cell setPWRecordListM:poiM];
    }
    return cell;
    

}



-(void)getPWRecordData{
    NSString *url = @"http://www.zgzqjh.com/ajax.aspx?action=App&cmd=Fetus_User_Record&UserInfoId=fubxf20160325101144";
    
    [[NetworkSingleton sharedManager]getUrl:url id:nil successBlock:^(id responseBody){
        NSLog(@"网络请求：我的记录成功");
        
        [_dataSource removeAllObjects];
        
      //  NSMutableArray *dataArray = [responseBody objectForKey:@"data"];
        NSMutableArray *dataArray = responseBody;
        
        for (int i = 0; i < dataArray.count; ++i) {
            
            PWRecordListModel *homeM = [PWRecordListModel mj_objectWithKeyValues:dataArray[i]];
            
            [_dataSource addObject:homeM];
        }
        
        [self.tableView reloadData];
        
        
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSString *error){
        NSLog(@"网络请求：我的记录失败：%@",error);
        [self.tableView.mj_header endRefreshing];
    }];

    
    }


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  // PWRecordListModel *poiM = _dataSource[indexPath.row];
    
    
    [self performSegueWithIdentifier:@"PWRecordToDetail" sender:nil];
    
}

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PWRecordDetailViewController * vc = segue.destinationViewController;
    //indexPathForSelectedRow 取得选中的那一行
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    
    vc.pwRecordModel = self.dataSource [path.row]; //将数据模型传给成员变量contactModel
     
}



@end
