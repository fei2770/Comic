//
//  MessagesViewController.m
//  Comic
//
//  Created by vision on 2019/11/18.
//  Copyright © 2019 vision. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessageMenuView.h"
#import "MyCommentTableView.h"
#import "CommentMeTableView.h"
#import "MessageTableView.h"
#import "ReplyToolBarView.h"
#import "PPBadgeView.h"
#import "MyCommentModel.h"
#import "MessageModel.h"

@interface MessagesViewController ()<MessageMenuViewDelegate,MyCommentTableViewDelegate,CommentMeTableViewDelegate,ReplyToolBarViewDelegate>

@property (nonatomic,strong) MessageMenuView      *menuView;
@property (nonatomic,strong) PPBadgeLabel         *msgLabel;
@property (nonatomic,strong) MyCommentTableView   *myTableView;
@property (nonatomic,strong) CommentMeTableView   *replyTableView;
@property (nonatomic,strong) MessageTableView     *messageTableView;
@property (nonatomic,strong) UIView               *layerView;  //蒙层
@property (nonatomic,strong) ReplyToolBarView     *replyBarView;  //回复框

@property (nonatomic,strong) MyCommentModel       *selComment;
@property (nonatomic,strong) NSMutableArray       *myCommentsArray;

@property (nonatomic,assign) NSInteger     selectedIndex;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6FA"];
    
    self.baseTitle = @"Informasi saya";
    self.selectedIndex = 1;
    
    [self initMessagesView];
    [self loadcommentsData];
}

#pragma mark - Delegage
#pragma mark 选择菜单
-(void)messageMenuViewDidClickItemWithIndex:(NSInteger)index{
    self.selectedIndex = index+1;
    if (index==2) {
        self.myTableView.hidden = self.replyTableView.hidden = YES;
        self.messageTableView.hidden = NO;
        [self loadMessagesData];
    }else{
        if (index==0) {
            self.myTableView.hidden = NO;
            self.replyTableView.hidden = self.messageTableView.hidden =  YES;
        }else{
            self.myTableView.hidden = self.messageTableView.hidden = YES;
            self.replyTableView.hidden = NO;
        }
        [self loadcommentsData];
    }
}

