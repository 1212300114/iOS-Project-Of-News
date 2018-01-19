//
//  InformationDisclosureViewController.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/21.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import "InformationDisclosureViewController.h"
#import "InformationDisclosureDetailViewController.h"
#import "Constants.h"
#import "SlideNavigationController.h"
typedef enum {
    LeaderTag = 1000,
    OrganizationTag = 1001,
    HistoryTag = 1002,
    ProcessTag = 1003
}LabelTag;

@interface InformationDisclosureViewController ()<SlideNavigationControllerDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (strong, nonatomic) UIColor *selectedButtonColor;

@property (strong, nonatomic) UIColor *defaultButtonColor;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) NSURLRequest *webRequest;

@property (nonatomic,assign) NSUInteger currentButtonTag;

@property (strong, nonatomic) InformationDisclosureDetailViewController *leaderVC;

@property (strong, nonatomic) InformationDisclosureDetailViewController *organizationVC;

@property (strong, nonatomic) InformationDisclosureDetailViewController *historyVC;

@property (strong, nonatomic) InformationDisclosureDetailViewController *processVC;

@end

@implementation InformationDisclosureViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIButton *button in self.buttons) {
        [button.layer setBorderColor:[UIColor colorWithRed:0.627 green:0.627 blue:0.627 alpha:1].CGColor];
        [button.layer setBorderWidth:0.5];
        [button.layer setMasksToBounds:YES];

    }
    
    // Do any additional setup after loading the view.
    [self initNavigationItem];
    [self addViewFromViewController];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}
- (void)initNavigationItem{

    // add the title to the navigation item
    UIImageView* appNameImage = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH/15*10,SCREEN_WIDTH*0.0667)];
    appNameImage.image        = [UIImage imageNamed:@"appName"];
    self.navigationItem.titleView = appNameImage;
    
}

-(void)addViewFromViewController{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.leaderVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"InformationDisclosureDetailViewController"];
    self.leaderVC.webRequest = self.webRequest;
    [self.containerView addSubview:self.leaderVC.view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - properties
//make the default value ;
-(NSURLRequest *)webRequest{
    if (!_webRequest) {
        _webRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:LEADER_URL]];
    }
    return _webRequest;
}

-(NSUInteger)currentButtonTag{
    if (!_currentButtonTag) {
        _currentButtonTag = LeaderTag;
    }
    return _currentButtonTag;
}
#pragma mark - action
- (IBAction)titleClicked:(UIButton *)sender {
   
    if (self.currentButtonTag == sender.tag) {
    NSLog(@"returned and current tag = %ld",self.currentButtonTag);
        return;
    }
    self.currentButtonTag = sender.tag;
    NSLog(@"%ld",(long)sender.tag);
    
    for (UIButton *button in self.buttons) {
        button.backgroundColor = [UIColor colorWithRed:0.835 green:0.835 blue:0.835 alpha:1];
        [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    }
    sender.backgroundColor = [UIColor redColor];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    

    switch (sender.tag) {
        case LeaderTag:
            self.webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:LEADER_URL]];
            if (self.leaderVC) {
                NSLog(@"Show from memory");
                [self.containerView bringSubviewToFront:self.leaderVC.view];
            }
            break;
        case OrganizationTag:
            self.webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:ORGANIZATION_URL]];
            if (self.organizationVC) {
               NSLog(@"Show from memory");
                [self.containerView bringSubviewToFront:self.organizationVC.view];
            }else{
                self.organizationVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"InformationDisclosureDetailViewController"];
                self.organizationVC.webRequest = self.webRequest;
                [self.containerView addSubview:self.organizationVC.view];
            }
            break;
        case HistoryTag:
            self.webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:HISTORY_URL]];
            if (self.historyVC) {
                NSLog(@"Show from memory");
                [self.containerView bringSubviewToFront:self.historyVC.view];
            }else{
                self.historyVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"InformationDisclosureDetailViewController"];
                self.historyVC.webRequest = self.webRequest;
                [self.containerView addSubview:self.historyVC.view];
            }
            break;
        case ProcessTag:
            self.webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:PROCESS_URL]];
            if (self.processVC) {
                NSLog(@"Show from memory");
                [self.containerView bringSubviewToFront:self.processVC.view];
            }else{
                self.processVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"InformationDisclosureDetailViewController"];
                self.processVC.webRequest = self.webRequest;
                [self.containerView addSubview:self.processVC.view];
            }
            break;
        default:
            NSLog(@"fuck error may happened in action");
            break;
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
#pragma mark - slide navigation controller delegate
-(BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    return YES;
}

-(BOOL)slideNavigationControllerShouldDisplayRightMenu{
    return YES;
}
@end
