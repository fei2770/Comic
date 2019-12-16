//
//  ShelfBookModel.h
//  Comic
//
//  Created by vision on 2019/11/27.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ShelfBookModel : NSObject

@property (nonatomic ,strong) NSNumber  *book_id;
@property (nonatomic , copy ) NSString  *detail_cover;   //详情封面
@property (nonatomic , copy ) NSString  *book_name;    //书名
@property (nonatomic ,strong) NSNumber  *catalogue_id;  //章节id
@property (nonatomic ,copy  ) NSString  *catalogue_name; //章节名
@property (nonatomic ,strong) NSNumber  *comment_count;   //评论数
@property (nonatomic ,strong) NSNumber  *like; //喜欢数
@property (nonatomic ,strong) NSNumber  *like_status; 
@property (nonatomic ,strong) NSNumber  *create_time; //加入时间
@property (nonatomic ,strong) NSNumber  *type;   //1连载中2完结
@property (nonatomic ,strong) NSNumber  *isSelected;


@end


