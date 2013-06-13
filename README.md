# EBDateFormatter

EBDateFormatter is a thread-safe date/time formatter and parser, capable of converting dates into strings and vice versa, while supporting arbitrary locales and time zones. EBDateFormatter uses the [ICU library](http://site.icu-project.org) under the hood, and uses the date/time formatting patterns specified by [UTS #35 Locale Data Markup Language](http://www.unicode.org/reports/tr35/tr35-25.html#Date_Format_Patterns).

EBDateFormatter is useful as a replacement for NSDateFormatter due to its thread-safety, as EBDateFormatter can be used from multiple threads simultaneously without requiring thread synchronization.

## Requirements

- Mac OS 10.8 or iOS 6. (Earlier platforms have not been tested.)
- Automatic reference counting (ARC) must be enabled for the source files.

## Integration

1. Integrate [EBFoundation](https://github.com/davekeck/EBFoundation) into your project.
2. Drag EBDateFormatter.xcodeproj into your project's file hierarchy.
3. In your target's "Build Phases" tab:
    * Add EBDateFormatter as a dependency ("Target Dependencies" section)
    * Link against EBDateFormatter ("Link Binary With Libraries" section)
    * Link against libicucore ("Link Binary With Libraries" section)
4. Add `#import <EBDateFormatter/EBDateFormatter.h>` to your source files.