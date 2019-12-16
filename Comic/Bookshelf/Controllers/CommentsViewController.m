//
//  CommentsViewController.m
//  Comic
//
//  Created by vision on 2019/11/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentDetailsViewController.h"
#import "SlideMenuView.h"
#import "InputToolbarView.h"
#import "ReplyToolBarView.h"
#import "CommentTableViewCell.h"
#import "BlankView.h"
#import "CommentModel.h"
#import "CommentTool.h"
#import <MJRefresh/MJRefresh.h>

@interface CommentsViewController ()<SlideMenuViewDelegate,ReplyToolBarViewDelegate,InputToolbarViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,CommentTableViewCellDelegate>{
    NSInteger   selectedIndex;
}

@property (nonatomic,strong) UIView            *navBarView;
@property (nonatomic,strong) UITableView       *myTableView;
@property (nonatomic,strong) UIView            *layerView;  //蒙层
@property (nonatomic,strong) ReplyToolBarView  *tempReplyBarView;
@property (nonatomic,strong) ReplyToolBarView  *replyBarView;
@property (nonatomic,strong) InputToolbarView  *commentBarView;

@property (nonatomic,strong) BlankView         *blankView;

@property (nonatomic,strong) NSMutableArray    *myCommentsArray;

@property (nonatomic,assign) NSInteger         page;

