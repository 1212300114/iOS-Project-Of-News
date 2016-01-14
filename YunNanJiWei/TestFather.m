//
//  TestFather.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/22.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import "TestFather.h"

@implementation TestFather

-(instancetype)init{
    self = [super init];
    [self testMethod];
    return self;
}
-(void)testMethod{
    NSLog(@"father method called");
}
@end
