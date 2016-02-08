//
//  XCTestCaseResultTests.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/7/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import XCTest

class XCTestCaseResultTests: XCTestCase {
    
    func testInit() {
        let expectedSuiteName = "SuiteA"
        let expectedMethodName = "Method123"

        let dummySuite = XCTestSuiteResult(summary:XCTestSummaryResult(), suiteName:expectedSuiteName)
        let testCase = XCTestCaseResult(testSuite:dummySuite,methodName:expectedMethodName)

        XCTAssertEqual(expectedSuiteName, testCase.suiteName)
        XCTAssertEqual(expectedMethodName, testCase.methodName)
        XCTAssertTrue(testCase.log.isEmpty)
    }

    func testProcessLog() {
        let expectedLogLines = ["Line A", "Line B"]

        let dummySuite = XCTestSuiteResult(summary:XCTestSummaryResult(), suiteName:"")
        let testCase = XCTestCaseResult(testSuite:dummySuite,methodName:"")

        for logLine in expectedLogLines {
            testCase.processLog(logLine)
        }
        XCTAssertEqual(expectedLogLines, testCase.log)
    }

}
