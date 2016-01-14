//
//  GJLeftMenuController.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/10/14.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJLeftMenuController : UIViewController<UITableViewDataSource,UITableViewDelegate>
//logo 背景图片  列表
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
