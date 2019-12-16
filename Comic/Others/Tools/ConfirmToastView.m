//
//  ConfirmToastView.m
//  Teasing
//
//  Created by vision on 2019/5/30.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ConfirmToastView.h"
#import "QWAlertView.h"

@interface ConfirmToastView ()

@property (nonatomic, copy) SureBlock   sureBlock;
@property (nonatomic, copy) CancelBlock cancelBlock;

@end


@implementation ConfirmToastView

+(void)showConfirmToastWithFrame:(CGRect)frame message:(NSString *)message sureBlock:(SureBlock)sureBlock cancelBlock:(CancelBlock)cancelBlock{
    ConfirmToastView *toastView = [[ConfirmToastView alloc] initWithFrame:frame toastMsg:message sureBlock:sureBlock cancelBlock:cancelBlock];
    [toastView show];
}


-(instancetype)initWithFrame:(CGRect)frame toastMsg:(NSString *)msg sureBlock:(SureBlock)sureBlock cancelBlock:(CancelBlock)cancelBlock{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBorderWithCornerRadius:6 type:UIViewCornerTypeAll];
        self.backgroundColor = [UIColor whiteColor];
        
        self.sureBlock = sureBlock;
        self.cancelBlock = cancelBlock;
        
        CGFloat viewWidth = frame.size.width;

        UILabel *msgLab = [[UILabel alloc] initWithFrame:CGRectZero];
        msgLab.font = [UIFont regularFontWithSize:16.0f];
        msgLab.textColor = [UIColor commonColor_black];
        msgLab.numberOfLines = 0;
        msgLab.textAlignment = NSTextAlignmentCenter;
        msgLab.text = msg;
        CGFloat labH = [msg boundingRectWithSize:CGSizeMake(viewWidth-32, CGFLOAT_MAX) withTextFont:msgLab.font].height;
        msgLab.frame = CGRectMake(16, 20, viewWidth-32, labH);
        [self addSubview:msgLab];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth-180)/2.0, msgLab.bottom+20, 180, 32)];
        [sureBtn setTitle:@"Yakin" forState:UIControlStateNormal];
        [sureBtn setBackgroundColor:[UIColor systemColor]];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont mediumFontWithSize:16.0f];
        sureBtn.layer.cornerRadius = 16.0;
        [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth-180)/2.0, sureBtn.bottom+15, 180, 32)];
        [cancelBtn setTitle:@"Hapus" forState:UIControlStateNormal];
        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [cancelBtn setTitleColor:[UIColor systemColor] forState:UIControlStateNormal];
        cancelBtn.layer.cornerRadius = 16.0;
        cancelBtn.layer.borderColor = [UIColor systemColor].CGColor;
        cancelBtn.layer.borderWidth = 1.0;
        cancelBtn.titleLabel.font = [UIFont mediumFontWithSize:16.0f];
        [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
    }
    return self;
}

-(void)show{
     [[QWAlertView sharedMask] show:self withType:QWAlertViewStyleAlert];
}

#pragma mark -- Event Response
#pragma mark 确定
-(void)sureAction:(UIButton *)sender{
    [[QWAlertView sharedMask] dismiss];
    self.sureBlock();
}

#pragma mark 取消
-(void)cancelAction:(UIButton *)sender{
    [[QWAlertView sharedMask] dismiss];
    self.cancelBlock();

}


@end
