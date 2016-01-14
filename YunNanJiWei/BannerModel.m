//
//  BannerModel.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/24.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel
-(NSString *)description{
    return [NSString stringWithFormat:@"content_id:%lu, \nclass_id:%lu, \ntitle:%@, \nimage:%@, \napp_label:%@, \ninfo_link:%@",self.content_id,self.class_id,self.title,self.image,self.app_label,self.info_link];
}

@end
