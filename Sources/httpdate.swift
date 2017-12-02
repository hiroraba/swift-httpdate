//
//  httpdate.swift
//  swift-httpdate
//
//  Created by matsuohiroki on 2017/11/29.
//  Copyright © 2017年 matsuohiroki. All rights reserved.
//

struct Httpdate {
    
    //MARK:- regex patterns
    static let fastReg = "^([SMTWF][a-z][a-z]), (\\d\\d) ([JFMAJSOND][a-z][a-z]) (\\d\\d\\d\\d) (\\d\\d):(\\d\\d):(\\d\\d) GMT$"
    static let uselessweekday = "^(?i)(?:Sun|Mon|Tue|Wed|Thu|Fri|Sat)[a-z]*,?\\s*"
    static let mostFormatReg = "^(\\d\\d?)" + // 1. day
        "(?:\\s+|[-\\/])" +
        "(\\w+)" + // 2. month
        "(?:\\s+|[-\\/])" +
        "(\\d+)" + // 3. year
        "(?:" +
        "(?:\\s+|:)" + // separator before clock
        "(\\d\\d?):(\\d\\d)" + // 4. 5. hour:min
        "(?::(\\d\\d))?" + // 6. optional seconds
        ")?\\s*" + // optional clock
        "([-+]?\\d{2,4})?\\s*" + // 7. offset
        "(\\w+)?" + // 8. ASCII representation of timezone.
    "\\s*$"
    static let ctimeAndAsctimeReg = "^(\\w{1,3})\\s+" + // 1. month
        "(\\d\\d?)\\s+" + // 2. day
        "(\\d\\d?):(\\d\\d)" + // 3,4. hour:min
        "(?::(\\d\\d))?\\s+" + // 5. optional seconds
        "(?:([A-Za-z]+)\\s+)?" + // 6. optional timezone
        "(\\d+)" + // 7. year
    "\\s*$"
    static let unixLsReg = "^(\\w{3})\\s+" + // 1. month
        "(\\d\\d?)\\s+" + // 2. day
        "(?:" +
        "(\\d{4})|" + // 3. year(optional)
        "(\\d{1,2}):(\\d{2})" + // 4,5. hour:min
        "(?::(\\d{2}))?" + // 6 optional seconds
    ")\\s*$"
    static let iso8601Reg = "^(\\d{4})" + // 1. year
        "[-\\/]?" +
        "(\\d\\d?)" + // 2. numerical month
        "[-\\/]?" +
        "(\\d\\d?)" + // 3. day
        "(?:" +
        "(?:\\s*|[-:Tt])" + // separator before clock
        "(\\d\\d?):?(\\d\\d)" + // 4,5. hour:min
        "(?::?(\\d\\d)(?:\\.(\\d+))?)?" + // 6,7. optional seconds and fractional
        ")?\\s*" + // optional clock
        "([-+]?\\d\\d?:?(:?\\d\\d)?|Z|z)?" + // 8. offset (Z is "zero meridian", i.e. GMT)
    "\\s*$"
    static let winDirReg = "^(\\d{2})-" + // 1. mumerical month
        "(\\d{2})-" + // 2. day
        "(\\d{2})\\s+" + // 3. year
        "(\\d\\d?):(\\d\\d)([APap][Mm])" + // 4,5,6. hour:min AM/PM
    "\\s*$"
    
    //MARK:- Utils
    
    // return datecomponents weekday
    static private func weekDay2Int(_ str:String) -> Int {
        switch str {
        case "Mon":
            return 1
        case "Tue":
            return 2
        case "Wed":
            return 3
        case "Thu":
            return 4
        case "Fri":
            return 5
        case "Sat":
            return 6
        case "Sun":
            return 7
        default:
            return 1
        }
        
    }
    
    // return datecompoments month
    static private func month2Int(_ str:String) -> Int {
        switch str {
        case "Jan":
            return 1
        case "Feb":
            return 2
        case "Mar":
            return 3
        case "Apr":
            return 4
        case "May":
            return 5
        case "Jun":
            return 6
        case "Jul":
            return 7
        case "Aug":
            return 8
        case "Sep":
            return 9
        case "Oct":
            return 10
        case "Nov":
            return 11
        case "Dec":
            return 12
        default:
            return 1
        }
        
    }
    
