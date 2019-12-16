//
//  InvalidRemindView.m
//  Comic
//
//  Created by vision on 2019/11/18.
//  Copyright © 2019 vision. All rights reserved.
//

#import "InvalidRemindView.h"
#import "QWAlertView.h"

@interface InvalidRemindView (){
    NSString  *_time;
    NSInteger _count;
}

@property (nonatomic,strong) UILabel   *titleLab;
@property (nonatomic,strong) UIButton  *closeBtn;
@property (nonatomic,strong) UILabel   *descLab;
@property (nonatomic,strong) UIView    *bgView;
@property (nonatomic,strong) UILabel   *timeLab;
@property (nonatomic,strong) UIView    *dotLine;
@property (nonatomic,strong) UILabel   *countLab;
@property (nonatomic,strong) UILabel   *lab;

@end

@implementation InvalidRemindView

-(instancetype)initWithFrame:(CGRect)frame time:(NSString *)time beans:(NSInteger)beans{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setBorderWithCornerRadius:18 type:UIViewCornerTypeAll];
        
        _time = time;
        _count = beans;
        
        [self addSubview:self.titleLab];
        [self addSubview:self.closeBtn];
        [self addSubview:self.descLab];
        [self addSubview:self.bgView];
        [self addSubview:self.timeLab];
        [self addSubview:self.dotLine];
        [self addSubview:self.countLab];
        [self addSubview:self.lab];
    }
    return self;
}

+(void)showEvaluateViewWithFrame:(CGRect)frame time:(NSString *)timeStr beans:(NSInteger)beans{
    InvalidRemindView *view = [[InvalidRemindView alloc] initWithFrame:frame time:timeStr beans:beans];
    [view invalidViewShow];
}

#pragma mark 取消评价
-(void)closeInvalidReminderView{
    [[QWAlertView sharedMask] dismiss];
}

#pragma mark -- private methods
-(void)invalidViewShow{
    [[QWAlertView sharedMask] show:self withType:QWAlertViewStyleAlert];
}

#pragma mark 画虚线
-(void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor{
  CAShapeLayer *shapeLayer = [CAShapeLayer layer];
  [shapeLayer setBounds:lineView.bounds];
  [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame), CGRectGetHeight(lineView.frame)/2)];
  [shapeLayer setFillColor:[UIColor clearColor].CGColor];
  //  设置虚线颜色为blackColor
  [shapeLayer setStrokeColor:lineColor.CGColor];
  //  设置虚线宽度
  [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
  [shapeLayer setLineJoin:kCALineJoinRound];
  //  设置线宽，线间距
  [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
  //  设置路径
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathMoveToPoint(path, NULL, 0, 0);
  CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
  [shapeLayer setPath:path];
  CGPathRelease(path);
  //  把绘制好的虚线添加上来
  [lineView.layer addSublayer:shapeLayer];
}

#pragma mark
#pragma mark 提示
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.width-20, 20)];
        _titleLab.font = [UIFont mediumFontWithSize:18.0f];
        _titleLab.textColor = [UIColor colorWithHexString:@"#FF9100"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"Mencontohkan";
    }
    return _titleLab;
}

#pragma mark 关闭
-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-40, 10, 30, 30)];
        [_closeBtn setImage:[ UIImage drawImageWithName:@"popup_close" size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeInvalidReminderView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

#pragma mark 描述
-(UILabel *)descLab{
    if (!_descLab) {
        _descLab = [[UILabel alloc] initWithFrame:CGRectMake(10,self.titleLab.bottom+10, self.width-20, 40)];
        _descLab.font = [UIFont regularFontWithSize:14.0f];
        _descLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _descLab.textAlignment = NSTextAlignmentCenter;
        _descLab.numberOfLines = 0;
        _descLab.text = @"Hadiah koin segera berakhir! jangan lupa segera habiskan ya";
    }
    return _descLab;
}

#pragma mark 背景
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(15, self.descLab.bottom+10, self.width-30, 58)];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"#FFF2E2"];
        [_bgView setBorderWithCornerRadius:4 type:UIViewCornerTypeAll];
    }
    return _bgView;
}

#pragma mark 失效日期
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(20,self.bgView.top+20, self.width-120, 20)];
        _timeLab.font = [UIFont mediumFontWithSize:13.0f];
        _timeLab.textColor = [UIColor colorWithHexString:@"#FF9100"];
        _timeLab.text = [NSString stringWithFormat:@"%@ Gagal",_time];
    }
    return _timeLab;
}

-(UIView *)dotLine{
    if (!_dotLine) {
        _dotLine = [[UIView alloc]  initWithFrame:CGRectMake(self.timeLab.right, self.bgView.top+14, 1, 30)];
        [self drawDashLine:_dotLine lineLength:2 lineSpacing:1 lineColor:[UIColor colorWithHexString:@"#FF9100"]];
    }
    return _dotLine;
}

#pragma mark 金币数
-(UILabel *)countLab{
    if (!_countLab) {
        _countLab = [[UILabel alloc] initWithFrame:CGRectMake(self.timeLab.right+10,self.bgView.top+10, 60, 22)];
        _countLab.font = [UIFont mediumFontWithSize:20.0f];
        _countLab.textColor = [UIColor colorWithHexString:@"#FF9100"];
        _countLab.textAlignment = NSTextAlignmentCenter;
        _countLab.text = [NSString stringWithFormat:@"%ld",(long)_count];
    }
    return _countLab;
}

#pragma mark 金币数
-(UILabel *)lab{
    if (!_lab) {
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(self.timeLab.right+10,self.countLab.bottom, 55, 22)];
        _lab.font = [UIFont regularFontWithSize:10.0f];
        _lab.textColor = [UIColor colorWithHexString:@"#FF9100"];
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.text = @"koin";
    }
    return _lab;
}


@end
