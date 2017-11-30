//
//  httpdate.swift
//  swift-httpdate
//
//  Created by matsuohiroki on 2017/11/29.
//  Copyright © 2017年 matsuohiroki. All rights reserved.
//

import UIKit

struct Httpdate {
    
    static let fastReg = "^([SMTWF][a-z][a-z]), (\\d\\d) ([JFMAJSOND][a-z][a-z]) (\\d\\d\\d\\d) (\\d\\d):(\\d\\d):(\\d\\d) GMT$"
    
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
    
    static private func result2array(result:NSTextCheckingResult, nsstr:NSString) -> [String] {
        var str:[String] = []
        for i in 0..<result.numberOfRanges {
            if Range(result.range(at: i)) != nil {
                str.append(nsstr.substring(with: result.range(at: i)))
            }
        }
        return str
    }
    
    static private func datecomponents(year:Int?, month:Int?, day:Int?, weekday:Int?, hour:Int?, minutes:Int?, seconds:Int?) -> Date? {
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
        
        return Calendar(identifier: .gregorian).date(from: comp)
    }
    
    static func str2time(str:String) throws -> Date? {
        
        // fastReg
        let regex = try NSRegularExpression(pattern: fastReg)
        let nsstr = str as NSString
        if let result = regex.firstMatch(in: str, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, nsstr.length)) {
            let s:[String] = result2array(result: result, nsstr: nsstr)
            return datecomponents(year: Int(s[4]),
                           month: month2Int(s[3]),
                           day: Int(s[2]),
                           weekday: weekDay2Int(s[1]),
                           hour: Int(s[5]),
                           minutes: Int(s[6]),
                           seconds: Int(s[7])
            )
            
        }
        
        return nil
    }
}
