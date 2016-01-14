//
//  SearchListModel.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 16/1/4.
//  Copyright © 2016年 GaryJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchListModel : NSObject

@property (strong, nonatomic) NSMutableArray *list;

@property (strong, nonatomic) NSString *next_link;

@property (assign, nonatomic) NSUInteger page;

@property (assign, nonatomic) NSUInteger pagecount;
@end
