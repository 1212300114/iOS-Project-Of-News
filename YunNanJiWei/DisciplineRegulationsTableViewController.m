//
//  DisciplineRegulationsTableViewController.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/24.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#import "InformationDisclosureDetailViewController.h"
#import "DisciplineRegulationsTableViewController.h"

#import "SlideNavigationController.h"
#import "MJRefresh.h"
#import "MJExtension.h"


#import "HttpUtils.h"
#import "Constants.h"

#import "ColumnModel.h"
#import "BannerModel.h"

@interface DisciplineRegulationsTableViewController ()<SlideNavigationControllerDelegate>
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) NSUInteger pageCount;

@property (nonatomic, strong) ColumnModel *model;
@property (nonatomic) NSUInteger listCount;
@property (nonatomic, strong) NSMutableArray *listModels;//array of list data model type BannerModel;
@end

@implementation DisciplineRegulationsTableViewController
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItem];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initPullDownToGetNewData];
    [self initPullUpToGetMoreData];
}

- (void)initNavigationItem{
   
    UIImageView* appNameImage = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH/15*10,SCREEN_WIDTH*0.0667)];
    appNameImage.image        = [UIImage imageNamed:@"appName"];
    self.navigationItem.titleView = appNameImage;
    
}
//
-(void)initPullDownToGetNewData{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)requestData{
    self.currentPage = 1;
    [self.tableView.mj_footer resetNoMoreData];
    NSString *requestUrl = [NSString stringWithFormat:@"%@&page=%ld",DISCIPLINE_REGULATION_LIST_URL,self.currentPage];
    NSLog(@"current url = %@",requestUrl);
    __weak typeof(self) weakSelf = self;
    [[HttpUtils shareInstance]get:requestUrl success:^(id json) {
//        NSLog(@"%@",json);
        if ([json isKindOfClass:[NSDictionary class]]) {
            weakSelf.model = [ColumnModel mj_objectWithKeyValues:json];
            weakSelf.listModels = weakSelf.model.data.list;
            [weakSelf.tableView.mj_header endRefreshing];
            
            NSLog(@"%ld",weakSelf.model.data.pagecount);
        }
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)initPullUpToGetMoreData{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
-(void)loadMoreData{
    self.currentPage ++;
    if (self.currentPage > self.pageCount) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@&page=%ld",DISCIPLINE_REGULATION_LIST_URL,self.currentPage];
    NSLog(@"%@",requestUrl);
    __weak typeof(self) weakSelf = self;
    [[HttpUtils shareInstance]get:requestUrl success:^(id json) {
        ColumnModel *model = [ColumnModel mj_objectWithKeyValues:json];
        if (model) {
            [weakSelf.listModels addObjectsFromArray:model.data.list];
           
            [weakSelf.tableView reloadData];
            
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - properties
//make the default of currentPage to 1;
-(NSUInteger)currentPage{
    if (!_currentPage) {
        _currentPage = 1;
    }
    return _currentPage;
}

-(NSUInteger)pageCount{
    return self.model.data.pagecount;
}
@synthesize listCount = _listCount;
-(NSUInteger)listCount{
    return self.listModels.count;
}

-(void)setListCount:(NSUInteger)listCount{
    _listCount = listCount;
    [self.tableView reloadData];
}

-(void)setListModels:(NSMutableArray *)listModels{
    _listModels = listModels;
    self.listCount = listModels.count;
    NSLog(@"go away%ld",self.listCount);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DISCIPLINE_REGULATION_CELL_ID];

    BannerModel *currentModel = self.listModels[indexPath.row];
    cell.textLabel.text = currentModel.title;
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"pushToNewsDetail"]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *path = [self.tableView indexPathForCell:sender];
            if ([segue.destinationViewController isKindOfClass:[InformationDisclosureDetailViewController class]]) {
                BannerModel *currnetModel = self.listModels[path.row];
                if (currnetModel.info_link) {
                    ((InformationDisclosureDetailViewController *)segue.destinationViewController).webRequest =
                    [NSURLRequest requestWithURL:[NSURL URLWithString:currnetModel.info_link]];
                    ((InformationDisclosureDetailViewController *)segue.destinationViewController).detail = YES;
                    ((InformationDisclosureDetailViewController *)segue.destinationViewController).contentID = [NSNumber numberWithInteger:currnetModel.content_id];
                }
            }
        }
    }

}

#pragma mark - slide navigation controller delegate;
-(BOOL)slideNavigationControllerShouldDisplayLeftMenu{
return YES;
}

-(BOOL)slideNavigationControllerShouldDisplayRightMenu{
return YES;
}

@end
