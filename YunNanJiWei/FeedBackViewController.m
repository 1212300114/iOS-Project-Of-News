//
//  FeedBackViewController.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 16/1/13.
//  Copyright © 2016年 GaryJ. All rights reserved.
//

#import "FeedBackViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
@interface FeedBackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

- (void)initView{
    self.inputTextView.delegate = self;
    [self initNavigationItem];
}
- (void)initNavigationItem{
    
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
    
    //    //添加标题栏
    UIImageView* appNameImage = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH/100,SCREEN_WIDTH/17)];
    appNameImage.image        = [UIImage imageNamed:@"feedBackTitle"];
    self.navigationItem.titleView = appNameImage;
    
    
    //初始化显示右侧栏的button
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/10, SCREEN_WIDTH/13)];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitFeedback:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}
- (void)cancleSelected:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitFeedback:(UIButton *)button{
    //只显示文字
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (!self.inputTextView.text.length) {
        hud.mode = MBProgressHUDModeDeterminate;
        hud.labelText = @"请先输入内容";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];
    }else{
        hud.labelText = @"发送成功";
    }
}
- (IBAction)tapToHideKeyBoard:(UITapGestureRecognizer *)sender {
    if ([self.inputTextView isFirstResponder]) {
        [self.inputTextView resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - text view delegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length) {
        self.placeHolderLabel.hidden = YES;
    }else {
        self.placeHolderLabel.hidden = NO;
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

@end
