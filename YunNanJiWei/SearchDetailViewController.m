//
//  SearchDetailViewController.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 16/1/4.
//  Copyright © 2016年 GaryJ. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "ColumnTableViewCell.h"
#import "InformationDisclosureDetailViewController.h"

#import "SearchModel.h"
#import "BannerModel.h"

#import "Constants.h"
#import "HttpUtils.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"


@interface SearchDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (strong, nonatomic) NSString *requestUrl;

@property (strong, nonatomic) NSMutableArray *listModels;

@property (assign, nonatomic) NSUInteger currentPage;

@property (assign, nonatomic) NSUInteger pageCount;

@property (strong, nonatomic) NSMutableArray *history;

@property (strong, nonatomic) UIButton *clearButton;


@end

@implementation SearchDetailViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSearchHistory];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.hidden = YES;
    self.historyTableView.dataSource = self;
    self.historyTableView.delegate = self;
//    self.historyTableView.alpha = 0;
    self.historyTableView.tableFooterView = self.clearButton;
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(logNotification:) name:SEARCH_INPUT_NOTIFICATION object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];

    // Do any additional setup after loading the view.
    [self initPullDownToGetNewData];
    [self initPullUpToGetMoreData];
}
//remove observer when view disapper;
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:SEARCH_INPUT_NOTIFICATION object:nil];
    [defaultCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];

}

- (void)keyboardWillShow{
    NSLog(@"keyboard showed!!");
    self.searchTableView.hidden = YES;
    self.historyTableView.hidden = NO;
//    [UIView animateWithDuration:2.0 animations:^{
//        self.historyTableView.alpha = 1;
//    } completion:^(BOOL finished) {
//        
//    }];
    [self.listModels removeAllObjects];
    [self.searchTableView reloadData];
    self.errorLabel.hidden = YES;
    [self getSearchHistory];
    [self.historyTableView reloadData];
    if (self.history.count) {
        [self.clearButton setTitle:@"清除搜索记录" forState:UIControlStateNormal];
        self.clearButton.userInteractionEnabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initPullDownToGetNewData{
    self.searchTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNewData)];
}
- (void)requestNewData{
    self.currentPage = 1;
    [self.searchTableView.mj_footer resetNoMoreData];
    if (self.requestUrl) {
        [[HttpUtils shareInstance]get:self.requestUrl success:^(id json) {
            if (json) {
                [self parseDataFromDicToModel:json isRefresh:YES];
            }
        } failure:^(NSError *error) {
            NSLog(@"error");
            [self.searchTableView.mj_header endRefreshing];
            [self showError];
        }];
    }
}
- (void)showError{

    self.searchTableView.hidden = YES;
    self.errorLabel.hidden = NO;
}
- (void)initPullUpToGetMoreData{
    self.searchTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData) ];

}

