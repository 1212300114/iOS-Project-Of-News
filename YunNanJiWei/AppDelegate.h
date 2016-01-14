//
//  AppDelegate.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/10/12.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPageController.h"
#import "InformationDisclosureViewController.h"
#import "DisciplineRegulationsTableViewController.h"
#import "InformationDisclosureDetailViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//register left view controllers on appdelegate for reuse;
@property (strong, nonatomic) WMPageController *pageController;//the first page

@property (strong, nonatomic) InformationDisclosureViewController *informationDisclosureViewController;

@property (strong, nonatomic) DisciplineRegulationsTableViewController *disciplineRegulationsTableViewController;

@property (strong, nonatomic) InformationDisclosureDetailViewController *aboutUsWebViewController;
@end

