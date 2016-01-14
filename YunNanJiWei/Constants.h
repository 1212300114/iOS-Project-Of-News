//  Constans used in app
//  Constants.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 15/12/16.
//  Copyright © 2015年 GaryJ. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//获取设备的物理高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width


//二级栏目获取URL
#define COLUMN_INDICATOR_URL @"http://api.jjjc.yn.gov.cn/jwapp/?service=Category.index"
//栏目列表的URL ---需要参数
#define COLUMN_LIST_URL @"http://api.jjjc.yn.gov.cn/jwapp/?service="

#define COLUMN_LIST_CELL_ID @"columnCell"

#define HISTORY_LIST_CELL_ID @"historyCell"

//list url and cell id in regulation
#define DISCIPLINE_REGULATION_LIST_URL @"http://api.jjjc.yn.gov.cn//jwapp//?service=List.index&cid=43"

#define DISCIPLINE_REGULATION_CELL_ID @"DisciplineRegulationsCell"

//web urls in information ;
#define LEADER_URL @"http://www.jjjc.yn.gov.cn/mpage-2.html"

#define ORGANIZATION_URL @"http://www.jjjc.yn.gov.cn/mpage-37.html"

#define HISTORY_URL @"http://www.jjjc.yn.gov.cn/mpage-36.html"

#define PROCESS_URL @"http://www.jjjc.yn.gov.cn/mpage-74.html"

//web url of about us
#define ABOUT_US_URL @"http://www.jjjc.yn.gov.cn//mpage-12.html"

#define STATE_DYNAMIC_COLUMN_URL @"http://api.jjjc.yn.gov.cn/jwapp/?service=Dynamic.index"

//params in search view controller
#define SEARCH_URL @"http://api.jjjc.yn.gov.cn/jwapp/?service=Search.index&title="

#define SEARCH_RESULT_TAG 10000

#define SEARCH_HISTORY_TAG 10001

#define SEARCH_HISTORY_KEY @"history"

#define SEARCH_INPUT_NOTIFICATION @"SearchInputString"

#define SEARCH_HISTORY_LIST_CLICKED_NOTIFICATION @"HistorySelected"

#define PLACE_HOLDER_IMAGE @"defaultImage"

//params in collection view controller
#define COLLECTION_KEY @"collection"

#define COLLECTION_LIST_CELL_ID @"swipeCell"

#define COLLECTION_URL @"http://api.jjjc.yn.gov.cn/jwapp/?service=Favorites.index&content_ids="
#endif /* Constants_h */
