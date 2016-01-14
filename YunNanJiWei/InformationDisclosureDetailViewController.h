//
//  InformationDisclosureDetailViewController.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/22.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationDisclosureDetailViewController : UIViewController
//详情地址
@property (strong, nonatomic) NSURLRequest *webRequest;
//是否为详情
@property (nonatomic, getter=isDetail) BOOL detail;
//是否为关于我们
@property (nonatomic, getter=isAboutUs) BOOL aboutUs;
//详情的Id
@property (assign, nonatomic) NSNumber *contentID;
//调用方法设置详情地址为关于我们的地址
-(void)setAboutUsWebRequest;

@end
