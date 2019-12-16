//
//  ReadFooterModel.h
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ReadFooterModel : NSObject

@property (nonatomic ,strong) NSNumber  *catalogue_id;  //章节id
@property (nonatomic , copy ) NSString  *catalogue_name; //章节名
@property (nonatomic , copy ) NSArray   *catalogue_content; //章节内容
@property (nonatomic ,strong) NSNumber  *like;              //点赞数
@property (nonatomic ,strong) NSNumber  *is_like;   //点赞状态
@property (nonatomic ,strong) NSNumber  *state;   //加入书架状态
@property (nonatomic ,strong) NSNumber  *type;   //0免费 1付费
@property (nonatomic ,strong) NSNumber  *pre_catalogue_id;   //上一话id
@property (nonatomic ,strong) NSNumber  *next_catalogue_id;   //下一话id
@property (nonatomic ,strong) NSNumber  *vip_cost;   //vip消耗金币
@property (nonatomic ,strong) NSNumber  *cost;   //非vip消耗金币

@property (nonatomic ,strong) NSNumber      *comment_count;   //评论数
@property (nonatomic , copy ) NSDictionary  *banner_dict;   //banner
@property (nonatomic , copy ) NSArray       *books;

@end

@interface CatalogueModel : NSObject

@property (nonatomic,strong) NSNumber *height;
@property (nonatomic,strong) NSNumber *width;
@property (nonatomic, copy ) NSString *url;

@end


