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
#import "HomeMenuCell.h"
#import "HomeMenu2Cell.h"
#import "JZWebViewController.h"
#import "NSString+convertImgStr.h"



@interface JianHuJiluTableViewController ()<UITableViewDataSource, UITableViewDelegate,SDCycleScrollViewDelegate,HomeMenu2Delegate>
@property(nonatomic,strong)NSArray *menuArray;
@property(nonatomic,strong)NSArray *menuArray2;
@end

@implementation JianHuJiluTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
    
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
        return 184;
    }else if(indexPath.row == 1){
        return 180;
    }else if (indexPath.row == 2){
        return 180;
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
        
       _menuArray = @[
                       @[@"分级诊疗",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_ico01.png",@"web?url=http://www.zgzqjh.com/InterrogationOnline"],
                       @[@"专家智库",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_ico02.png",@"web?url=http://www.zgzqjh.com/Doctors"],
                        @[@"病友社区",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_ico03.png",@"web?url=http://jk.dhqckb.com/"],
                       @[@"预约挂号",@"http://www.zgzqjh.com/templets/default/wkkx/images/bot_ico01.png",@"web?url=http://www.zgzqjh.com/guaha/register"],
                       @[@"政策公益",@"http://www.zgzqjh.com/templets/default/wkkx/images/bot_ico02.png",@"web?url=http://www.zgzqjh.com/list.aspx?cid=81"],
                       @[@"更多服务",@"http://www.zgzqjh.com/templets/default/wkkx/images/bot_ico03.png",@"web?url=http://www.zgzqjh.com/Product/services"]
                     
                       ];
        _menuArray2=@[
                              @[@"胎儿监护",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_ico07.png"],
                              @[@"血压监护",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_ico08.png"],
                              @[@"糖尿病监护",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_ico10.png"],
                              @[@"老人疾病监护",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_ico09.png"]
                              ];
        
        static NSString *cellIndentifier = @"homecell";
        HomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[HomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier menuArray:_menuArray];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row == 2) {
        
        NSArray *menuArray=@[
                              @[@"胎儿监护",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_ico07.png"],
                              @[@"血压监护",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_ico08.png"],
                              @[@"糖尿病监护",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_ico10.png"],
                              @[@"老人疾病监护",@"http://www.zgzqjh.com/templets/default/wkkx/images/index_ico09.png"]
                              ];
        
        static NSString *cellIndentifier = @"homecell";
        HomeMenu2Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[HomeMenu2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier menuArray:menuArray];
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
    [self gotoViewControllerWithType:index array:_menuArray2];
    // [self performSegueWithIdentifier:@"pushToMovie" sender:nil];
}


#pragma mark - **************** UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



-(void)gotoViewControllerWithType:(int )index array:(NSArray *)array{
    NSLog(@"goto_type:%ld",index);

        //bainuo://web?
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        JZWebViewController *VC = [sb instantiateViewControllerWithIdentifier:@"JZWebViewController"];
        VC.url = [NSString getWebUrl:array[index][2]];
        [self.navigationController pushViewController:VC animated:YES];
    
    
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
