//
//  SettingViewController.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 16/1/13.
//  Copyright © 2016年 GaryJ. All rights reserved.
//

#import "SettingViewController.h"
#import "UIImageView+WebCache.h"
#import "FeedBackViewController.h"
#import "SlideNavigationController.h"
#import "Constants.h"
@interface SettingViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UIView *clearCacheView;
@property (weak, nonatomic) IBOutlet UIView *feedBackView;

@end

@implementation SettingViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getImageCacheSize];
    // Do any additional setup after loading the view.
    [self initNavigationItem];
}

- (void)initNavigationItem{
    UIImageView* appNameImage = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH/100,SCREEN_WIDTH/17)];
    appNameImage.image        = [UIImage imageNamed:@"settingTitle"];
    self.navigationItem.titleView = appNameImage;
}
- (void)getImageCacheSize{
    
    NSInteger cacheSize = [[SDImageCache sharedImageCache]getSize];
    self.cacheLabel.text = [NSString stringWithFormat:@"%.2fM",(float)cacheSize/1024/1024];
    NSLog(@"cacheSize:%lu",cacheSize);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (IBAction)clearAction:(UITapGestureRecognizer *)sender {
    [self showAlert];
    NSLog(@"clear!");
}

- (void)showAlert{
    //初始化AlertView
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AlertViewTest"
                                                    message:@"message"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    //设置标题与信息，通常在使用frame初始化AlertView时使用
    alert.title = @"清理数据";
    alert.message = @"你是否要清楚当前的缓存？";

    //这个属性继承自UIView，当一个视图中有多个AlertView时，可以用这个属性来区分
    alert.tag = 0;
    //只读属性，看AlertView是否可见
    NSLog(@"%d",alert.visible);
    //通过给定标题添加按钮
//    [alert addButtonWithTitle:@"addButton"];
    [alert show];
}

- (IBAction)feedBackAction:(UITapGestureRecognizer *)sender {
    NSLog(@"feedBack!");
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FeedBackViewController *feedBackViewController = [mainSb instantiateViewControllerWithIdentifier:@"FeedBackViewController"];
    [[SlideNavigationController sharedInstance] pushViewController:feedBackViewController animated:YES];
}

- (IBAction)clearCacheAction:(UIButton *)sender {
    switch (sender.tag) {
        case 2:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
    
}
#pragma mark - alert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"index:%lu",buttonIndex);
    if (buttonIndex) {
        [[SDImageCache sharedImageCache]clearDisk];
        [self getImageCacheSize];
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
