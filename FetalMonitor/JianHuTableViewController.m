//
//  JianHuTableViewController.m
//  FetalMonitor
//
//  Created by hexin on 16/4/22.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "JianHuTableViewController.h"
#import "MyWebViewController.h"
@interface JianHuTableViewController ()

@end

@implementation JianHuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 6;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // PWRecordListModel *poiM = _dataSource[indexPath.row];
    
    UITableViewCell *clickedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if([[clickedCell reuseIdentifier] isEqualToString:@"hospitalLoginCell" ]){
       // [self showWebView:@"http://www.zgzqjh.com/Fetus/DoctorLogin"];
        [self showWebView:@"http://www.zgzqjh.com/list.aspx?cid=86"];
       
    }else if([[clickedCell reuseIdentifier] isEqualToString:@"doctorLoginCell" ]){
        [self showWebView:@"http://www.zgzqjh.com/Fetus/DoctorLogin"];
    }
    else if([[clickedCell reuseIdentifier] isEqualToString:@"onlineDemoCell" ]){
         //[self showWebView:@"http://www.zgzqjh.com/Fetus/OnlineDemo"];
         [self showWebView:@"http://www.zgzqjh.com/list.aspx?cid=31"];
       
    }
    else if([[clickedCell reuseIdentifier] isEqualToString:@"pregnantGuideCell" ]){
        [self showWebView:@"http://www.zgzqjh.com/Fetus/Guide"];
    }
    /*
    else if([[clickedCell reuseIdentifier] isEqualToString:@"otherCell" ]){
        [self showWebView:@"http://www.zgzqjh.com/Fetus/Other"];
    }
    */
     //   [self showMyRecordView];
        
    
}

-(void)showWebView:(NSString *)url{
    //  MyWebViewController *vc = [[MyWebViewController alloc] init];
    MyWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"myWebView"];
    vc.url = url;
    [self.navigationController pushViewController:vc animated:YES];
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
