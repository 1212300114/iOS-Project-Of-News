//
//  GJBannerView.m  --banner of my app it needs some improve for the cache and memory things
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/10/22.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import "GJBannerView.h"
#import "UIImageView+WebCache.h"

#define BANNER_WIDTH self.bounds.size.width
#define BANNER_HEIGHT self.bounds.size.height

@interface GJBannerView ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *scrollView; //the banner's main scroll
@property (nonatomic,weak) UIPageControl *pageControl;//the page control of banner - no user interaction enable
@property (nonatomic,assign) NSUInteger currentPage;// the current index of images
@property (nonatomic,weak) UILabel *titleLable; //the title label of the banner
@property (nonatomic,weak) UIView *placeHolderView;// the place holder view to show when images are not setted ;
@property (nonatomic,strong) NSMutableArray *currentImages;//the current three images to show in the scrol view
@property (nonatomic,strong) NSMutableArray *currentImageUrls;// the current url of images
@end


@implementation GJBannerView
#pragma mark - initialization
-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
//        UIView* placeHolderView = [[UIView alloc]initWithFrame:
//                                        CGRectMake(0, 0, BannerWidth, BannerHeight)];
//        placeHolderView.backgroundColor = [UIColor colorWithRed:244 green:244 blue:244 alpha:1];
        UIImageView *placeHolderView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, BANNER_WIDTH, BANNER_HEIGHT)];
        placeHolderView.image = [UIImage imageNamed:@"defaultImage"];
        [self addSubview:placeHolderView];
        self.placeHolderView = placeHolderView;
    }
    
    return self;
}
#pragma mark - public method
-(void)setImages:(NSArray *)images titles:(NSArray *)titles interval:(NSTimeInterval)interval{

    self.images = images;
    self.titles = titles;
    self.interval = interval;
    _currentPage = 0;
    //add scroll view and page control then remove the place holder view
    [self addScrollView];
    [self addPageControl];
    [self.placeHolderView removeFromSuperview];
}

#pragma mark - properties
-(NSMutableArray *)currentImages{
  
    if (!_currentImages) {
        _currentImages = [NSMutableArray array];
    }
    //get the image
    [_currentImages removeAllObjects];
    NSInteger count = self.images.count;
    int i = (int)(_currentPage + count - 1)%count;
    [_currentImages addObject:self.images[i]];
    [_currentImages addObject:self.images[_currentPage]];
    i = (int)(_currentPage + 1)%count;
    [_currentImages addObject:self.images[i]];
    
    return _currentImages;
}
-(NSMutableArray *)currentImageUrls{
    if (!_currentImageUrls) {
        _currentImageUrls = [NSMutableArray array];
    }
    [_currentImageUrls removeAllObjects];
    NSInteger count = self.imageUrls.count;
    int i = (int)(_currentPage +count -1)%count;
    // get the font one in the recycle array (i made it like recycle) just add a count to the page and get the residual;
    [_currentImageUrls addObject:self.imageUrls[i]];
    [_currentImageUrls addObject:self.imageUrls[_currentPage]];
    //get the behind one in the recycle array ;
    i = (int)(_currentPage +count +1)%count;
    [_currentImageUrls addObject:self.imageUrls[i]];
    
    return _currentImageUrls;
}

#pragma mark - private methods
-(void)addScrollView{
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:
                                CGRectMake(0, 0, BANNER_WIDTH, BANNER_HEIGHT)];
    for (int i = 0; i < 3; i ++) {
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:
                                  CGRectMake(BANNER_WIDTH*i, 0, BANNER_WIDTH, BANNER_HEIGHT)];
        //imageView.image = self.currentImages[i];
        //set the image of these images
        [imageView sd_setImageWithURL:self.currentImageUrls[i]
                     placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        [scrollView addSubview:imageView];
    }
    [scrollView setContentSize:CGSizeMake(BANNER_WIDTH*3, BANNER_HEIGHT)];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setPagingEnabled:YES];
    [scrollView setContentOffset :CGPointMake(BANNER_WIDTH, 0) ];
    scrollView.delegate = self;
    //to recognize the gesture for the scrollView
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
    [scrollView addGestureRecognizer:tap];
    
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
}

-(void)singleTapped:(UIGestureRecognizer*) recognizer{
    
    if ([self.delegate respondsToSelector:@selector(bannerViewDidSelectedBanner:atIndex:)]) {
        [self.delegate bannerViewDidSelectedBanner:self atIndex :_currentPage];
    }
}


-(void)addPageControl{
    UIView* backGroud = [[UIView alloc]initWithFrame:
                         CGRectMake(0,BANNER_HEIGHT-40, BANNER_WIDTH,40)];
    
    [backGroud setBackgroundColor:
     [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
  
    UIPageControl* pageControl = [[UIPageControl alloc]initWithFrame:
                                  CGRectMake(BANNER_WIDTH*0.8, 10, BANNER_WIDTH/5, 30)];
    [pageControl setNumberOfPages:self.imageUrls.count];
    [pageControl setCurrentPage:0];
    [pageControl setUserInteractionEnabled:NO];
    [pageControl setCurrentPageIndicatorTintColor:
     [UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    [pageControl setPageIndicatorTintColor:
     [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1]];
    [backGroud addSubview:pageControl];
    self.pageControl = pageControl;

    UILabel* titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, BANNER_WIDTH*0.75, 40)];
    titleLable.text = _titles[0];
    titleLable.numberOfLines = 1;
    [backGroud addSubview:titleLable];
    titleLable.textColor = [UIColor whiteColor];
    self.titleLable = titleLable;
    
    [self addSubview:backGroud];
}


#pragma mark - scroll view delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
//    NSLog(@"%f",x/BANNER_WIDTH);
    if (x >= BANNER_WIDTH*2) {
//        _currentPage = (++_currentPage)%_images.count;
        _currentPage = (++_currentPage)%_imageUrls.count;
        self.pageControl.currentPage = _currentPage;
        [self refreshImages];
    }
    if (x <= 0) {
//        _currentPage = (int)(_currentPage + self.images.count - 1)%self.images.count;
        _currentPage = (int)(_currentPage + self.imageUrls.count -1)%self.imageUrls.count;
        self.pageControl.currentPage = _currentPage;
        [self refreshImages];
    }
     self.titleLable.text = _titles[_currentPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
}


//刷新scrollView里面的三个imageView 里面的图片---使用currentImages-
-(void)refreshImages{

    [self.placeHolderView removeFromSuperview];
    NSArray *subViews = self.scrollView.subviews;
    for (int i = 0; i < subViews.count; i++) {
        
        UIImageView* imageView = (UIImageView *)subViews[i];
//        imageView.image = [UIImage imageNamed:self.currentImages[i]];
//        imageView.image = [UIImage imageNamed:@"defaultImage"];
//        imageView.image = self.currentImages[i];
        [imageView sd_setImageWithURL:self.currentImageUrls[i] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        
    }
    [self.scrollView setContentOffset:CGPointMake(BANNER_WIDTH, 0)];

}

@end
