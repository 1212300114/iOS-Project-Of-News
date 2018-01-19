//
//  AppDelegate.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/10/12.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import "AppDelegate.h"
#import "GJLeftMenuController.h"
#import "GJRightMenuCOntroller.h"
#import "SlideNavigationContorllerAnimator.h"
#import "ColumnController.h"
#import "Constants.h"
#import "HttpUtils.h"
#import "PlaceHolderVC.h"
@interface AppDelegate ()

@property (strong,nonatomic) NSArray *columnNames;//array of names - string type;
@property (strong,nonatomic) NSArray *columnLinks;//array of links - string type

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    UIStoryboard *mainStoryboard = [UIStoryboard
                                    storyboardWithName:@"Main"
                                    bundle: nil];

    SlideNavigationController* navigation = [[SlideNavigationController alloc]init];
    navigation.interactivePopGestureRecognizer.enabled = YES;
    navigation.view.backgroundColor = [UIColor whiteColor];
    PlaceHolderVC *placeHoldVC = [[PlaceHolderVC alloc]init];
    navigation.viewControllers = @[placeHoldVC];

    __weak AppDelegate *weakSelf = self;
    [[HttpUtils shareInstance]get:COLUMN_INDICATOR_URL
                            param:nil
                          success:^(id json)
     {
         if ([json isKindOfClass:[NSDictionary class]]) {
             weakSelf.columnLinks = [json valueForKeyPath:@"data.cate.cate_link"];
             weakSelf.columnNames = [json valueForKeyPath:@"data.cate.name"];
             WMPageController* pageController = [[WMPageController
                                                  alloc]initWithViewControllerClasses:weakSelf.columnNames andTheirTitles:weakSelf.columnNames];
             //    GJMainUIViewController *pageController = [[GJMainUIViewController alloc]init];
             pageController.menuViewStyle = WMMenuViewStyleLine;
             pageController.menuItemWidth = 66;
             pageController.postNotification = YES;
             pageController.menuHeight = 40;
             pageController.columnLinks = weakSelf.columnLinks;
//             navigation.viewControllers = @[pageController]
             self.pageController = pageController;
             [navigation popToRootAndSwitchToViewController:pageController withSlideOutAnimation:NO andCompletion:nil];
             NSLog(@"%@",weakSelf.columnNames);
                      }
     }
                          failure:^(NSError *error) {
                              NSLog(@"%@",error);
                          }];
    // 初始化显示左侧栏的button
    UIButton* leftButton                  = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame                      = CGRectMake(0, 0, SCREEN_WIDTH/13, SCREEN_WIDTH/13);
    [leftButton addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:
                          @"leftButtonNomal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:
                          @"leftButtonPressed"] forState:UIControlStateHighlighted];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView: leftButton];
    [SlideNavigationController sharedInstance].leftBarButtonItem = leftItem;
    
    
    
    //初始化显示右侧栏的button
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/13, SCREEN_WIDTH/13)];
    [button setImage:[UIImage imageNamed:@"rightButtonNomal"]
            forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"rightButtonPressed"]
            forState:UIControlStateHighlighted];
    [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleRightMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [SlideNavigationController sharedInstance].rightBarButtonItem = rightBarButtonItem;
    
    
    
    //初始化导航栏的标题
    UIImageView* appNameImage = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(SCREEN_WIDTH/6, 10,
                                                          SCREEN_WIDTH/15*10,SCREEN_WIDTH/15)];
    appNameImage.image        = [UIImage imageNamed:@"appName"];
    appNameImage.tag = 10001;
//    [SlideNavigationController sharedInstance].navigationItem.titleView = appNameImage;
//    [[SlideNavigationController sharedInstance].navigationBar addSubview:appNameImage];
    
    //添加两侧的menu
    GJLeftMenuController  *leftMenu  = [mainStoryboard instantiateViewControllerWithIdentifier:@"GJLeftMenuController"];
    GJRightMenuController *rightMenu = [mainStoryboard instantiateViewControllerWithIdentifier:@"GJRightMenuCOntroller"];
    [SlideNavigationController sharedInstance].rightMenu = rightMenu;
    [SlideNavigationController sharedInstance].leftMenu  = leftMenu;
    
    //设置侧边栏出现的时候主视图显示部分宽度
    [SlideNavigationController sharedInstance].landscapeSlideOffset = 100;
    [SlideNavigationController sharedInstance].portraitSlideOffset  = 100;
    //设置主视图
    
    self.window.rootViewController = navigation;
    [self.window setBackgroundColor:[UIColor colorWithRed:244 green:244 blue:244 alpha:1]];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)initColumns{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
