//
//  DetailHeaderView.m
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import "DetailHeaderView.h"
#import "BookLabelsView.h"

@interface DetailHeaderView ()

@property (nonatomic,strong) UIImageView    *coverImgView; //封面
@property (nonatomic,strong) UILabel        *nameLabel;    //书名
@property (nonatomic,strong) BookLabelsView *labelsView;     //标签
@property (nonatomic,strong) UIButton       *addShelfBtn;  //加入书架

@end

@implementation DetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.coverImgView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.labelsView];
        [self addSubview:self.addShelfBtn];
        self.addShelfBtn.hidden = YES;
    }
    return self;
}

#pragma mark -- event response
#pragma mark 加入书架
-(void)addToBookShelfAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(detailHeaderViewDidAddToBookShelf)]) {
        [self.delegate detailHeaderViewDidAddToBookShelf];
    }
}

#pragma mark 填充数据
-(void)setBookModel:(BookModel *)bookModel{
    if (kIsEmptyString(bookModel.detail_cover)) {
        self.coverImgView.image = [UIImage imageNamed:@"default_page_detail"];
    }else{
        [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:bookModel.detail_cover] placeholderImage:[UIImage imageNamed:@"default_page_detail"]];
    }
    self.nameLabel.text = bookModel.book_name;
    CGFloat nameH = [bookModel.book_name boundingRectWithSize:CGSizeMake(kScreenWidth-40, CGFLOAT_MAX) withTextFont:self.nameLabel.font].height;
    self.nameLabel.frame = CGRectMake(20, self.height-nameH-66, kScreenWidth-40, nameH);
    self.labelsView.labelsArray = bookModel.label;
    
    self.addShelfBtn.hidden = NO;
    if ([bookModel.state boolValue]) { //已加入书架
        self.addShelfBtn.selected = YES;
        self.addShelfBtn.userInteractionEnabled = NO;
        self.addShelfBtn.backgroundColor = [UIColor colorWithHexString:@"#8981B3"];
    }else{
        self.addShelfBtn.selected = NO;
        self.addShelfBtn.userInteractionEnabled = YES;
        self.addShelfBtn.backgroundColor = [UIColor colorWithHexString:@"#915AFF"];
    }
}

#pragma mark -- Getters
#pragma mark  封面
-(UIImageView *)coverImgView{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _coverImgView;
}

#pragma mark 书名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.height-76, 200, 20)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont mediumFontWithSize:16];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

#pragma mark 标签
-(BookLabelsView *)labelsView{
    if (!_labelsView) {
        _labelsView = [[BookLabelsView alloc] initWithFrame:CGRectMake(20, self.height-56, kScreenWidth-(IS_IPHONE_5?140:160), 20)];
    }
    return _labelsView;
}

#pragma mark 加入书架
-(UIButton *)addShelfBtn{
    if (!_addShelfBtn) {
        _addShelfBtn = [[UIButton alloc] initWithFrame:IS_IPHONE_5?CGRectMake(kScreenWidth-120, self.height-60, 120, 32):CGRectMake(kScreenWidth-140, self.height-56, 140, 32)];
        [_addShelfBtn setTitle:@"+Masuk ke rak buku" forState:UIControlStateNormal];
        [_addShelfBtn setTitle:@"Telah masuk rak buku" forState:UIControlStateSelected];
        [_addShelfBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addShelfBtn.titleLabel.font = [UIFont regularFontWithSize:IS_IPHONE_5?11.0:13.0f];
        _addShelfBtn.backgroundColor = [UIColor colorWithHexString:@"#915AFF"];
        [_addShelfBtn setBorderWithCornerRadius:16 type:UIViewCornerTypeLeft];
        [_addShelfBtn addTarget:self action:@selector(addToBookShelfAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addShelfBtn;
}

@end
