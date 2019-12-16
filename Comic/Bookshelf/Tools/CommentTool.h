//
//  CommentTool.h
//  Comic
//
//  Created by vision on 2019/11/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"
#import "MyCommentModel.h"



@interface CommentTool : NSObject

+(CGFloat)getCommentCellHeightWithModel:(CommentModel *)comment;

+(CGFloat)getMyCommentCellHeightWithModel:(MyCommentModel *)myComment;

+(CGFloat)getCommentMeCellHeightWithModel:(MyCommentModel *)comment;


@end


