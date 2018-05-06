//
//  SplashViewController.m
//  FetalMonitor
//
//  Created by hexin on 16/7/5.
//  Copyright © 2016年 soar. All rights reserved.
//

#import "SplashViewController.h"
#import "SDCycleScrollView.h"
#import "NSString+convertImgStr.h"
#import "Public.h"
#import "JianHuJiluTableViewController.h"
#import "StartViewController.h"
#import "AppDelegate.h"
#import "Login2TableViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
  
    // Do any additional setup after loading the view.

    
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults valueForKey:@"loaded"] isEqualToString:@"loaded"]){
        
        [self loadMainPage];
        
    }else{
        [super viewDidLoad];
        [self loadImg];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadImg{
    NSArray *imagesGroup=@[@"splash1.jpg",@"splash2.jpg",@"splash3.jpg",@"splash4.jpg"];    // 本地加载图片的轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, screen_width, screen_height) imageNamesGroup:imagesGroup];
    
    [cycleScrollView2 setAutoScroll:false];
    cycleScrollView2.infiniteLoop = false;
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.currentPageDotColor = [UIColor grayColor]; // 自定义分页控件小圆标颜色

    cycleScrollView2.delegate = self;
    [self.view addSubview:cycleScrollView2];
    

}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@"didSelectItemAtIndex %i",index);
    if(index == 3){
        
        
          [self loadMainPage];
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    NSLog(@"didScrollToIndex %i",index);
    if(index == 3){
        
        [self loadMainPage];
        
    }

}

-(void)loadMainPage
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.first = @"loaded";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"loaded" forKey:@"loaded"];
    [defaults synchronize];

    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    StartViewController * nav = [storyBoard instantiateViewControllerWithIdentifier:@"StartViewController"];
    Login2TableViewController * login2 = [storyBoard instantiateViewControllerWithIdentifier:@"Login2TableViewController"];
    
  //  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if(appDelegate.currentUserId == nil){
      //  [self presentViewController:login2 animated:YES completion:nil];
          [self presentViewController:nav animated:YES completion:nil];
        
    }else{
        [self presentViewController:nav animated:YES completion:nil];
    }
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
