//
//  PlaceHolderVC.m ----this class is writen for the placeholder of the navigation
//  and implements the delegate protocol to show the menu of the slide navigation
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/19.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import "PlaceHolderVC.h"
#import "SlideNavigationController.h"
#import "Constants.h"
@interface PlaceHolderVC ()<SlideNavigationControllerDelegate>

@end

@implementation PlaceHolderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]init];
    spinner.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    spinner.bounds = CGRectMake(0, 0 , 200, 200);
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    spinner.color = [UIColor lightGrayColor];
    [spinner startAnimating ];
    [self.view addSubview:spinner];
     // Do any additional setup after loading the view.
    [self initNavigationItem];

}

- (void)initNavigationItem{
    UIImageView* appNameImage = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(0, 0,
                                                          SCREEN_WIDTH/15*10,SCREEN_WIDTH*0.0667)];
    appNameImage.image        = [UIImage imageNamed:@"appName"];
    self.navigationItem.titleView = appNameImage;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu{
    return YES;
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    return YES;
}
@end
