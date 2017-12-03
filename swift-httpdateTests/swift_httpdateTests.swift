//
//  swift_httpdateTests.swift
//  swift-httpdateTests
//
//  Created by matsuohiroki on 2017/11/29.
//  Copyright © 2017年 matsuohiroki. All rights reserved.
//

import XCTest
@testable import swift_httpdate

class swift_httpdateTests: XCTestCase {
    
    func testPatterns() {
        
        var comp = DateComponents()
        comp.year = 1994
        comp.month = 2
        comp.day = 3
        comp.hour = 14
        comp.minute = 15
        comp.second = 29
        let expect = Calendar(identifier: .gregorian).date(from: comp)
        
        let patterns = [
            "Thu, 03 Feb 1994 14:15:29 GMT",
            "Thu Feb  3 14:15:29 GMT 1994",        // ctime(3) format
            "Thu Feb  3 14:15:29 1994",            // ANSI C asctime() format
            "Thursday, 03-Feb-94 14:15:29 GMT",     // old rfc850 HTTP format
            "Thursday, 03-Feb-1994 14:15:29 GMT",   // broken rfc850 HTTP format
            "03/Feb/1994:14:15:29 -0700",   // common logfile format
            "03 Feb 1994 14:15:29 GMT",     // HTTP format (no weekday)
            "03-Feb-94 14:15:29 GMT",       // rfc850 format (no weekday)
            "03-Feb-1994 14:15:29 GMT",     // broken rfc850 format (no weekday)
            "1994-02-03 14:15:29 -0100",    // ISO 8601 format
            "1994-02-03 14:15:29",          // zone is optional
            "1994-02-03T14:15:29",          // Use T as separator
            "19940203T141529Z",             // ISO 8601 compact format
        ]
        
        for p in patterns {
            if let result = try? Httpdate.str2time(str: p) {
                let date = Calendar(identifier: .gregorian).date(from: (result.dateComponents)!)
                XCTAssertEqual(date, expect)
            } else {
                XCTFail()
            }
        }
    }
    
    func testOnlyDate() {
        
        var comp = DateComponents()
        comp.year = 1994
        comp.month = 2
        comp.day = 3
        let expect = Calendar(identifier: .gregorian).date(from: comp)
        
        
        let patterns = [
            "1994-02-03",        // only date
            "19940203",          // only date
            "03-Feb-94",         // old rfc850 HTTP format    (no weekday, no time)
            "03-Feb-1994",       // broken rfc850 HTTP format (no weekday, no time)
            "03 Feb 1994",       // proposed new HTTP format  (no weekday, no time)
            "03/Feb/1994",      // common logfile format     (no time, no offset)
            "Feb  3  1994",     // Unix 'ls -l' format
        ]
        
        for p in patterns {
            if let result = try? Httpdate.str2time(str: p) {
                let date = Calendar(identifier: .gregorian).date(from: (result.dateComponents)!)
                XCTAssertEqual(expect, date)
            } else {
                XCTFail()
            }
        }
    }
    
    func testWithoutSeconds() {
        var comp = DateComponents()
        comp.year = 1994
        comp.month = 2
        comp.day = 3
        comp.hour = 14
        comp.minute = 15
        let expect = Calendar(identifier: .gregorian).date(from: comp)
        
        let pattern = "02-03-94  02:15PM"
        if let result = try? Httpdate.str2time(str: pattern) {
            let date = Calendar(identifier: .gregorian).date(from: (result.dateComponents)!)
            XCTAssertEqual(expect, date)
        } else {
            XCTFail()
        }

    }
    
    func testWithnsec() {
        var comp = DateComponents()
        comp.year = 2017
        comp.month = 12
        comp.day = 2
        comp.hour = 16
        comp.minute = 53
        comp.second = 36
        comp.nanosecond = 999999999
        let expect = Calendar(identifier: .gregorian).date(from: comp)
        
        
        let pattern = "2017-12-02T16:53:36.999999999+00:00"
        if let result = try? Httpdate.str2time(str: pattern) {
            let date = Calendar(identifier: .gregorian).date(from: (result.dateComponents)!)
            XCTAssertEqual(expect, date)
            XCTAssertEqual(TimeZone(identifier: "GMT"), (result.1)!)
        } else {
            XCTFail()
        }
    }
    
    func testTimeZone() {
        let pattern = "19940203T141529Z"
        if let result = try? Httpdate.str2time(str: pattern) {
            XCTAssertEqual(TimeZone(identifier: "UTC"), (result.timeZone)!)
        } else {
            XCTFail()
        }
    }
    
    func testAllMonth() {
        
        var comp = DateComponents()
        comp.year = 2017
        comp.month = 1
        comp.day = 1
        comp.hour = 16
        comp.minute = 53
        comp.second = 36
        
        let testPattern = { (comp:DateComponents, p:String) -> Void in
            if let result = try? Httpdate.str2time(str: p) {
                let expect = Calendar(identifier: .gregorian).date(from: comp)
                let res = Calendar(identifier: .gregorian).date(from: (result.dateComponents)!)
                XCTAssertEqual(expect,res)
            } else {
                XCTFail()
            }
        }
        
        let patternJan = "Sun, 01 Jan 2017 16:53:36 GMT"
        testPattern(comp, patternJan)
        
        let patternMar = "Wed, 01 Mar 2017 16:53:36 GMT"
        comp.month = 3
        testPattern(comp, patternMar)
        
        let patternApr = "Fri, 01 Apr 2017 16:53:36 GMT"
        comp.month = 4
        testPattern(comp, patternApr)
        
        let patternMay = "Mon, 01 May 2017 16:53:36 GMT"
        comp.month = 5
        testPattern(comp, patternMay)
        
        let patternJun = "Thu, 01 Jun 2017 16:53:36 GMT"
        comp.month = 6
        testPattern(comp, patternJun)
        
        let patternJul = "Sat, 01 Jul 2017 16:53:36 GMT"
        comp.month = 7
        testPattern(comp, patternJul)
        
        let patternAug = "Tue, 01 Aug 2017 16:53:36 GMT"
        comp.month = 8
        testPattern(comp, patternAug)

        let patternSep = "Fri, 01 Sep 2017 16:53:36 GMT"
        comp.month = 9
        testPattern(comp, patternSep)
        
        let patternOct = "Sun, 01 Oct 2017 16:53:36 GMT"
        comp.month = 10
        testPattern(comp, patternOct)
        
        let patternNov = "Wed, 01 Nov 2017 16:53:36 GMT"
        comp.month = 11
        testPattern(comp, patternNov)
        
        let patternDec = "Fri, 01 Dec 2017 16:53:36 GMT"
        comp.month = 12
        testPattern(comp, patternDec)
    }
}
