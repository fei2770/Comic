//
//  CommentMeTableView.m
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import "CommentMeTableView.h"
#import "CommentMeTableViewCell.h"
#import "CommentTool.h"
#import "BlankView.h"

@interface CommentMeTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BlankView  *blankView;

@end

@implementation CommentMeTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.blankView];
        self.blankView.hidden = YES;
    }
    return self;
}

#pragma mark UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CommentMeTableViewCell";
    CommentMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[CommentMeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyCommentModel *model = self.commentsArray[indexPath.row];
    cell.commentModel = model;
    
    cell.replyBtn.tag = indexPath.row;
    [cell.replyBtn addTarget:self action:@selector(replyOtherCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCommentModel *model = self.commentsArray[indexPath.row];
    return [CommentTool getCommentMeCellHeightWithModel:model];
}

-(void)setCommentsArray:(NSMutableArray *)commentsArray{
    _commentsArray = commentsArray;
    self.blankView.hidden = commentsArray.count>0;
}

#pragma mark - Event response
#pragma mark 回复评论
-(void)replyOtherCommentAction:(UIButton *)sender{
    MyCommentModel *model = self.commentsArray[sender.tag];
    if ([self.viewDelegate respondsToSelector:@selector(commentMeTableViewDidReplyWithComment:)]) {
        [self.viewDelegate commentMeTableViewDidReplyWithComment:model];
    }
}

#pragma mark 空白页
-(BlankView *)blankView{
    if (!_blankView) {
        _blankView = [[BlankView alloc] initWithFrame:CGRectMake(0,40, kScreenWidth, 120) img:@"default_page_information" msg:@"Sementara tidak ada informasi"];
    }
    return _blankView;
}

@end
