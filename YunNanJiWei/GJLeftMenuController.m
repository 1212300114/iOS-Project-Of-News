//  left menu view controller
//  GJLeftMenuController.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/10/14.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import "GJLeftMenuController.h"
#import "Constants.h"
#import "SlideNavigationController.h"
#import "AppDelegate.h"
#import "InformationDisclosureViewController.h"
#import "InformationDisclosureDetailViewController.h"
@interface GJLeftMenuController ()

@end

@implementation GJLeftMenuController
#pragma mark - initialization



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)initView{
    _table.dataSource = self;
    _table.delegate   = self;
    
}

#pragma mark - table view data source;
//this is not good i should improve these codes
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:
                              [NSString stringWithFormat: @"%ld", (long)indexPath.row]];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

#pragma mark - table view delegate;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *destinationViewController = nil;
    AppDelegate *myAppDelegate = [UIApplication sharedApplication].delegate;
    //all left side view controllers are register in appdelegate for reuse;
    switch (indexPath.row) {
        case 0:
            if (myAppDelegate) {
                destinationViewController = myAppDelegate.pageController;
            }
            break;
        case 1:
            if (myAppDelegate) {
                destinationViewController = myAppDelegate.informationDisclosureViewController;
            }
            if (!destinationViewController) {
                NSLog(@"get vc by creating a new one");
                destinationViewController = [mainSB instantiateViewControllerWithIdentifier:@"InformationDisclosureViewController"];
                myAppDelegate.informationDisclosureViewController = (InformationDisclosureViewController*)destinationViewController;
            }
            break;
        case 2:
            destinationViewController = [mainSB instantiateViewControllerWithIdentifier:@"StateDynamicViewController"];
            
            
            break;
        case 3:
            if (myAppDelegate) {
                destinationViewController = myAppDelegate.disciplineRegulationsTableViewController;
            }
            if (!destinationViewController) {
                destinationViewController = [mainSB instantiateViewControllerWithIdentifier:@"DisciplineRegulationsTableViewController"];
                myAppDelegate.disciplineRegulationsTableViewController  = (DisciplineRegulationsTableViewController *)destinationViewController;
            }
            break;
        case 4:
            if (myAppDelegate) {
                destinationViewController = myAppDelegate.aboutUsWebViewController ;
            }
            if (!destinationViewController) {
                destinationViewController = [mainSB instantiateViewControllerWithIdentifier:@"InformationDisclosureDetailViewController"];
                if ([destinationViewController isKindOfClass:[InformationDisclosureDetailViewController class]]) {

                    [((InformationDisclosureDetailViewController *)destinationViewController) setAboutUsWebRequest];
                    ((InformationDisclosureDetailViewController *)destinationViewController).aboutUs = true;
                }
            }
        default:
            break;
    }
//    pop to all vc these should benifit the memory
    if (destinationViewController) {
        [[SlideNavigationController sharedInstance]popAllAndSwitchToViewController:destinationViewController
                                                             withSlideOutAnimation:NO
                                                                     andCompletion:nil];
    }
//            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:destinationViewController
//                                                             withSlideOutAnimation:NO
//                                                                     andCompletion:nil];

}


@end
