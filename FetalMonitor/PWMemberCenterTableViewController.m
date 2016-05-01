//
//  PWMemberCenterTableViewController.m
//  FetalMonitor
//
//  Created by hexin on 16/4/17.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "PWMemberCenterTableViewController.h"
#import "WBWeiboAPI.h"
#import "PBWebViewController.h"
#import "MyWebViewController.h"
#import "PWRecordTableViewController.h"

@interface PWMemberCenterTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UIImageView *img;



@end

@implementation PWMemberCenterTableViewController
@synthesize imgURL;
@synthesize htmlString;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self didAddLabel];
    [self didAddImg];

    
    
    

}

-(void)didAddLabel{
//    NSString * htmlString = @"您的孕周是 19 周 2 天<br/>还有 24 周 1 天就要和宝宝见面了<br/>设备类型：胎心检测<br/>设备设备编号：FD123456<br/>胎儿数量：2 胎 先测左后测右";
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    self.lblDetail.attributedText = attrStr;
}
-(void)didAddImg{
  //  NSString *url = @"/uploads/defaultPhoto.png";
    NSString *url = self.imgURL;
    
    UIImage *img =   [[WBWeiboAPI shareWeiboApi] getImageFromURL:url];
    [self.img setImage:img];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // PWRecordListModel *poiM = _dataSource[indexPath.row];
    
   UITableViewCell *clickedCell = [tableView cellForRowAtIndexPath:indexPath];
 
    if([[clickedCell reuseIdentifier] isEqualToString:@"myHospitalCell" ]){
        [self showWebView:@"http://www.zgzqjh.com/FetusMember/MyHospital"];
    }else if([[clickedCell reuseIdentifier] isEqualToString:@"myDoctorCell" ]){
        [self showWebView:@"http://www.zgzqjh.com/FetusMember/MyDoctor"];
    }
    
else if([[clickedCell reuseIdentifier] isEqualToString:@"myFamilyMemberCell" ]){
    [self showWebView:@"http://www.zgzqjh.com/FetusMember/Family"];
}
else if([[clickedCell reuseIdentifier] isEqualToString:@"myChangePwdCell" ]){
    [self showWebView:@"http://www.zgzqjh.com/FetusMember/Modify"];
}
else if([[clickedCell reuseIdentifier] isEqualToString:@"myDoctorPointCell" ]){
    [self showWebView:@"http://www.zgzqjh.com/FetusMember/Score"];
}
else if([[clickedCell reuseIdentifier] isEqualToString:@"myAdviceCell" ]){
    [self showWebView:@"http://www.zgzqjh.com/FetusMember/Jianyi"];
}
else if([[clickedCell reuseIdentifier] isEqualToString:@"myRecordCell" ]){
    
    [self showMyRecordView];

}
}

-(void)showWebView:(NSString *)url{
  //  MyWebViewController *vc = [[MyWebViewController alloc] init];
   MyWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"myWebView"];
    vc.url = url;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)showMyRecordView{
    PWRecordTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"myRecord"];
    
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
