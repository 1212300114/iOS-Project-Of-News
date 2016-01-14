//
//  ColumnController.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/10/15.
//  Copyright © 2015年 GaryJ. All rights reserved.
//
#import "SlideNavigationController.h"
#import "ColumnController.h"
#import "ColumnTableViewCell.h"
#import "GJBannerView.h"
#import "InformationDisclosureDetailViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#import "Constants.h"
#import "HttpUtils.h"

#import "ColumnModel.h"
#import "BannerModel.h"
#import "DynamicModel.h"

@interface ColumnController ()<UITableViewDataSource,UITableViewDelegate,GJBannerViewDelegate>

//views
@property (weak, nonatomic) IBOutlet UITableView *columnTable;
@property (weak, nonatomic) GJBannerView *newsBanner;
//properties-data
@property (nonatomic) NSUInteger listCount;
//use MJExtension to get data moderl rather than use arraies;
//Deprecated
//@property (strong, nonatomic) NSArray *listImageURLs;// array of imageURLs of rows--- type string;
//@property (strong, nonatomic) NSArray *listTitleNames;// array of titles of rows --- type string;
//@property (strong, nonatomic) NSArray *listNewsLinks;// array of news link of rows --- type string;
//property of normal columns

@property (strong, nonatomic) ColumnModel *columnModel;

@property (strong, nonatomic) DynamicModel *dynamicModel;

//common variables
@property (assign, nonatomic) NSUInteger currentPage; // the page index of list
@property (assign, nonatomic) NSUInteger pageCount; //
@property (strong, nonatomic) NSMutableArray *listModels;//array of list data model  type BannerModel;

@property (strong, nonatomic) NSArray *bannerImageURLS;// array of imageURLs of banner --- type string
@property (strong, nonatomic) NSArray *bannerTitles; // array of titles of banner --- type string;
@property (strong, nonatomic) NSArray *bannerNewsLinks;// array of news link of banner --- type string;
@property (strong, nonatomic) NSArray *bannerContentId;// array of content id of banner --- type NSNumber;


@end

