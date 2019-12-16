//
//  MessageTableViewCell.h
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"


@interface MessageTableViewCell : UITableViewCell

@property (nonatomic,strong) MessageModel *message;

+(CGFloat)getMessageCellHeightWithModel:(MessageModel *)model;

@end


