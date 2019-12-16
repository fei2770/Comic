//
//  ReadingFooterView.m
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ReadingFooterView.h"
#import "CustomButton.h"
#import "FooterRecommandView.h"
#import "FooterBookModel.h"

@interface ReadingFooterView ()<FooterRecommandViewDelegate>

@property (nonatomic,strong) UIView       *bgView;
@property (nonatomic,strong) UIView       *line1;
@property (nonatomic,strong) CustomButton *likeBtn;
@property (nonatomic,strong) CustomButton *addBtn;
@property (nonatomic,strong) CustomButton *shareBtn;
@property (nonatomic,strong) UIView       *line2;
@property (nonatomic,strong) UIButton     *lastWordBtn;
@property (nonatomic,strong) UIView       *line3;
@property (nonatomic,strong) UIButton     *nextWordBtn;
@property (nonatomic,strong) UIImageView  *bannerImgView;
@property (nonatomic,strong) FooterRecommandView  *recommandView;


@property (nonatomic,strong) BannerModel  *myBanner;


@end

@implementation ReadingFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F6F6FA"];
        
        [self addSubview:self.bgView];
        [self addSubview:self.line1];
        [self addSubview:self.likeBtn];
        [self addSubview:self.addBtn];
        [self addSubview:self.shareBtn];
        [self addSubview:self.lastWordBtn];
        [self addSubview:self.nextWordBtn];
        [self addSubview:self.line2];
        [self addSubview:self.line3];
        [self addSubview:self.bannerImgView];
        [self addSubview:self.recommandView];
    }
    return self;
}

#pragma mark 填充数据
-(void)setFooterModel:(ReadFooterModel *)footerModel{
    _footerModel = footerModel;
    if ([footerModel.is_like boolValue]) {
        self.likeBtn.imgName = @"cartoon_chapter_praise";
        self.likeBtn.textColor = [UIColor colorWithHexString:@"#915AFF"];
        self.likeBtn.enabled = NO;
    }else{
        self.likeBtn.imgName = @"cartoon_chapter_praise_black";
        self.likeBtn.textColor = [UIColor commonColor_black];
        self.likeBtn.enabled = YES;
    }
    self.likeBtn.titleString = [NSString stringWithFormat:@"Suka %ld",(long)[footerModel.like integerValue]];
    if ([footerModel.state boolValue]) {
        self.addBtn.imgName = @"cartoon_chapter_add_bookshelf_purple";
        self.addBtn.textColor = [UIColor colorWithHexString:@"#915AFF"];
        self.addBtn.enabled = NO;
    }else{
        self.addBtn.imgName = @"cartoon_chapter_add_bookshelf";
        self.addBtn.textColor = [UIColor commonColor_black];
        self.addBtn.enabled = YES;
    }
    CGFloat originY = 0.0;
    if (kIsDictionary(footerModel.banner_dict)&&footerModel.banner_dict.count>0) {
        self.bannerImgView.hidden = NO;
        [self.myBanner setValues:footerModel.banner_dict];
        [self.bannerImgView sd_setImageWithURL:[NSURL URLWithString:self.myBanner.banner_pic] placeholderImage:[UIImage imageNamed:@"default_graph_3"]];
        originY = self.bannerImgView.bottom+10;
    }else{
        self.bannerImgView.hidden = YES;
        originY = self.bgView.bottom+10;
    }
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in footerModel.books) {
        FooterBookModel *model = [[FooterBookModel alloc] init];
        [model setValues:dict];
        [tempArr addObject:model];
    }
    if (tempArr.count>0) {
        self.recommandView.hidden = NO;
        self.recommandView.booksArray = tempArr;
        self.recommandView.frame = CGRectMake(0, originY, kScreenWidth, 250);
    }else{
        self.recommandView.hidden = YES;
    }
}

#pragma mark  FooterRecommandViewDelegate
#pragma mark 选择漫画
-(void)footerRecommandViewDidSelectedBook:(FooterBookModel *)bookModel{
    if ([self.delegate respondsToSelector:@selector(readingFooterViewDidSelectedBook:)]) {
        [self.delegate readingFooterViewDidSelectedBook:bookModel.book_id];
    }
}

#pragma mark -- Setters
#pragma mark 点赞 加入书架 分享
-(void)clickBtnAction:(UIButton *)sener{
    if (sener.tag==100) { //点赞
        self.likeBtn.imgName = @"cartoon_chapter_praise";
        self.likeBtn.textColor = [UIColor colorWithHexString:@"#915AFF"];
        self.likeBtn.enabled = NO;
        NSInteger likeCount = [self.footerModel.like integerValue];
        likeCount ++;
        self.likeBtn.titleString = [NSString stringWithFormat:@"Suka %ld",(long)likeCount];
    }
    
    if ([self.delegate respondsToSelector:@selector(readingFooterViewClickBtnActionWithTag:)]) {
        [self.delegate readingFooterViewClickBtnActionWithTag:sener.tag];
    }
}

#pragma mark 上一话 下一话
-(void)pageTurnAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(readingFooterViewPageTurnActionWithTag:)]) {
        [self.delegate readingFooterViewPageTurnActionWithTag:sender.tag];
    }
}

#pragma mark 点击banner
-(void)tapBannerAction:(UITapGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(readingFooterViewDidClickBanner:)]) {
        [self.delegate readingFooterViewDidClickBanner:self.myBanner];
    }
}

