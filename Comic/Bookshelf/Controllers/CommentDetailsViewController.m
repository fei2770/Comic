//
//  CommentDetailsViewController.m
//  Comic
//
//  Created by vision on 2019/11/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import "CommentDetailsViewController.h"
#import "CommentTableViewCell.h"
#import "ReplyTableViewCell.h"
#import "ReplyToolBarView.h"
#import "CommentTool.h"
#import "CommentModel.h"
#import <MJRefresh/MJRefresh.h>


@interface CommentDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,ReplyToolBarViewDelegate>

@property (nonatomic,strong) UITableView     *detailsTableView;
@property (nonatomic,strong) ReplyToolBarView  *tempReplyBarView;
@property (nonatomic,strong) ReplyToolBarView  *replyBarView;
@property (nonatomic,strong) UIView            *layerView;  //蒙层

@property (nonatomic,strong) CommentModel    *commentModel;

@property (nonatomic,strong) NSMutableArray  *commentsArray;

@property (nonatomic,assign) NSInteger       page;
@property (nonatomic,assign) NSInteger       replyedUid;
@property (nonatomic,assign) NSInteger       selReplyId;

@end

@implementation CommentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"Detail komentar";
    
    
    self.page = 1;
    self.replyedUid = 0;
    self.selReplyId = 0;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6FA"];
    [self.view addSubview:self.detailsTableView];
    [self.view addSubview:self.tempReplyBarView];
    self.detailsTableView.hidden = self.tempReplyBarView.hidden = YES;
    
    [self loadCommentDetailsData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([ComicManager sharedComicManager].isCommentDetailsLoad) {
        [self loadCommentDetailsData];
        [ComicManager sharedComicManager].isCommentDetailsLoad = NO;
    }
}

