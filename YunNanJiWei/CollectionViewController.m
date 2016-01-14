//
//  CollectionViewController.m
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 16/1/12.
//  Copyright © 2016年 GaryJ. All rights reserved.
//

#import "CollectionViewController.h"
#import "MyCollectionCell.h"
#import "Constants.h"
#import "HttpUtils.h"
#import "CollectionModel.h"
#import "BannerModel.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "InformationDisclosureDetailViewController.h"
@interface CollectionViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;
@property (weak, nonatomic) IBOutlet UITableView *colletionTableView;
@property (strong, nonatomic) NSString *generatedCollectionStrings;
@property (strong, nonatomic) NSMutableArray *listModels;
@property (strong, nonatomic) NSMutableArray *dates;
@property (strong, nonatomic) NSMutableArray *collections;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colletionTableView.delegate = self;
    self.colletionTableView.dataSource = self;
    [self initNavigationItem];
 
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.colletionTableView reloadData];
//    [self.listModels removeAllObjects];
 
}
-(void)viewWillAppear:(BOOL)animated{
    self.generatedCollectionStrings = @"";
    [self getCollectionsFromUserDefaults];
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
    
    //    self.navigationItem.rightBarButtonItem = leftItem;
    //    self.navigationItem.backBarButtonItem = leftItem;
    //    //添加标题栏
    UIImageView* appNameImage = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH/100,SCREEN_WIDTH/17)];
    appNameImage.image        = [UIImage imageNamed:@"MyCollectionTitle"];
    self.navigationItem.titleView = appNameImage;
    
}
- (void)cancleSelected:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getCollectionsFromUserDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *collections = [userDefaults objectForKey:COLLECTION_KEY];
    if (collections && [collections isKindOfClass:[NSArray class]]) {
//        for (NSNumber *collectionID in collections) {
//            self.generatedCollectionStrings = [NSString stringWithFormat:@"%@,%@",self.generatedCollectionStrings,collectionID];
//            NSLog(@"%@",collectionID);
//        }
        if (!collections.count) {
            self.noDataLabel.hidden = NO;
            self.colletionTableView.hidden = YES;
        }else{
            self.noDataLabel.hidden = YES;
            self.colletionTableView.hidden = NO;
        }
        self.collections = [NSMutableArray arrayWithArray:collections];
        for (NSDictionary *dic in collections) {
            if (dic) {
                NSNumber *contentID = [dic objectForKey:@"contentID"];
                self.generatedCollectionStrings = [NSString stringWithFormat:@"%@,%@",self.generatedCollectionStrings,contentID];
                NSString *date = [dic objectForKey:@"time"];
                [self.dates addObject:date];
            }
        }
        NSLog(@"%@",self.generatedCollectionStrings);
    }
    //create url and request data;
    NSString *url = [COLLECTION_URL stringByAppendingString:self.generatedCollectionStrings];
    NSLog(@"%@",url);
    [self getCollectionContent:url];
}

- (void)getCollectionContent:(NSString *)url{
    [[HttpUtils shareInstance]get:url success:^(id json) {
        if (json) {
//            NSLog(@"%@",json);
            CollectionModel *collectionModel = [CollectionModel mj_objectWithKeyValues:json];
            self.listModels = collectionModel.data.list;
            [self.colletionTableView reloadData];
            NSLog(@"%lu",collectionModel.ret);
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -properties 
- (NSString *)generatedCollectionStrings{
    if (!_generatedCollectionStrings) {
        _generatedCollectionStrings = @"";
    }
    if (_generatedCollectionStrings.length) {
        if (([_generatedCollectionStrings characterAtIndex:0] == ',')&&(_generatedCollectionStrings.length > 1 )) {
            _generatedCollectionStrings = [_generatedCollectionStrings substringFromIndex:1];
        }
    }
    return _generatedCollectionStrings;
}
- (NSMutableArray *)dates{
    if (!_dates) {
        _dates = [NSMutableArray array];
    }
    return _dates;
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:COLLECTION_LIST_CELL_ID];
    if (!cell) {
        cell = [[MyCollectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:COLLECTION_LIST_CELL_ID];
    }
    cell.delegate = self;
    BannerModel *currentModel = self.listModels[indexPath.row];
    if (currentModel) {
        [cell.itemImage sd_setImageWithURL:[NSURL URLWithString:currentModel.image] placeholderImage:[UIImage imageNamed:PLACE_HOLDER_IMAGE]];
        cell.itemDescription.text = currentModel.title;
        cell.itemDate.text = self.dates[indexPath.row];
    }
    return cell;
}

#pragma mark - Swipe Cell Delegate

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point{
    
    if (direction == MGSwipeDirectionRightToLeft) {
        return YES;
    }
    return NO;
}

- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings{
    swipeSettings.transition = MGSwipeTransitionBorder;
    expansionSettings.buttonIndex = 0;
    if (direction == MGSwipeDirectionRightToLeft) {
        expansionSettings.fillOnTrigger = YES;
        __weak typeof(self) weakSelf = self;
        MGSwipeButton *deleteButton = [MGSwipeButton buttonWithTitle:nil icon:[UIImage imageNamed:@"collectionDeleteIcon"] backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
            NSLog(@"delete clicked!");
            NSIndexPath *indexPath = [weakSelf.colletionTableView indexPathForCell:sender];
            [weakSelf deleteCollection:indexPath];
            return NO;
        }];
        return @[deleteButton];
    }
    return nil;
}
- (void)deleteCollection:(NSIndexPath *)indexPath{
    [self.listModels removeObjectAtIndex:indexPath.row];
    [self.colletionTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.collections removeObjectAtIndex:indexPath.row];
    if (!self.collections.count) {
        self.colletionTableView.hidden = YES;
        self.noDataLabel.hidden = NO;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.collections forKey:COLLECTION_KEY];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"pushToNewsDetail"]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *path = [self.colletionTableView indexPathForCell:sender];
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


@end
