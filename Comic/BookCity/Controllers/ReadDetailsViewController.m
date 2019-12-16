//
//  ReadDetailsViewController.m
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ReadDetailsViewController.h"
#import "MemberCenterViewController.h"
#import "RechargeViewController.h"
#import "MoreSettingsViewController.h"
#import "CommentsViewController.h"
#import "BookDetailsViewController.h"
#import "BaseWebViewController.h"
#import "ReadingTableViewCell.h"
#import "CommentTableViewCell.h"
#import "ToolBarView.h"
#import "InputToolbarView.h"
#import "BarrageTypeView.h"
#import "OrdinaryBarrageTypeView.h"
#import "BookListView.h"
#import "ReadSettingsView.h"
#import "ReadingFooterView.h"
#import "CommentTool.h"
#import "ReadConsumeKoinView.h"
#import "ReadFooterModel.h"
#import "BookSelectionModel.h"
#import "BarrageModel.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import <SVProgressHUD.h>

@interface ReadDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,ToolBarViewDelegate,InputToolbarViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ReadingFooterViewDelegate,ReadSettingsViewDelegate,UIScrollViewDelegate,BookListViewDelegate>{
    BOOL          hasShowBar;
    BOOL          isEditBarrage;
    NSTimer       *myTimer;
    double        animSpeed;
}

@property (nonatomic,strong) UIView            *navbarView;
@property (nonatomic,strong) UILabel           *titleLabel;
@property (nonatomic,strong) UITableView       *booksTableView;
@property (nonatomic,strong) ReadingFooterView *readFooterView;
@property (nonatomic,strong) ToolBarView       *toolBarView;
@property (nonatomic,strong) UIView            *layerView;           //蒙层
@property (nonatomic,strong) InputToolbarView  *barrageInputBarView;    //弹幕输入框
@property (nonatomic,strong) BarrageTypeView   *barrageTypeView;        //付费弹幕样式
@property (nonatomic,strong) OrdinaryBarrageTypeView  *commonTypeView;  //普通弹幕模式
@property (nonatomic,strong) InputToolbarView  *commentInputBarView; //评论输入框
@property (nonatomic,strong) UIButton          *cancelBtn;       //取消弹幕
@property (nonatomic,strong) UIButton          *confirmBtn;      //确定弹幕
@property (nonatomic,strong) BookListView      *listView;        //目录
@property (nonatomic,strong) ReadSettingsView  *settingsView;    //设置
@property (nonatomic,strong) UIButton          *pageUpBtn;      //上翻页
@property (nonatomic,strong) UIButton          *pageDownBtn;      //下翻页
@property (nonatomic,strong) UIButton          *addShelfBtn;     //加入书架
@property (nonatomic,strong) UIButton          *toTopBtn;        //回到顶部


@property (nonatomic,strong) NSMutableArray  *pagesArray;
@property (nonatomic,strong) NSMutableArray  *commentsArray;
@property (nonatomic,strong) NSMutableArray  *selectionsArray;
@property (nonatomic,strong) NSMutableArray  *barragesArray;
@property (nonatomic,strong) NSMutableArray  *selBarragesArray;

@property (nonatomic,assign) NSInteger       selBarrageIndex;

@property (nonatomic,strong) ReadFooterModel *readFooterModel;   //底部视图数据
@property (nonatomic,strong) BarrageModel    *barrageModel;

@property (nonatomic,assign) NSInteger      selBarrageType;
@property (nonatomic,assign) NSInteger      selectedPage;
@property (nonatomic,assign) CGFloat        currentScrollOffsetY;

@property (nonatomic,assign) NSInteger      listPage;  //目录分页


@end

static const CGFloat imageCellHeight = 250.0f;

