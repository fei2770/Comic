//
//  ToolBarView.m
//  Comic
//
//  Created by vision on 2019/11/20.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ToolBarView.h"
#import "CustomButton.h"
#import "PPBadgeView.h"

@interface ToolBarView (){
    BOOL         isBarrageClose;
    NSInteger    _type;
}

@property (nonatomic,strong) UIButton      *barrageBtn; //弹幕
@property (nonatomic,strong) UIView        *rootView;
@property (nonatomic,strong) UIButton      *inputBtn; // 输入
@property (nonatomic,strong) UIButton      *switchBtn; //弹幕和评论切换
@property (nonatomic,strong) UIButton      *barrageTypeBtn;  //弹幕样式
@property (nonatomic,strong) UIButton      *launchBtn; //发射
@property (nonatomic,strong) UIButton      *lastWordBtn;  //上一话
@property (nonatomic,strong) CustomButton  *listBtn;  //目录
@property (nonatomic,strong) UIButton      *nextWordBtn;  //下一话
@property (nonatomic,strong) CustomButton  *commentBtn;  //评论
@property (nonatomic,strong) CustomButton   *shareBtn;  //分享
@property (nonatomic,strong) CustomButton   *installBtn;  //设置

@end

@implementation ToolBarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _type = 0;
        
        [self addSubview:self.barrageBtn];
        [self addSubview:self.rootView];
        [self addSubview:self.inputBtn];
        [self addSubview:self.switchBtn];
        [self addSubview:self.barrageTypeBtn];
        [self addSubview:self.launchBtn];
        [self addSubview:self.lastWordBtn];
        [self addSubview:self.listBtn];
        [self addSubview:self.nextWordBtn];
        [self addSubview:self.commentBtn];
        [self addSubview:self.shareBtn];
        [self addSubview:self.installBtn];
    }
    return self;
}

#pragma mark -- Event response
#pragma mark 关闭或开启弹幕
-(void)setBarrageSwitchAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.switchBtn.selected = sender.selected;
    self.barrageTypeBtn.hidden = sender.selected;
    isBarrageClose = sender.selected;
    _type = sender.selected;
    if ([self.delegate respondsToSelector:@selector(toolBarViewSetBarrageOpen:)]) {
        [self.delegate toolBarViewSetBarrageOpen:sender.selected];
    }
}

#pragma mark 切换弹幕和评论
-(void)switchInputTypeAction:(UIButton *)sender{
    if (!isBarrageClose) {
        sender.selected = !sender.selected;
        self.barrageTypeBtn.hidden = sender.selected;
        _type = sender.selected;
    }else{
        _type = 1;
        if ([self.delegate respondsToSelector:@selector(toolBarViewStartEditWithType:)]) {
            [self.delegate toolBarViewStartEditWithType:_type];
        }
    }
}

#pragma mark 输入事件
-(void)inputClickAction:(UIButton *)sender{
    MyLog(@"type:%ld",_type);
    if ([self.delegate respondsToSelector:@selector(toolBarViewStartEditWithType:)]) {
        [self.delegate toolBarViewStartEditWithType:_type];
    }
}

#pragma mark 显示新一话
-(void)showNewWordAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(toolBarViewShowBookNewChapterWithTag:)]) {
        [self.delegate toolBarViewShowBookNewChapterWithTag:sender.tag];
    }
}

#pragma mark 显示目录
-(void)toolBarHandleAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(toolBarViewHandleEventWithTag:)]) {
        [self.delegate toolBarViewHandleEventWithTag:sender.tag];
    }
}


