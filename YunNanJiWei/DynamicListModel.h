//
//  DynamicListModel.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/31.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicListModel : NSObject

@property (nonatomic, strong) NSString *cate_name;

@property (nonatomic, strong) NSString *next_link;

@property (nonatomic) NSInteger pagecount;

@property (nonatomic) NSInteger page;

@property (nonatomic, strong) NSMutableArray *banner;

@property (nonatomic, strong) NSMutableArray *list;

@end