@implementation ReadDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenNavBar = YES;
    
    self.selBarrageType = 0;
    self.selectedPage = 0;
    self.currentScrollOffsetY = 0.0;
    self.listPage = 1;
    
    [self initReadDetailsView];
    [self readSettingsCallBack];
    [self loadBookReadingDetailsData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([ComicManager sharedComicManager].isReadDetailsLoad) {
        [self loadBookReadingDetailsData];
        [ComicManager sharedComicManager].isReadDetailsLoad = NO;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (myTimer) {
        [myTimer invalidate];
        myTimer = nil;
    }
}

#pragma mark UITableViewDataSource and UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
       return self.pagesArray.count;
    }else{
       return self.commentsArray.count;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return nil;
    }else{
        if (self.commentsArray.count>0) {
            UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
            aView.backgroundColor = [UIColor whiteColor];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 4, 18)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#915AFF"];
            [lineView setBorderWithCornerRadius:2 type:UIViewCornerTypeAll];
            [aView addSubview:lineView];
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 120, 18)];
            titleLab.text = @"Komentar";
            titleLab.font = [UIFont mediumFontWithSize:18];
            titleLab.textColor = [UIColor commonColor_black];
            [aView addSubview:titleLab];
            
            return aView;
        }else{
            return nil;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        return self.readFooterView;
    }else{
        return nil;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString *identifier = @"ReadingTableViewCell";
        ReadingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [[ReadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CatalogueModel *model = self.pagesArray[indexPath.row];
        cell.catalogueModel = model;
        
        cell.contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTopAndBottomViewAction:)];
        [cell.contentView addGestureRecognizer:tap];
        return cell;
    }else{
        static NSString *identifier = @"CommentTableViewCell";
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CommentModel *model = self.commentsArray[indexPath.row];
        cell.commentModel = model;
        
        cell.likeBtn.tag = indexPath.row;
        [cell.likeBtn addTarget:self action:@selector(setChapterCommentLikeAtion:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&self.pagesArray.count>0) {
        CatalogueModel *model = self.pagesArray[indexPath.row];
        CGFloat imgW = [model.width floatValue];
        CGFloat imgH = [model.height floatValue];
        return kScreenWidth*(imgH/imgW);
    }else{
        CommentModel *model = self.commentsArray[indexPath.row];
        return [CommentTool getCommentCellHeightWithModel:model];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01;
    }else{
        if (self.commentsArray.count>0) {
            return 40;
        }else{
           return 0.01;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        if (self.readFooterModel.banner_dict.count>0&&self.readFooterModel.books.count>0) {
            return 576;
        }else if(self.readFooterModel.banner_dict.count>0&&self.readFooterModel.books.count==0){
            return 316;
        }else if (self.readFooterModel.banner_dict.count==0&&self.readFooterModel.books.count>0){
            return 426;
        }else{
            return 166;
        }
    }else{
        return 0.01;
    }
}

#pragma mark - Delegate
#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage *curImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = [UIImage zipNSDataWithImage:curImage];
    NSString *encodeResult = [imageData base64EncodedStringWithOptions:0]; //base64
    [[HttpRequest sharedInstance] postWithURLString:kUploadPicAPI showLoading:YES parameters:@{@"pic":encodeResult} success:^(id responseObject) {
        NSString *imgUrl = [responseObject objectForKey:@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.commentInputBarView.contentImageUrl = imgUrl;
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark UIScrollViewDelegate
#pragma mark 滚动中
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.currentScrollOffsetY = scrollView.contentOffset.y;
    self.selectedPage = self.currentScrollOffsetY/kScreenHeight;
    BOOL pageTurn = [[NSUserDefaultsInfos getValueforKey:kClickPageTurn] boolValue];
    if (!pageTurn) {
        if (self.currentScrollOffsetY>self.pagesArray.count*(kScreenWidth*(666.0/85.0))-120) {
            self.pageUpBtn.hidden = YES;
        }else if (self.currentScrollOffsetY<kScreenHeight){
            self.pageUpBtn.hidden = YES;
        }else{
            self.pageUpBtn.hidden = NO;
        }
        
        if (self.currentScrollOffsetY>self.pagesArray.count*(kScreenWidth*(666.0/85.0))-kScreenHeight) {
            self.pageDownBtn.hidden = YES;
        }else{
            self.pageDownBtn.hidden = NO;
        }
    }
}


#pragma mark 停止滚动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    MyLog(@"scrollViewDidEndDragging----OffsetY:%.f",self.currentScrollOffsetY);
    if (!decelerate) {
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [self showBarragePlay];
        }
    }
}

#pragma mark ToolBarViewDelegate
#pragma mark 关闭或开启弹幕
-(void)toolBarViewSetBarrageOpen:(BOOL)isOpen{
    if (isOpen) {
        [self showBarragePlay];
    }else{
        [self closeBarrage];
    }
}

#pragma mark 发弹幕或评论
-(void)toolBarViewStartEditWithType:(NSInteger)type{
    if ([ComicManager hasSignIn]) {
        if (type==0) {
            [self.view addSubview:self.layerView];
            [self.view addSubview:self.barrageInputBarView];
            [UIView animateWithDuration:0.3 animations:^{
                self.barrageInputBarView.frame = CGRectMake(0, kScreenHeight-60, kScreenWidth, 60);
                [self.barrageInputBarView.commentTextView becomeFirstResponder];
            }];
        }else{
           [self.view addSubview:self.layerView];
           [self.view addSubview:self.commentInputBarView];
           [UIView animateWithDuration:0.3 animations:^{
               self.commentInputBarView.frame = CGRectMake(0, kScreenHeight-105, kScreenWidth, 105);
               [self.commentInputBarView.commentTextView becomeFirstResponder];
           }];
        }
    }else{
        [self presentLoginVC];
    }
}

#pragma mark 上一话 下一话
-(void)toolBarViewShowBookNewChapterWithTag:(NSInteger)tag{
    [self turnToNewPageWithIndex:tag];
}

#pragma mark 目录 评论 分享 设置
-(void)toolBarViewHandleEventWithTag:(NSInteger)tag{
    if (tag==100) { //目录
        [self showBookListView];
    }else if (tag==101){ //评论
        CommentsViewController *commentVC = [[CommentsViewController alloc] init];
        commentVC.book_id = self.bookId;
        commentVC.type = 2;
        commentVC.chapter_id = self.catalogue_id;
        [self.navigationController pushViewController:commentVC animated:YES];
    }else if (tag==102){ //分享
        [self shareToFriends];
    }else{ //设置
        [self showReadSettingsView];
    }
}

#pragma mark BookListViewDelegate
#pragma mark 选择章节
-(void)bookListViewDidChooseSelection:(BookSelectionModel *)selectionModel{
    self.catalogue_id = selectionModel.catalogue_id;
    [self hideCurrentView];
    [self loadBookReadingDetailsData];
}

#pragma mark InputToolbarViewDelegate
#pragma mark 选择弹幕
-(void)inputToolbarView:(InputToolbarView *)barView didSelectedBarrageType:(NSInteger)type{
    if (barView==self.barrageInputBarView) {
        NSArray *typesArr = [ComicManager sharedComicManager].barrageTypesArray;
        [self.view addSubview:self.barrageTypeView];
        //设置弹幕样式
        self.barrageTypeView.typeDict = typesArr[type-1];
        self.selBarrageType = type;
    }
}

#pragma mark 选择图片
-(void)inputToolbarView:(InputToolbarView *)barView choosePhotoAtcion:(NSInteger)tag{
    if (barView==self.commentInputBarView) {
         self.imgPicker=[[UIImagePickerController alloc]init];
         self.imgPicker.delegate=self;
         self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        if (tag==1) {
           if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) //判断设备相机是否可用
           {
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
}

#pragma mark 开通会员、去充值
-(void)inputToolbarView:(InputToolbarView *)barView toastViewHanderActionWithType:(NSInteger)type{
    if (barView==self.barrageInputBarView) {
        if (type==0) { //开通会员
            MemberCenterViewController *memberCenterVC = [[MemberCenterViewController alloc] init];
            [self.navigationController pushViewController:memberCenterVC animated:YES];
        }else{ //充值
            RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
    }
}

#pragma mark 发送弹幕或评论
-(void)inputToolbarView:(InputToolbarView *)barView didSendText:(NSString *)text images:(NSArray *)images{
    MyLog(@"inputToolbarView-- didSendText:%@",text);
    if (barView==self.barrageInputBarView) { //弹幕
        [UIView animateWithDuration:0.3 animations:^{
            [self.barrageInputBarView.commentTextView resignFirstResponder];
            self.barrageInputBarView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 60);
        } completion:^(BOOL finished) {
            [self.barrageInputBarView removeFromSuperview];
            self.barrageInputBarView = nil;
        }];
        hasShowBar = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.navbarView.frame = CGRectMake(0,-kNavHeight, kScreenWidth, kNavHeight);
            self.toolBarView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 138);
        } completion:^(BOOL finished) {
            [self.navbarView removeFromSuperview];
            [self.toolBarView removeFromSuperview];
        }];
        
        //进入弹幕编辑模式
        self.barrageModel = [[BarrageModel alloc] init];
        self.barrageModel.barrage_content = text;
        isEditBarrage = YES;
        if (self.selBarrageType>0) { //付费弹幕
            self.barrageModel.xcoord = [NSNumber numberWithDouble:self.barrageTypeView.x];
            self.barrageModel.ycoord = [NSNumber numberWithDouble:self.barrageTypeView.y];
            self.barrageModel.style_id = [NSNumber numberWithInteger:self.selBarrageType];
            
            self.barrageTypeView.contentText = text;
            self.barrageTypeView.canMove = YES;
            self.selBarrageType = 0;
        }else{ //默认弹幕样式
            self.selBarrageType = 0;
            [self.view addSubview:self.commonTypeView];
            self.commonTypeView.contentText = text;
            self.barrageModel.xcoord = [NSNumber numberWithDouble:self.commonTypeView.x];
            self.barrageModel.ycoord = [NSNumber numberWithDouble:self.commonTypeView.y];
            self.barrageModel.style_id = [NSNumber numberWithInteger:self.selBarrageType];
        }
        [self.view addSubview:self.cancelBtn];
        [self.view addSubview:self.confirmBtn];
    }else{ // 评论
        NSString *picsStr = [[ComicManager sharedComicManager] getValueWithParams:images];
        NSDictionary *params = @{@"token":kUserTokenValue,@"book_id":self.bookId,@"catalogue_id":self.catalogue_id,@"pics":picsStr,@"comment":text};
        [[HttpRequest sharedInstance] postWithURLString:kCommentBookAPI showLoading:YES parameters:params success:^(id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideCurrentView];
                [self.view makeToast:@"Komentar berhasil terkirim" duration:1.0 position:CSToastPositionCenter];
            });
        } failure:^(NSString *errorStr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
            });
        }];
    }
}

