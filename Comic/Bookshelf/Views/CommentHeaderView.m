//
//  CommentHeaderView.m
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import "CommentHeaderView.h"

@interface CommentHeaderView ()

@property (nonatomic,strong) UIView      *bgView;
@property (nonatomic,strong) UIView      *introIconView;
@property (nonatomic,strong) UILabel     *introTitleLab;
@property (nonatomic,strong) UILabel     *bookIntroLab; //作品简介
@property (nonatomic,strong) UILabel     *authorLab;    //作者
@property (nonatomic,strong) UIButton    *commentCountBtn;    //评论数
@property (nonatomic,strong) UIButton    *collectCountBtn;    //加入书架数

@property (nonatomic,strong) UIView      *commentBgView;
@property (nonatomic,strong) UIView      *commentIconView;
@property (nonatomic,strong) UILabel     *commentTitleLab;


@end

@implementation CommentHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor bgColor_Gray];
        
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.introIconView];
        [self.bgView addSubview:self.introTitleLab];
        [self.bgView addSubview:self.bookIntroLab];
        [self.bgView addSubview:self.authorLab];
        [self.bgView addSubview:self.commentCountBtn];
        [self.bgView addSubview:self.collectCountBtn];
        
        [self addSubview:self.commentBgView];
        [self.commentBgView addSubview:self.commentIconView];
        [self.commentBgView addSubview:self.commentTitleLab];
        [self.commentBgView addSubview:self.commentBtn];
    }
    return self;
}

#pragma mark 填充数据
-(void)setBook:(BookModel *)book{
    self.bookIntroLab.text = book.des;
    CGFloat introHeight = [book.des boundingRectWithSize:CGSizeMake(kScreenWidth-40, CGFLOAT_MAX) withTextFont:self.bookIntroLab.font].height;
    self.bookIntroLab.frame = CGRectMake(20, self.introTitleLab.bottom+10, kScreenWidth-40, introHeight);
    
    self.authorLab.text = [NSString stringWithFormat:@"Penulis：%@",book.author];
    self.authorLab.frame = CGRectMake(20, self.bookIntroLab.bottom+20, kScreenWidth-40, 20);
    
    NSString *commentCountStr = [NSString stringWithFormat:@"Total komentar  %@",book.comment_count];
    CGFloat commentW = [commentCountStr boundingRectWithSize:CGSizeMake(kScreenWidth, 16) withTextFont:[UIFont regularFontWithSize:11]].width;
    [self.commentCountBtn setTitle:commentCountStr forState:UIControlStateNormal];
    self.commentCountBtn.frame = CGRectMake(20, self.authorLab.bottom+5, commentW+30, 16);
    
    NSString *collectCountStr = [NSString stringWithFormat:@"%@ orang yang telah memasukkannya ke rak buku",book.collect];
    CGFloat collectW = [collectCountStr boundingRectWithSize:CGSizeMake(kScreenWidth, 16) withTextFont:[UIFont regularFontWithSize:11]].width;
    [self.collectCountBtn setTitle:collectCountStr forState:UIControlStateNormal];
    self.collectCountBtn.frame = CGRectMake(20, self.commentCountBtn.bottom+5,collectW+30, 16);
    
    self.bgView.frame = CGRectMake(0, 0, kScreenWidth, self.collectCountBtn.bottom+15);
    
    self.commentBgView.frame = CGRectMake(0,self.bgView.bottom+10, kScreenWidth, 50);
}


#pragma mark -- Getters
-(UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

-(UIView *)introIconView{
    if (!_introIconView) {
        _introIconView = [[UIView alloc] initWithFrame:CGRectMake(20, 24, 4, 15)];
        _introIconView.backgroundColor = [UIColor colorWithHexString:@"#915AFF"];
        [_introIconView setBorderWithCornerRadius:2 type:UIViewCornerTypeAll];
    }
    return _introIconView;
}

#pragma mark 作品简介标题
-(UILabel *)introTitleLab{
    if (!_introTitleLab) {
        _introTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.introIconView.right+5, 20,240, 20)];
        _introTitleLab.textColor = [UIColor commonColor_black];
        _introTitleLab.font = [UIFont mediumFontWithSize:16.0f];
        _introTitleLab.text = @"Ringkasan cerita";
    }
    return _introTitleLab;
}

