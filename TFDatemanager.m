//
//  TFDatemanager.m
//  daily
//
//  Created by taffy on 15/7/27.
//  Copyright (c) 2015年 Taffy. All rights reserved.
//

#import "TFDatemanager.h"


@interface TimeModel : NSObject

@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger hour;
@property (nonatomic) NSInteger minute;
@property (nonatomic) NSInteger second;

- (TimeModel *) bindWithDateComponents: (NSDateComponents *)components;

@end


@implementation TimeModel

- (TimeModel *)bindWithDateComponents:(NSDateComponents *)components {
  self.year = [components year];
  self.month = [components month];
  self.day = [components day];
  self.hour = [components hour];
  self.minute = [components minute];
  self.second = [components second];
  return self;
}

@end



#define IS_MAX(a, b) (a-b>0?1:0)

NSString static *kDateStyle1 = @"HH:mm";
NSString static *kDateStyle2 = @"MM/dd/yy HH:mm";
NSString static *kDateStyle3 = @"MM-dd";
NSString static *KDateStyle4 = @"yyyy-MM-dd";
NSString static *kDateStyle5 = @"MM 月 dd 日 EEEE";
NSString static *kDateStyle6 = @"MM 月 dd 日";


@implementation TFDatemanager {
  
}

NSDateFormatter *dateFormatter() {
  static NSDateFormatter *formate;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    formate = [NSDateFormatter new];
  });
  
  return formate;
}

NSDateFormatter *dateFormatterStyle1() {
  [dateFormatter() setDateFormat:kDateStyle1];
  return dateFormatter();
}

NSDateFormatter *dateFormatterStyle2() {
  [dateFormatter() setDateFormat:kDateStyle2];
  return dateFormatter();
}

NSDateFormatter *dateFormatterStyle3() {
  [dateFormatter() setDateFormat:kDateStyle3];
  return dateFormatter();
}

NSDateFormatter *dateFormatterStyle4() {
  [dateFormatter() setDateFormat:KDateStyle4];
  return dateFormatter();
}

NSDateFormatter *dateFormatterStyle5() {
  [dateFormatter() setDateFormat:kDateStyle5];
  return dateFormatter();
}

NSDateFormatter *dateFormatterStyle6() {
  [dateFormatter() setDateFormat:kDateStyle6];
  return dateFormatter();
}


TimeModel *getTimeModel(NSDate *date){
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
  return [[TimeModel new] bindWithDateComponents:components];
}

NSString *get24TimeFormatter(NSInteger number) {
  if (number <= 9) return [NSString stringWithFormat:@"0%ld", number];
  return [NSString stringWithFormat:@"%ld", number];
}


#pragma mark - 获取特殊的时间格式

+ (NSString *)getSpecialtyTimeFromAbsoluteDate: (NSInteger) atUnixTime {
  
  if (atUnixTime == 0) {
    return @"";
  }
  
  NSString *suffixText;
  
  // @"yyyy-MM-dd HH:mm:ss"
  
  // 当前时间的时间戳
  NSInteger currentUnixTime = [[NSDate new] timeIntervalSince1970];
  
  // 拿到相对时间差
  float relativelyUnixTime = currentUnixTime - atUnixTime;
  float divisionValue = relativelyUnixTime / 3600.0f;
  
  if (!IS_MAX(relativelyUnixTime, 60.0f)) {
    return @"刚刚";
  } else {
    if (!IS_MAX(divisionValue, 1.0f)) {
      return [NSString stringWithFormat:@"%.f 分钟前", relativelyUnixTime / 60];
    } else {
      if (!IS_MAX(divisionValue, 24.0f)) {
        return [NSString stringWithFormat:@"%.f 小时前", divisionValue];
      } else {
        if (!IS_MAX(divisionValue, 96.0f)) {
          return [NSString stringWithFormat:@"%.f 天前", divisionValue / 24];
        } else {
          [dateFormatter() setDateFormat:kDateStyle6];
          suffixText = @"";
        }
      }
    }
  }
  
  // 转化成标准时间格式
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:atUnixTime];
  
  return [NSString stringWithFormat:@"%@ %@", [dateFormatter() stringFromDate:date], suffixText];
}

