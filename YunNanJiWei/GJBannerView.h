//
//  GJBannerView.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/10/22.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GJBannerView;
@protocol GJBannerViewDelegate <NSObject>

@required
//single tap on the banner and jump to a link;
-(void)bannerViewDidSelectedBanner:(GJBannerView*) banner atIndex:(NSUInteger)index;


@end

@interface GJBannerView : UIView

@property (nonatomic,assign) BOOL autoPlay;
@property (nonatomic,strong) NSArray *images; // array of images --- type UIImage
@property (nonatomic,assign) NSTimeInterval interval;
@property (nonatomic,strong) NSArray *titles;// array of titles of image --- type string
@property (nonatomic,weak) id<GJBannerViewDelegate> delegate;// delegate to recognize the gesture;
@property (nonatomic,strong) NSArray *imageUrls;


-(void)setImages:(NSArray*) images
          titles:(NSArray*) titles
        interval:(NSTimeInterval) interval;

@end
