//
//  InformationDisclosureDetailViewController.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/22.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import "InformationDisclosureDetailViewController.h"

@interface InformationDisclosureDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation InformationDisclosureDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"detail vc loaded!!!");
    // Do any additional setup after loading the view.
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
