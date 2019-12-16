//
//  CommentMeTableViewCell.h
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCommentModel.h"

@interface CommentMeTableViewCell : UITableViewCell

@property (nonatomic,strong) UIButton       *replyBtn;
@property (nonatomic,strong) MyCommentModel *commentModel;

@end

