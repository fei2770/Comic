//
//  InputToolbarView.m
//  Comic
//
//  Created by vision on 2019/11/20.
//  Copyright © 2019 vision. All rights reserved.
//

#import "InputToolbarView.h"
#import "UITextView+ZWPlaceHolder.h"
#import "BarrageDefaultButton.h"
#import "BarrageTypeView.h"
#import "CommentCollectionView.h"
#import "OpenVipToastView.h"
#import "ConsumeKoinView.h"

@interface InputToolbarView ()<UITextViewDelegate,CommentCollectionViewDelegate>{
    NSArray   *barrageTypes;
}

@property (nonatomic,strong) CommentCollectionView *photosView;
@property (nonatomic,strong) UIView      *toolbarView;
@property (nonatomic,strong) UIView      *rootView;
@property (nonatomic,strong) UIImageView *switchImgView;
@property (nonatomic,strong) UIButton    *barrageTypeBtn;
@property (nonatomic,strong) UIButton    *sendBtn;

@property (nonatomic,strong) UIView      *commentBottomView;
@property (nonatomic,strong) UIView      *barrageBottomView;


@property (nonatomic,strong) ConsumeKoinView   *consumeKoinView; //消耗金币提示
@property (nonatomic,strong) OpenVipToastView  *vipToastView; //开通vip提示

@property (nonatomic,strong) NSMutableArray  *photosArray;

@property (nonatomic,assign) BOOL   isSettingBarrageType;

@end

@implementation InputToolbarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        barrageTypes = [ComicManager sharedComicManager].barrageTypesArray;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolBarKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [self addSubview:self.toolbarView];
        [self.toolbarView addSubview:self.rootView];
        [self.toolbarView addSubview:self.commentTextView];
        [self.toolbarView addSubview:self.switchImgView];
        [self.toolbarView addSubview:self.barrageTypeBtn];
        [self.toolbarView addSubview:self.sendBtn];
        [self addSubview:self.commentBottomView];
        [self addSubview:self.barrageBottomView];
        [self addSubview:self.photosView];
        
        self.barrageBottomView.hidden = self.photosView.hidden =  YES;
    }
    return self;
}

#pragma mark 选择弹幕样式框
-(void)setBarrageTypeAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.isSettingBarrageType = sender.selected;
    self.commentBottomView.hidden = YES;
    if (self.isSettingBarrageType) {
       [self.commentTextView resignFirstResponder];
        self.barrageBottomView.hidden = NO;
        self.barrageBottomView.frame = CGRectMake(0, self.toolbarView.bottom, kScreenWidth,260);
        CGRect aFrame = self.frame;
        aFrame.origin.y -= 260;
        aFrame.size.height += 260;
        self.frame = aFrame;
    }else{
        self.barrageBottomView.hidden = YES;
        CGRect aFrame = self.frame;
        aFrame.origin.y += 260;
        aFrame.size.height -= 260;
        self.frame = aFrame;
        [self.commentTextView becomeFirstResponder];
    }
}

