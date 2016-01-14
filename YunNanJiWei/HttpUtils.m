//  network help class 
//  HttpUtils.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/16.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import "HttpUtils.h"
#import "AFNetworking.h"
@interface HttpUtils()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation HttpUtils

static HttpUtils *sharedInstance;

+ (instancetype)shareInstance{
    if (!sharedInstance) {
        sharedInstance = [[self alloc]init];
    }
    return sharedInstance;
}

- (void) get:(NSString *) URLString
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure
{
    [self get:URLString param:nil success:success failure:failure];
}

- (void) get:(NSString *)URLString
       param:(NSDictionary *)params
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure
{
    [self.manager GET:URLString parameters:params
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   if (success) {
                       success(responseObject);
                   }
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   failure(error);
                   if (failure) {
                       failure(error);
                   }
               }];
}

- (AFHTTPRequestOperationManager *)manager{
    
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    return _manager;
}

@end
