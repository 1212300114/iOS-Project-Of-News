//
//  ColumnListModel.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/25.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import "ColumnListModel.h"

@implementation ColumnListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"cate" : @"CateModel",
             @"banner" : @"BannerModel",
             @"list" : @"BannerModel"
             };
}
@end