#pragma mark 选择弹幕样式
-(void)chooseBarrageTypeAction:(UITapGestureRecognizer *)sender{
    NSInteger index = sender.view.tag;
    if (index>0) {
        if (index==1||index==2||index==4) { //开通会员
            BOOL isVip = [[NSUserDefaultsInfos getValueforKey:kUserVip] boolValue];
            if (isVip) {
                [self confrimChooseBarrageType:index];
            }else{
                [OpenVipToastView showOpenVipToastWithFrame:CGRectMake(0, 0, 252, 300) confirmAction:^{
                    if ([self.delegate respondsToSelector:@selector(inputToolbarView:toastViewHanderActionWithType:)]) {
                        [self.delegate inputToolbarView:self toastViewHanderActionWithType:0];
                    }
                }];
            }
        }else{
            if ([self.purchasedStylesArray containsObject:[NSNumber numberWithInteger:index]]) {
                [self confrimChooseBarrageType:index];
            }else{
                [ConsumeKoinView showConsumeKoinWithFrame:CGRectMake(0, 0, 252, 320) confirmAction:^(NSInteger type) {
                    if (type==0) { //消耗金币
                        [[HttpRequest sharedInstance] postWithURLString:kExchangeTypeAPI showLoading:YES parameters:@{@"token":kUserTokenValue,@"style_id":[NSNumber numberWithInteger:index],@"bean":@100} success:^(id responseObject) {
                            if (!self.purchasedStylesArray) {
                                self.purchasedStylesArray = [[NSMutableArray alloc] init];
                            }
                            [self.purchasedStylesArray addObject:[NSNumber numberWithInteger:index]];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self confrimChooseBarrageType:index];
                            });
                        } failure:^(NSString *errorStr) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [kKeyWindow makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
                            });
                        }];
                    }else{ //去充值
                        if ([self.delegate respondsToSelector:@selector(inputToolbarView:toastViewHanderActionWithType:)]) {
                            [self.delegate inputToolbarView:self toastViewHanderActionWithType:type+1];
                        }
                    }
                }];
            }
        }
    }
}

#pragma mark 发射弹幕或发送评论
-(void)sendContentAction:(UIButton *)sender{
    if (kIsEmptyString(self.commentTextView.text)) {
        [kKeyWindow makeToast:@"Silahkan masukkan komentar" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    MyLog(@"sendContentAction");
    if ([self.delegate respondsToSelector:@selector(inputToolbarView:didSendText:images:)]) {
        [self.delegate inputToolbarView:self didSendText:self.commentTextView.text images:self.photosArray];
    }
}

#pragma mark 上传图片
-(void)addPhotoAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(inputToolbarView:choosePhotoAtcion:)]) {
        [self.delegate inputToolbarView:self choosePhotoAtcion:sender.tag];
    }
}

#pragma mark -- Delegate
#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.isSettingBarrageType) {
        self.isSettingBarrageType = NO;
    }
    self.photosView.hidden = self.photosArray.count<1;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    self.sendBtn.enabled = [textView.text length]+text.length>0;
    if (self.type==InputToolbarViewTypeBarrage) {
        return [textView.text length]+text.length<31;
    }else{
        return [textView.text length]+text.length<301;
    }
}

#pragma mark CommentCollectionViewDelegate
-(void)commentCollectionView:(CommentCollectionView *)commentView didDeletePhoto:(NSInteger)index{
    [self.photosArray removeObjectAtIndex:index];
    if (self.photosArray.count>0) {
        self.photosView.hidden = NO;
        self.photosView.frame = CGRectMake(0, 0, kScreenWidth, 66);
        self.toolbarView.frame = CGRectMake(0, self.photosView.bottom, kScreenWidth, 60);
        self.commentBottomView.frame = CGRectMake(0, self.toolbarView.bottom, kScreenWidth, 45);
    }else{
        self.photosView.hidden = YES;
        self.toolbarView.frame = CGRectMake(0, 0, kScreenWidth, 60);
        self.commentBottomView.frame = CGRectMake(0, self.toolbarView.bottom, kScreenWidth, 45);
        
        CGRect aFrame = self.frame;
        aFrame.origin.y += 66;
        aFrame.size.height -= 66;
        self.frame = aFrame;
    }
    self.photosView.photosArray = self.photosArray;
    [self.photosView reloadData];
}

#pragma mark -- NSNotification
-(void)toolBarKeyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)(void) = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}


#pragma mark -- Private methods
#pragma mark 显示键盘
- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
        [self willShowBottomHeight:toFrame.size.height];
    }else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height){
        [self willShowBottomHeight:0];
    }else{
        [self willShowBottomHeight:toFrame.size.height];
    }
}

