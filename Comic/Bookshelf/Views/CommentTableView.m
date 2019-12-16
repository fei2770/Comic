//
//  CommentTableView.m
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentTableViewCell.h"
#import "BlankView.h"
#import "CommentTool.h"

@interface CommentTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BlankView  *blankView;

@end

@implementation CommentTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [[UIView alloc] init];
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self addSubview:self.blankView];
        self.blankView.hidden = YES;
    }
    return self;
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdenditifier = @"CommentTableViewCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenditifier];
    if (cell==nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenditifier];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CommentModel *model = self.commentsArray[indexPath.row];
    cell.commentModel = model;
    
    cell.likeBtn.tag = indexPath.row;
    [cell.likeBtn addTarget:self action:@selector(commentLikeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = self.commentsArray[indexPath.row];
    return [CommentTool getCommentCellHeightWithModel:model];
}

-(void)setCommentsArray:(NSMutableArray *)commentsArray{
    _commentsArray = commentsArray;
    self.blankView.hidden = commentsArray.count>0;
}

#pragma mark 点赞
-(void)commentLikeBtnClickAction:(UIButton *)sender{
    CommentModel *model = self.commentsArray[sender.tag];
    model.is_like = [NSNumber numberWithBool:YES];
    NSInteger count = [model.like integerValue];
    count += 1;
    model.like = [NSNumber numberWithInteger:count];
    [self reloadData];
    
    if ([self.viewDelegate respondsToSelector:@selector(commentTableViewDidSetLikeWithCommentId:)]) {
        [self.viewDelegate commentTableViewDidSetLikeWithCommentId:model.comment_id];
    }
}

#pragma mark 空白页
-(BlankView *)blankView{
    if (!_blankView) {
        _blankView = [[BlankView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 120) img:@"default_page_comment" msg:@"Sementara tidak ada komentar"];
    }
    return _blankView;
}

@end