+ (NSString *)getSpecialtyTimeFromAbsoluteUnixTime: (NSInteger) atUnixTime {
  
  if (atUnixTime == 0) {
    return @"";
  }
  
  // 当前时间的时间戳
  NSInteger currentUnixTime = [[NSDate new] timeIntervalSince1970];
  
  // 拿到相对时间差
  float relativelyUnixTime = currentUnixTime - atUnixTime;
  float divisionValue = relativelyUnixTime / 3600.0f;
  
  if (!IS_MAX(relativelyUnixTime, 60.0f)) {
    return @"刚刚";
  } else {
    if (!IS_MAX(divisionValue, 1.0f)) {
      return [NSString stringWithFormat:@"%.f 分钟前", relativelyUnixTime / 60];
    }
  }
  
  if (IS_MAX([HMRV3DateManage getRoundUnixDateFromUnixTime:currentUnixTime], [HMRV3DateManage getRoundUnixDateFromUnixTime:atUnixTime])) {
    [dateFormatter() setDateFormat:kDateStyle2];
  } else {
    [dateFormatter() setDateFormat:kDateStyle1];
  }
  
  
  // 对 ‘秒’ 取整
  NSInteger ss = 10 - atUnixTime % 10;
  atUnixTime += (ss < 5) ? ss : 0;
  
  // 转化成标准时间格式
  NSDate *date = [NSDate dateWithTimeIntervalSince1970: atUnixTime];
  
  
  NSString *specialtyTime = [NSString stringWithFormat:@"%@", [dateFormatter() stringFromDate:date]];
  
  return specialtyTime;
}


+ (NSString *)getSpecialtyTimeWithUnixTime:(NSInteger)atUnixTime {
  
  if (atUnixTime == 0) {
    return @"";
  }
  
  NSDate *currentDate = [NSDate new];
  NSDate *beforeDate = [NSDate dateWithTimeIntervalSince1970:atUnixTime];
  
  TimeModel *currentTime = getTimeModel(currentDate);
  TimeModel *beforeTime = getTimeModel(beforeDate);
  
  
  if (currentTime.year != beforeTime.year) {
    return [NSString stringWithFormat:@"%@-%@-%@", get24TimeFormatter(beforeTime.year), get24TimeFormatter(beforeTime.month), get24TimeFormatter(beforeTime.day)];
  }
  else if ((currentTime.month != beforeTime.month) || ((currentTime.day - beforeTime.day) >= 7)) {
    return [NSString stringWithFormat:@"%@-%@", get24TimeFormatter(beforeTime.month), get24TimeFormatter(beforeTime.day)];
  }
  else if ((currentTime.day - beforeTime.day) > 1) {
    return [NSString stringWithFormat:@"%ld 天前", currentTime.day - beforeTime.day];
  }
  else if (currentTime.day != beforeTime.day) {
    return [NSString stringWithFormat:@"昨天 %@:%@", get24TimeFormatter(beforeTime.hour), get24TimeFormatter(beforeTime.minute)];
  }
  else if (currentTime.hour - beforeTime.hour >= 12) {
    return [NSString stringWithFormat:@"%@:%@", get24TimeFormatter(beforeTime.hour), get24TimeFormatter(beforeTime.minute)];
  }
  else if (currentTime.hour != beforeTime.hour) {
    return [NSString stringWithFormat:@"%ld 小时前", currentTime.hour - beforeTime.hour];
  }
  else if (currentTime.minute != beforeTime.minute) {
    return [NSString stringWithFormat:@"%ld 分钟前", currentTime.minute - beforeTime.minute];
  }
  else {
    return @"刚刚";
  }
}



+ (NSInteger) getRoundUnixDateFromUnixTime: (NSInteger) atUnixTime {
  
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:atUnixTime];
  NSString *dateString = [dateFormatterStyle4() stringFromDate:date];
  
  NSInteger roundTime = [[dateFormatter() dateFromString:dateString] timeIntervalSince1970];
  return roundTime;
}

+ (NSInteger) getRoundDelayUnixDateFromUnixTime: (NSInteger) atUnixTime {
  
  NSInteger roundTime = [HMRV3DateManage getRoundUnixDateFromUnixTime:atUnixTime];
  
  
  if (atUnixTime < roundTime + TIME_DELAY) {
    return roundTime - 24 * 60 * 60 + TIME_DELAY;
  } else {
    return roundTime + TIME_DELAY;
  }
}


+ (NSString *)getSpecialtyDateFromUnixTime: (NSInteger) atUnixTime {

  NSDate *date = [NSDate dateWithTimeIntervalSince1970:atUnixTime];
  NSString *dateString = [dateFormatterStyle5() stringFromDate:date];
  
  
  return dateString;

}

@end

