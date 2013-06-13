#import "EBDateFormatter.h"
#import <EBFoundation/EBFoundation.h>
#import "unicode/udat.h"

@implementation EBDateFormatter
{
    UDateFormat *_dateFormat;
}

#pragma mark - Creation -
- (instancetype)initWithFormat: (NSString *)format locale: (NSLocale *)locale timeZone: (NSTimeZone *)timeZone
{
        NSParameterAssert(format);
    
    if (!(self = [super init]))
        return nil;
    
    /* ## Get the locale identifier */
    if (!locale)
        locale = [NSLocale currentLocale];
    
    NSString *localeIdentifier = [locale localeIdentifier];
        EBAssertOrRecover(localeIdentifier, return nil);
    
    const char *cLocaleIdentifier = [localeIdentifier UTF8String];
        EBAssertOrRecover(cLocaleIdentifier, return nil);
    
    /* ## Get the time zone ID */
    if (!timeZone)
        timeZone = [NSTimeZone defaultTimeZone];
    
    NSString *timeZoneID = [timeZone name];
        EBAssertOrRecover(timeZoneID, return nil);
    
    const UChar *unicodeTimeZoneID = (const UChar *)[timeZoneID cStringUsingEncoding: NSUnicodeStringEncoding];
        EBAssertOrRecover(unicodeTimeZoneID, return nil);
    
    NSUInteger timeZoneIDLength = [timeZoneID length];
        EBAssertOrRecover(timeZoneIDLength, return nil);
    
    int32_t unicodeTimeZoneIDLength = 0;
        /* Verify that 'timeZoneIDLength' can safely fit into 'unicodeTimeZoneIDLength'. */
        EBAssertOrRecover((uintmax_t)timeZoneIDLength <= (uintmax_t)EBMaxSignedVal(unicodeTimeZoneIDLength), return nil);
    unicodeTimeZoneIDLength = (int32_t)timeZoneIDLength;
    
    /* ## Create our UDateFormat object! */
    UErrorCode openStatus = U_ZERO_ERROR;
    _dateFormat = udat_open(UDAT_NONE, UDAT_NONE, cLocaleIdentifier, unicodeTimeZoneID, unicodeTimeZoneIDLength, nil, 0, &openStatus);
        EBAssertOrRecover(_dateFormat, return nil);
        EBAssertOrRecover(U_SUCCESS(openStatus), return nil);
    
    /* Convert 'format' to Unicode */
    const UChar *unicodeFormat = (const UChar *)[format cStringUsingEncoding: NSUnicodeStringEncoding];
        EBAssertOrRecover(unicodeFormat, return nil);
    
    NSUInteger formatLength = [format length];
    int32_t unicodeFormatLength = 0;
        /* Verify that 'formatLength' can safely fit into 'unicodeFormatLength'. */
        EBAssertOrRecover((uintmax_t)formatLength <= (uintmax_t)EBMaxSignedVal(unicodeFormatLength), return nil);
    unicodeFormatLength = (int32_t)formatLength;
    
    /* We're using this udat_applyPattern() function (instead of supplying the pattern to udat_open()) because there's no public
       UDateFormatStyle constant allowing us to specify that we want to use a pattern for the formatter. (See arguments 0 and 1
       for udat_open()). */
    udat_applyPattern(_dateFormat, TRUE, unicodeFormat, unicodeFormatLength);
    return self;
}

- (void)dealloc
{
    if (_dateFormat)
    {
        udat_close(_dateFormat),
        _dateFormat = nil;
    }
}

#pragma mark - Methods -
- (NSString *)stringFromDate: (NSDate *)date
{
        NSParameterAssert(date);
    
    UDate unicodeDate = [date timeIntervalSince1970] * U_MILLIS_PER_SECOND;
    /* For performance we're using a constant-size, stack-based buffer. In the future, perhaps we should use a dynamically-allocated buffer instead, with either a
       larger constant-size buffer, or an exact-fit buffer by calling udat_format() with nil arguments to determine the exact size needed. */
    UChar formatBuffer[128];
    UErrorCode formatStatus = U_ZERO_ERROR;
    int32_t formatResult = udat_format(_dateFormat, unicodeDate, formatBuffer, sizeof(formatBuffer), nil, &formatStatus);
        /* A zero-length string is acceptable, formatResult == 0 is OK. */
        EBAssertOrRecover(formatResult >= 0, return nil);
        EBAssertOrRecover(U_SUCCESS(formatStatus), return nil);
        /* Verify that 'formatResult' can be safely converted to an NSUInteger, since it's casted to an NSUInteger below. */
        EBAssertOrRecover((uintmax_t)formatResult <= (uintmax_t)EBMaxUnsignedVal(NSUInteger), return nil);
    
    NSString *result = [[NSString alloc] initWithCharacters: formatBuffer length: formatResult];
        EBAssertOrRecover(result, return nil);
    
    return result;
}

- (NSDate *)dateFromString: (NSString *)dateString
{
        NSParameterAssert(dateString);
    
    const UChar *unicodeDateString = (const UChar *)[dateString cStringUsingEncoding: NSUnicodeStringEncoding];
        EBAssertOrRecover(unicodeDateString, return nil);
    
    NSUInteger dateStringLength = [dateString length];
    int32_t unicodeDateStringLength = 0;
        /* Verify that 'dateStringLength' can safely fit into 'unicodeDateStringLength'. */
        EBAssertOrRecover((uintmax_t)dateStringLength <= (uintmax_t)EBMaxSignedVal(unicodeDateStringLength), return nil);
    unicodeDateStringLength = (int32_t)dateStringLength;
    
    UErrorCode parseStatus = U_ZERO_ERROR;
    UDate parseResult = udat_parse(_dateFormat, unicodeDateString, unicodeDateStringLength, nil, &parseStatus);
        EBAssertOrRecover(U_SUCCESS(parseStatus), return nil);
    
    NSDate *result = [NSDate dateWithTimeIntervalSince1970: (parseResult / U_MILLIS_PER_SECOND)];
        EBAssertOrRecover(result, return nil);
    
    return result;
}

@end