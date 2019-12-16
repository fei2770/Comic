//
//  CommentHeaderView.h
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"


@interface CommentHeaderView : UIView

@property (nonatomic,strong) BookModel *book;
@property (nonatomic,strong) UIButton    *commentBtn;    //发表评论

@end


