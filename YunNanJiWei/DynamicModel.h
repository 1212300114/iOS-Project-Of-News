//
//  DynamicModel.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/31.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DynamicListModel.h"
@interface DynamicModel : NSObject

@property (strong, nonatomic) DynamicListModel *data;

@property (strong,nonatomic) NSString *msg;

@property (nonatomic) NSInteger ret;

@end
