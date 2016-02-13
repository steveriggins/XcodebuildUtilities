//
//  XCTestCaseFailureMessage.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/8/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

class XCTestCaseFailureMessage {

    // /Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummySwiftAllFailuresTests.swift:15: error: -[ASDA_Tests.DummySwiftAllFailuresTests testFailure1] : failed - Failure 1

    let sourceFilepath:String
    let sourceLineNumber:Int
    let message:String

    init?(line:String) {
        var sourceFilepath:String?
        var sourceLineNumber:Int?
        var message:String?

        if line.matches(XCTestRegexPatterns.TestCaseFailureMessage) {
            let pieces = line.componentsSeparatedByString(":")
            if pieces.count > 4 {
                let failureTag = ": failed - "
                if let failureTagRange = line.rangeOfString(failureTag) {
                    sourceFilepath = pieces[0]
                    sourceLineNumber = Int(pieces[1])
                    message = line.substringFromIndex(failureTagRange.endIndex)
                }
            }
        }

        if let sourceFilepath = sourceFilepath, sourceLineNumber = sourceLineNumber, message = message {
            self.sourceFilepath = sourceFilepath
            self.sourceLineNumber = sourceLineNumber
            self.message = message
        } else {
            self.sourceFilepath = ""
            self.sourceLineNumber = 0
            self.message = ""
            return nil
        }
    }
    
}