@implementation ColumnController
#pragma mark - life cycle
-(void)viewDidLoad{
    self.columnTable.delegate = self;
    self.columnTable.dataSource = self;
    if (self.isDynamic) {
        self.navigationItem.title = self.navigationTitle;
    }
    NSLog(@"columncateLink = %@",self.cateLink);
    [self pullDownToGetNewData];
    [self pullUpToGetMoreData];
}
//添加轮播图
-(void)initBanner{
    GJBannerView *newsBanner = [[GJBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3.0f)];
    newsBanner.delegate = self;
  
    newsBanner.imageUrls = self.bannerImageURLS ;
    self.newsBanner = newsBanner;
    self.columnTable.tableHeaderView = newsBanner;
    [newsBanner setImages:nil titles:self.bannerTitles interval:2.0];
}
//为列表绑定 下拉刷新 并且开始动画
-(void)pullDownToGetNewData{

    self.columnTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self.columnTable.mj_header beginRefreshing];
}
//请求数据的方法
-(void)requestData{
    self.currentPage = 1;
    [self.columnTable.mj_footer resetNoMoreData];
    NSString *requestURL = [COLUMN_LIST_URL stringByAppendingString:self.cateLink];
    requestURL = [NSString stringWithFormat:@"%@&page=%d",requestURL,(int)self.currentPage];
    NSLog(@"current url = %@",requestURL);
    __weak ColumnController *weakSelf = self;
    [[HttpUtils shareInstance]get:requestURL success:^(id json) {
//        NSLog(@"%@",json);
        if ([json isKindOfClass:[NSDictionary class]]) {
            //get data of list
//            weakSelf.listTitleNames = [json valueForKeyPath:@"data.list.title"];
//            weakSelf.listImageURLs = [json valueForKeyPath:@"data.list.image"];
//            weakSelf.listNewsLinks = [json valueForKeyPath:@"data.list.info_link"];
            
            //get data of banner
            weakSelf.bannerTitles = [json valueForKeyPath:@"data.banner.title"];
            weakSelf.bannerNewsLinks = [json valueForKeyPath:@"data.banner.info_link"];
            weakSelf.bannerImageURLS = [json valueForKeyPath:@"data.banner.image"];
            weakSelf.bannerContentId = [json valueForKeyPath:@"data.banner.content_id"];

            if (!self.isDynamic) {
                ColumnModel *columnModel = [ColumnModel mj_objectWithKeyValues:json];
//              [weakSelf.listModel addObjectsFromArray:columnModel.data.list];
//              NSArray *tempArray = columnModel.data.list;
                weakSelf.listModels = columnModel.data.list;
                NSLog(@"%@model1!!!!!!",((BannerModel *)weakSelf.listModels[1]));
                weakSelf.columnModel = columnModel;
            }else{
                DynamicModel *dynamicModel = [DynamicModel mj_objectWithKeyValues:json];
                weakSelf.dynamicModel = dynamicModel;
                weakSelf.listModels = dynamicModel.data.list;
                NSLog(@"dymicModeldata %@",[dynamicModel.data class]);
            }
//            NSLog(@"%@",[columnModel.data.list[0] class]);
            [weakSelf.columnTable.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        NSLog(@"data get error");
    }];
}

-(void)pullUpToGetMoreData{
    self.columnTable.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

-(void)loadMoreData{
    self.currentPage ++;
    if (self.currentPage > self.pageCount) {
        [self.columnTable.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    NSString *requestURL = [COLUMN_LIST_URL stringByAppendingString:self.cateLink];
    requestURL = [NSString stringWithFormat:@"%@&page=%d",requestURL,(int)self.currentPage];
    NSLog(@"%@",requestURL);
    __weak typeof (self) weakSelf = self;
    [[HttpUtils shareInstance]get:requestURL success:^(id json) {

        ColumnModel *model = [ColumnModel mj_objectWithKeyValues:json];
        if (model) {
            
            [weakSelf.listModels addObjectsFromArray:model.data.list];
            [weakSelf.columnTable reloadData];
            
            [weakSelf.columnTable.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - properties 
@synthesize listCount = _listCount;
-(void)setListCount:(NSUInteger)listCount{
    _listCount = listCount;
    [self.columnTable reloadData];
}

-(NSUInteger)listCount{
    return self.listModels.count;
}

-(void)setListModels:(NSMutableArray *)listModels{
    _listModels = listModels;
    self.listCount = listModels.count;
    NSLog(@"go away%ld",self.listCount);
}

-(NSUInteger)currentPage{
    if (!_currentPage) {
        _currentPage = 1;
    }
    return _currentPage;
}
-(NSUInteger)pageCount{
    if (self.isDynamic) {
        return self.dynamicModel.data.pagecount;
    }
    return self.columnModel.data.pagecount;
}
// if there is no banner data reomove the header of the table
-(void)setBannerImageURLS:(NSArray *)bannerImageURLS{
    _bannerImageURLS = bannerImageURLS;
    if (bannerImageURLS.count == 0) {
        NSLog(@"No banner in current column");
        //set the header view to nil;
//        self.columnTable.tableHeaderView = nil;
    }else{
        [self initBanner];
        NSLog(@"the banner size of the current column = %ld",(unsigned long)bannerImageURLS.count);
    }
}
-(void)setColumnModel:(ColumnModel *)columnModel{
    _columnModel = columnModel;
    self.pageCount = columnModel.data.pagecount;

}
#pragma mark - table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%@", self.listNewsLinks[indexPath.row]);

}

#pragma mark - table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listCount;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ColumnTableViewCell *cell;


    cell = [tableView dequeueReusableCellWithIdentifier:COLUMN_LIST_CELL_ID];
    if (cell == nil) {
        cell = [[ColumnTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:COLUMN_LIST_CELL_ID];
        NSLog(@"ID not set!!");
    }
    BannerModel *currentModel = self.listModels[indexPath.row];
    cell.titleLabel.text = currentModel.title;
    
//    self.listImageURLs = nil; code test what if i can't get the url of the image and it's a great framework and it is can dual with this ;
    [cell.newsImage sd_setImageWithURL:[NSURL URLWithString:currentModel.image] placeholderImage:[UIImage imageNamed:PLACE_HOLDER_IMAGE]];
    return cell;
    
    
}
#pragma mark - banner delegate
-(void)bannerViewDidSelectedBanner:(GJBannerView *)banner atIndex:(NSUInteger)index{
    NSLog(@"%lu",(unsigned long)index);
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InformationDisclosureDetailViewController *bannerDetail = [mainSb instantiateViewControllerWithIdentifier:@"InformationDisclosureDetailViewController"];
    if (bannerDetail) {
        bannerDetail.detail = YES;
        bannerDetail.webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.bannerNewsLinks[index]]];

        bannerDetail.contentID = self.bannerContentId[index];
        NSLog(@"%@",bannerDetail.contentID);
        [[SlideNavigationController sharedInstance] pushViewController:bannerDetail animated:YES];
            }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"pushToNewsDetail"]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *path = [self.columnTable indexPathForCell:sender];
            if ([segue.destinationViewController isKindOfClass:[InformationDisclosureDetailViewController class]]) {
                BannerModel *currnetModel = self.listModels[path.row];
                if (currnetModel.info_link) {
                    ((InformationDisclosureDetailViewController *)segue.destinationViewController).webRequest =
                    [NSURLRequest requestWithURL:[NSURL URLWithString:currnetModel.info_link]];
                    ((InformationDisclosureDetailViewController *)segue.destinationViewController).detail = YES;
                    ((InformationDisclosureDetailViewController *)segue.destinationViewController).contentID =
                    [NSNumber numberWithInteger:currnetModel.content_id];
                }
            }
        }
    }
}
- (IBAction)backClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
