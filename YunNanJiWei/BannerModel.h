//
//  BannerModel.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/24.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject
@property (nonatomic) NSUInteger content_id;
@property (nonatomic) NSUInteger class_id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *app_label;
@property (nonatomic,copy) NSString *info_link;

@end
