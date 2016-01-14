//
//  CollectionModel.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 16/1/12.
//  Copyright © 2016年 GaryJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionListModel.h"
@interface CollectionModel : NSObject

@property (strong, nonatomic) CollectionListModel *data;

@property (strong, nonatomic) NSString *msg;

@property (assign, nonatomic) NSInteger ret;

@end
