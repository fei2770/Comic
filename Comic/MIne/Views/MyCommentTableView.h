//
//  MyCommentTableView.h
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCommentModel.h"

@protocol MyCommentTableViewDelegate <NSObject>

-(void)myCommentTableViewDidDeleteMyComment:(MyCommentModel *)commentModel;

@end

@interface MyCommentTableView : UITableView

@property (nonatomic, weak ) id<MyCommentTableViewDelegate>viewDelegate;
@property (nonatomic,strong) NSMutableArray *myCommentsArray;

@end


