//
//  CommentsViewController.h
//  Comic
//
//  Created by vision on 2019/11/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BaseViewController.h"



@interface CommentsViewController : BaseViewController

@property (nonatomic,strong) NSNumber   *book_id;
@property (nonatomic,assign) NSInteger  type;        //1为漫画评论2为章节评论
@property (nonatomic,strong) NSNumber   *chapter_id;     //章节id为0表示评价漫画 不为0评价章节id

@end


