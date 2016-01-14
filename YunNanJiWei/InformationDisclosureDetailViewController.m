//
//  InformationDisclosureDetailViewController.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/22.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import "SlideNavigationController.h"
#import "InformationDisclosureDetailViewController.h"
#import "Constants.h"

@interface InformationDisclosureDetailViewController ()<UIWebViewDelegate,SlideNavigationControllerDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *collectionItem;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (nonatomic, getter=isCollected) BOOL collected;
@end

@implementation InformationDisclosureDetailViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.isDetail) {
        [self initNavigationItem];
    }else{
    
    }
    [self checkCollection];
    // Do any additional setup after loading the view.
    self.webView.delegate = self;
    if (self.webRequest) {
        [self.webView loadRequest:self.webRequest];
    }
    self.spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.hidesWhenStopped = YES;
    self.spinner.color = [UIColor grayColor];
 
    if (self.isDetail||self.isAboutUs) {
        self.spinner.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    }else{
        self.spinner.center = CGPointMake(SCREEN_WIDTH/2,
                                          (SCREEN_HEIGHT*0.8)/2);
    }
    self.spinner.bounds = CGRectMake(0, 0, 80, 80);
    [self.spinner startAnimating];
    [self.view addSubview:self.spinner];
    
}

- (void)initNavigationItem{
    
    // add the title to the navigation item
    UIImageView* appNameImage = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH/15*10,SCREEN_WIDTH*0.0667)];
    appNameImage.image        = [UIImage imageNamed:@"appName"];
    self.navigationItem.titleView = appNameImage;
    //初始化显示右侧栏的button
    if (self.isAboutUs) {
        UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/13, SCREEN_WIDTH/13)];
        [button setImage:[UIImage imageNamed:@"rightButtonNomal"]
                forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"rightButtonPressed"]
                forState:UIControlStateHighlighted];
        [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleRightMenu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItems = @[rightBarButtonItem];
    }
}

- (void)checkCollection{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *collections = [defaults objectForKey:COLLECTION_KEY];
//    self.collected = [collections containsObject:self.contentID];
    for (NSDictionary *dic in collections) {
        if (dic) {
            NSNumber *temp = [dic objectForKey:@"contentID"];
            if (temp) {
                if ([temp isEqual:self.contentID]) {
                    self.collected = YES;
                }
            }
        }
    }
    NSLog(@"%@---%@",self.contentID,collections);
    if (self.collected) {
        self.collectionButton.selected = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - public method
// set the request value by call perfrom selector method
- (void)setAboutUsWebRequest{
    self.webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:ABOUT_US_URL]];
}

#pragma mark - webView delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if (self.spinner) {
        [self.spinner stopAnimating];
        [self.spinner removeFromSuperview];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - slide navigation delegate
-(BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    if (self.isDetail) {
        return NO;
    }
    return YES;
}

-(BOOL)slideNavigationControllerShouldDisplayRightMenu{
    if (self.isDetail) {
        return NO;
    }
    return YES;
}

- (IBAction)backClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
            sender.selected = !sender.selected;
            [self configCollection];
            break;
        case 2:
            break;
        default:
            break;
    }
}

- (void)configCollection{
    NSLog(@"config");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *collections = [defaults objectForKey:COLLECTION_KEY];
    NSMutableArray *mutableCollections = [NSMutableArray arrayWithArray:collections];
    NSString *currentTime = [self getCurrentTime];
    NSDictionary *collectionContents = @{@"contentID":self.contentID,
                                         @"time":currentTime};
    if (self.collected) {
        for (NSDictionary *dic in collections) {
            if (dic) {
                if ([[dic objectForKey:@"contentID"] isEqualToNumber:self.contentID]) {
                    [mutableCollections removeObject:dic];
                }
            }
        }
    }else{
        [mutableCollections addObject:collectionContents];
    }
    self.collected = !self.collected;
    [defaults setObject:mutableCollections forKey:COLLECTION_KEY];
}

- (NSString *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

@end