#pragma mark ReadingFooterViewDelegate
#pragma mark 点赞 加入书架 分享
-(void)readingFooterViewClickBtnActionWithTag:(NSInteger)tag{
    if (tag==100) { //点赞章节
        [self readDetailSetlikeWithRelationId:self.catalogue_id type:2];
    }else if (tag==101){ //加入书架
        [self addToBookShelf];
    }else{ //分享
        [self shareToFriends];
    }
}

#pragma mark 上一话 下一话
-(void)readingFooterViewPageTurnActionWithTag:(NSInteger)tag{
    [self turnToNewPageWithIndex:tag];
}

#pragma mark 点击banner
-(void)readingFooterViewDidClickBanner:(BannerModel *)banner{
    if ([banner.banner_cate integerValue]==1) {
        BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
        webVC.webTitle = banner.banner_name;
        webVC.urlStr = banner.banner_url;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
}

#pragma makr 选择漫画
-(void)readingFooterViewDidSelectedBook:(NSNumber *)bookId{
    BookDetailsViewController *bookDetailsVC = [[BookDetailsViewController alloc] init];
    bookDetailsVC.bookId = bookId;
    bookDetailsVC.currentIndex = 0;
    [self.navigationController pushViewController:bookDetailsVC animated:YES];
}

#pragma mark ReadSettingsViewDelegate
#pragma mark 更多设置
-(void)readSettingsViewDidMoreSettings{
    [self hideCurrentView];
    MoreSettingsViewController *moreSettingVC = [[MoreSettingsViewController alloc] init];
    moreSettingVC.modalPresentationStyle = 0;
    kSelfWeak;
    moreSettingVC.setBlock = ^{
        [weakSelf readSettingsCallBack];
    };
    [self presentViewController:moreSettingVC animated:YES completion:nil];
}

#pragma mark 设置成功
-(void)readSettingsViewDidSetSuccess{
    [self readSettingsCallBack];
}

#pragma mark -- Event response
#pragma mark 全集
-(void)rightNavigationItemAction{
    BookDetailsViewController *bookDetailsVC = [[BookDetailsViewController alloc] init];
    bookDetailsVC.bookId = self.bookId;
    bookDetailsVC.currentIndex = 1;
    [self.navigationController pushViewController:bookDetailsVC animated:YES];
}

#pragma mark 显示或隐藏工具栏
-(void)showTopAndBottomViewAction:(UITapGestureRecognizer *)sender{
    if (hasShowBar) {
        hasShowBar = NO;
        self.addShelfBtn.hidden = self.toTopBtn.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.navbarView.frame = CGRectMake(0,-kNavHeight, kScreenWidth, kNavHeight);
            self.toolBarView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 138);
        } completion:^(BOOL finished) {
            [self.navbarView removeFromSuperview];
            self.navbarView = nil;
            [self.toolBarView removeFromSuperview];
            self.toolBarView = nil;
        }];
    }else{
        hasShowBar = YES;
        if ([self.readFooterModel.state boolValue]) {
            self.addShelfBtn.hidden = YES;
        }else{
            self.addShelfBtn.hidden = NO;
        }
        self.toTopBtn.hidden = NO;
        [self.view addSubview:self.navbarView];
        self.titleLabel.text = self.readFooterModel.catalogue_name;
        [self.view addSubview:self.toolBarView];
        self.toolBarView.commentCount = [self.readFooterModel.comment_count integerValue];
        [UIView animateWithDuration:0.3 animations:^{
            self.navbarView.frame = CGRectMake(0, 0, kScreenWidth, kNavHeight);
            self.toolBarView.frame = CGRectMake(0, kScreenHeight-138, kScreenWidth, 138);
        }];
    }
}