#pragma mark -- Getters
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 156)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

#pragma mark 线条1
-(UIView *)line1{
    if (!_line1) {
        _line1  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        _line1.backgroundColor = [UIColor colorWithHexString:@"#EAEBF0"];
    }
    return _line1;
}

#pragma mark 点赞
-(CustomButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [[CustomButton alloc] initWithFrame:CGRectMake(20, 12, (kScreenWidth-80)/3, 66) imgSize:CGSizeMake(28, 28)];
        _likeBtn.imgName = @"cartoon_chapter_praise_black";
        _likeBtn.textColor = [UIColor commonColor_black];
        _likeBtn.titleString = @"Suka 0";
        _likeBtn.titleFont = [UIFont regularFontWithSize:13.0f];
        _likeBtn.tag = 100;
        [_likeBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}

#pragma mark 加入书架
-(CustomButton *)addBtn{
    if (!_addBtn) {
         _addBtn = [[CustomButton alloc] initWithFrame:CGRectMake(self.likeBtn.right+20, 20, (kScreenWidth-80)/3, 76) imgSize:CGSizeMake(28, 28)];
        _addBtn.imgName = @"cartoon_chapter_add_bookshelf";
        _addBtn.textColor = [UIColor commonColor_black];
        _addBtn.titleString = @"Masuk ke rak buku";
        _addBtn.titleFont = [UIFont regularFontWithSize:13.0f];
        _addBtn.tag = 101;
        [_addBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

#pragma mark 分享
-(CustomButton *)shareBtn{
    if (!_shareBtn) {
         _shareBtn = [[CustomButton alloc] initWithFrame:CGRectMake(self.addBtn.right+20, 20, (kScreenWidth-80)/3, 76) imgSize:CGSizeMake(28, 28)];
        _shareBtn.imgName = @"cartoon_chapter_share";
        _shareBtn.textColor = [UIColor commonColor_black];
        _shareBtn.titleString = @"Bagikan";
        _shareBtn.titleFont = [UIFont regularFontWithSize:13.0f];
        _shareBtn.tag = 102;
        [_shareBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

#pragma mark 上一话
-(UIButton *)lastWordBtn{
    if (!_lastWordBtn) {
        _lastWordBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,100, kScreenWidth/2.0, 50)];
        [_lastWordBtn setTitle:@"Chapter selanjutnya" forState:UIControlStateNormal];
        [_lastWordBtn setTitleColor:[UIColor colorWithHexString:@"#6D6D6D"] forState:UIControlStateNormal];
        [_lastWordBtn setImage:[UIImage imageNamed:@"cartoon_last_chapter"] forState:UIControlStateNormal];
        _lastWordBtn.titleLabel.font = [UIFont regularFontWithSize:IS_IPHONE_5?11.0f:13.0f];
        _lastWordBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _lastWordBtn.tag = 0;
        [_lastWordBtn addTarget:self action:@selector(pageTurnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastWordBtn;
}

#pragma mark 下一话
-(UIButton *)nextWordBtn{
    if (!_nextWordBtn) {
        _nextWordBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2.0,100, kScreenWidth/2.0, 50)];
        [_nextWordBtn setTitle:@"Chapter sebelumnya" forState:UIControlStateNormal];
        [_nextWordBtn setTitleColor:[UIColor colorWithHexString:@"#6D6D6D"] forState:UIControlStateNormal];
        [_nextWordBtn setImage:[UIImage imageNamed:@"cartoon_next_chapter"] forState:UIControlStateNormal];
        _nextWordBtn.titleLabel.font = [UIFont regularFontWithSize:IS_IPHONE_5?11.0f:13.0f];
        _nextWordBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        _nextWordBtn.imageEdgeInsets = UIEdgeInsetsMake(0, kScreenWidth/2.0-30, 0, 0);
        _nextWordBtn.tag = 1;
        [_nextWordBtn addTarget:self action:@selector(pageTurnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextWordBtn;
}

#pragma mark 线条2
-(UIView *)line2{
    if (!_line2) {
        _line2  = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 1)];
        _line2.backgroundColor = [UIColor colorWithHexString:@"#EAEBF0"];
    }
    return _line2;
}

#pragma mark 线条3
-(UIView *)line3{
    if (!_line3) {
        _line3  = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, 117, 1, 25)];
        _line3.backgroundColor = [UIColor colorWithHexString:@"#EAEBF0"];
    }
    return _line3;
}

#pragma mark banner
-(UIImageView *)bannerImgView{
    if (!_bannerImgView) {
        _bannerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bgView.bottom+10, kScreenWidth, 140)];
        _bannerImgView.backgroundColor = [UIColor whiteColor];
        _bannerImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBannerAction:)];
        [_bannerImgView addGestureRecognizer:gesture];
    }
    return _bannerImgView;
}

#pragma mark 推荐书籍
-(FooterRecommandView *)recommandView{
    if (!_recommandView) {
        _recommandView = [[FooterRecommandView alloc] initWithFrame:CGRectMake(0, self.bannerImgView.bottom+10, kScreenWidth, 250) isRecommanded:NO];
        _recommandView.delegate = self;
    }
    return _recommandView;
}

-(BannerModel *)myBanner{
    if (!_myBanner) {
        _myBanner = [[BannerModel alloc] init];
    }
    return _myBanner;
}


@end
