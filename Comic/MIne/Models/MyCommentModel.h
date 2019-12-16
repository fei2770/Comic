//
//  MyCommentModel.h
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MyCommentModel : NSObject

@property (nonatomic, copy ) NSString  *user_cover;
@property (nonatomic, copy ) NSString  *name;
@property (nonatomic,strong) NSNumber  *comment_id;
@property (nonatomic,strong) NSNumber  *book_id;
@property (nonatomic, copy ) NSString  *book_name;
@property (nonatomic,strong) NSNumber  *catalogue_id;
@property (nonatomic, copy ) NSString  *catalogue_name;
@property (nonatomic, copy ) NSString  *content;
@property (nonatomic, copy ) NSArray   *pics;
@property (nonatomic,strong) NSNumber  *like;
@property (nonatomic, copy ) NSString  *detail_cover;
@property (nonatomic,strong) NSNumber  *be_user_id;
@property (nonatomic, copy ) NSDictionary  *comment;

@property (nonatomic,strong) NSNumber  *reply_id;

@property (nonatomic, copy ) NSString  *comment_nick;
@property (nonatomic, copy ) NSString  *commented_nick;
@property (nonatomic, copy ) NSString  *comment_content;
@property (nonatomic,strong) NSNumber  *comment_time;

@end


