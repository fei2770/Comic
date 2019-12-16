//
//  SlideMenuView.m
//  ZuoYe
//
//  Created by vision on 2018/9/11.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "SlideMenuView.h"

@interface SlideMenuView ()

//按钮标题字体
@property (nonatomic, strong) UIFont   *titleFont;
//按钮标题选中后颜色
@property (nonatomic, strong) UIColor  *titleSelectColor;
//按钮标题默认颜色
@property (nonatomic, strong) UIColor  *titleColor;

//滚动视图
@property(strong,nonatomic) UIScrollView *myScrollView;
//滚动下划线
@property(strong,nonatomic) UIView *line;
//所有的Button集合
@property(nonatomic,strong) NSMutableArray  *items;

//被选中前面的宽度合（用于计算是否进行超过一屏，没有一屏则进行平分）
@property(nonatomic,assign)CGFloat selectedTitlesWidth;


@end

@implementation SlideMenuView

-(instancetype)initWithFrame:(CGRect)frame btnTitleFont:(UIFont *)titleFont color:(UIColor *)color selColor:(UIColor *)selcolor{
    self = [super initWithFrame:frame];
    if (self) {
        self.myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
        self.myScrollView.showsHorizontalScrollIndicator = NO;
        self.myScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.myScrollView];
        
        self.items = [[NSMutableArray alloc] init];
        self.titleFont = titleFont ? titleFont : [UIFont pingFangSCWithWeight:FontWeightStyleSemibold size:18];
        self.titleColor = color ? color : [UIColor blackColor];
        self.titleSelectColor = selcolor ? selcolor : [UIColor redColor];
    }
    return self;
}

#pragma mark -- Event Response
#pragma mark 菜单点击事件
- (void)itemPressed:(UIButton *)button
{
    NSInteger index = [_items indexOfObject:button];
    self.currentIndex=index;
    
    if ([self.delegate respondsToSelector:@selector(slideMenuView:didSelectedWithIndex:)]) {
        [self.delegate slideMenuView:self didSelectedWithIndex:index];
    }
}

#pragma mark -- Setters
#pragma mark 菜单栏标题数组
-(void)setMyTitleArray:(NSMutableArray *)myTitleArray{
    _myTitleArray = myTitleArray;
    
    if (_items.count>0) {
        [_items removeAllObjects];
    }
    
    for (UIView *aview in self.myScrollView.subviews) {
        if ([aview isKindOfClass:[UIButton class]]) {
            [aview removeFromSuperview];
        }
    }
    
    //计算宽度
    NSMutableArray *widths = [@[] mutableCopy];
    _selectedTitlesWidth = 0.0;
    CGFloat capWidth = self.btnCapWidth ? self.btnCapWidth:20;
    for (NSString *title in myTitleArray){
        CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleFont} context:nil].size;
        CGFloat eachButtonWidth = size.width + capWidth;
        _selectedTitlesWidth += eachButtonWidth;
        NSNumber *width = [NSNumber numberWithFloat:eachButtonWidth];
        [widths addObject:width];
    }
    if (_selectedTitlesWidth < self.width) {
        [widths removeAllObjects];
        NSNumber *width = [NSNumber numberWithFloat:self.width / myTitleArray.count];
        for (int index = 0; index < myTitleArray.count; index++) {
            [widths addObject:width];
        }
    }
    
    // 设置按钮
    CGFloat buttonsWidth = 0.0;
    for (NSInteger index = 0; index < widths.count; index++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonsWidth, 0, [widths[index] floatValue], self.height);
        button.titleLabel.font = self.titleFont;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:self.myTitleArray[index] forState:UIControlStateNormal];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.myScrollView addSubview:button];
        
        [_items addObject:button];
        
        buttonsWidth += [widths[index] floatValue];
    }
    self.myScrollView.contentSize = CGSizeMake(buttonsWidth, 0);
    
    UIButton *btn = _items[0];
    
    self.lineWidth = self.lineWidth>0.0?self.lineWidth:[btn.currentTitle boundingRectWithSize:CGSizeMake(btn.width, btn.height) withTextFont:btn.titleLabel.font].width;
    
   
    _line = [[UIView alloc] initWithFrame:CGRectMake((btn.width-self.lineWidth)/2.0, self.height - 3,self.lineWidth,3)];
    [_line setBorderWithCornerRadius:4.0 type:UIViewCornerTypeAll];
    _line.backgroundColor = [UIColor commonColor_black];
    [self.myScrollView addSubview:_line];
    
}

#pragma mark 选中当前菜单
-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    
    UIButton *button = nil;
    button = _items[currentIndex];
    [button setTitleColor:self.titleSelectColor forState:UIControlStateNormal];
    
    //修改选中跟没选中的Button字体颜色
    for (NSInteger i=0; i<_items.count; i++) {
        if (i == currentIndex) {
            [button setTitleColor:self.titleSelectColor forState:UIControlStateNormal];
            [UIView animateWithDuration:.2f animations:^{
                 button.titleLabel.font = self.selectTitleFont?self.selectTitleFont:self.titleFont;
            }];
        }else{
            UIButton *btn = _items[i];
            [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
            [UIView animateWithDuration:.2f animations:^{
                  btn.titleLabel.font = self.titleFont;
            }];
        }
    }
    
    //设置滚动视图的滚动位置
    CGFloat offsetX = button.center.x - self.width * 0.5;
    CGFloat offsetMax = _selectedTitlesWidth - self.width;
    if (offsetX < 0 || offsetMax < 0) {
        offsetX = 0;
    } else if (offsetX > offsetMax){
        offsetX = offsetMax;
    }
    [self.myScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    [UIView animateWithDuration:.2f animations:^{
        self.line.frame = CGRectMake(button.frame.origin.x +(button.width-self.lineWidth)/2.0, self.line.frame.origin.y,self.lineWidth, self.line.frame.size.height);
    }];
}

-(void)setSelectTitleFont:(UIFont *)selectTitleFont{
    _selectTitleFont = selectTitleFont;
}


-(void)setBtnCapWidth:(CGFloat)btnCapWidth{
    _btnCapWidth = btnCapWidth;
}

-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
}

@end
