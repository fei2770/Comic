//
//  SelectionTableView.h
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookSelectionModel.h"

@protocol SelectionTableViewDelegate <NSObject>

//选择漫画集数
-(void)selectionTableViewDidSelectedCellWithModel:(BookSelectionModel*)model;

//排序
-(void)selectionTableViewSortByOrder:(NSString *)type;

//点赞
-(void)selectionTableViewDidClickLikeWithSelectionId:(NSNumber *)selectionId;

@end


@interface SelectionTableView : UITableView


@property (nonatomic,assign) NSInteger vipCost;
@property (nonatomic,strong) NSMutableArray *selectionsArray;

@property (nonatomic, weak ) id<SelectionTableViewDelegate>viewDelegate;

@end


