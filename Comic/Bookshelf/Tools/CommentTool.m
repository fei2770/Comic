//
//  CommentTool.m
//  Comic
//
//  Created by vision on 2019/11/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import "CommentTool.h"



@implementation CommentTool

+(CGFloat)getCommentCellHeightWithModel:(CommentModel *)comment{
    CGFloat commentHeight = 0.0;
    if (!kIsEmptyString(comment.content)) {
        CGFloat contentH = [comment.content boundingRectWithSize:CGSizeMake(kScreenWidth-84, CGFLOAT_MAX) withTextFont:[UIFont regularFontWithSize:14.0f]].height;
        commentHeight += contentH;
    }
    
    if (comment.pics.count>0) {
        CGFloat picH = 0.0;
        if (comment.pics.count==1) {
            picH = 95;
        }else{
            CGFloat picW = (kScreenWidth-84-2*10)/3.0;
            picH = ((comment.pics.count/3)+1)*(picW+10)+(comment.pics.count/3)*10;
        }
        commentHeight += picH;
    }
    
    if (comment.review.count>0) {
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in comment.review) {
            ReplyModel *model = [[ReplyModel alloc] init];
            [model setValues:dict];
            [tempArr addObject:model];
        }
        
        CGFloat replyHeight = 0.0;
        for (NSInteger i=0; i<tempArr.count; i++) {
            ReplyModel *reply = tempArr[i];
            NSString *tempStr = nil;
            if ([reply.be_user_id integerValue]==[comment.user_id integerValue]) {
                tempStr = [NSString stringWithFormat:@"%@：%@",reply.user_name,reply.content];
            }else{
                tempStr = [NSString stringWithFormat:@"%@ Balasan %@：%@",reply.user_name,reply.be_user_name,reply.content];
            }
            CGFloat replyContentH = [tempStr boundingRectWithSize:CGSizeMake(kScreenWidth-105, CGFLOAT_MAX) withTextFont:[UIFont regularFontWithSize:12.0f]].height;
            replyHeight += replyContentH;
            
        }
        if ([comment.review_count integerValue]>3) {
            replyHeight += 40;
        }
        commentHeight += replyHeight+30;
    }
    
    return commentHeight+75;
}


+(CGFloat)getMyCommentCellHeightWithModel:(MyCommentModel *)myComment{
    CGFloat commentH = 0.0;
    if (!kIsEmptyString(myComment.content)) {
        CGFloat contentH = [myComment.content boundingRectWithSize:CGSizeMake(kScreenWidth-40, CGFLOAT_MAX) withTextFont:[UIFont regularFontWithSize:15]].height;
        commentH += contentH;
    }
    if (!kIsEmptyString(myComment.comment_content)) {
        NSString *replyStr = nil;
        if (kIsEmptyString(myComment.commented_nick)) {
            replyStr = [NSString stringWithFormat:@"%@：%@",myComment.comment_nick,myComment.comment_content];
        }else{
            replyStr = [NSString stringWithFormat:@"%@ Balasan %@：%@",myComment.comment_nick,myComment.commented_nick,myComment.comment_content];
        }
        CGFloat replyH = [replyStr boundingRectWithSize:CGSizeMake(kScreenWidth-50, CGFLOAT_MAX) withTextFont:[UIFont regularFontWithSize:14]].height;
        commentH += replyH+90;
    }else{
        commentH += 60;
    }
    return commentH+65;
}

+(CGFloat)getCommentMeCellHeightWithModel:(MyCommentModel *)comment{
    CGFloat commentH = 65.0;
    if (!kIsEmptyString(comment.content)) {
        CGFloat contentH = [comment.content boundingRectWithSize:CGSizeMake(kScreenWidth-40, CGFLOAT_MAX) withTextFont:[UIFont regularFontWithSize:15]].height;
        commentH += contentH;
    }
  
    NSString *replyStr = nil;
    if (kIsEmptyString(comment.commented_nick)) {
        replyStr = [NSString stringWithFormat:@"%@：%@",comment.comment_nick,comment.comment_content];
    }else{
        replyStr = [NSString stringWithFormat:@"%@ Balasan %@：%@",comment.comment_nick,comment.commented_nick,comment.comment_content];
    }
    CGFloat replyH = [replyStr boundingRectWithSize:CGSizeMake(kScreenWidth-50, CGFLOAT_MAX) withTextFont:[UIFont regularFontWithSize:14]].height;
    commentH += replyH+90;
    
    return commentH+20;
}




@end
