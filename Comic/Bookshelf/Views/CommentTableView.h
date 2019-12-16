//
//  CommentTableView.h
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@protocol CommentTableViewDelegate <NSObject>

//点赞
-(void)commentTableViewDidSetLikeWithCommentId:(NSNumber *)commentId;

@end

@interface CommentTableView : UITableView

@property (nonatomic,strong) NSMutableArray *commentsArray;
@property (nonatomic, weak ) id<CommentTableViewDelegate>viewDelegate;

@end


