//
//  XCTestCaseFailureMessageTests.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/8/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import XCTest

class XCTestCaseFailureMessageTests: XCTestCase {

    func testErrorLogLine() {
        let line = "/dir/file.xyz:15: error: -[file method] : failed - Failure 1"
        if let actualValue = XCTestCaseFailureMessage(line:line) {
            XCTAssertEqual("/dir/file.xyz", actualValue.sourceFilepath)
            XCTAssertEqual(15, actualValue.sourceLineNumber)
            XCTAssertEqual("Failure 1", actualValue.message)
        } else {
            XCTFail("Line should be an error log line: \(line)")
        }
    }

    func testNonErrorLogLine() {
        let line = "/dir/file.xyz:15: error shows up in log in other format"
        let actualValue = XCTestCaseFailureMessage(line:line)
        XCTAssertNil(actualValue, "Line should NOT be an error log line: \(line)")
    }

}
