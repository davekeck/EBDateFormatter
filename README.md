# EBDateFormatter

EBDateFormatter is a thread-safe date/time formatter and parser, capable of converting dates into strings and vice versa, while supporting arbitrary locales and time zones. EBDateFormatter uses the [ICU library](http://site.icu-project.org) under the hood, and uses the date/time formatting patterns specified by [UTS #35 Locale Data Markup Language](http://www.unicode.org/reports/tr35/tr35-25.html#Date_Format_Patterns).

EBDateFormatter is useful as a replacement for NSDateFormatter due to its thread-safety, as EBDateFormatter can be used from multiple threads simultaneously without requiring thread synchronization.

## Requirements

- iOS 6. (Earlier platform versions have not been tested.)
- Automatic reference counting (ARC) must be enabled for the source files.

## Integration

1. Integrate [EBFoundation](https://github.com/davekeck/EBFoundation) into your project.
2. Link against libicucore.
3. Add the source files to your project.