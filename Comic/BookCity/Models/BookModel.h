//
//  BookModel.h
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookModel : NSObject

@property (nonatomic ,strong) NSNumber  *book_id;
@property (nonatomic , copy ) NSString  *oblong_cover;   //长方形封面
@property (nonatomic , copy ) NSString  *square_cover;   //正方形封面
@property (nonatomic , copy ) NSString  *detail_cover;   //详情封面
@property (nonatomic , copy ) NSString  *book_name;    //书名
@property (nonatomic , copy ) NSString  *author;  //作者
@property (nonatomic , copy ) NSString  *des;    //描述
@property (nonatomic , copy ) NSArray   *label;    //标签

@property (nonatomic ,strong) NSNumber  *collect; //加入书架数
@property (nonatomic ,strong) NSNumber  *state;  //是否加入书架
@property (nonatomic ,strong) NSNumber  *comment_count; //评论数

@property (nonatomic ,strong) NSNumber  *vip_cost; //
@property (nonatomic ,strong) NSNumber  *cost; //

@property (nonatomic ,strong) NSNumber  *like_count; //点赞数
@property (nonatomic ,strong) NSNumber  *like_status; //点赞状态


@end