#pragma mark 调整toolBar的高度
- (void)willShowBottomHeight:(CGFloat)bottomHeight{
    CGRect fromFrame = self.frame;
    CGFloat toHeight;
    if (self.type == InputToolbarViewTypeBarrage) {
        toHeight = self.toolbarView.height +bottomHeight;
    }else{
        toHeight = self.toolbarView.height + self.commentBottomView.height+(self.photosArray.count>0?66:0)+ bottomHeight;
    }
    
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    if(bottomHeight == 0 && self.height == self.toolbarView.height){
        return;
    }
    self.frame = toFrame;
}

#pragma mark 确定选择弹幕样式
-(void)confrimChooseBarrageType:(NSInteger)index{
    self.isSettingBarrageType = NO;
    self.barrageBottomView.hidden = YES;
    CGRect aFrame = self.frame;
    aFrame.origin.y += 260;
    aFrame.size.height -= 260;
    self.frame = aFrame;
    [self.commentTextView becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(inputToolbarView:didSelectedBarrageType:)]) {
        [self.delegate inputToolbarView:self didSelectedBarrageType:index];
    }
}

-(void)setPurchasedStylesArray:(NSMutableArray *)purchasedStylesArray{
    _purchasedStylesArray = purchasedStylesArray;
}

#pragma mark -- Setters
#pragma mark 选择弹幕
-(void)setIsSettingBarrageType:(BOOL)isSettingBarrageType{
    _isSettingBarrageType = isSettingBarrageType;
    self.barrageTypeBtn.selected = isSettingBarrageType;
    self.barrageBottomView.hidden = !isSettingBarrageType;
}

#pragma mark 添加图片
-(void)setContentImageUrl:(NSString *)contentImageUrl{
    _contentImageUrl = contentImageUrl;
    
    [self.photosArray addObject:contentImageUrl];
    self.photosView.hidden = NO;
    self.photosView.frame = CGRectMake(0, 0, kScreenWidth, 66);
    self.toolbarView.frame = CGRectMake(0, self.photosView.bottom, kScreenWidth, 60);
    self.commentBottomView.frame = CGRectMake(0, self.toolbarView.bottom, kScreenWidth, 45);
    self.photosView.photosArray = self.photosArray;
    [self.photosView reloadData];
    
    [self.commentTextView becomeFirstResponder];
}

#pragma mark 设置样式
-(void)setType:(InputToolbarViewType)type{
    _type = type;
    if (type == InputToolbarViewTypeComment) {
        self.commentTextView.zw_placeHolder =@"Silahkan masukkan komentar";
        self.switchImgView.image = [UIImage imageNamed:@"comment_icon"];
        self.barrageTypeBtn.hidden = YES;
        [self.sendBtn setTitle:@"Memposting" forState:UIControlStateNormal];
        self.commentBottomView.hidden = NO;
    }else{
        self.commentTextView.zw_placeHolder = @"Komentar langsung diluncurkan";
        self.switchImgView.image = [UIImage imageNamed:@"barrage_icon"];
        self.barrageTypeBtn.hidden = NO;
        [self.sendBtn setTitle:@"Diluncurkan" forState:UIControlStateNormal];
        self.commentBottomView.hidden = YES;
    }
}

#pragma mark -- getters
#pragma mark
-(UIView *)toolbarView{
    if (!_toolbarView) {
        _toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        _toolbarView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F7"];
    }
    return _toolbarView;
}

#pragma mark 背景
-(UIView *)rootView{
    if (!_rootView) {
        _rootView = [[UIView alloc] initWithFrame:CGRectMake(18, 14, kScreenWidth-115, 32)];
        _rootView.layer.borderWidth = 1;
        _rootView.layer.borderColor = [UIColor colorWithHexString:@"#D8D8D8"].CGColor;
        _rootView.layer.cornerRadius = 16.0f;
        _rootView.backgroundColor = [UIColor whiteColor];
    }
    return _rootView;
}

