//
//  XCTestsToJUnitTypes.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/2/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

/*(
Test Case '-[ASDA_iPhone_UI_Tests.browseTaxonomyNotSignedIn_iPhone testPagination]' started.
Test Case '-[ASDA_iPhone_UI_Tests.browseTaxonomyNotSignedIn_iPhone testPagination]' passed (27.127 seconds).
Test Suite 'browseTaxonomyNotSignedIn_iPhone' passed at 2016-02-01 10:31:10.888.
Test Suite 'ASDA-iPhone-UI-Tests.xctest' passed at 2016-02-01 10:31:11.023.
Test Suite 'Selected tests' started at 2016-02-02 16:45:56.488
Test Suite 'FileReaderTests' started at 2016-02-02 16:45:56.489
Test Case '-[XcodebuildUtilitiesTests.FileReaderTests testReadLineWithTrailingNL]' started.
Test Case '-[XcodebuildUtilitiesTests.FileReaderTests testReadLineWithTrailingNL]' failed (44.679 seconds).
Test Suite 'FileReaderTests' failed at 2016-02-02 16:46:41.170.
*/

struct XCTestRegexPatterns {
    static let TestCaseName = "\\-\\[.* .*\\]"
}

struct XCTTestToJUnitConstants {
    // 2016-02-01 10:25:05.405
    static let TimestampFormat = "yyyy-MM-dd HH:mm:ss.SSS"
}

enum LineType {
    case SuiteStarted(String,NSDate)
    case SuiteFinished(String,NSDate,Bool)
    case CaseStarted(String,String)
    case CaseFinished(String,String,NSTimeInterval,Bool)

    static var dateFormatter: NSDateFormatter {
        let result = NSDateFormatter()
        result.dateFormat = XCTTestToJUnitConstants.TimestampFormat
        return result
    }

    // return nil for lines that should be ignored
    static func parse(line:String) -> LineType? {
        let pieces = line.componentsSeparatedByString("'")
        guard pieces.count == 3 else {
            return nil
        }

        let prefixPiece = pieces[0]
        let namePiece = pieces[1]
        let resultPieces = pieces[2].componentsSeparatedByString(" ")
        let resultPiece1 = resultPieces.count > 1 ? resultPieces[1] : ""
        let resultPiece2 = resultPieces.count > 2 ? resultPieces[2] : ""
        let resultPiece3 = resultPieces.count > 3 ? resultPieces[3] : ""
        let resultPiece4 = resultPieces.count > 4 ? resultPieces[4] : ""

        switch (prefixPiece, namePiece, resultPiece1) {
        case ("Test Suite ", "All tests", _):
            return nil
        case ("Test Suite ", "Selected tests", _):
            return nil
        case ("Test Suite ", _, "started"):
            if let timestamp = parseTimestamp(resultPiece3 + " " + resultPiece4) {
                return LineType.SuiteStarted(namePiece, timestamp)
            }
            return nil
        case ("Test Suite ", _, "failed"):
            if let timestamp = parseTimestamp(resultPiece3 + " " + resultPiece4) {
                return LineType.SuiteFinished(namePiece, timestamp, false)
            }
            return nil
        case ("Test Suite ", _, "passed"):
            if let timestamp = parseTimestamp(resultPiece3 + " " + resultPiece4) {
                return LineType.SuiteFinished(namePiece, timestamp, true)
            }
            return nil
        case ("Test Case ", _, "started."):
            if let (suiteName, caseName) = parseTestCaseName(namePiece) {
                return LineType.CaseStarted(suiteName,caseName)
            }
            return nil
        case ("Test Case ", _, "failed"):
            if let (suiteName, caseName) = parseTestCaseName(namePiece), duration = parseDuration(resultPiece2) {
                return LineType.CaseFinished(suiteName,caseName,duration,false)
            }
            return nil
        case ("Test Case ", _, "passed"):
            if let (suiteName, caseName) = parseTestCaseName(namePiece), duration = parseDuration(resultPiece2) {
                return LineType.CaseFinished(suiteName,caseName,duration,true)
            }
            return nil
        default:
            return nil
        }
    }

    static func parseDuration(value:String) -> NSTimeInterval? {
        let pieces = value.componentsSeparatedByString(" ")
        let trimmedValue = pieces[0].substringFromIndex(pieces[0].startIndex.successor()) // strip leading "("
        if let duration = Double(trimmedValue) {
            return duration
        }
        return nil
    }

    static func parseTimestamp(value:String) -> NSDate? {
        let trimmedValue = value.substringToIndex(value.endIndex) // strip trailing "."
        return dateFormatter.dateFromString(trimmedValue)
    }

    static func parseTestCaseName(value:String) -> (String,String)? {
        if value.matches(XCTestRegexPatterns.TestCaseName) {
            let trimmedPieces = value.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "-[]")).componentsSeparatedByString(" ")
            return (trimmedPieces[0], trimmedPieces[1])
        }
        return nil
    }
}

