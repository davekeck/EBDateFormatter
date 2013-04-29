#import <Foundation/Foundation.h>

@interface EBDateFormatter : NSObject

/* ## Creation */
/* If 'locale' is nil, [NSLocale currentLocale] is used.
   If 'timeZone' is nil, [NSTimeZone defaultTimeZone] is used. */
- (instancetype)initWithFormat: (NSString *)format locale: (NSLocale *)locale timeZone: (NSTimeZone *)timeZone;

/* ## Methods */
- (NSString *)stringFromDate: (NSDate *)date;
- (NSDate *)dateFromString: (NSString *)dateString;

@end