#pragma mark -- Private methods
#pragma mark 按钮
-(UIButton *)createBtnWithFrame:(CGRect)frame image:(NSString *)imgName title:(NSString *)title tag:(NSInteger)tag{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont regularFontWithSize:10];
    btn.imageEdgeInsets = UIEdgeInsetsMake(-(btn.height - btn.titleLabel.height- btn.titleLabel.y),(btn.width-btn.imageView.width)/2.0, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(btn.imageView.height+btn.imageView.y, -btn.imageView.width, 0, 0);
    btn.tag = tag;
    [btn addTarget:self action:@selector(toolBarHandleAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark -- Setters
-(void)setCommentCount:(NSInteger)commentCount{
    if (commentCount>0) {
        [self.commentBtn pp_moveBadgeWithX:-5 Y:5];
        if (commentCount>99) {
            [self.commentBtn pp_addBadgeWithText:@"99+"];
        }else{
            [self.commentBtn pp_addBadgeWithNumber:commentCount];
        }
    }else{
        [self.commentBtn pp_hiddenBadge];
    }
    [self.commentBtn pp_setBadgeLabelAttributes:^(PPBadgeLabel *badgeLabel) {
        badgeLabel.backgroundColor = [UIColor colorWithHexString:@"#F3F4F7"];
        badgeLabel.textColor = [UIColor commonColor_black];
    }];
}

#pragma mark -- getters
#pragma mark 弹幕
-(UIButton *)barrageBtn{
    if (!_barrageBtn) {
        _barrageBtn = [[UIButton alloc] initWithFrame:CGRectMake(18, 0, 120, 18)];
        [_barrageBtn setImage:[UIImage imageNamed:@"barrage_open"] forState:UIControlStateNormal];
        [_barrageBtn setImage:[UIImage imageNamed:@"barrage_close"] forState:UIControlStateSelected];
        [_barrageBtn setTitle:@"Komentar langsung" forState:UIControlStateNormal];
        [_barrageBtn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        _barrageBtn.titleLabel.font = [UIFont regularFontWithSize:10.0f];
        _barrageBtn.backgroundColor = [UIColor colorWithHexString:@"#E5E6E9"];
        [_barrageBtn setBorderWithCornerRadius:4.0 type:UIViewCornerTypeTop];
        _barrageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_barrageBtn addTarget:self action:@selector(setBarrageSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _barrageBtn;
}

-(UIView *)rootView{
    if (!_rootView) {
        _rootView = [[UIView alloc] initWithFrame:CGRectMake(0, self.barrageBtn.bottom, kScreenWidth, 120)];
        _rootView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F7"];
    }
    return _rootView;
}

#pragma mark 输入
-(UIButton*)inputBtn{
    if (!_inputBtn) {
        _inputBtn = [[UIButton alloc] initWithFrame:CGRectMake(18,self.rootView.top+14, kScreenWidth-115, 32)];
        [_inputBtn setTitle:@"Komentar langsung diluncurkan" forState:UIControlStateNormal];
        [_inputBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        _inputBtn.backgroundColor = [UIColor whiteColor];
        _inputBtn.layer.borderWidth = 1;
        _inputBtn.layer.borderColor = [UIColor colorWithHexString:@"#D8D8D8"].CGColor;
        _inputBtn.titleLabel.font = [UIFont regularFontWithSize:12];
        [_inputBtn setBorderWithCornerRadius:16 type:UIViewCornerTypeAll];
        [_inputBtn addTarget:self action:@selector(inputClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inputBtn;
}

#pragma mark 切换
-(UIButton *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(21,self.inputBtn.top+3, 26, 26)];
        [_switchBtn setTitle:@"L" forState:UIControlStateNormal];
        [_switchBtn setTitle:@"C" forState:UIControlStateSelected];
        [_switchBtn setTitleColor:[UIColor colorWithHexString:@"#915AFF"] forState:UIControlStateNormal];
        _switchBtn.titleLabel.font = [UIFont regularFontWithSize:14.0f];
        _switchBtn.backgroundColor = [UIColor colorWithHexString:@"#F9F9FF"];
        _switchBtn.layer.cornerRadius = 13;
        _switchBtn.layer.borderColor = [UIColor colorWithHexString:@"#915AFF"].CGColor;
        _switchBtn.layer.borderWidth = 1.0;
        [_switchBtn addTarget:self action:@selector(switchInputTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

#pragma mark 弹幕样式选择
-(UIButton *)barrageTypeBtn{
    if (!_barrageTypeBtn) {
        _barrageTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.inputBtn.right-30, self.inputBtn.top+6, 20, 20)];
        [_barrageTypeBtn setImage:[UIImage imageNamed:@"barrage_color_gray"] forState:UIControlStateNormal];
        [_barrageTypeBtn addTarget:self action:@selector(inputClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _barrageTypeBtn;
}

#pragma mark  发射
-(UIButton *)launchBtn{
    if (!_launchBtn) {
        _launchBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.inputBtn.right+5,self.inputBtn.top, 90, 32)];
        [_launchBtn setTitle:@"Diluncurkan" forState:UIControlStateNormal];
        [_launchBtn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        _launchBtn.titleLabel.font = [UIFont mediumFontWithSize:14.0f];
        [_launchBtn addTarget:self action:@selector(inputClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _launchBtn;
}

#pragma mark 上一话
-(UIButton *)lastWordBtn{
    if (!_lastWordBtn) {
        _lastWordBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.inputBtn.bottom+22, 30, 30)];
        [_lastWordBtn setImage:[UIImage drawImageWithName:@"cartoon_last_chapter" size:CGSizeMake(10, 17)] forState:UIControlStateNormal];
        _lastWordBtn.tag = 0;
        [_lastWordBtn addTarget:self action:@selector(showNewWordAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastWordBtn;
}

#pragma mark 目录
-(CustomButton *)listBtn{
    if (!_listBtn) {
        _listBtn = [[CustomButton alloc] initWithFrame:CGRectMake(self.lastWordBtn.right+5, self.inputBtn.bottom+20, 50, 50) imgSize:CGSizeMake(28, 28)];
        _listBtn.imgName = @"cartoon_directory";
        _listBtn.titleString = @"Daftar Isi";
        _listBtn.tag = 100;
        [_listBtn addTarget:self action:@selector(toolBarHandleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listBtn;
}

#pragma mark 下一话
-(UIButton *)nextWordBtn{
    if (!_nextWordBtn) {
        _nextWordBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.listBtn.right+5, self.inputBtn.bottom+22, 30, 30)];
        [_nextWordBtn setImage:[UIImage drawImageWithName:@"cartoon_next_chapter" size:CGSizeMake(10, 17)] forState:UIControlStateNormal];
        _nextWordBtn.tag = 1;
        [_nextWordBtn addTarget:self action:@selector(showNewWordAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextWordBtn;
}

#pragma mark评论
-(UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [[CustomButton alloc] initWithFrame:CGRectMake(self.nextWordBtn.right+(kScreenWidth-300)/4.0, self.inputBtn.bottom+20, 50, 50) imgSize:CGSizeMake(28, 28)];
        _commentBtn.imgName = @"cartoon_evaluation";
        _commentBtn.titleString = @"Komentar";
        _commentBtn.tag = 101;
        [_commentBtn addTarget:self action:@selector(toolBarHandleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

#pragma mark 分享
-(UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [[CustomButton alloc] initWithFrame:CGRectMake(self.commentBtn.right+(kScreenWidth-300)/4.0, self.inputBtn.bottom+20, 50, 50) imgSize:CGSizeMake(28, 28)];
        _shareBtn.imgName = @"cartoon_share";
        _shareBtn.titleString = @"Bagikan";
        _shareBtn.tag = 102;
        [_shareBtn addTarget:self action:@selector(toolBarHandleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

#pragma mark 设置
-(UIButton *)installBtn{
    if (!_installBtn) {
        _installBtn = [[CustomButton alloc] initWithFrame:CGRectMake(self.shareBtn.right+(kScreenWidth-300)/4.0, self.inputBtn.bottom+20, 60, 50) imgSize:CGSizeMake(28, 28)];
        _installBtn.imgName = @"cartoon_settings";
        _installBtn.titleString = @"Pengaturan";
        _installBtn.tag = 103;
        [_installBtn addTarget:self action:@selector(toolBarHandleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _installBtn;
}

@end
