//
//  BookCollectionViewCell.m
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BookCollectionViewCell.h"
#import "NSDate+Extend.h"

#define kImageW (kScreenWidth-50)/2.0

@interface BookCollectionViewCell ()

@property (nonatomic,strong) UIView     *coverView;
@property (nonatomic,strong) UIButton   *selBtn;

@end

@implementation BookCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.myImgView];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.descLabel];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.coverView];
        [self.contentView addSubview:self.selBtn];
        self.coverView.hidden = self.selBtn.hidden = YES;
    }
    return self;
}

#pragma mark 填充数据
-(void)displayCellWithBookModel:(ShelfBookModel *)bookModel isEditing:(BOOL)isEditing{
    if (kIsEmptyString(bookModel.detail_cover)) {
        self.myImgView.image = [UIImage imageNamed:@"default_graph_1"];
    }else{
        [self.myImgView sd_setImageWithURL:[NSURL URLWithString:bookModel.detail_cover] placeholderImage:[UIImage imageNamed:@"default_graph_1"]];
    }
    
    //跟新时间
    NSString *timeStr;
    if ([bookModel.type boolValue]) { //已完结
        timeStr = @"Selesai";
        self.timeLabel.backgroundColor = [UIColor colorWithHexString:@"#FF5B00"];
    }else{
        NSString *createTime = [[ComicManager sharedComicManager] timeWithTimeIntervalNumber:bookModel.create_time format:@"yyyy-MM-dd"];
        NSString *currentTime = [NSDate currentDateTimeWithFormat:@"yyyy-MM-dd"];
        NSInteger timeVal = [self pleaseInsertStarTime:createTime andInsertEndTime:currentTime];
        if (timeVal<1) {
            timeStr = @"Hari ini";
        }else if (timeVal<3){
            timeStr = @"1 hari lalu";
        }else if (timeVal<7){
            timeStr = @"3 hari lalu";
        }else{
            timeStr = @"7 hari lalu";
        }
        self.timeLabel.backgroundColor = [UIColor colorWithHexString:@"#8200FF"];
    }
    self.timeLabel.text = timeStr;
    CGFloat timeW = [timeStr boundingRectWithSize:CGSizeMake(kImageW, 18) withTextFont:self.timeLabel.font].width;
    self.timeLabel.frame = CGRectMake(8, self.myImgView.bottom-26,timeW+10, 18);
    [self.timeLabel setBorderWithCornerRadius:9 type:UIViewCornerTypeAll];
    
    
    self.nameLabel.text = bookModel.book_name;
    self.descLabel.text = bookModel.catalogue_name;
    
    NSString *likeStr = [NSString stringWithFormat:@"%ld",(long)[bookModel.like integerValue]];
    CGFloat likeW = [likeStr boundingRectWithSize:CGSizeMake(80, 20) withTextFont:[UIFont regularFontWithSize:10]].width;
    self.likeBtn.frame = CGRectMake(0, self.descLabel.bottom+5,likeW+30, 20);
    [self.likeBtn setTitle:likeStr forState:UIControlStateNormal];
    
    if ([bookModel.like_status boolValue]) {
        self.likeBtn.selected = YES;
        self.likeBtn.userInteractionEnabled = NO;
    }else{
        self.likeBtn.selected = YES;
        self.likeBtn.userInteractionEnabled = YES;
    }
    self.commentBtn.frame = CGRectMake(self.likeBtn.right+10, self.descLabel.bottom+5, 80, 20);
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld",(long)[bookModel.comment_count integerValue]] forState:UIControlStateNormal];
    
    if (isEditing) {
        self.coverView.hidden = self.selBtn.hidden = NO;
        self.selBtn.selected = [bookModel.isSelected boolValue];
    }else{
        self.coverView.hidden = self.selBtn.hidden = YES;
    }
}

#pragma mark 计算时间差
- (NSInteger)pleaseInsertStarTime:(NSString *)time1 andInsertEndTime:(NSString *)time2{
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    MyLog(@"两个时间相差%ld年%ld月%ld日", (long)cmps.year, (long)cmps.month, (long)cmps.day);
    return cmps.month*30+cmps.day;
}

#pragma mark -- Getters
#pragma mark 封面
-(UIImageView *)myImgView{
    if (!_myImgView) {
        _myImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kImageW, kImageW)];
        [_myImgView setBorderWithCornerRadius:4.0 type:UIViewCornerTypeAll];
    }
    return _myImgView;
}

#pragma mark 更新时间
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, self.myImgView.bottom-26, 50, 18)];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont mediumFontWithSize:11.0f];
        _timeLabel.backgroundColor = [UIColor colorWithHexString:@"#8200FF"];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

#pragma mark 书名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.myImgView.bottom+10, kImageW, 40)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#303030"];
        _nameLabel.font = [UIFont mediumFontWithSize:14.0f];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

#pragma mark 描述
-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.nameLabel.bottom+5, kImageW, 36)];
        _descLabel.textColor = [UIColor colorWithHexString:@"#989FAE"];
        _descLabel.font = [UIFont regularFontWithSize:12.0f];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

#pragma mark 点赞
-(UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.descLabel.bottom+5, 80, 20)];
        [_likeBtn setImage:[UIImage imageNamed:@"title_praise_gray"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"title_praise_purple"] forState:UIControlStateSelected];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:@"#915AFF"] forState:UIControlStateSelected];
        _likeBtn.titleLabel.font = [UIFont regularFontWithSize:10.0f];
        _likeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _likeBtn.enabled = NO;
    }
    return _likeBtn;
}

#pragma mark 点赞
-(UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.likeBtn.right+10, self.descLabel.bottom+5, 80, 20)];
        [_commentBtn setImage:[UIImage imageNamed:@"title_comment"] forState:UIControlStateNormal];
        [_commentBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont regularFontWithSize:10.0f];
        _commentBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    return _commentBtn;
}


#pragma mark 蒙层
-(UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.myImgView.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
        [_coverView setBorderWithCornerRadius:4.0 type:UIViewCornerTypeAll];
        _coverView.alpha = 0.5;
    }
    return _coverView;
}

#pragma mark 选择
-(UIButton *)selBtn{
    if (!_selBtn) {
        _selBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.coverView.right-32, 12, 20, 20)];
        [_selBtn setImage:[UIImage imageNamed:@"cartoon_delete_unchoose"] forState:UIControlStateNormal];
        [_selBtn setImage:[UIImage imageNamed:@"cartoon_delete_choose"] forState:UIControlStateSelected];
    }
    return _selBtn;
}

@end