- (void)requestMoreData{
    self.currentPage ++;
    if (self.currentPage > self.pageCount) {
        [self.searchTableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    if (self.requestUrl) {
        NSString *currentUrl = [NSString stringWithFormat:@"%@&page=%lu",self.requestUrl,self.currentPage];
        NSLog(@"%@",currentUrl);
        [[HttpUtils shareInstance]get:currentUrl success:^(id json) {
            if (json) {
                [self parseDataFromDicToModel:json isRefresh:NO];
            }
        }failure:^(NSError *error) {
            NSLog(@"error");
        }];
    }
}

- (void)parseDataFromDicToModel:(id)json isRefresh:(BOOL)isRefresh{
    if ([json isKindOfClass:[NSDictionary class]]) {
        SearchModel *searchModel = [SearchModel mj_objectWithKeyValues:json];
        if (searchModel) {
            if (isRefresh) {
                self.listModels = searchModel.data.list;
                [self.searchTableView.mj_header endRefreshing];
                self.pageCount = searchModel.data.pagecount;
            }else{
                [self.listModels addObjectsFromArray:searchModel.data.list];
                [self.searchTableView reloadData];
                [self.searchTableView.mj_footer endRefreshing];
            }
        }
    }

}
- (void)getSearchHistory{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *history = [userDefaults objectForKey:SEARCH_HISTORY_KEY];
    NSLog(@"%@",history);
    for (NSString *tempString in history) {
        NSString *encodedString = [tempString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (![self.history containsObject:encodedString]) {
            [self.history addObject:encodedString];
        }
    }
    for (NSString *showString in self.history) {
        NSLog(@"%@",showString);
    }
    if (!self.history.count) {
        [self.clearButton setTitle:@"暂无搜索记录" forState:UIControlStateNormal];
    }
   
}

- (void)logNotification:(NSNotification *)notification {
    if ([notification object]) {
        if ([[notification object] isKindOfClass:[NSString class]]) {

            NSString *string = [notification object];
            [self encodeUrlAndStartRefreshWithString:string];
        }
    }
    
}

- (void)encodeUrlAndStartRefreshWithString:(NSString *)string{
    NSString *requestUrl = [SEARCH_URL stringByAppendingString:string];
    self.requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.listModels removeAllObjects];
    [self.searchTableView reloadData];
    self.searchTableView.hidden = NO;
    self.historyTableView.hidden = YES;
    [self.searchTableView.mj_header beginRefreshing];
  

}
#pragma mark - properties
- (void)setListModels:(NSMutableArray *)listModels{
    _listModels  = listModels;
    [self.searchTableView reloadData];
}

- (NSUInteger)currentPage{
    if (!_currentPage) {
        _currentPage = 1;
    }
    return _currentPage;
}

- (NSMutableArray *)history{
    if (!_history) {
        _history = [NSMutableArray array];
    }
    return _history;
}

- (UIButton *)clearButton{
    if (!_clearButton) {
        _clearButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-5, 40)];
        [_clearButton addTarget:self action:@selector(clearClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_clearButton setBackgroundColor:[UIColor clearColor]];
        [_clearButton setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [_clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-5, 0.5)];
        topLine.backgroundColor = [UIColor lightGrayColor];
        [_clearButton addSubview:topLine];
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(5, 39.5, SCREEN_WIDTH-5, 0.5)];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [_clearButton addSubview:bottomLine];
        
    }
    return _clearButton;
}
- (void)clearClicked:(UIButton *)button{
    if (self.history.count) {
        [self.history removeAllObjects];
        [self.historyTableView reloadData];
        [button setTitle:@"暂无搜索记录" forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:nil forKey:SEARCH_HISTORY_KEY];
    }
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *currentUrl;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    switch (tableView.tag) {
        case SEARCH_HISTORY_TAG:
            currentUrl = self.history[indexPath.row];
            [self encodeUrlAndStartRefreshWithString:currentUrl];
            [center postNotificationName:SEARCH_HISTORY_LIST_CLICKED_NOTIFICATION object:currentUrl];
            break;
        case SEARCH_RESULT_TAG:
//            NSLog(@"%@",self.history[indexPath.row]);
        default:
            break;
    }
    
}

#pragma mark - table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == SEARCH_RESULT_TAG) {
        ColumnTableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:COLUMN_LIST_CELL_ID];

        if (!cell) {
            cell = [[ColumnTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:COLUMN_LIST_CELL_ID];
            //this should be wrong.....but i don't know what to do yet;
        }
        BannerModel *currentModel = self.listModels[indexPath.row];
        [cell.newsImage sd_setImageWithURL:[NSURL URLWithString:currentModel.image] placeholderImage:[UIImage imageNamed: PLACE_HOLDER_IMAGE]];
        cell.titleLabel.text = currentModel.title;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HISTORY_LIST_CELL_ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HISTORY_LIST_CELL_ID];
        }
        cell.textLabel.text = self.history[indexPath.row];
        return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == SEARCH_HISTORY_TAG) {
        return self.history.count;
    }else{
        return self.listModels.count;
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"pushToNewsDetail"]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *path = [self.searchTableView indexPathForCell:sender];
            if ([segue.destinationViewController isKindOfClass:[InformationDisclosureDetailViewController class]]) {
                BannerModel *currentModel = self.listModels[path.row];
                if (currentModel.info_link) {
                    ((InformationDisclosureDetailViewController *)segue.destinationViewController).webRequest =
                    [NSURLRequest requestWithURL:[NSURL URLWithString:currentModel.info_link]];
                    ((InformationDisclosureDetailViewController *)segue.destinationViewController).detail = YES;
                    ((InformationDisclosureDetailViewController *)segue.destinationViewController).contentID = [NSNumber numberWithInteger: currentModel.content_id];
                }
            }
        }
    }
}

@end
