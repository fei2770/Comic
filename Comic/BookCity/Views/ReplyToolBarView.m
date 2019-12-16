//
//  ReplyToolBarView.m
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ReplyToolBarView.h"

@interface ReplyToolBarView ()<UITextFieldDelegate>

@property (nonatomic,strong) UIView         *toolbarView;
@property (nonatomic,strong) UIView         *bgView;
@property (nonatomic,strong) UIImageView    *iconImgView;
@property (nonatomic,strong) UIButton       *sendBtn;

@end

@implementation ReplyToolBarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F3F4F7"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyToolBarKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [self addSubview:self.toolbarView];
        [self.toolbarView addSubview:self.bgView];
        [self.toolbarView addSubview:self.replyTextFiled];
        [self.toolbarView addSubview:self.iconImgView];
        [self.toolbarView addSubview:self.sendBtn];
    }
    return self;
}

#pragma mark -- Event response
#pragma mark 发送
-(void)sendAction:(UIButton *)sender{
    if (kIsEmptyString(self.replyTextFiled.text)) {
        [kKeyWindow makeToast:@"Silahkan masukkan komentar" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(replyToolBarView:didSendText:)]) {
        [self.delegate replyToolBarView:self didSendText:self.replyTextFiled.text];
    }
}

#pragma mark -- NSNotification
-(void)replyToolBarKeyboardWillChangeFrame:(NSNotification *)notification{
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
    CGFloat  toHeight = self.toolbarView.height +bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    if(bottomHeight == 0 && self.height == self.toolbarView.height){
        return;
    }
    self.frame = toFrame;
}


#pragma mark -- Setters
#pragma mark 禁止输入
-(void)setNoInput:(BOOL)noInput{
    _noInput = noInput;
}

#pragma mark
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.noInput) {
        if ([self.delegate respondsToSelector:@selector(replyToolBarViewDidShowBar:)]) {
            [self.delegate replyToolBarViewDidShowBar:self];
        }
    }
    return !self.noInput;
}

#pragma mark -- Getters
#pragma mark
-(UIView *)toolbarView{
    if (!_toolbarView) {
        _toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        _toolbarView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F7"];
    }
    return _toolbarView;
}

#pragma mark 背景
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 14, kScreenWidth-115, 32)];
        _bgView.layer.borderWidth = 1;
        _bgView.layer.borderColor = [UIColor colorWithHexString:@"#D8D8D8"].CGColor;
        _bgView.layer.cornerRadius = 16.0f;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

#pragma mark 切换
-(UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(13,self.bgView.top+3, 26, 26)];
        _iconImgView.image = [UIImage imageNamed:@"comment_icon"];
    }
    return _iconImgView;
}

#pragma mark 评论
-(UITextField *)replyTextFiled{
    if (!_replyTextFiled) {
        _replyTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(self.iconImgView.right+10,15,self.bgView.width-56, 30)];
        _replyTextFiled.font = [UIFont regularFontWithSize:13];
        _replyTextFiled.placeholder = @"Silahkan masukkan komentar";
        _replyTextFiled.backgroundColor = [UIColor whiteColor];
        _replyTextFiled.delegate = self;
    }
    return _replyTextFiled;
}

#pragma mark  发送
-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bgView.right+10,self.replyTextFiled.top, 90, 32)];
        [_sendBtn setTitle:@"Memposting" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont mediumFontWithSize:14.0f];
        [_sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

@end
