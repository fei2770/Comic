//
//  BarrageTypeView.m
//  Comic
//
//  Created by vision on 2019/11/21.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BarrageTypeView.h"

@interface BarrageTypeView (){
    CGPoint startLocation;
}

@property (nonatomic,strong) UIImageView   *typeImgView;
@property (nonatomic,strong) UIView        *bgView;    //背景
@property (nonatomic,strong) UIImageView   *myImgView;
@property (nonatomic,strong) UIImageView   *tagImgView;  //vip 或 金币
@property (nonatomic,strong) UILabel       *inputLabel; //文字

@end

@implementation BarrageTypeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        [self addSubview:self.bgView];
        [self addSubview:self.typeImgView];
        [self addSubview:self.myImgView];
        [self addSubview:self.inputLabel];
        [self addSubview:self.tagImgView];
        
        self.tagImgView.hidden = YES;
    }
    return self;
}

#pragma mark 填充数据
-(void)setTypeDict:(NSDictionary *)typeDict{
    _typeDict = typeDict;
    
    self.typeImgView.image = [UIImage imageNamed:typeDict[@"begin_icon"]];
    self.myImgView.image = [UIImage imageNamed:typeDict[@"end_icon"]];
    self.bgView.backgroundColor= [UIColor bm_colorGradientChangeWithSize:self.bgView.size direction:IHGradientChangeDirectionVertical startColor:[UIColor colorWithHexString:typeDict[@"begin_color"]] endColor:[UIColor colorWithHexString:typeDict[@"end_color"]]];
}

#pragma mark vip或金币
-(void)setPay_type:(NSInteger)pay_type{
    _pay_type = pay_type;
    if (pay_type>0) {
        self.tagImgView.hidden = NO;
        self.tagImgView.image = [UIImage imageNamed:pay_type==1?@"barrage_style_vip":@"barrage_style_koin"];
    }else{
        self.tagImgView.hidden = YES;
    }
}

#pragma mark 显示文字
-(void)setContentText:(NSString *)contentText{
    _contentText = contentText;
    
    self.inputLabel.text = contentText;
    CGFloat labW = [contentText boundingRectWithSize:CGSizeMake(kScreenWidth, 24) withTextFont:self.inputLabel.font].width;
    self.inputLabel.frame = CGRectMake(55, 20, labW, 24);
    self.bgView.frame = CGRectMake(20, 16, labW+60, 32);
    self.myImgView.frame = CGRectMake(self.bgView.right-30,self.bgView.top, 30, 30);
    
    CGRect frame = self.frame;
    frame.origin.x = (kScreenWidth-labW-90)/2.0;
    frame.size.width = labW +90;
    self.frame = frame;
}

#pragma mark -- Event
#pragma mark 拖拽事件
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    if (!self.canMove) {
        return;
    }
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
    [[self superview] bringSubviewToFront:self];
}
 
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    if (!self.canMove) {
        return;
    }
    CGPoint pt = [[touches anyObject] locationInView:self];
    float dx = pt.x - startLocation.x;
    float dy = pt.y - startLocation.y;
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    //
    float halfx = CGRectGetMidX(self.bounds);
    newcenter.x = MAX(halfx, newcenter.x);
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
    //
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
    //
    self.center = newcenter;
}
 
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.canMove) {
        return;
    }
}

#pragma mark -- Getters
#pragma mark 开始
-(UIImageView *)typeImgView{
    if (!_typeImgView) {
        _typeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 45, 45)];
    }
    return _typeImgView;
}

#pragma mark
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 16,self.width-40, 32)];
        _bgView.layer.cornerRadius = 16;
    }
    return _bgView;
}

#pragma mark 文字
-(UILabel *)inputLabel{
    if (!_inputLabel) {
        _inputLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 20, self.width-90, 24)];
        _inputLabel.textColor = [UIColor whiteColor];
        _inputLabel.font = [UIFont mediumFontWithSize:14.0f];
    }
    return _inputLabel;
}

#pragma mark
-(UIImageView *)myImgView{
    if (!_myImgView) {
        _myImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bgView.right-30,self.bgView.top, 30, 30)];
    }
    return _myImgView;
}

#pragma mark
-(UIImageView *)tagImgView{
    if (!_tagImgView) {
        _tagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-32, 5,27, 14)];
    }
    return _tagImgView;
}

@end