#pragma mark 取消或确定编辑弹幕
-(void)editBarrageAction:(UIButton *)sender{
    isEditBarrage = NO;
    [self.cancelBtn removeFromSuperview];
    self.cancelBtn = nil;
    [self.confirmBtn removeFromSuperview];
    self.confirmBtn = nil;
    if (self.layerView) {
        [self.layerView removeFromSuperview];
        self.layerView = nil;
    }
    if (sender.tag==101) { //确定发送
        self.commonTypeView.hideLine = YES;
        CGFloat barrageY = self.currentScrollOffsetY + [self.barrageModel.ycoord doubleValue]; MyLog(@"发送弹幕-----x:%@,y:%.f,type:%@,text:%@",self.barrageModel.xcoord,barrageY,self.barrageModel.style_id,self.barrageModel.barrage_content);
        BOOL isVip = [[NSUserDefaultsInfos getValueforKey:kUserVip] boolValue];
        NSDictionary *params = @{@"token":kUserTokenValue,@"book_id":self.bookId,@"catalogue_id":self.catalogue_id,@"barrage_content":self.barrageModel.barrage_content,@"style_id":self.barrageModel.style_id,@"xcoord":self.barrageModel.xcoord,@"ycoord":[NSNumber numberWithDouble:barrageY],@"bean":isVip?@3:@5};
        [[HttpRequest sharedInstance] postWithURLString:kSendBarrageAPI showLoading:YES parameters:params success:^(id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideCurrentView];
                [self.view makeToast:@"Komentar langsung berhasil terkirim" duration:1.0 position:CSToastPositionCenter];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //显示弹幕
                if (self.barrageTypeView) {
                    [UIView animateWithDuration:1.0 animations:^{
                        [self.barrageTypeView setAlpha:0.0];
                    }completion:^(BOOL finished) {
                        [self.barrageTypeView removeFromSuperview];
                        self.barrageTypeView = nil;
                    }];
                }
                if (self.commonTypeView) {
                    [UIView animateWithDuration:1.0 animations:^{
                        [self.commonTypeView setAlpha:0.0];
                    }completion:^(BOOL finished) {
                        [self.commonTypeView removeFromSuperview];
                        self.commonTypeView = nil;
                    }];
                }
            });
        } failure:^(NSString *errorStr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.barrageTypeView) {
                    [self.barrageTypeView removeFromSuperview];
                    self.barrageTypeView = nil;
                }
                if (self.commonTypeView) {
                    [self.commonTypeView removeFromSuperview];
                    self.commonTypeView = nil;
                }
                
                [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
            });
        }];
    }else{
        if (self.barrageTypeView) {
            [self.barrageTypeView removeFromSuperview];
            self.barrageTypeView = nil;
        }
        if (self.commonTypeView) {
            [self.commonTypeView removeFromSuperview];
            self.commonTypeView = nil;
        }
    }
}

#pragma mark 隐藏
-(void)hideCurrentView{
    if (isEditBarrage) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        if (self.barrageInputBarView) {
            [self.barrageInputBarView.commentTextView resignFirstResponder];
            self.barrageInputBarView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 60);
        }
        if (self.listView) {
            self.listView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 190);
        }
        if (self.commentInputBarView) {
            [self.commentInputBarView.commentTextView resignFirstResponder];
            self.commentInputBarView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 105);
        }
        if (self.settingsView) {
            self.settingsView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 360);
        }
    } completion:^(BOOL finished) {
        if (self.barrageInputBarView) {
            [self.barrageInputBarView removeFromSuperview];
            self.barrageInputBarView = nil;
        }
        if (self.listView) {
            [self.listView removeFromSuperview];
            self.listView = nil;
        }
        if (self.commentInputBarView) {
            [self.commentInputBarView removeFromSuperview];
            self.commentInputBarView = nil;
        }
        if (self.settingsView) {
            [self.settingsView removeFromSuperview];
            self.settingsView = nil;
        }
        if (self.layerView) {
            [self.layerView removeFromSuperview];
            self.layerView = nil;
        }
        
    }];
}

#pragma mark 加入书架
-(void)addToBookShelfAction:(UIButton *)sender{
    [self addToBookShelf];
}

#pragma mark 回到顶部
-(void)backToTopAction:(UIButton *)sender{
    [UIView animateWithDuration:0.3 animations:^{
        [self.booksTableView setContentOffset:CGPointMake(0, 0)];
    }];
}

#pragma mark 翻页
-(void)pageTurnAction:(UIButton *)sener{
    if (sener.tag==100) {
        if (self.selectedPage==0) {
            return;
        }
        self.selectedPage -- ;
    }else{
        self.selectedPage ++;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.booksTableView setContentOffset:CGPointMake(0, self.selectedPage*kScreenHeight)];
    }];
}

#pragma mark 章节评论点赞
-(void)setChapterCommentLikeAtion:(UIButton *)sender{
    CommentModel *model = self.commentsArray[sender.tag];
    model.is_like = [NSNumber numberWithBool:YES];
    NSInteger likeCount = [model.like integerValue];
    likeCount ++;
    model.like = [NSNumber numberWithInteger:likeCount];
    
    [self readDetailSetlikeWithRelationId:model.comment_id type:4];
}

#pragma mark -- Private methods
#pragma mark 初始化界面
-(void)initReadDetailsView{
    [self.view addSubview:self.booksTableView];
    self.booksTableView.hidden = YES;
    [self.view addSubview:self.addShelfBtn];
    [self.view addSubview:self.toTopBtn];
    [self.view addSubview:self.pageUpBtn];
    [self.view addSubview:self.pageDownBtn];
    self.addShelfBtn.hidden = self.toTopBtn.hidden = self.pageUpBtn.hidden = self.pageDownBtn.hidden = YES;
}

