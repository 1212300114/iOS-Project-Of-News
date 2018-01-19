//
//  TestModalViewController.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 16/2/29.
//  Copyright © 2016年 GaryJ. All rights reserved.
//

#import "TestModalViewController.h"

@interface TestModalViewController ()

@end

@implementation TestModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 300, 40)];
    label.text = @"hey guys i want fuck you!";
    [self.view addSubview: label];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 300, 400)];
    [button setTitle:@"heiheihei" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpOutside];
    // Do any additional setup after loading the view.
}
- (void)clickEvent:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"heiheiheo");
    }];
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
