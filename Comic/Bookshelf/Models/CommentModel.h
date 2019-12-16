//
//  CommentModel.h
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommentModel : NSObject

@property (nonatomic ,strong) NSNumber  *book_id;
@property (nonatomic ,strong) NSNumber  *comment_id;
@property (nonatomic ,strong) NSNumber  *comment_time;
@property (nonatomic , copy ) NSString  *content;            //评价内容
@property (nonatomic ,strong) NSNumber  *user_id;            //评论用户id
@property (nonatomic , copy ) NSString  *head_portrait;      //头像
@property (nonatomic , copy ) NSString  *name;
@property (nonatomic ,strong) NSNumber  *like;           //点赞数
@property (nonatomic ,assign) NSNumber  *is_like;        //是否点赞 1.已点赞 0.未点赞
@property (nonatomic , copy ) NSArray   *pics;               //图片

@property (nonatomic ,strong) NSArray   *review;              //回复数据集
@property (nonatomic ,strong) NSNumber  *review_count;          //回复数量


@end


@interface ReplyModel : NSObject

@property (nonatomic ,strong) NSNumber  *comment_id;
@property (nonatomic ,strong) NSNumber  *user_id;                 //评论者用户id
@property (nonatomic , copy ) NSString  *user_name;               //评论者昵称
@property (nonatomic , copy ) NSString  *user_head_portrait;      //评论者头像
@property (nonatomic ,strong) NSNumber  *be_user_id;              //被评论者用户id
@property (nonatomic , copy ) NSString  *be_user_name;            //被评论者昵称
@property (nonatomic , copy ) NSString  *be_user_head_portrait;   //被评论者头像
@property (nonatomic , copy ) NSString  *content;                  //评论内容
@property (nonatomic , copy ) NSArray   *pics;                     //评论图片
@property (nonatomic ,strong) NSNumber  *review_id;                //回复id
@property (nonatomic ,strong) NSNumber  *review_time;              //回复时间
@property (nonatomic ,strong) NSNumber  *like;                     //点赞数
@property (nonatomic ,assign) NSNumber  *is_like;                  //是否点赞 1.已点赞 0.未点赞





@end

