//
//  GJRightMenuCOntroller.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/10/13.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import "GJRightMenuCOntroller.h"
#import "SearchViewController.h"
#import "SlideNavigationController.h"
#import "Constants.h"
@interface GJRightMenuController ()

@end

@implementation GJRightMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma tableView dataSource
//tableview的dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: [NSString stringWithFormat: @"%ld", (long)indexPath.row]];
    return cell;
}
//列表列数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
//section数 其实默认是1
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
#pragma mark - table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Select at index%ld",(long)indexPath.row);
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *destionationVieController = nil;
    switch (indexPath.row) {
        case 0:
            destionationVieController = [mainSB instantiateViewControllerWithIdentifier:@"SearchViewController"];
            break;
        case 1:
            destionationVieController = [mainSB instantiateViewControllerWithIdentifier:@"CollectionViewController"];
            break;
        case 2:
            destionationVieController = [mainSB instantiateViewControllerWithIdentifier:@"SettingViewController"];
        default:
            break;
    }
    if (destionationVieController) {
        [[SlideNavigationController sharedInstance]pushViewController:destionationVieController animated:YES];
    }
    
}
//初始化列表;
-(void)initView{
    
    _table.dataSource = self;
    _table.delegate   = self;
    
}




@end
