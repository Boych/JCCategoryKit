//
//  NSDate+JCKit.m
//  JCCategoryKit
//
//  Created by ChenJianjun on 16/7/1.
//  Copyright © 2016 Boych<https://github.com/Boych>. All rights reserved.
//

#import "NSDate+JCKit.h"
#import <objc/runtime.h>

static const char *kCachedDateFormattersKey;

@implementation NSDate (JCKit)

+ (NSString *)jc_currentDate
{
    NSDateFormatter *formatter = [NSDateFormatter jc_cachedDateFormatter:@"yyyy-MM-dd HH:mm"]; //:ss
    return [formatter stringFromDate:[NSDate date]];
}

@end

@implementation NSDateFormatter (JCKit)

+ (NSDateFormatter *)jc_cachedDateFormatter:(NSString *)stringDateFormatter
{
    NSMutableDictionary *cachedDictionary = objc_getAssociatedObject(self, &kCachedDateFormattersKey);
    if (!cachedDictionary) {
        objc_setAssociatedObject(self, &kCachedDateFormattersKey, [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        cachedDictionary = objc_getAssociatedObject(self, &kCachedDateFormattersKey);
    }
    NSString *key = [NSString stringWithFormat:@"cachedDateFormatter_%@", stringDateFormatter];
    NSDateFormatter *dateFormatter = [cachedDictionary objectForKey:key];
    if (!dateFormatter) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setCalendar:calendar];
        [dateFormatter setDateFormat:stringDateFormatter];
        [cachedDictionary setObject:dateFormatter forKey:key];
    }
    return dateFormatter;
}

@end