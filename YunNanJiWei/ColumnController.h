//
//  ColumnController.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/10/15.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColumnController : UIViewController

@property (strong,nonatomic) NSString *cateLink;

@property (nonatomic,getter=isSubject) BOOL subject;

@property (nonatomic,getter=isDynamic) BOOL dynamic;

@property (nonatomic,copy) NSString *navigationTitle;
@end
