//
//  CustomDatePickerView.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/18.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "CustomDatePickerView.h"

@interface CustomDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSString *_title;
    NSString *_minDateStr;
    NSString *_maxDateStr;
    BRDateResultBlock _resultBlock;
    NSString *_selectValue;
}

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation CustomDatePickerView

+(void)showDatePickerWithTitle:(NSString *)title defauldValue:(NSString *)selectValue minDateStr:(NSString *)minDateStr maxDateStr:(NSString *)maxDateStr resultBlock:(BRDateResultBlock)resultBlock{
    CustomDatePickerView *pickerView = [[CustomDatePickerView alloc] initWithTitle:title defaultSelValue:selectValue minDateStr:minDateStr maxDateStr:maxDateStr resultBlock:resultBlock];
    [pickerView showWithAnimation:YES];
}

#pragma mark - 初始化时间选择器
- (instancetype)initWithTitle:(NSString *)title defaultSelValue:(NSString *)defaultSelValue minDateStr:(NSString *)minDateStr maxDateStr:(NSString *)maxDateStr resultBlock:(BRDateResultBlock)resultBlock {
    if (self = [super init]) {
        _title = title;
        _minDateStr = minDateStr;
        _maxDateStr = maxDateStr;
        _resultBlock = resultBlock;
        
        [self loadData];
        [self initUI];
    }
    return self;
}

#pragma mark - UIPickerView
//返回多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//返回多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.data.count;
}

//每一行的数据
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.data[row];
}

//选中时的效果
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectValue = self.data[row];
}

//返回高度
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35.0f;
}

//返回宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 180;
}

#pragma mark -- Event response
#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES];
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    [self dismissWithAnimation:YES];
    if(_resultBlock) {
       _resultBlock(_selectValue);
    }
}

#pragma mark -- Private Methods
#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = SCREEN_HEIGHT;
        self.alertView.frame = rect;
        
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= kDatePicHeight + kTopViewHeight;
            self.alertView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += kDatePicHeight + kTopViewHeight;
        self.alertView.frame = rect;
        
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.leftBtn removeFromSuperview];
        [self.rightBtn removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.lineView removeFromSuperview];
        [self.topView removeFromSuperview];
        [self.pickerView removeFromSuperview];
        [self.alertView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
        self.leftBtn = nil;
        self.rightBtn = nil;
        self.titleLabel = nil;
        self.lineView = nil;
        self.topView = nil;
        self.pickerView = nil;
        self.alertView = nil;
        self.backgroundView = nil;
    }];
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    self.titleLabel.text = _title;
    // 添加时间选择器
    [self.alertView addSubview:self.pickerView];
}

#pragma mark 加载数据
-(void)loadData{
    //当前日期时间
    NSDate *currentDate = [NSDate date];
    //设定数据格式为xxxx-mm
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    //通过日历可以直接获取前几个月的日期，所以这里直接用该类的方法进行循环获取数据
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    NSString *dateStr = [formatter stringFromDate:currentDate];
    NSInteger lastIndex = 0;
    NSDate *newdate;
    //循环获取可选月份，从当前月份到最小月份，直接用字符串的比较来判断是否大于设定的最小日期
    while (!([dateStr compare:_minDateStr] == NSOrderedAscending)) {
        [self.data addObject:dateStr];
        lastIndex--;
        //获取之前n个月, setMonth的参数为正则向后，为负则表示之前
        [lastMonthComps setMonth:lastIndex];
        newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
        dateStr = [formatter stringFromDate:newdate];
    }
}

#pragma mark 选择器
-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, SCREEN_WIDTH, kDatePicHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

-(NSMutableArray *)data{
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}



@end
