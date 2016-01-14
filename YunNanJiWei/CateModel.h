//
//  CateModel.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/24.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CateModel : NSObject

@property (nonatomic) NSUInteger class_id;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *image;

@property (nonatomic) NSUInteger show_child;

@property (nonatomic,copy) NSString *cate_link;

@end