#pragma mark MyCommentTableViewDelegate
#pragma mark 删除我的评论或回复
-(void)myCommentTableViewDidDeleteMyComment:(MyCommentModel *)commentModel{
    self.selComment = commentModel;
    NSInteger type = !kIsEmptyString(commentModel.comment_content)&&!kIsEmptyString(commentModel.comment_nick)?2:1;
    NSDictionary *params = @{@"token":kUserTokenValue,@"id":commentModel.comment_id,@"type":[NSNumber numberWithInteger:type]};
    [[HttpRequest sharedInstance] postWithURLString:kDelMyCommentAPI showLoading:YES parameters:params success:^(id responseObject) {
        [self.myCommentsArray removeObject:commentModel];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.myTableView.myCommentsArray = self.myCommentsArray;
            [self.myTableView reloadData];
            [self.view makeToast:@"Berhasil menghapus" duration:1.0 position:CSToastPositionCenter];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
    
}

#pragma mark CommentMeTableViewDelegate
#pragma mark 回复
-(void)commentMeTableViewDidReplyWithComment:(MyCommentModel *)comment{
    self.selComment = comment;
    [self.view addSubview:self.layerView];
    [self.view addSubview:self.replyBarView];
    [UIView animateWithDuration:0.3 animations:^{
        self.replyBarView.frame = CGRectMake(0, kScreenHeight-60, kScreenWidth, 60);
        [self.replyBarView.replyTextFiled becomeFirstResponder];
    }];
}

#pragma mark ReplyToolBarViewDelegate
#pragma mark 发送回复
-(void)replyToolBarView:(ReplyToolBarView *)barView didSendText:(NSString *)text{
    NSDictionary *params = @{@"token":kUserTokenValue,@"comment_id":self.selComment.comment_id,@"be_user_id":self.selComment.be_user_id,@"reply_id":self.selComment.reply_id,@"comment":text};
       [[HttpRequest sharedInstance] postWithURLString:kReplyCommentAPI showLoading:YES parameters:params success:^(id responseObject) {
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

#pragma mark -- Private methods
#pragma mark 初始化
-(void)initMessagesView{
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.msgLabel];
    self.msgLabel.hidden = !self.hasUnreadMsg;
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.replyTableView];
    self.replyTableView.hidden = YES;
    [self.view addSubview:self.messageTableView];
    self.messageTableView.hidden = YES;
}

#pragma mark 加载评论数据
-(void)loadcommentsData{
    [[HttpRequest sharedInstance] postWithURLString:kMessagesAPI showLoading:YES parameters:@{@"token":kUserTokenValue,@"type":[NSNumber numberWithInteger:self.selectedIndex]} success:^(id responseObject) {
        NSArray *comments = [responseObject objectForKey:@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in comments) {
            MyCommentModel *model = [[MyCommentModel alloc] init];
            [model setValues:dict];
            if (kIsDictionary(model.comment)&&model.comment.count>0) {
                model.commented_nick = model.comment[@"be_name"];
                model.comment_nick = model.comment[@"name"];
                model.comment_content = model.comment[@"content"];
            }
            [tempArr addObject:model];
        }
        self.myCommentsArray = tempArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.selectedIndex==1) {
                self.myTableView.myCommentsArray = self.myCommentsArray;
                [self.myTableView reloadData];
            }else if (self.selectedIndex==2){
                self.replyTableView.commentsArray = self.myCommentsArray;
                [self.replyTableView reloadData];
            }
            
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.selectedIndex==1) {
                self.myTableView.myCommentsArray = [[NSMutableArray alloc] init];
                [self.myTableView reloadData];
            }else if (self.selectedIndex==2){
                self.replyTableView.commentsArray = [[NSMutableArray alloc] init];
                [self.replyTableView reloadData];
            }
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 加载消息
-(void)loadMessagesData{
    [[HttpRequest sharedInstance] postWithURLString:kMessagesAPI showLoading:YES parameters:@{@"token":kUserTokenValue,@"type":[NSNumber numberWithInteger:self.selectedIndex]} success:^(id responseObject) {
        [ComicManager sharedComicManager].isMessagesReload = YES;
        NSArray *data = [responseObject objectForKey:@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data) {
            MessageModel *model = [[MessageModel alloc] init];
            [model setValues:dict];
            [tempArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.msgLabel.hidden = YES;
            self.messageTableView.messagesArray = tempArr;
            [self.messageTableView reloadData];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.messageTableView.messagesArray = [[NSMutableArray alloc] init];
            [self.messageTableView reloadData];
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
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

#pragma mark -- Getters
#pragma mark 菜单栏
-(MessageMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[MessageMenuView alloc] initWithFrame:CGRectMake(0,kNavHeight,kScreenWidth,66) titles:@[@"Komentar yang saya kirimkan",@"Balasan komentar saya",@"Pemberitahuan"]];
        _menuView.delegate = self;
    }
    return _menuView;
}

#pragma mark 消息
-(PPBadgeLabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[PPBadgeLabel alloc] initWithFrame:CGRectMake(kScreenWidth-15, kNavHeight+15, 8, 8)];
    }
    return _msgLabel;
}

#pragma mark 我发出的
-(MyCommentTableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[MyCommentTableView alloc] initWithFrame:CGRectMake(0, self.menuView.bottom+10, kScreenWidth, kScreenHeight-self.menuView.bottom-10) style:UITableViewStylePlain];
        _myTableView.viewDelegate = self;
    }
    return _myTableView;
}

#pragma mark 回复我的
-(CommentMeTableView *)replyTableView{
    if (!_replyTableView) {
        _replyTableView = [[CommentMeTableView alloc] initWithFrame:CGRectMake(0, self.menuView.bottom+10, kScreenWidth, kScreenHeight-self.menuView.bottom-10) style:UITableViewStylePlain];
        _replyTableView.viewDelegate = self;
    }
    return _replyTableView;
}

#pragma mark 消息
-(MessageTableView *)messageTableView{
    if (!_messageTableView) {
        _messageTableView = [[MessageTableView alloc] initWithFrame:CGRectMake(0, self.menuView.bottom+10, kScreenWidth, kScreenHeight-self.menuView.bottom-10) style:UITableViewStylePlain];
    }
    return _messageTableView;
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

-(NSMutableArray *)myCommentsArray{
    if (!_myCommentsArray) {
        _myCommentsArray = [[NSMutableArray alloc] init];
    }
    return _myCommentsArray;
}

-(MyCommentModel *)selComment{
    if (!_selComment) {
        _selComment = [[MyCommentModel alloc] init];
    }
    return _selComment;
}

@end
