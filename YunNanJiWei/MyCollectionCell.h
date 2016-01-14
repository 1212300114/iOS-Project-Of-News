//
//  MyCollectionCell.h
//  YunNanJiWei
//
//  Created by 嵇俊杰 on 16/1/12.
//  Copyright © 2016年 GaryJ. All rights reserved.
//

#import <MGSwipeTableCell/MGSwipeTableCell.h>

@interface MyCollectionCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemDescription;
@property (weak, nonatomic) IBOutlet UILabel *itemDate;

@end