#pragma mark 加载数据
-(void)loadBookReadingDetailsData{
    [self closeBarrage];
    
    NSDictionary *params = @{@"token":kUserTokenValue,@"book_id":self.bookId,@"catalogue_id":self.catalogue_id};
    [[HttpRequest sharedInstance] postWithURLString:kBookReadDetailsAPI showLoading:YES parameters:params success:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        //漫画
        NSDictionary *catalogueDict = [data valueForKey:@"catalogue"];
        self.readFooterModel = [[ReadFooterModel alloc] init];
        [self.readFooterModel setValues:catalogueDict];
        //阅读页
        NSArray *contents = self.readFooterModel.catalogue_content;
        NSMutableArray *tempContentsArr = [[NSMutableArray alloc] init];
        for (NSDictionary *cateDict in contents) {
            CatalogueModel *model = [[CatalogueModel alloc] init];
            [model setValues:cateDict];
            [tempContentsArr addObject:model];
        }
        self.pagesArray = tempContentsArr;
        //banner
        NSArray *banners = [data valueForKey:@"banner"];
        if (banners.count>0) {
            self.readFooterModel.banner_dict = banners[0];
        }else{
            self.readFooterModel.banner_dict = nil;
        }
        //推荐
        self.readFooterModel.books = [data valueForKey:@"commend"];
        //评论
        NSArray *comments = [data valueForKey:@"comment"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in comments) {
            CommentModel *model = [[CommentModel alloc] init];
            [model setValues:dict];
            [tempArr addObject:model];
        }
        self.commentsArray = tempArr;
        
        //免费 上传阅读记录
        NSInteger type  = [self.readFooterModel.type integerValue];
        if (type==0) {
            [self generateReadRecordsWithType:type+1];
        }
        
        [self loadPurchasedBarrageTypesData];
        [self loadBookSelectionsData];
        
        //加载弹幕数据
        BOOL barrageSwitch = [[NSUserDefaultsInfos getValueforKey:kBarrageSwitch] boolValue];
        if (!barrageSwitch) {
            [self loadBarrageData];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.titleLabel.text = self.readFooterModel.catalogue_name;
            self.booksTableView.hidden = NO;
            self.readFooterView.footerModel = self.readFooterModel;
            [self.booksTableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.booksTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            //需付费
            if (type==1) {
                NSInteger vipKoin = [self.readFooterModel.vip_cost integerValue];
                NSInteger costKoin= [self.readFooterModel.cost integerValue];
                
                BOOL isVip = [[NSUserDefaultsInfos getValueforKey:kUserVip] boolValue];
                NSInteger myKoin = [[NSUserDefaultsInfos getValueforKey:kMyKoin] integerValue];
                if ((isVip&&myKoin<vipKoin)||(!isVip&&myKoin<costKoin)) {
                    [self showPurchaseToastViewWithIsPaying:NO];
                }else{
                    [self showPurchaseToastViewWithIsPaying:YES];
                }
            }
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.booksTableView.hidden = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        });
    }];
}

#pragma mark 加载已购买弹幕样式
-(void)loadPurchasedBarrageTypesData{
    [[HttpRequest sharedInstance] postWithURLString:kPurchasedTypesAPI showLoading:NO parameters:@{@"token":kUserTokenValue} success:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        NSArray *stylesArr = [data valueForKey:@"style"];
        NSMutableArray *tempIdsArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in stylesArr) {
            [tempIdsArr addObject:dict[@"style_id"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.barrageInputBarView.purchasedStylesArray = tempIdsArr;
        });
    } failure:^(NSString *errorStr) {
        
    }];
}

#pragma mark 获取目录
-(void)loadBookSelectionsData{
    NSDictionary *params = @{@"token":kUserTokenValue,@"book_id":self.bookId,@"orderby":@"asc",@"page":[NSNumber numberWithInteger:self.listPage],@"pagesize":@500};
    [[HttpRequest sharedInstance] postWithURLString:kBookSelectionAPI showLoading:NO parameters:params success:^(id responseObject) {
        NSDictionary  *data = [responseObject objectForKey:@"data"];
        //总话数
        NSInteger words = [[data valueForKey:@"words"] integerValue];
        NSInteger lastWords = [[data valueForKey:@"residue_words"] integerValue];
        
        //章节数组
        NSArray *selectionsArr = [data valueForKey:@"anthology"];
        NSMutableArray *tempSelectionsArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in selectionsArr) {
            BookSelectionModel *model = [[BookSelectionModel alloc] init];
            [model setValues:dict];
            [tempSelectionsArr addObject:model];
        }
        if (self.listPage==1) {
            self.selectionsArray = tempSelectionsArr;
        }else{
            [self.selectionsArray addObjectsFromArray:tempSelectionsArr];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.listView) {
                self.listView.vipCost = [self.readFooterModel.vip_cost integerValue];
                self.listView.listArray = self.selectionsArray;
                self.listView.currentcatalogueId = self.catalogue_id;
                self.listView.progressString = [NSString stringWithFormat:@"Totalnya %ld chapter, %ld chapter belum dibaca",(long)words,(long)lastWords];
            }
        });
    }failure:^(NSString *errorStr) {
        
    }];
}