@property (nonatomic,strong) CommentModel      *selComment;
@property (nonatomic,assign) NSInteger         replyedUid;
@property (nonatomic,assign) NSInteger         selReplyId;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    selectedIndex = 0;
    self.page = 1;
    self.replyedUid = 0;
    self.selReplyId = 0;
    
    [self initCommentsView];
    [self loadCommentsData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([ComicManager sharedComicManager].isCommentLoad) {
        [self loadCommentsData];
        [ComicManager sharedComicManager].isCommentLoad = NO;
    }
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myCommentsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdenditifier = @"CommentTableViewCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenditifier];
    if (cell==nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenditifier];
        cell.cellDelegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CommentModel *model = self.myCommentsArray[indexPath.row];
    cell.commentModel = model;
    
    cell.likeBtn.tag = indexPath.row;
    [cell.likeBtn addTarget:self action:@selector(setCommentLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = self.myCommentsArray[indexPath.row];
    return [CommentTool getCommentCellHeightWithModel:model];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyLog(@"commentTableViewDidReplyMainComment-----回复评论");
    if ([ComicManager hasSignIn]) {
        CommentModel *model = self.myCommentsArray[indexPath.row];
        self.selComment = model;
        [self showReplyBarView];
    }else{
        [self presentLoginVC];
    }
    
}

#pragma mark -- Event response
#pragma mark 评论
-(void)rightNavigationItemAction{
    if ([ComicManager hasSignIn]) {
        [self showCommentBarView];
    }else{
        [self presentLoginVC];
    }
}

#pragma mark 隐藏
-(void)hideCommentCurrentView{
    [self hideAllView];
}

#pragma mark 点赞
-(void)setCommentLikeAction:(UIButton *)sender{
    CommentModel *model = self.myCommentsArray[sender.tag];
    model.is_like = [NSNumber numberWithBool:YES];
    NSInteger count = [model.like integerValue];
    count += 1;
    model.like = [NSNumber numberWithInteger:count];
    [self.myTableView reloadData];
    
    NSDictionary *params;
    if (self.type==1) {//点赞漫画评论
        params = @{@"token":kUserTokenValue,@"relation_id":model.comment_id,@"type":[NSNumber numberWithInteger:3]};
    }else{//点赞章节评论
        params = @{@"token":kUserTokenValue,@"relation_id":model.comment_id,@"type":[NSNumber numberWithInteger:4]};
    }
    [[HttpRequest sharedInstance] postWithURLString:kSetLikeBookAPI showLoading:NO parameters:params success:^(id responseObject) {
        
    } failure:^(NSString *errorStr) {
        
    }];
}

#pragma mark -- delegate
#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage *curImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = [UIImage zipNSDataWithImage:curImage];
    NSString *encodeResult = [imageData base64EncodedStringWithOptions:0]; //base64
    [[HttpRequest sharedInstance] postWithURLString:kUploadPicAPI showLoading:YES parameters:@{@"pic":encodeResult} success:^(id responseObject) {
        NSString *imgUrl = [responseObject objectForKey:@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.commentBarView.contentImageUrl = imgUrl;
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark  SlideMenuViewDelegate
-(void)slideMenuView:(SlideMenuView *)menuView didSelectedWithIndex:(NSInteger)index{
    selectedIndex = index;
    self.page = 1;
    [self loadCommentsData];
}

#pragma mark CommentTableViewCellDelegate
#pragma mark 查看详情
-(void)commentTableViewCellDidCheckCommentDetails:(CommentModel *)model{
    MyLog(@"commentTableViewDidCheckCommentDetailsWithModel-----查看详情");
    CommentDetailsViewController *detailsVC = [[CommentDetailsViewController alloc] init];
    detailsVC.commentId = model.comment_id;
    detailsVC.type = self.type;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark 回复回复
-(void)commentTableViewCellDidReplyWithModel:(CommentModel *)model commentedUserId:(NSNumber *)uid replyId:(NSNumber *)replyId commented_nick:(NSString *)name{
    MyLog(@"commentTableViewDidReplyOtherReplyWithModel-----回复回复---commentedUserId:%@,replyId:%@, commented_nick:%@",uid,replyId,name);
    if ([ComicManager hasSignIn]) {
        self.selComment = model;
        self.replyedUid = [uid integerValue];
        self.selReplyId = [replyId integerValue];
        [self showReplyBarView];
    }else{
        [self presentLoginVC];
    }
}

#pragma mark ReplyToolBarViewDelegate
#pragma mark 显示输入框
-(void)replyToolBarViewDidShowBar:(ReplyToolBarView *)barView{
    if ([ComicManager hasSignIn]) {
        if (barView==self.tempReplyBarView) {
            [self showCommentBarView];
        }
    }else{
        [self presentLoginVC];
    }
}

#pragma mark 发送回复
-(void)replyToolBarView:(ReplyToolBarView *)barView didSendText:(NSString *)text{
    MyLog(@"replyToolBarView,---- text:%@",text);
    NSDictionary *params = @{@"token":kUserTokenValue,@"comment_id":self.selComment.comment_id,@"be_user_id":self.replyedUid>0?[NSNumber numberWithInteger:self.replyedUid]: self.selComment.user_id,@"reply_id":[NSNumber numberWithInteger:self.selReplyId],@"comment":text};
    [[HttpRequest sharedInstance] postWithURLString:kReplyCommentAPI showLoading:YES parameters:params success:^(id responseObject) {
        self.replyedUid = 0;
        [self loadNewCommentsListData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideAllView];
            [self.view makeToast:@"Komentar berhasil terkirim" duration:1.0 position:CSToastPositionCenter];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark InputToolbarViewDelegate
#pragma mark 选择图片
-(void)inputToolbarView:(InputToolbarView *)barView choosePhotoAtcion:(NSInteger)tag{
     self.imgPicker=[[UIImagePickerController alloc]init];
     self.imgPicker.delegate=self;
     self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
     if (tag==1) {
       if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
           self.imgPicker.sourceType=UIImagePickerControllerSourceTypeCamera;
           [self presentViewController:self.imgPicker animated:YES completion:nil];
       }else{
           [self.view makeToast:@"Kamera anda tidak bisa digunakan" duration:1.0 position:CSToastPositionCenter];
           return ;
       }
     }else{
        self.imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imgPicker animated:YES completion:nil];
    }
}

#pragma mark 发送评论
-(void)inputToolbarView:(InputToolbarView *)barView didSendText:(NSString *)text images:(NSArray *)images{
    NSString *picsStr = [[ComicManager sharedComicManager] getValueWithParams:images];
    NSDictionary *params = @{@"token":kUserTokenValue,@"book_id":self.book_id,@"catalogue_id":self.type==1?@0:self.chapter_id,@"pics":picsStr,@"comment":text};
    [[HttpRequest sharedInstance] postWithURLString:kCommentBookAPI showLoading:YES parameters:params success:^(id responseObject) {
        [ComicManager sharedComicManager].isBookDetailsLoad = YES;
        [self loadNewCommentsListData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideAllView];
            [self.view makeToast:@"Komentar berhasil terkirim" duration:1.0 position:CSToastPositionCenter];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark -- Private methods
#pragma mark 界面初始化
-(void)initCommentsView{
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.tempReplyBarView];
    [self.myTableView addSubview:self.blankView];
    self.blankView.hidden = YES;
}

#pragma mark
-(void)loadNewCommentsListData{
    self.page = 1;
    [self loadCommentsData];
}

-(void)loadMoreCommentsListData{
    self.page ++;
    [self loadCommentsData];
}

#pragma mark 加载评论数据
-(void)loadCommentsData{
    NSDictionary *params = @{@"token":kUserTokenValue,@"book_id":self.book_id,@"type":[NSNumber numberWithInteger:self.type],@"catalogue_id":self.type==1?@0:self.chapter_id,@"state":[NSNumber numberWithInteger:selectedIndex],@"page":[NSNumber numberWithInteger:self.page],@"pagesize":@15};
    [[HttpRequest sharedInstance] postWithURLString:kBookCommentsAPI showLoading:YES parameters:params success:^(id responseObject) {
        NSArray *comments = [responseObject objectForKey:@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in comments) {
            CommentModel *model = [[CommentModel alloc] init];
            [model setValues:dict];
            [tempArr addObject:model];
        }
        if (self.page==1) {
            self.myCommentsArray = tempArr;
        }else{
            [self.myCommentsArray addObjectsFromArray:tempArr];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.myTableView.mj_footer.hidden = tempArr.count<15;
            self.blankView.hidden = self.myCommentsArray.count>0;
            [self.myTableView.mj_header endRefreshing];
            [self.myTableView.mj_footer endRefreshing];
            [self.myTableView reloadData];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView.mj_header endRefreshing];
            [self.myTableView.mj_footer endRefreshing];
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 显示评论框
-(void)showCommentBarView{
    [self.view addSubview:self.layerView];
    [self.view addSubview:self.commentBarView];
    [UIView animateWithDuration:0.3 animations:^{
        self.commentBarView.frame = CGRectMake(0, kScreenHeight-105, kScreenWidth, 105);
        [self.commentBarView.commentTextView becomeFirstResponder];
    }];
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

#pragma mark 隐藏所有蒙层
-(void)hideAllView{
    [UIView animateWithDuration:0.3 animations:^{
        if (self.commentBarView) {
            [self.commentBarView.commentTextView resignFirstResponder];
            self.commentBarView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 105);
        }
        if (self.replyBarView) {
            [self.replyBarView.replyTextFiled resignFirstResponder];
            self.replyBarView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 60);
        }
    } completion:^(BOOL finished) {
        if (self.commentBarView) {
            [self.commentBarView removeFromSuperview];
            self.commentBarView = nil;
        }
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
#pragma mark 导航栏
-(UIView *)navBarView{
    if (!_navBarView) {
        _navBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
        _navBarView.backgroundColor = [UIColor whiteColor];
        
        UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
        [backBtn setImage:[UIImage drawImageWithName:@"return_black"size:CGSizeMake(12, 18)] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
        [backBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:backBtn];
        
        SlideMenuView *menuView = [[SlideMenuView alloc] initWithFrame:CGRectMake(60, KStatusHeight+2,kScreenWidth-120, 40) btnTitleFont:[UIFont regularFontWithSize:18] color:[UIColor colorWithHexString:@"#9B9B9B"] selColor:[UIColor commonColor_black]];
        menuView.backgroundColor = [UIColor whiteColor];
        menuView.selectTitleFont = [UIFont mediumFontWithSize:18.0f];
        menuView.lineWidth = 16.0;
        menuView.myTitleArray =[NSMutableArray arrayWithArray:@[@"Terbaru",@"Terpopuler"]];
        menuView.currentIndex = 0;
        menuView.delegate = self;
        [_navBarView addSubview:menuView];
        
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-45, KStatusHeight+2, 40, 40)];
        [rightBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:rightBtn];
        
    }
    return _navBarView;
}

#pragma mark 评论列表
-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navBarView.bottom, kScreenWidth, kScreenHeight-self.navBarView.bottom-60) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.tableFooterView = [[UIView alloc] init];
        
        //  下拉加载最新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewCommentsListData)];
        header.automaticallyChangeAlpha=YES;
        header.lastUpdatedTimeLabel.hidden=YES;
        _myTableView.mj_header=header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCommentsListData)];
        footer.automaticallyRefresh = NO;
        _myTableView.mj_footer = footer;
        footer.hidden=YES;
    }
    return _myTableView;
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
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCommentCurrentView)];
        [_layerView addGestureRecognizer:tap];
    }
    return _layerView;
}

#pragma mark 评论框
-(InputToolbarView *)commentBarView{
    if (!_commentBarView) {
        _commentBarView = [[InputToolbarView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth,105)];
        _commentBarView.type = InputToolbarViewTypeComment;
        _commentBarView.delegate = self;
    }
    return _commentBarView;
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

#pragma mark 空白页
-(BlankView *)blankView{
    if (!_blankView) {
        _blankView = [[BlankView alloc] initWithFrame:CGRectMake(0,60, kScreenWidth, 200) img:@"default_page_comment" msg:@"Sementara tidak ada komentar"];
    }
    return _blankView;
}

- (CommentModel *)selComment{
    if (!_selComment) {
        _selComment = [[CommentModel alloc] init];
    }
    return _selComment;
}

@end
