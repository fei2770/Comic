//
//  SelectionTableViewCell.h
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookSelectionModel.h"


@interface SelectionTableViewCell : UITableViewCell



@property (nonatomic,strong) UIButton           *likeBtn;

-(void)displayCellWithModel:(BookSelectionModel *)selectionModel vipCost:(NSInteger)vipCost;

@end


