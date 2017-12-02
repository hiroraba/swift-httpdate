# swift-httpdate

provides functions that deal the date formats used by the HTTP protocol (and then some more).

## example
```swift
if let r = try? Httpdate.str2time(str: "Tuesday, 08-Feb-1994 14:15:29 GMT") {
    // str2time return tuple (DateComponents, Timezone)
    if let comp = r.dateComponents {
        print(comp) // => "year: 1994 month: 2 day: 8 hour: 14 minute: 15 second: 29 isLeapMonth: false \n"
    }
}
```

## support format
The function is able to parse the following formats:
```
 "Wed, 09 Feb 1994 22:23:32 GMT"       -- HTTP format
 "Thu Feb  3 17:03:55 GMT 1994"        -- ctime(3) format
 "Thu Feb  3 00:00:00 1994",           -- ANSI C asctime() format
 "Tuesday, 08-Feb-94 14:15:29 GMT"     -- old rfc850 HTTP format
 "Tuesday, 08-Feb-1994 14:15:29 GMT"   -- broken rfc850 HTTP format

 "03/Feb/1994:17:03:55 -0700"   -- common logfile format
 "09 Feb 1994 22:23:32 GMT"     -- HTTP format (no weekday)
 "08-Feb-94 14:15:29 GMT"       -- rfc850 format (no weekday)
 "08-Feb-1994 14:15:29 GMT"     -- broken rfc850 format (no weekday)

 "1994-02-03 14:15:29 -0100"    -- ISO 8601 format
 "1994-02-03 14:15:29"          -- zone is optional
 "1994-02-03"                   -- only date
 "1994-02-03T14:15:29"          -- Use T as separator
 "19940203T141529Z"             -- ISO 8601 compact format
 "19940203"                     -- only date

 "08-Feb-94"         -- old rfc850 HTTP format    (no weekday, no time)
 "08-Feb-1994"       -- broken rfc850 HTTP format (no weekday, no time)
 "09 Feb 1994"       -- proposed new HTTP format  (no weekday, no time)
 "03/Feb/1994"       -- common logfile format     (no time, no offset)

 "Feb  3  1994"      -- Unix 'ls -l' format
 "Feb  3 17:03"      -- Unix 'ls -l' format

 "11-15-96  03:52PM" -- Windows 'dir' format
```

## Requirements

- iOS 8.0+
- Swift3.2+

## Contribute

We would love you for the contribution, check the ``LICENSE`` file for more info.
