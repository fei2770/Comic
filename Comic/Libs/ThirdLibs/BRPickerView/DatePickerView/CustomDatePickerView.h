//
//  CustomDatePickerView.h
//  ZYForTeacher
//
//  Created by vision on 2018/10/18.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseView.h"

//日期选择完成之后的操作
typedef void(^BRDateResultBlock)(NSString *selectValue);

@interface CustomDatePickerView : BaseView

//对外开放的类方法
+ (void)showDatePickerWithTitle:(NSString *)title defauldValue:(NSString *)selectValue minDateStr:(NSString *)minDateStr maxDateStr:(NSString *)maxDateStr resultBlock:(BRDateResultBlock)resultBlock;

@end
