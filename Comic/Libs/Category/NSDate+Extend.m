//
//  NSDate+Extend.m
//  HRLibrary
//
//  Created by vision on 2019/5/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import "NSDate+Extend.h"

@implementation NSDate (Extend)

#pragma mark 当前年
+(NSInteger)currentYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
}

#pragma mark 当前年月
+(NSString *)currentYearMonthWithFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}

#pragma mark 今天
+(NSString *)todayDateWithFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    return dateStr;
}

#pragma mark 以后的日期
+(NSString *)futureDateForDays:(NSInteger)days format:(NSString *)format{
    NSDate *aDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+days)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:beginningOfWeek];
}

#pragma mark 当前时间
+(NSString *)currentDateTimeWithFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}

#pragma mark 从日期中获取年、月、日、时、分或秒
+(NSString *)getDateInsideType:(DateInsideType)type FromDate:(NSDate *)fromDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents  = [calendar components:unitFlags fromDate:fromDate];
    
    NSString *result = nil;
    if (type == DateInsideTypeYear) {
        NSInteger year = [dateComponents year];
        result = [NSString stringWithFormat:@"%ld",(long)year];
    }else if (type == DateInsideTypeMonth){
        NSInteger month = [dateComponents month];
        result = [NSString stringWithFormat:@"%ld",(long)month];
    }else if (type == DateInsideTypeDay){
        NSInteger day = [dateComponents day];
        result = [NSString stringWithFormat:@"%ld",(long)day];
    }else if (type == DateInsideTypeHour){
        NSInteger hour = [dateComponents hour];
        result = [NSString stringWithFormat:@"%02ld",(long)hour];
    }else if (type == DateInsideTypeMinute){
        NSInteger minute = [dateComponents minute];
        result =  [NSString stringWithFormat:@"%02ld",(long)minute];
    }else{
        NSInteger second = [dateComponents second];
        result = [NSString stringWithFormat:@"%02ld",(long)second];
    }
    return result;
}

#pragma mark 计算任意2个时间的之间的间隔
+ (NSTimeInterval)pleaseInsertStarTime:(NSString *)starTime endTime:(NSString *)endTime format:(NSString *)format{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:format];
    NSDate* startDate = [formater dateFromString:starTime];
    NSDate* endDate = [formater dateFromString:endTime];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    return time;
}

#pragma mark 比较时间
- (NSDateComponents *)deltaFrom:(NSDate *)from{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:from toDate:self options:0];
}

#pragma mark 是否今年
- (BOOL)isThisYear{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    return nowYear == selfYear;
}

#pragma mark 是否今天
- (BOOL)isToday{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    
    return [nowString isEqualToString:selfString];
}

#pragma mark 是否昨天
- (BOOL)isYesterday{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}



@end
