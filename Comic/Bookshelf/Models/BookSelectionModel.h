//
//  BookSelectionModel.h
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BookSelectionModel : NSObject

@property (nonatomic ,strong) NSNumber  *book_id;
@property (nonatomic ,strong) NSNumber  *catalogue_id;
@property (nonatomic , copy ) NSString  *catalogue_cover;   //封面
@property (nonatomic , copy ) NSString  *catalogue_name;
@property (nonatomic ,strong) NSNumber  *create_time;
@property (nonatomic ,strong) NSNumber  *like;       //点赞数
@property (nonatomic ,strong) NSNumber  *is_like;    //点赞状态
@property (nonatomic ,strong) NSNumber  *type;       // 1收费0免费
@property (nonatomic ,strong) NSNumber  *sort;       //序号

@property (nonatomic, strong) NSNumber  *is_selected;

@end