#pragma mark 生成阅读记录
-(void)generateReadRecordsWithType:(NSInteger)type{
    NSDictionary *params;
    if (type==1) {  //免费看
        params = @{@"token":kUserTokenValue,@"book_id":self.bookId,@"catalogue_id":self.catalogue_id,@"type":@1};
    }else{
        BOOL isVip = [[NSUserDefaultsInfos getValueforKey:kUserVip] boolValue];
        NSNumber *koin = isVip?self.readFooterModel.vip_cost:self.readFooterModel.cost;
        params = @{@"token":kUserTokenValue,@"book_id":self.bookId,@"catalogue_id":self.catalogue_id,@"type":@2,@"bean":koin};
    }
    if (type==2) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD show];
    }
    [[HttpRequest sharedInstance] postWithURLString:kReadRecordsAPI showLoading:NO parameters:params success:^(id responseObject) {
        if (type==2) {
            
            [ComicManager sharedComicManager].isBookSelectionsLoad = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self.view makeToast:@"Pembelian berhasil" duration:1.0 position:CSToastPositionCenter];
            });
        }
    } failure:^(NSString *errorStr) {
        if (type==2) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

#pragma mark 加载弹幕数据
-(void)loadBarrageData{
    [[HttpRequest sharedInstance] postWithURLString:kBarrageListAPI showLoading:NO parameters:@{@"book_id":self.bookId,@"catalogue_id":self.catalogue_id} success:^(id responseObject) {
        NSArray *data = [responseObject objectForKey:@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data) {
            BarrageModel *model = [[BarrageModel alloc] init];
            [model setValues:dict];
            [tempArr addObject:model];
        }
        self.barragesArray = tempArr;
    } failure:^(NSString *errorStr) {
        MyLog(@"接口地址：%@，加载失败---error：%@",kBarrageListAPI,errorStr);
    }];
}

#pragma mark 显示目录
-(void)showBookListView{
    if (self.selectionsArray.count>0) {
        [self.view addSubview:self.layerView];
        [self.view addSubview:self.listView];
        self.listView.vipCost = [self.readFooterModel.vip_cost integerValue];
        self.listView.listArray = self.selectionsArray;
        self.listView.currentcatalogueId = self.catalogue_id;
        [UIView animateWithDuration:0.3 animations:^{
            self.listView.frame = CGRectMake(0, kScreenHeight-190, kScreenWidth, 190);
        }];
    }else{
        [self loadBookSelectionsData];
    }
}

#pragma mark 显示设置框
-(void)showReadSettingsView{
    [self.view addSubview:self.layerView];
    [self.view addSubview:self.settingsView];
    [UIView animateWithDuration:0.3 animations:^{
        self.settingsView.frame = CGRectMake(0, kScreenHeight-360, kScreenWidth, 360);
    }];
}

#pragma mark 点赞
-(void)readDetailSetlikeWithRelationId:(NSNumber *)relationId type:(NSInteger)type{
    NSDictionary *params = @{@"token":kUserTokenValue,@"relation_id":relationId,@"type":[NSNumber numberWithInteger:type]};
    [[HttpRequest sharedInstance] postWithURLString:kSetLikeBookAPI showLoading:NO parameters:params success:^(id responseObject) {
         
    } failure:^(NSString *errorStr) {
        
    }];
}

#pragma mark 加入书架
-(void)addToBookShelf{
    MyLog(@"addToBookShelf");
    if ([ComicManager hasSignIn]) {
        [[HttpRequest sharedInstance] postWithURLString:kAddBookShelfAPI showLoading:YES parameters:@{@"token":kUserTokenValue,@"book_id":self.bookId} success:^(id responseObject) {
            self.readFooterModel.state = [NSNumber numberWithBool:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.addShelfBtn.hidden = YES;
                self.readFooterView.footerModel = self.readFooterModel;
            });
        } failure:^(NSString *errorStr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
            });
        }];
    }else{
        [self presentLoginVC];
    }
}

#pragma mark 翻书
-(void)turnToNewPageWithIndex:(NSInteger)index{
    if (index==0) { //上一话
        if ([self.readFooterModel.pre_catalogue_id integerValue]==0) {
            return;
        }
        self.catalogue_id = self.readFooterModel.pre_catalogue_id;
    }else{ //下一话
        if ([self.readFooterModel.next_catalogue_id integerValue]==0) {
            return;
        }
        self.catalogue_id = self.readFooterModel.next_catalogue_id;
    }
    [self loadBookReadingDetailsData];
}

#pragma mark 分享
-(void)shareToFriends{
    [UMSocialShareUIConfig shareInstance].shareContainerConfig.shareContainerCornerRadius = 8.0;
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewTitleString = @"share";  //面板标题
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewFont = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewPaddingTop = 10.0;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPadingBottom = 10.0;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageMaxItemSpaceBetweenIconAndName = 10.0;
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;  //不显示取消
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Facebook),@(UMSocialPlatformType_Whatsapp)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        UIImage *image = [UIImage imageNamed:@"login_logo"];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"Ayo sini ! Kita bertemu di APP Pulau Komik" descr:@"Bersama kami membaca banyak sekali komik yang menarik" thumImage:image];
        shareObject.webpageUrl = [NSString stringWithFormat:kHostTempURL,kShareUrl];
        messageObject.shareObject = shareObject;
        
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
            MyLog(@"分享完成 --- result:%@",result);
            if (!error) {
                [self verificationDailyTask];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToast:@"Berbagi kesuksesan" duration:1.0 position:CSToastPositionCenter];
                });
            } else {
                if (error.code == 2009) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view makeToast:@"Batalkan berbagi" duration:1.0 position:CSToastPositionCenter];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view makeToast:error.localizedDescription duration:1.0 position:CSToastPositionCenter];
                    });
                }
                MyLog(@"分享失败， error:%@",error.localizedDescription);
            }
        }];
    }];
    
}

#pragma mark 设置处理
-(void)readSettingsCallBack{
    //翻页
    BOOL pageTurn = [[NSUserDefaultsInfos getValueforKey:kClickPageTurn] boolValue];
    if (!pageTurn) {
        self.pageUpBtn.hidden = self.pageDownBtn.hidden = NO;
    }else{
        self.pageUpBtn.hidden = self.pageDownBtn.hidden = YES;
    }
    //调节亮度
    CGFloat value = [UIScreen mainScreen].brightness;
    MyLog(@"亮度---value:%.f",value);
    BOOL lightMode = [[NSUserDefaultsInfos getValueforKey:kNightMode] boolValue];
    if (lightMode) {
        [[UIScreen mainScreen] setBrightness:0.2];
    }else{
        [[UIScreen mainScreen] setBrightness:value];
    }
    
    double speed = [[NSUserDefaultsInfos getValueforKey:kBarrageSpeed] doubleValue];
    animSpeed = 4.0*(speed>0.0?speed:1.0);
    MyLog(@"弹幕播放速度--%.f",animSpeed);
    
    BOOL barrageSwitch = [[NSUserDefaultsInfos getValueforKey:kBarrageSwitch] boolValue];
    if (!barrageSwitch) {
        [self showBarragePlay];
    }else{
        if (myTimer) {
            [myTimer invalidate];
            myTimer = nil;
        }
    }
}

