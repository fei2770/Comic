//
//  ReplyTableViewCell.h
//  Comic
//
//  Created by vision on 2019/11/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface ReplyTableViewCell : UITableViewCell

@property (nonatomic,strong) UIButton        *likeBtn;

-(void)displayTableViewCellWithCommentId:(NSNumber *)commentId reply:(ReplyModel *)replyModel;

+(CGFloat)getReplyViewCellWithCommentId:(NSNumber *)commentId reply:(ReplyModel *)replyModel;

@end