    // loadTimezone from "Z" or "UT" and more
    static private func loadTZ(_ str:String) -> TimeZone? {
        switch str {
        case "Z","UT":
            return TimeZone(identifier: "UTC") ?? nil
        default:
            return TimeZone(identifier: str) ?? nil
        }
        
    }
    
    // adjust year datecomponents
    static private func adjustyear(_ str:String) -> Int? {
        
        guard let year = Int(str) else {
            return nil
        }
        
        if year >= 100 {
            return year
        } else if year >= 69 {
            return year + 1900
        }
        
        return year + 2000
    }
    
    // convert NSTextcheckingResult to String Array
    static private func result2array(result:NSTextCheckingResult, nsstr:NSString) -> [String] {
        var str:[String] = []
        for i in 0..<result.numberOfRanges {
            if Range(result.range(at: i)) != nil {
                str.append(nsstr.substring(with: result.range(at: i)))
            } else {
                str.append("")
            }
        }
        return str
    }
    
    // convert offset string(ex,+0900)
    static private func offsetstr2offset(_ str:String) -> Int {
        let regexOffset = try! NSRegularExpression(pattern: "^([-+])?(\\d\\d?):?(\\d\\d)?$")
        if let result = regexOffset.firstMatch(in: str, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, str.count)) {
            let s = result2array(result: result, nsstr: str as NSString)
            let hour = Int(s[2])
            let minites = Int(s[3])
            let offset = (hour ?? 0)*60*60 + (minites ?? 0)*60
            if s[1] == "-" {
                return offset * -1
            }
            return offset
        }
        return 0
    }
    
    static private func datecomponents(year:Int?, month:Int?, day:Int?, weekday:Int?, hour:Int?, minutes:Int?, seconds:Int?, nanosecond:Int?=nil) -> DateComponents {
        
        var comp = DateComponents()
        
        if let year = year {
            comp.year = year
        }
        
        if let month = month {
            comp.month = month
        }
        
        if let day = day {
            comp.day = day
        }
        
        if let weekday = weekday {
            comp.weekday = weekday
        }
        
        if let hour = hour {
            comp.hour = hour
        }
        
        if let minutes = minutes {
            comp.minute = minutes
        }
        
        if let seconds = seconds {
            comp.second = seconds
        }
        
        if let nanoseconds = nanosecond {
            comp.nanosecond = nanoseconds
        }
        
        return comp
    }
    
    /*
     str2time() function converts a string to machine time.  It returns
     (nil, nil) if the format of str is unrecognized, otherwise whatever the
     (DateCompnents, Timezone) tuple functions can make out of the parsed time.  Dates
     before the system's epoch may not work on all operating systems.
     The function is able to parse the following formats:
     
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
     
     The parser ignores leading and trailing whitespace.  It also allow the
     seconds to be missing and the month to be numerical in most formats.
     */
    //MARK:- Main
    static func str2time(str:String, timezone:TimeZone? = nil) throws -> (DateComponents?, TimeZone?) {
        
        var nsstr = str as NSString
        
        // fastReg
        let regexFR = try NSRegularExpression(pattern: fastReg)
        if let result = regexFR.firstMatch(in: str, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, nsstr.length)) {
            let s:[String] = result2array(result: result, nsstr: nsstr)
            print(s)
            return (datecomponents(year: Int(s[4]),
                                   month: month2Int(s[3]),
                                   day: Int(s[2]),
                                   weekday: weekDay2Int(s[1]),
                                   hour: Int(s[5]),
                                   minutes: Int(s[6]),
                                   seconds: Int(s[7])), timezone)
            
        }
        
        nsstr = str.replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression, range: str.range(of: str)) as NSString
        nsstr = str.replacingOccurrences(of: uselessweekday, with: "", options: .regularExpression, range: (nsstr as String).range(of: (nsstr as String))) as NSString
        print(nsstr)
        let regexMFR = try NSRegularExpression(pattern: mostFormatReg)
        if let result = regexMFR.firstMatch(in: (nsstr as String), options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, nsstr.length)) {
            let s:[String] = result2array(result: result, nsstr: nsstr)
            print(s)
            switch s[safe : 8] {
            case "AM","PM":
                break
            default:
                var timezone:TimeZone?
                
                if s[safe: 8] != "" {
                    timezone = loadTZ(s[safe :8])
                }
                
                if timezone == nil && s[safe: 7] == "" {
                    timezone = TimeZone(secondsFromGMT: offsetstr2offset(s[7]))
                }
                
                return (datecomponents(year: adjustyear(s[3]),
                                       month: Int(month2Int(s[2])),
                                       day: Int(s[1]),
                                       weekday: nil,
                                       hour: Int(s[4]),
                                       minutes: Int(s[5]),
                                       seconds: Int(s[6])), timezone)
            }
        }
        
        let regexCAA = try NSRegularExpression(pattern: ctimeAndAsctimeReg)
        if let result = regexCAA.firstMatch(in: (nsstr as String), options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, nsstr.length)) {
            
            let s:[String] = result2array(result: result, nsstr: nsstr)
            
            var tz:TimeZone?
            
            if s[safe: 6] != "" {
                tz = loadTZ(s[safe: 6])
            }
            
            if tz == nil {
                tz = timezone
            }
            
            return (datecomponents(year: adjustyear(s[7]),
                                   month: Int(month2Int(s[1])),
                                   day: Int(s[2]),
                                   weekday: nil,
                                   hour: Int(s[3]),
                                   minutes: Int(s[4]),
                                   seconds: Int(s[5])), tz)
        }
        
        let regexUnixLs = try NSRegularExpression(pattern: unixLsReg)
        if let result = regexUnixLs.firstMatch(in: (nsstr as String), options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, nsstr.length)) {
            let s:[String] = result2array(result: result, nsstr: nsstr)
            var y:Int = 0
            if let year = Int(s[3]) {
                y = year
            } else {
                let calendar = Calendar(identifier: .gregorian)
                y = calendar.component(.year, from: Date())
            }
            return (datecomponents(year: y,
                                   month: month2Int(s[1]),
                                   day: Int(s[2]),
                                   weekday: nil,
                                   hour: 0,
                                   minutes: 0,
                                   seconds: 0), nil)
        }
        
        let regexiso8601 = try NSRegularExpression(pattern: iso8601Reg)
        if let result = regexiso8601.firstMatch(in: (nsstr as String), options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, nsstr.length)) {
            
            let s:[String] = result2array(result: result, nsstr: nsstr)
            var tz:TimeZone?
            
            if s[safe :8] == "Z" {
                tz = TimeZone(identifier: "UTC")
            } else if s[safe : 8] != "" {
                tz = TimeZone(secondsFromGMT: offsetstr2offset(s[safe :8]))
            }
            
            var nsec = 0
            let fracStr = s[7]
            if fracStr != "" {
                let of = 9 - fracStr.count
                
                if of <= 9 {
                    nsec = Int((fracStr as NSString).substring(to: 9)) ?? 0
                } else {
                    nsec = (Int(fracStr) ?? 0) * Int(pow(10, Double(of)))
                }
            }
            return (datecomponents(year: adjustyear(s[1]),
                                   month: Int(s[2]),
                                   day: Int(s[3]),
                                   weekday: nil,
                                   hour: Int(s[4]),
                                   minutes: Int(s[5]),
                                   seconds: Int(s[6]),
                                   nanosecond: nsec), tz)
        }
        
        let regexWinDir = try NSRegularExpression(pattern: winDirReg)
        if let result = regexWinDir.firstMatch(in: (nsstr as String), options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, nsstr.length)) {
            let s:[String] = result2array(result: result, nsstr: nsstr)
            var hour:Int = Int(s[4]) ?? 0
            let ampm = s[6]
            
            if ampm == "AM" && hour == 12 {
                hour = 0
            } else if ampm == "PM" && hour != 12 {
                hour = hour + 12
            }
            
            return (datecomponents(year: adjustyear(s[3]),
                                   month: Int(s[1]),
                                   day: Int(s[2]),
                                   weekday: nil,
                                   hour: hour,
                                   minutes: Int(s[5]),
                                   seconds: nil), timezone)
            
        }
        return (nil, nil)
    }
}
