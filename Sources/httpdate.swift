//
//  httpdate.swift
//  swift-httpdate
//
//  Created by matsuohiroki on 2017/11/29.
//  Copyright © 2017年 matsuohiroki. All rights reserved.
//

import UIKit

struct Httpdate {
    
    static let fastReg = "^[SMTWF][a-z][a-z], (\\d\\d) ([JFMAJSOND][a-z][a-z]) (\\d\\d\\d\\d) (\\d\\d):(\\d\\d):(\\d\\d) GMT$"

    static private func weekdaystr2datecomponents(str:String) -> Int {
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
    
    static private func result2array(result:NSTextCheckingResult, nsstr:NSString) -> [String] {
        var str:[String] = []
        for i in 0..<result.numberOfRanges {
            if Range(result.range(at: i)) != nil {
                str.append(nsstr.substring(with: result.range(at: i)))
            }
        }
        return str
    }
    
    static func str2time(str:String) throws -> Date? {
        
        // fastReg
        let regex = try NSRegularExpression(pattern: fastReg)
        let nsstr = str as NSString
        if let result = regex.firstMatch(in: str, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, nsstr.length)) {
            let matchesstring:[String] = result2array(result: result, nsstr: nsstr)
        }
     }
}
