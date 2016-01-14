//
//  HttpUtils.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/16.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpUtils : NSObject

-(void)get: (NSString *)URLString
   success: (void (^)(id json)) success
  failure : (void (^)(NSError *error)) failure;

-(void)get: (NSString *)URLString
     param: (NSDictionary *)params
   success: (void (^)(id json)) success
   failure: (void (^)(NSError *error)) failure;

+(instancetype)shareInstance;

@end
