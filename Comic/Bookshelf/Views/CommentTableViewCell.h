//
//  CommentTableViewCell.h
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@protocol CommentTableViewCellDelegate <NSObject>

//查看评论详情
-(void)commentTableViewCellDidCheckCommentDetails:(CommentModel *)model;
//回复
-(void)commentTableViewCellDidReplyWithModel:(CommentModel *)model commentedUserId:(NSNumber *)uid replyId:(NSNumber *)replyId commented_nick:(NSString *)name;

@end

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic, weak ) id <CommentTableViewCellDelegate>cellDelegate;
@property (nonatomic,strong) CommentModel *commentModel;
@property (nonatomic,strong) UIView       *lineView;
@property (nonatomic,strong) UIButton     *likeBtn;

@end