#pragma mark 评论
-(UITextView*)commentTextView{
    if (!_commentTextView) {
        _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(46,15, _rootView.width-46, 30)];
        _commentTextView.font = [UIFont regularFontWithSize:13];
        _commentTextView.zw_placeHolder = @"Komentar langsung diluncurkan";
        _commentTextView.delegate = self;
    }
    return _commentTextView;
}

#pragma mark 切换
-(UIImageView *)switchImgView{
    if (!_switchImgView) {
        _switchImgView = [[UIImageView alloc] initWithFrame:CGRectMake(21,self.rootView.top+3, 26, 26)];
        _switchImgView.image = [UIImage imageNamed:@"barrage_icon"];
    }
    return _switchImgView;
}

#pragma mark 弹幕样式选择
-(UIButton *)barrageTypeBtn{
    if (!_barrageTypeBtn) {
        _barrageTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.rootView.right-30, self.rootView.top+6, 20, 20)];
        [_barrageTypeBtn setImage:[UIImage imageNamed:@"barrage_color_gray"] forState:UIControlStateNormal];
        [_barrageTypeBtn setImage:[UIImage imageNamed:@"barrage_color_purple"] forState:UIControlStateSelected];
        [_barrageTypeBtn addTarget:self action:@selector(setBarrageTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _barrageTypeBtn;
}

#pragma mark  发送
-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.rootView.right+5,self.rootView.top, 90, 32)];
        [_sendBtn setTitle:@"Diluncurkan" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont mediumFontWithSize:14.0f];
        [_sendBtn addTarget:self action:@selector(sendContentAction:) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.enabled = NO;
    }
    return _sendBtn;
}

#pragma mark 评论底部视图
-(UIView *)commentBottomView{
    if (!_commentBottomView) {
        _commentBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.toolbarView.bottom, kScreenWidth, 45)];
        _commentBottomView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F7"];
        
        NSArray *images = @[@"comment_upload_photo",@"comment_take_picture"];
        for (NSInteger i=0; i<images.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(18+i*45, 0, 33, 30)];
            [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(addPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
            [_commentBottomView addSubview:btn];
        }
    }
    return _commentBottomView;
}

#pragma mark 弹幕样式视图
-(UIView *)barrageBottomView{
    if (!_barrageBottomView) {
        _barrageBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.toolbarView.bottom, kScreenWidth, 260)];
        _barrageBottomView.backgroundColor = [UIColor whiteColor];
        
        NSArray *payTypes = @[@0,@1,@1,@2,@1,@2];
        CGFloat btnW = (kScreenWidth-36-20)/2.0;
        for (NSInteger i=0; i<payTypes.count; i++) {
            if (i==0) {
                BarrageDefaultButton *btn = [[BarrageDefaultButton alloc] initWithFrame:CGRectMake(18, 10, btnW, 64)];
                [_barrageBottomView addSubview:btn];
            }else{
                NSDictionary *dict = barrageTypes[i-1];
                BarrageTypeView *typeView = [[BarrageTypeView alloc] initWithFrame:CGRectMake(18+(i%2)*(btnW+20), 10+(i/2)*(64+10), btnW, 64)];
                typeView.typeDict = dict;
                typeView.pay_type = [payTypes[i] integerValue];
                typeView.tag = i;
                [_barrageBottomView addSubview:typeView];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBarrageTypeAction:)];
                [typeView addGestureRecognizer:tap];
            }
        }
        
    }
    return _barrageBottomView;
}

#pragma mark 图片
-(CommentCollectionView *)photosView{
    if (!_photosView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(56, 66);
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 0);
        
        _photosView = [[CommentCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 66) collectionViewLayout:layout];
        _photosView.viewDelegate = self;
    }
    return _photosView;
}


-(NSMutableArray *)photosArray{
    if (!_photosArray) {
        _photosArray = [[NSMutableArray alloc] init];
    }
    return _photosArray;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

@end
