//
//  SearchModel.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 16/1/4.
//  Copyright © 2016年 GaryJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchListModel.h"
@interface SearchModel : NSObject

@property (strong, nonatomic) SearchListModel *data;

@property (strong, nonatomic) NSString *msg;

@property (assign, nonatomic) NSInteger ret;

@end
