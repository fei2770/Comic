//
//  CommentMeTableView.h
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCommentModel.h"

@protocol CommentMeTableViewDelegate <NSObject>

-(void)commentMeTableViewDidReplyWithComment:(MyCommentModel *)comment;

@end

@interface CommentMeTableView : UITableView

@property (nonatomic,strong) NSMutableArray *commentsArray;
@property (nonatomic, weak ) id<CommentMeTableViewDelegate>viewDelegate;

@end

