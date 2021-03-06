//
//  TFDatemanager.h
//  daily
//
//  Created by taffy on 15/7/27.
//  Copyright (c) 2015年 Taffy. All rights reserved.
//

#import <Foundation/Foundation.h>


#define TIME_DELAY (3600 * 7 - 3)

@interface TFDatemanager : NSObject {
  
}


/**
 * @brief 返回特殊的时间格式 (样式 1)
 *
 * @param atUnixTime 时间戳
 *
 * @return 格式 1：刚刚 <= 1 min；
 * @return 格式 2：x 分钟前 <= 1 h；
 * @return 格式 3：x 小时前 <= 24 h；
 * @return 格式 4：x 天前 <= 4 days；
 * @return 格式 5：xx 月 xx 日 > 4 days；
 */
+ (NSString *)getSpecialtyTimeFromAbsoluteDate: (NSInteger) atUnixTime;


/**
 * @brief 返回特殊的时间格式（样式二）
 *
 * @param atUnixTime 时间戳
 *
 * @return 格式 1：刚刚 <= 1 min；
 * @return 格式 2：mm 分钟前 <= 1 h；
 * @return 格式 3：HH:mm <= 24 h；
 * @return 格式 4：HH/dd HH:mm > 24 h；
 */
+ (NSString *)getSpecialtyTimeFromAbsoluteUnixTime: (NSInteger) atUnixTime;


/**
 * @brief 返回特殊的时间格式（样式三）
 *
 * @param atUnixTime 时间戳
 *
 * @return 刚刚:<= 1 分钟
 * @return xx 分钟前: 1 分钟 <= 41 分钟  <= 59 分钟
 * @return xx:xx : 12 小时 <= 16:23 <= 00:00
 * @return 昨天 xx:xx : 00:00 <= 昨天 08:32 <= 昨天 00:00
 * @return 2 天前: 昨天 00:00 <= 2 天前 <= 2 天前的 00:00
 * ...
 * @return 6 天前: 5 天前 00:00 <= 6 天前 <= 6 天前 00:00
 * @return xx-xx: 6 天前 00:00 <= 02-17 <= 今年 12/31
 * @return xxxx-xx-xx: 今年 12-31 <= 2015-11-21
 */
+ (NSString *)getSpecialtyTimeWithUnixTime:(NSInteger)atUnixTime;


// 对时间戳取整
+ (NSInteger) getRoundUnixDateFromUnixTime: (NSInteger) atUnixTime;

// 对时间取整 后推迟 TIME_DELAY 秒
+ (NSInteger) getRoundDelayUnixDateFromUnixTime: (NSInteger) atUnixTime;

//+ (NSInteger) getRoundDelayUnixDateFromCurrentDay: (NSDate *) currentTime;


// 获取如： ”xxxx 年 xx 月 xx 日 星期一“ 的格式
+ (NSString *)getSpecialtyDateFromUnixTime: (NSInteger) atUnixTime;

@end




