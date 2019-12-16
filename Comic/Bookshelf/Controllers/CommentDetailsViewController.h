//
//  CommentDetailsViewController.h
//  Comic
//
//  Created by vision on 2019/11/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BaseViewController.h"



@interface CommentDetailsViewController : BaseViewController

@property (nonatomic,assign) NSInteger  type;  //1书本 2章节
@property (nonatomic,strong) NSNumber   *commentId;



@end


