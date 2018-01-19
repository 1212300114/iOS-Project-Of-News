//
//  SearchViewController.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/11/19.
//  Copyright © 2015年 GaryJ. All rights reserved.
//
#import "Constants.h"
#import "SearchViewController.h"
#import "HttpUtils.h"
#import "SlideNavigationController.h"
#import "SearchModel.h"




@interface SearchViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UITextField *searchInputTextField;
@property (weak, nonatomic) IBOutlet UIView *containerView;// to handle the table views
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) NSString *searchInputString;
@end

@implementation SearchViewController
#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchView.layer.borderWidth = 0.5;
    self.searchView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cancleButton.layer.borderWidth = 0.5;
    self.cancleButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.searchInputTextField.delegate = self;
    self.tapGesture.delegate = self;
//    self.containerView.backgroundColor = [UIColor redColor];
    [self initNavigationItem];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(hideKeyboard) name:SEARCH_HISTORY_LIST_CLICKED_NOTIFICATION object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:SEARCH_HISTORY_LIST_CLICKED_NOTIFICATION object:nil];
}

- (void)initNavigationItem
{

    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/12, SCREEN_WIDTH/12);
    [leftButton addTarget:self action:@selector(cancleSelected:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:
                          @"backNormal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:
                          @"backSelected"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView: leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIView *palceHolderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/12, SCREEN_WIDTH/12)];
    palceHolderView.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:palceHolderView];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.title = @"Search";
//    self.navigationItem.rightBarButtonItem = leftItem;
//    self.navigationItem.backBarButtonItem = leftItem;
//    //添加标题栏
//    UIImageView* appNameImage = [[UIImageView alloc]
//                                 initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH*0.2,SCREEN_WIDTH*0.07)];
//    appNameImage.image        = [UIImage imageNamed:@"appName"];
//    self.navigationItem.titleView = appNameImage;
    
}

- (void)hideKeyboard
{
    if ([self.searchInputTextField isFirstResponder]){
        [self.searchInputTextField resignFirstResponder];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - properties 
//return the text of textfield;
- (NSString *)searchInputString
{
    return self.searchInputTextField ? self.searchInputTextField.text : @"";
}


#pragma mark - action
- (IBAction)cancleSelected:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clearSelected:(UIButton *)sender
{
    self.searchInputTextField.text = @"";
}

- (IBAction)cancleEditGesture:(UITapGestureRecognizer *)sender
{
    NSLog(@"tap gesture recognized");
    if ([self.searchInputTextField isFirstResponder])
    {
        [self.searchInputTextField resignFirstResponder];
    }
}


#pragma mark - textfield delegate;
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchInputTextField resignFirstResponder];
    [self startSearch];
    [self recordInput];
    return  YES;
}

- (void)recordInput
{
    NSString *inputString = self.searchInputTextField.text;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *history =  [userDefaults objectForKey:SEARCH_HISTORY_KEY];
    inputString = [inputString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (!history)
    {
        history = [NSMutableArray array];
    }
    else
    {
        history = [[NSMutableArray alloc]initWithArray:history];
    }
    if ([history containsObject:inputString])
    {
        [history removeObject:inputString];
    }

    [history addObject:inputString];
    [userDefaults setObject:history forKey:SEARCH_HISTORY_KEY];

}

- (void)startSearch
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:SEARCH_INPUT_NOTIFICATION object:self.searchInputString];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"it's time for write!!!");
}
#pragma mark - gesture delegate;
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{

    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]||[NSStringFromClass(touch.view.class) isEqualToString:@"UITableViewLabel"]) {
        return NO;
    }
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
}

@end
