//
//  JianHuJiluTableViewController.m
//  FetalMonitor
//
//  Created by hexin on 16/4/22.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "JianHuJiluTableViewController.h"
#import "SDCycleScrollView.h"
#import "BannerTableViewCell.h"
#import "JianHuCenterTableCell.h"
#import "BarCell.h"
#import "HomeMenuCell.h"
#import "HomeMenu2Cell.h"
#import "MyWebViewController.h"
#import "NSString+convertImgStr.h"
#import "MyWebViewController.h"
#import "JianHuTableViewController.h"



@interface JianHuJiluTableViewController ()<UITableViewDataSource, UITableViewDelegate,SDCycleScrollViewDelegate,HomeMenu2Delegate>
@property(nonatomic,strong)NSArray *menuArray;

@property(nonatomic,strong)NSArray *menuArray2;
@end

@implementation JianHuJiluTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
    
}


- (IBAction)btnClientService:(id)sender {
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupData{
    /* _menuArray = @[
     @[@"aa",@"a.png"],
     @[],
     @[]
     ];
     */
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 150;
    }else if(indexPath.row == 1){
        return 30;
    }else if (indexPath.row == 2){
        return 260;
    }else{
        return 96;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *cellIndentifier = @"bannerTableCell";
        BannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        [cell loadImages ];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(indexPath.row == 1) {
        static NSString *cellIndentifier = @"BarCell";
        BarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
        
    }else if(indexPath.row == 2) {
        
        
        _menuArray = @[
                       @[@"胎心监护",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_n1.png",@"web?url=http://www.zgzqjh.com/InterrogationOnline"],
                       @[@"血糖监护",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_n3.png",@"web?url=http://www.zgzqjh.com/list.aspx?cid=10"],
                       @[@"血压监护",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_n5.png",@"web?url=http://www.zgzqjh.com/list.aspx?cid=8"],
                       @[@"体重监护",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_n6.png",@"web?url=http://www.zgzqjh.com/list.aspx?cid=9"],
                       @[@"心电心率",@"http://upload-images.jianshu.io/upload_images/1845730-1a3f4e5e096bb748.png",@"web?url=http://www.zgzqjh.com/list.aspx?cid=5"],
                       @[@"睡眠呼吸",@"http://upload-images.jianshu.io/upload_images/1845730-2d62d95eec0ce012.png",@"web?url=http://www.zgzqjh.com/list.aspx?cid=6"]
                     /*  @[@"儿童体温",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_n2.png",@"web?url=#"],*/
                       
                       
                       /*
                       @[@"母婴体重称",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_n4.png",@"web?url=#"],
                        */
                    
                       
                       
                       ];
        
        /**
         * Note By:QP
         * Modify Date:17-04-09
         * 调整顺序,新增心电心率,睡眠呼吸
         
         */

        
        static NSString *cellIndentifier = @"homecell";
        HomeMenu2Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[HomeMenu2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier menuArray:_menuArray];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        return nil;
    }
}

-(void)homeMenuDidSelectedAtIndex:(NSInteger)index{
    [self gotoViewControllerWithType:index array:_menuArray];
}

-(void)homeMenu2DidSelectedAtIndex:(NSInteger)index{
    [self gotoViewControllerWithType:index array:_menuArray];
}


#pragma mark - **************** UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



-(void)gotoViewControllerWithType:(int )index array:(NSArray *)array{
    NSLog(@"goto_type:%ld",index);
    
    if(index == 0){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        JianHuTableViewController *VC = [sb instantiateViewControllerWithIdentifier:@"JianHuTableViewController"];
     
        [self.navigationController pushViewController:VC animated:YES];

        
    }else{
    
    
    
    //bainuo://web?
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyWebViewController *VC = [sb instantiateViewControllerWithIdentifier:@"myWebView"];
    VC.url = [NSString getWebUrl:array[index][2]];
    [self.navigationController pushViewController:VC animated:YES];
    
    }
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

- (IBAction)btnClient:(id)sender {
    
    /*
    MyWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"myWebView"];
    vc.url = @"http://www.zgzqjh.com/list.aspx?cid=264";
    [self.navigationController pushViewController:vc animated:YES];
    */
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyWebViewController *VC = [sb instantiateViewControllerWithIdentifier:@"myWebView"];
    VC.url =  @"http://www.zgzqjh.com/list.aspx?cid=264";
    [self.navigationController pushViewController:VC animated:YES];
}
@end
