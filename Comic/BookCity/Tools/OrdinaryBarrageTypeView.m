//
//  OrdinaryBarrageTypeView.m
//  Comic
//
//  Created by vision on 2019/11/21.
//  Copyright © 2019 vision. All rights reserved.
//

#import "OrdinaryBarrageTypeView.h"

@interface OrdinaryBarrageTypeView (){
    CGPoint startLocation;
}

@property (nonatomic,strong) UIView      *upView;
@property (nonatomic,strong) UILabel     *inputLabel; //文字

@end

@implementation OrdinaryBarrageTypeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        [self addSubview:self.inputLabel];
        [self addSubview:self.upView];
    
    }
    return self;
}

-(void)setContentText:(NSString *)contentText{
    self.inputLabel.text = contentText;
    CGFloat labW = [contentText boundingRectWithSize:CGSizeMake(kScreenWidth, 32) withTextFont:self.inputLabel.font].width;
    CGRect labFrame = self.inputLabel.frame;
    labFrame.origin.x = 0;
    labFrame.size.width = labW+30;
    self.inputLabel.frame = labFrame;
    [self.inputLabel setBorderWithCornerRadius:16 type:UIViewCornerTypeAll];
    self.upView.frame = labFrame;
    
    CGRect frame = self.frame;
    frame.origin.x = (kScreenWidth-labW-30)/2.0;
    frame.size.width = labW +30;
    self.frame = frame;
}

-(void)setHideLine:(BOOL)hideLine{
    _hideLine = hideLine;
    self.upView.hidden = hideLine;
}


#pragma mark -- Event
#pragma mark 拖拽事件
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    MyLog(@"touchesBegan");
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
    [[self superview] bringSubviewToFront:self];
}
 
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    MyLog(@"touchesMoved");
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
    MyLog(@"touchesEnded");
    
}

#pragma mark -- Getters
#pragma mark 文字
-(UILabel *)inputLabel{
    if (!_inputLabel) {
        _inputLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _inputLabel.textColor = [UIColor whiteColor];
        _inputLabel.font = [UIFont mediumFontWithSize:14.0f];
        _inputLabel.textAlignment = NSTextAlignmentCenter;
        double  transparency = [[NSUserDefaultsInfos getValueforKey:kBarrageTransparency] doubleValue];
        _inputLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:transparency>0?(transparency/100.0):0.6];
        [_inputLabel setBorderWithCornerRadius:16 type:UIViewCornerTypeAll];
    }
    return _inputLabel;
}

#pragma mark
-(UIView *)upView{
    if (!_upView) {
        _upView = [[UIView alloc] initWithFrame:self.bounds];
        _upView.layer.borderWidth = 1.0;
        _upView.layer.borderColor = [UIColor colorWithHexString:@"#FFE845"].CGColor;
    }
    return _upView;
}




@end
