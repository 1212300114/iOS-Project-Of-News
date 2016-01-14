//
//  GJRightMenuCOntroller.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/10/13.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJRightMenuController : UIViewController<UITableViewDataSource,UITableViewDelegate>


//列表以及顶部图片
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
