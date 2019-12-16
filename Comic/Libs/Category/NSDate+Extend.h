//
//  NSDate+Extend.h
//  HRLibrary
//
//  Created by vision on 2019/5/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    DateInsideTypeYear,
    DateInsideTypeMonth,
    DateInsideTypeDay,
    DateInsideTypeHour,
    DateInsideTypeMinute,
    DateInsideTypeSecond,
    DateInsideTypeWeek,
} DateInsideType;


@interface NSDate (Extend)

/**
 *  今年
 *
 *  @return 当前年
 */
+ (NSInteger )currentYear;

/**
 *  当前年月
 *
 *  @param  format 日期格式 （如yyyy-MM）
 *  @return 当前年月
 */
+ (NSString *)currentYearMonthWithFormat:(NSString *)format;

/**
 *  获取今天日期
 *
 *  @param  format 日期格式 （如yyyy-MM）
 *  @return 今天日期
 */
+(NSString *)todayDateWithFormat:(NSString *)format;

/**
 *  获取以后的日期
 *
 *  @param  format 日期格式 （如yyyy-MM）
 *  @param  days  以后天数 （如明天 +1）
 *  @return 以后的日期
 */
+(NSString *)futureDateForDays:(NSInteger)days format:(NSString *)format;

/**
 *  获取当前时间
 *
 *  @param  format 日期格式 （如yyyy-MM-dd HH:mm）
 *  @return 当前时间
 */
+ (NSString *)currentDateTimeWithFormat:(NSString *)format;

/**
 *  从日期中获取年、月、日、时、分或秒
 *
 *  @param  type     获取日期类型
 *  @param  fromDate  日期
 *  @return 日期中的年、月、日、时、分或秒
 */
+ (NSString *)getDateInsideType:(DateInsideType)type FromDate:(NSDate *)fromDate;

/**
 *  计算任意两个时间的间隔
 *
 *  @param  starTime     开始时间
 *  @param  endTime      结束时间
 *  @param  format       时间格式
 *  @return 间隔
 */
+ (NSTimeInterval)pleaseInsertStarTime:(NSString *)starTime endTime:(NSString *)endTime format:(NSString *)format;


/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;

@end


