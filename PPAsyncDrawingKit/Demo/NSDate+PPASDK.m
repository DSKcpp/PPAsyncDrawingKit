//
//  NSDate+PPASDK.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/12/11.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "NSDate+PPASDK.h"

@interface PPDateFormatter : NSDateFormatter
+ (PPDateFormatter *)dateFormatter;
@end

@implementation PPDateFormatter

+ (PPDateFormatter *)dateFormatter
{
    static PPDateFormatter *df;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        df = [[self alloc] init];
    });
    return df;
}

@end

@implementation NSDate (PPASDK)
- (NSString *)toDisplayString
{
    PPDateFormatter *fmt = [PPDateFormatter dateFormatter];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    fmt.dateFormat = @"HH:mm";
    NSDateComponents *dateComps = [calendar components:unit fromDate:self];
    NSDateComponents *nowComps = [calendar components:unit fromDate:[NSDate date]];
    NSTimeInterval interval = -self.timeIntervalSinceNow;
    if (interval < 60) {
        return @"刚刚";
    } else if (interval < 3600) {
        return [NSString stringWithFormat:@"%zd分钟前", interval / 60 ];
    } else if (nowComps.year == dateComps.year) {
        if (nowComps.month == dateComps.month) {
            if (nowComps.day == dateComps.day) {
                return [fmt stringFromDate:self];
            } else if ((nowComps.day - dateComps.day) == 1) {
                return [NSString stringWithFormat:@"昨天 %@", [fmt stringFromDate:self]];
            } else if ((nowComps.day - dateComps.day) < 9) {
                return [NSString stringWithFormat:@"%@ %@", [self getWeekday], [fmt stringFromDate:self]];
            }
        }
    }
    fmt.dateFormat = @"yyyy-MM-dd";
    return [fmt stringFromDate:self];
}

- (NSString *)getWeekday
{
   NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:self];
    return @[@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"][weekday-1];
}

@end
