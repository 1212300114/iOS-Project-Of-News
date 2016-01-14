//
//  ColumnListModel.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/25.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColumnListModel : NSObject

@property (strong, nonatomic) NSMutableArray *cate;//to handle the cate data;

@property (strong, nonatomic) NSMutableArray *banner;//to handle the banner data

@property (strong, nonatomic) NSMutableArray *list;// to handle the list data;

@property (nonatomic) NSUInteger page;

@property (strong, nonatomic) NSString *next_link;

@property (nonatomic) NSUInteger pagecount;

@end
