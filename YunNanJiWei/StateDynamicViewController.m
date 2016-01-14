//
//  StateDynamicViewController.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/31.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import "StateDynamicViewController.h"
#import "HttpUtils.h"
#import "Constants.h"
#import "ColumnController.h"
#import "SlideNavigationController.h"


@interface StateDynamicViewController ()<SlideNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong, nonatomic) NSArray *columnNames;// array of column names --- type string;

@property (strong, nonatomic) NSArray *columnLinks;// array of column links --- type string;

@end

@implementation StateDynamicViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationItem];
    [self initScrollView];
    [self requestData];
}

- (void)initScrollView{
    
    self.scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width, self.view.frame.size.height);

}
- (void)initNavigationItem{
    
    // add the title to the navigation item
    UIImageView* appNameImage = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH/15*10,SCREEN_WIDTH*0.0667)];
    appNameImage.image        = [UIImage imageNamed:@"appName"];
    self.navigationItem.titleView = appNameImage;
    
}

- (void)requestData{
    [[HttpUtils shareInstance]get:STATE_DYNAMIC_COLUMN_URL param:nil success:^(id json) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            NSArray *columnNames = [json valueForKeyPath:@"data.cate.name"];
            NSArray *columnLinks = [json valueForKeyPath:@"data.cate.cate_link"];
            self.columnNames = columnNames;
            self.columnLinks = columnLinks;
            [self addButtonsToScrollView];
        }
    } failure:^(NSError *error) {
        NSLog(@"data get error");
        [self showNodataView];
    }];
}
- (void)showNodataView{
}

- (void)addButtonsToScrollView{
    NSLog(@"%lu",self.columnNames.count);
    for (int i = 0; i < self.columnNames.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        int y = (int)i/2;
        int x = (int)i%2;
        button.frame = CGRectMake( x * self.scrollview.frame.size.width / 2, y * self.scrollview.frame.size.width/ 2 *0.453, self.scrollview.frame.size.width/2, self.scrollview.frame.size.width/2*0.453);
        [button setTitle:self.columnNames[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.layer setBorderColor:[UIColor grayColor].CGColor];
        [button.layer setBorderWidth:0.5];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollview addSubview:button];
   
    }
    
}

-(void)buttonClicked:(UIButton *)button{
    NSInteger index = button.tag;
    NSLog(@"name : %@ and link : %@",self.columnNames[index],self.columnLinks[index]);
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ColumnController *dynamicListController = [mainSb instantiateViewControllerWithIdentifier:@"ColumnController"];
    [dynamicListController setNavigationTitle:self.columnNames[index]];
    [dynamicListController setDynamic:YES];
    [dynamicListController setCateLink:self.columnLinks[index]];
    [[SlideNavigationController sharedInstance]pushViewController:dynamicListController animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - slide navigation controller delegate;
-(BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    return YES;
}

-(BOOL)slideNavigationControllerShouldDisplayRightMenu{
    return YES;
}

@end
