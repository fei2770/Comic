//
//  TaskTableViewCell.h
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"

@interface TaskTableViewCell : UITableViewCell

@property (nonatomic,strong) UIButton     *receiveBtn;
@property (nonatomic,strong) TaskModel    *taskModel;

@end