#pragma mark 付费提示
-(void)showPurchaseToastViewWithIsPaying:(BOOL)isPaying{
    NSInteger vipKoin = [self.readFooterModel.vip_cost integerValue];
    NSInteger costKoin= [self.readFooterModel.cost integerValue];
    [ReadConsumeKoinView showConsumeKoinWithFrame:CGRectMake(0, 0, 280, 220) costKoin:costKoin vipCoin:vipKoin isPaying:isPaying confirmAction:^{
        if (isPaying) {
            [self generateReadRecordsWithType:2];
        }else{
            RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
    } cancelAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark 显示弹幕
-(void)showBarragePlay{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    if (self.barragesArray.count>0) {
        for (BarrageModel *model in self.barragesArray) {
            CGFloat orginY = [model.ycoord doubleValue];
            if (orginY>self.currentScrollOffsetY&&orginY<self.currentScrollOffsetY+kScreenHeight) {
                [tempArr addObject:model];
            }
        }
    }
    self.selBarragesArray = tempArr;
    if (self.selBarragesArray.count>0) {
        self.selBarrageIndex = 0;
        myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(playBarrage) userInfo:nil repeats:YES];
    }
}

#pragma mark 播放弹幕
-(void)playBarrage{
    MyLog(@"playBarrage-------%ld",(long)self.selBarrageIndex);
    
    BarrageModel *barrage = self.selBarragesArray[self.selBarrageIndex];
    CGFloat originX = [barrage.xcoord floatValue];
    CGFloat orginY = [barrage.ycoord floatValue];
    NSInteger type = [barrage.style_id integerValue];
    NSArray *typesArr = [ComicManager sharedComicManager].barrageTypesArray;
    if ([barrage.style_id integerValue]>0) {
        BarrageTypeView *typeView = [[BarrageTypeView alloc] initWithFrame:CGRectMake(originX, orginY, 100, 64)];
        typeView.canMove = NO;
        typeView.typeDict = typesArr[type-1];
        typeView.contentText = barrage.barrage_content;
        typeView.alpha = 1.0;
        [self.booksTableView addSubview:typeView];
        [UIView animateWithDuration:animSpeed animations:^{
            typeView.alpha = 0.0;
        }completion:^(BOOL finished) {
            [typeView removeFromSuperview];
        }];
    }else{
        OrdinaryBarrageTypeView *commonView = [[OrdinaryBarrageTypeView alloc] initWithFrame:CGRectMake(originX, orginY, 100, 32)];
        commonView.hideLine = YES;
        commonView.contentText = barrage.barrage_content;
        commonView.alpha = 1.0;
        [self.booksTableView addSubview:commonView];
        [UIView animateWithDuration:animSpeed animations:^{
            commonView.alpha = 0.0;
        }completion:^(BOOL finished) {
            [commonView removeFromSuperview];
        }];
    }
    if (self.selBarrageIndex==self.selBarragesArray.count-1) {
       if (myTimer) {
           [myTimer invalidate];
           myTimer = nil;
       }
       return;
    }
    
    self.selBarrageIndex ++;
}

#pragma mark 关闭弹幕
-(void)closeBarrage{
    if (myTimer) {
        [myTimer invalidate];
        myTimer = nil;
    }
    self.selBarrageIndex = 0;
    
    for (UIView *aView in self.booksTableView.subviews) {
        if ([aView isKindOfClass:[BarrageTypeView class]]||[aView isKindOfClass:[OrdinaryBarrageTypeView class]]) {
            [aView removeFromSuperview];
        }
    }
}

#pragma mark 分享成功任务提交
-(void)verificationDailyTask{
    [[HttpRequest sharedInstance] postWithURLString:kShareTaskAPI showLoading:NO parameters:@{@"token":kUserTokenValue} success:^(id responseObject) {
        
    } failure:^(NSString *errorStr) {
    
    }];
}

#pragma mark -- getters
#pragma mark
-(UITableView *)booksTableView{
    if (!_booksTableView) {
        _booksTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _booksTableView.delegate = self;
        _booksTableView.dataSource = self;
        _booksTableView.estimatedRowHeight = imageCellHeight;
        _booksTableView.estimatedSectionHeaderHeight = 0;
        _booksTableView.estimatedSectionFooterHeight = 10;
        _booksTableView.showsVerticalScrollIndicator = NO;
        _booksTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (@available(iOS 11.0, *)) {
            _booksTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _booksTableView;
}

#pragma mark 导航栏
-(UIView *)navbarView{
    if (!_navbarView) {
        _navbarView = [[UIView alloc] initWithFrame:CGRectMake(0,-kNavHeight, kScreenWidth, kNavHeight)];
        _navbarView.backgroundColor = [UIColor whiteColor];
        
        UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
        [backBtn setImage:[UIImage drawImageWithName:@"return_black"size:CGSizeMake(12, 18)] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
        [backBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_navbarView addSubview:backBtn];
        
        self.titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(60, KStatusHeight+12,kScreenWidth-140, 22)];
        self.titleLabel.textColor=[UIColor commonColor_black];
        self.titleLabel.font=[UIFont mediumFontWithSize:16];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        [_navbarView addSubview:self.titleLabel];
        
        UIButton *allBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-80, KStatusHeight+2, 75, 40)];
        [allBtn setTitle:@"Daftar Isi" forState:UIControlStateNormal];
        [allBtn setTitleColor:[UIColor commonColor_black] forState:UIControlStateNormal];
        allBtn.titleLabel.font = [UIFont regularFontWithSize:14.0f];
        [allBtn addTarget:self action:@selector(rightNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_navbarView addSubview:allBtn];
    }
    return _navbarView;
}

#pragma mark 阅读页底部
-(ReadingFooterView *)readFooterView{
    if (!_readFooterView) {
        _readFooterView = [[ReadingFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 576)];
        _readFooterView.delegate = self;
    }
    return _readFooterView;
}

#pragma mark
-(ToolBarView *)toolBarView{
    if (!_toolBarView) {
        _toolBarView = [[ToolBarView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 138)];
        _toolBarView.delegate = self;
    }
    return _toolBarView;
}

#pragma mark 蒙版
-(UIView *)layerView{
    if (!_layerView) {
        _layerView = [[UIView alloc] initWithFrame:self.view.bounds];
        _layerView.backgroundColor = kRGBColor(0, 0, 0, 0.5);
        _layerView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCurrentView)];
        [_layerView addGestureRecognizer:tap];
    }
    return _layerView;
}

#pragma mark 弹幕
-(InputToolbarView *)barrageInputBarView{
    if (!_barrageInputBarView) {
        _barrageInputBarView = [[InputToolbarView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 60)];
        _barrageInputBarView.type = InputToolbarViewTypeBarrage;
        _barrageInputBarView.delegate = self;
    }
    return _barrageInputBarView;
}

#pragma mark 弹幕样式
-(BarrageTypeView *)barrageTypeView{
    if (!_barrageTypeView) {
        _barrageTypeView = [[BarrageTypeView alloc] initWithFrame:CGRectMake((kScreenWidth-240)/2.0,kNavHeight+80, 240, 64)];
        _barrageTypeView.canMove = NO;
    }
    return _barrageTypeView;
}

#pragma mark 普通弹幕样式
-(OrdinaryBarrageTypeView *)commonTypeView{
    if (!_commonTypeView) {
        _commonTypeView = [[OrdinaryBarrageTypeView alloc] initWithFrame:CGRectMake(10, kNavHeight+80, kScreenWidth-20, 32)];
    }
    return _commonTypeView;
}

#pragma mark 取消
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, kScreenHeight-64, (kScreenWidth-70)/2.0, 40)];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn setBorderWithCornerRadius:6 type:UIViewCornerTypeAll];
        [_cancelBtn setTitle:@"Batal" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor commonColor_black] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont mediumFontWithSize:16];
        _cancelBtn.tag = 100;
        [_cancelBtn addTarget:self action:@selector(editBarrageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

#pragma mark 确定
-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.cancelBtn.right+20, kScreenHeight-64, (kScreenWidth-70)/2.0, 40)];
        _confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#FFE845"];
        [_confirmBtn setBorderWithCornerRadius:6 type:UIViewCornerTypeAll];
        [_confirmBtn setTitle:@"Yakin" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor commonColor_black] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont mediumFontWithSize:16];
        _confirmBtn.tag = 101;
        [_confirmBtn addTarget:self action:@selector(editBarrageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

#pragma mark 评论
-(InputToolbarView *)commentInputBarView{
    if (!_commentInputBarView) {
        _commentInputBarView = [[InputToolbarView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth,105)];
        _commentInputBarView.type = InputToolbarViewTypeComment;
        _commentInputBarView.delegate = self;
    }
    return _commentInputBarView;
}

#pragma mark 目录
-(BookListView *)listView{
    if (!_listView) {
        _listView = [[BookListView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 220)];
        _listView.viewDelegate = self;
    }
    return _listView;
}

#pragma mark 设置
-(ReadSettingsView *)settingsView{
    if (!_settingsView) {
        _settingsView = [[ReadSettingsView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 360)];
        _settingsView.delegate = self;
    }
    return _settingsView;
}


#pragma mark 上翻页
-(UIButton *)pageUpBtn{
    if (!_pageUpBtn) {
        _pageUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,kScreenWidth, 120)];
        _pageUpBtn.tag = 100;
        [_pageUpBtn addTarget:self action:@selector(pageTurnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pageUpBtn;
}

#pragma mark 下翻页
-(UIButton *)pageDownBtn{
    if (!_pageDownBtn) {
        _pageDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,kScreenHeight-120,kScreenWidth, 120)];
        _pageDownBtn.tag = 101;
        [_pageDownBtn addTarget:self action:@selector(pageTurnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pageDownBtn;
}

#pragma mark 加入书架
-(UIButton *)addShelfBtn{
    if (!_addShelfBtn) {
        _addShelfBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-56, kScreenHeight-244, 46, 46)];
        [_addShelfBtn setImage:[UIImage imageNamed:@"cartoon_add_bookshelf"] forState:UIControlStateNormal];
        [_addShelfBtn addTarget:self action:@selector(addToBookShelfAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addShelfBtn;
}

#pragma mark 回到顶部
-(UIButton *)toTopBtn{
    if (!_toTopBtn) {
        _toTopBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-56, self.addShelfBtn.bottom+10, 46, 46)];
        [_toTopBtn setImage:[UIImage imageNamed:@"cartoon_to_top"] forState:UIControlStateNormal];
        [_toTopBtn addTarget:self action:@selector(backToTopAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toTopBtn;
}

-(NSMutableArray *)pagesArray{
    if (!_pagesArray) {
        _pagesArray = [[NSMutableArray alloc] init];
    }
    return _pagesArray;
}

-(NSMutableArray *)commentsArray{
    if (!_commentsArray) {
        _commentsArray = [[NSMutableArray alloc] init];
    }
    return _commentsArray;
}

-(NSMutableArray *)selectionsArray{
    if (!_selectionsArray) {
        _selectionsArray = [[NSMutableArray alloc] init];
    }
    return _selectionsArray;
}

-(NSMutableArray *)barragesArray{
    if (!_barragesArray) {
        _barragesArray = [[NSMutableArray alloc] init];
    }
    return _barragesArray;
}

-(NSMutableArray *)selBarragesArray{
    if (!_selBarragesArray) {
        _selBarragesArray = [[NSMutableArray alloc] init];
    }
    return _selBarragesArray;
}

@end
