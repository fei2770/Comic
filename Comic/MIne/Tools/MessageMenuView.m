//
//  MessageMenuVIew.m
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import "MessageMenuView.h"

@interface MessageMenuView (){
    UIButton  *selbtn;
}

@property (nonatomic,strong) UIView  *lineView;

@end

@implementation MessageMenuView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat btnW = kScreenWidth/3.0;
        
        self.backgroundColor = [UIColor whiteColor];
        
        for (NSInteger i=0; i<titles.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*btnW, 10, btnW, 40)];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#9B9B9B"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor commonColor_black] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont regularFontWithSize:IS_IPHONE_5?11.0f:13.0f];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.numberOfLines = 0;
            btn.tag = i;
            [btn addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            if (i==0) {
                btn.selected = YES;
                selbtn = btn;
            }
        }
        [self addSubview:self.lineView];
        
    }
    return self;
}

#pragma mark -- Event response
#pragma mark  点击
-(void)itemPressed:(UIButton *)sender{
    if (sender.selected) {
        sender.selected = NO;
    }
    sender.selected = YES;
    selbtn = sender;
    
    CGRect lineFrame = self.lineView.frame;
    lineFrame.origin.x = sender.tag*(kScreenWidth/3.0)+(kScreenWidth/3.0-16)/2.0;
    self.lineView.frame = lineFrame;
    
    if ([self.delegate respondsToSelector:@selector(messageMenuViewDidClickItemWithIndex:)]) {
        [self.delegate messageMenuViewDidClickItemWithIndex:sender.tag];
    }
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth/3.0 - 16)/2.0, 52, 16, 4)];
        _lineView.backgroundColor = [UIColor commonColor_black];
    }
    return _lineView;
}


@end