#pragma mark 作品简介
-(UILabel *)bookIntroLab{
    if (!_bookIntroLab) {
        _bookIntroLab = [[UILabel alloc] initWithFrame:CGRectMake(20, self.introTitleLab.bottom+10, kScreenWidth-40, 20)];
        _bookIntroLab.numberOfLines = 0;
        _bookIntroLab.textColor = [UIColor colorWithHexString:@"#6D6D6D"];
        _bookIntroLab.font = [UIFont regularFontWithSize:13.0f];
    }
    return _bookIntroLab;
}

#pragma mark 作者
-(UILabel *)authorLab{
    if (!_authorLab) {
        _authorLab = [[UILabel alloc] initWithFrame:CGRectMake(20, self.bookIntroLab.bottom+20, kScreenWidth-40, 16)];
        _authorLab.textColor = [UIColor colorWithHexString:@"#6D6D6D"];
        _authorLab.font = [UIFont regularFontWithSize:14.0f];
    }
    return _authorLab;
}

#pragma mark 总评论数
-(UIButton *)commentCountBtn{
    if (!_commentCountBtn) {
        _commentCountBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.authorLab.bottom+5,kScreenWidth-30, 16)];
        [_commentCountBtn setImage:[UIImage imageNamed:@"details_page_comments_number"] forState:UIControlStateNormal];
        [_commentCountBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        _commentCountBtn.titleLabel.font = [UIFont regularFontWithSize:11.0f];
        _commentCountBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    return _commentCountBtn;
}

#pragma mark 加入书架数
-(UIButton *)collectCountBtn{
    if (!_collectCountBtn) {
        _collectCountBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.commentCountBtn.bottom+5,kScreenWidth-30, 16)];
        [_collectCountBtn setImage:[UIImage imageNamed:@"details_page_follow_number"] forState:UIControlStateNormal];
        [_collectCountBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        _collectCountBtn.titleLabel.font = [UIFont regularFontWithSize:11.0f];
        _collectCountBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    return _collectCountBtn;
}

#pragma mark 评论
-(UIView *)commentBgView {
    if (!_commentBgView) {
        _commentBgView = [[UIView alloc] initWithFrame:CGRectMake(0,self.bgView.bottom+10, kScreenWidth, 50)];
        _commentBgView.backgroundColor = [UIColor whiteColor];
    }
    return _commentBgView;
}

-(UIView *)commentIconView{
    if (!_commentIconView) {
        _commentIconView = [[UIView alloc] initWithFrame:CGRectMake(20, 24, 4, 15)];
        _commentIconView.backgroundColor = [UIColor colorWithHexString:@"#915AFF"];
        [_commentIconView setBorderWithCornerRadius:2 type:UIViewCornerTypeAll];
    }
    return _commentIconView;
}

#pragma mark 评论标题
-(UILabel *)commentTitleLab{
    if (!_commentTitleLab) {
        _commentTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.introIconView.right+5, 20, 120, 20)];
        _commentTitleLab.textColor = [UIColor commonColor_black];
        _commentTitleLab.font = [UIFont mediumFontWithSize:16.0f];
        _commentTitleLab.text = @"Komentar";
    }
    return _commentTitleLab;
}

#pragma mark 发表评论
-(UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-160,18, 150, 24)];
        [_commentBtn setImage:[UIImage imageNamed:@"details_page_write_comments"] forState:UIControlStateNormal];
        [_commentBtn setTitle:@"Posting komentar" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:[UIColor colorWithHexString:@"#8981B3"] forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont regularFontWithSize:13.0f];
        _commentBtn.backgroundColor = [UIColor colorWithHexString:@"#E7E6FF"];
        [_commentBtn setBorderWithCornerRadius:12 type:UIViewCornerTypeAll];
        _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _commentBtn;
}

@end
