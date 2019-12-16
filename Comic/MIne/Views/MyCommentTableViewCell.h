//
//  MyCommentTableViewCell.h
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCommentModel.h"


@interface MyCommentTableViewCell : UITableViewCell

@property (nonatomic,strong) MyCommentModel *commentModel;
@property (nonatomic,strong) UIButton       *deleteBtn;

@end


