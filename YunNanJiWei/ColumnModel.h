//
//  ColumnModel.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/25.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColumnListModel.h"
@interface ColumnModel : NSObject

@property (strong, nonatomic) ColumnListModel *data;

@property (copy, nonatomic) NSString *msg;

@property (nonatomic) NSUInteger ret;

@end