#pragma mark UITableViewDataSource and UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return self.commentsArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        CommentTableViewCell *cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];\
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.commentModel = self.commentModel;
        cell.lineView.hidden = YES;
        
        [cell.likeBtn addTarget:self action:@selector(commentDetailsLikeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{
        static NSString *cellIdentifier = @"ReplyTableViewCell";
        ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[ReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithHexString:@"#F6F6FA"];
        
        ReplyModel *model = self.commentsArray[indexPath.row];
        [cell displayTableViewCellWithCommentId:self.commentModel.user_id reply:model];
        
        cell.likeBtn.tag = indexPath.row;
        [cell.likeBtn addTarget:self action:@selector(replyLikeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return [CommentTool getCommentCellHeightWithModel:self.commentModel];
    }else{
        ReplyModel *model = self.commentsArray[indexPath.row];
        return [ReplyTableViewCell getReplyViewCellWithCommentId:self.commentModel.user_id reply:model];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showReplyBarView];
    if (indexPath.section==1) { //回复评论
        ReplyModel *model = self.commentsArray[indexPath.row];
        self.replyedUid = [model.user_id integerValue];
        self.selReplyId = [model.review_id integerValue];
    }else{
        self.replyedUid = 0;
    }
}

#pragma mark ReplyToolBarViewDelegate
#pragma mark 显示回复框
-(void)replyToolBarViewDidShowBar:(ReplyToolBarView *)barView{
    if ([ComicManager hasSignIn]) {
        if (barView==self.tempReplyBarView) {
            [self showReplyBarView];
        }
    }else{
        [self presentLoginVC];
    }
}

#pragma mark 发送回复
-(void)replyToolBarView:(ReplyToolBarView *)barView didSendText:(NSString *)text{
    NSDictionary *params = @{@"token":kUserTokenValue,@"comment_id":self.commentModel.comment_id,@"be_user_id":self.replyedUid>0?[NSNumber numberWithInteger:self.replyedUid]: self.commentModel.user_id,@"reply_id":[NSNumber numberWithInteger:self.selReplyId],@"comment":text};
    [[HttpRequest sharedInstance] postWithURLString:kReplyCommentAPI showLoading:YES parameters:params success:^(id responseObject) {
        self.replyedUid = 0;
        [self loadCommentDetailsData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideReplyBarView];
            [self.view makeToast:@"Komentar berhasil terkirim" duration:1.0 position:CSToastPositionCenter];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark -- Event response
#pragma 隐藏蒙层
-(void)hideLayerViewAction:(UITapGestureRecognizer *)sender{
    [self hideReplyBarView];
}

#pragma mark 对评论点赞
-(void)commentDetailsLikeBtnClickAction:(UIButton *)sender{
    if ([ComicManager hasSignIn]) {
        [self setCommentLikeWithRelationId:self.commentId type:self.type==1?3:4];
    }else{
        [self presentLoginVC];
    }
}

#pragma mark 对回复点赞
-(void)replyLikeBtnClickAction:(UIButton *)sender{
    if ([ComicManager hasSignIn]) {
        ReplyModel *model = self.commentsArray[sender.tag];
        model.is_like = [NSNumber numberWithBool:YES];
        NSInteger count = [model.like integerValue];
        count += 1;
        model.like = [NSNumber numberWithInteger:count];
        [self.detailsTableView reloadData];
        
        [self setCommentLikeWithRelationId:model.comment_id type:5];
    }else{
        [self presentLoginVC];
    }
}

#pragma mark -- Private methods
#pragma mark 加载评论数据
-(void)loadCommentDetailsData{
    NSDictionary *params = @{@"token":kUserTokenValue,@"comment_id":self.commentId,@"page":[NSNumber numberWithInteger:self.page],@"pagesize":@20};
    [[HttpRequest sharedInstance] postWithURLString:kCommentDetailsAPI showLoading:YES parameters:params success:^(id responseObject) {
        NSDictionary *commentDict = [responseObject objectForKey:@"data"];
        [self.commentModel setValues:commentDict];
        self.commentModel.review = nil;
        
        //回复
        NSArray *arr = commentDict[@"review"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in arr) {
            ReplyModel *model = [[ReplyModel alloc] init];
            [model setValues:dict];
            [tempArr addObject:model];
        }
        if (self.page==1) {
            self.commentsArray = tempArr;
        }else{
            [self.commentsArray addObjectsFromArray:tempArr];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.detailsTableView.hidden = self.tempReplyBarView.hidden = NO;
            self.detailsTableView.mj_footer.hidden = tempArr.count<20;
            [self.detailsTableView.mj_header endRefreshing];
            [self.detailsTableView.mj_footer endRefreshing];
            [self.detailsTableView reloadData];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.detailsTableView.mj_header endRefreshing];
            [self.detailsTableView.mj_footer endRefreshing];
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 加载最新回复
-(void)loadNewCommentReplyListData{
    self.page = 1;
    [self loadCommentDetailsData];
}

#pragma mark 加载更多回复
-(void)loadMoreCommentReplyListData{
    self.page ++;
    [self loadCommentDetailsData];
}

#pragma mark 显示回复框
-(void)showReplyBarView{
    [self.view addSubview:self.layerView];
    [self.view addSubview:self.replyBarView];
    [UIView animateWithDuration:0.3 animations:^{
        self.replyBarView.frame = CGRectMake(0, kScreenHeight-60, kScreenWidth, 60);
        [self.replyBarView.replyTextFiled becomeFirstResponder];
    }];
}

#pragma mark 隐藏回复框
-(void)hideReplyBarView{
    [UIView animateWithDuration:0.3 animations:^{
        if (self.replyBarView) {
            [self.replyBarView.replyTextFiled resignFirstResponder];
            self.replyBarView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 60);
        }
    } completion:^(BOOL finished) {
        if (self.replyBarView) {
            [self.replyBarView removeFromSuperview];
            self.replyBarView = nil;
        }
        if (self.layerView) {
            [self.layerView removeFromSuperview];
            self.layerView = nil;
        }
    }];
}

#pragma mark 点赞
//relationId  书本id 章节id 书本主评论id 章节评论id 评论的评论id
// type 1点赞书本 2点赞章节 3点赞书本评论 4点赞章节评论 5点赞评论的回复
-(void)setCommentLikeWithRelationId:(NSNumber *)relationId type:(NSInteger)type{
    NSDictionary *params = @{@"token":kUserTokenValue,@"relation_id":relationId,@"type":[NSNumber numberWithInteger:type]};
    [[HttpRequest sharedInstance] postWithURLString:kSetLikeBookAPI showLoading:NO parameters:params success:^(id responseObject) {
        
    } failure:^(NSString *errorStr) {
        
    }];
}

#pragma mark -- Getters
#pragma mark 评论
-(UITableView *)detailsTableView{
    if (!_detailsTableView) {
        _detailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight+1, kScreenWidth, kScreenHeight-kNavHeight-60) style:UITableViewStyleGrouped];
        _detailsTableView.delegate = self;
        _detailsTableView.dataSource = self;
        _detailsTableView.showsVerticalScrollIndicator = NO;
        _detailsTableView.estimatedSectionHeaderHeight = 0;
        _detailsTableView.estimatedSectionFooterHeight = 0;
        _detailsTableView.tableFooterView = [[UIView alloc] init];
        _detailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //  下拉加载最新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewCommentReplyListData)];
        header.automaticallyChangeAlpha=YES;
        header.lastUpdatedTimeLabel.hidden=YES;
        _detailsTableView.mj_header=header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCommentReplyListData)];
        footer.automaticallyRefresh = NO;
        _detailsTableView.mj_footer = footer;
        footer.hidden=YES;
    }
    return _detailsTableView;
}

#pragma mark 仅显示
-(ReplyToolBarView *)tempReplyBarView{
    if (!_tempReplyBarView) {
        _tempReplyBarView = [[ReplyToolBarView alloc] initWithFrame:CGRectMake(0, kScreenHeight-60, kScreenWidth, 60)];
        _tempReplyBarView.noInput = YES;
        _tempReplyBarView.delegate = self;
    }
    return _tempReplyBarView;
}

#pragma mark 蒙版
-(UIView *)layerView{
    if (!_layerView) {
        _layerView = [[UIView alloc] initWithFrame:self.view.bounds];
        _layerView.backgroundColor = kRGBColor(0, 0, 0, 0.5);
        _layerView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideLayerViewAction:)];
        [_layerView addGestureRecognizer:tap];
    }
    return _layerView;
}

#pragma mark 回复框
-(ReplyToolBarView *)replyBarView{
    if (!_replyBarView) {
        _replyBarView = [[ReplyToolBarView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 60)];
        _replyBarView.noInput = NO;
        _replyBarView.delegate = self;
    }
    return _replyBarView;
}

-(CommentModel *)commentModel{
    if (!_commentModel) {
        _commentModel = [[CommentModel alloc] init];
    }
    return _commentModel;
}

-(NSMutableArray *)commentsArray{
    if (!_commentsArray) {
        _commentsArray = [[NSMutableArray alloc] init];
    }
    return _commentsArray;
}


@end
