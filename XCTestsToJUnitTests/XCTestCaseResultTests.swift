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

        let dummySuite = XCTestSuiteResult(testSummary:XCTestSummaryResult(), suiteName:expectedSuiteName)
        let testCase = XCTestCaseResult(testSuite:dummySuite,methodName:expectedMethodName)

        XCTAssertNotNil(testCase.testSuite)
        XCTAssertEqual(expectedSuiteName, testCase.suiteName)
        XCTAssertEqual(expectedMethodName, testCase.methodName)
        XCTAssertTrue(testCase.log.isEmpty)
        XCTAssertTrue(testCase.failureMessages.isEmpty)
    }

    func testProcessLogNoErrors() {
        let expectedLogLines = [
            "Line A",
            "Line B"
        ]

        let dummySuite = XCTestSuiteResult(testSummary:XCTestSummaryResult(), suiteName:"")
        let testCase = XCTestCaseResult(testSuite:dummySuite,methodName:"")

        for logLine in expectedLogLines {
            testCase.processLog(logLine)
        }
        XCTAssertEqual(expectedLogLines, testCase.log)
        XCTAssertTrue(testCase.failureMessages.isEmpty)
    }

    func testProcessLogWithErrors() {
        let expectedLogLines = [
            "Line A",
            "/Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummySwiftAllFailuresTests.swift:15: error: -[ASDA_Tests.DummySwiftAllFailuresTests testFailure1] : failed - Failure 1",
            "Line B"
        ]

        let dummySuite = XCTestSuiteResult(testSummary:XCTestSummaryResult(), suiteName:"")
        let testCase = XCTestCaseResult(testSuite:dummySuite,methodName:"")

        for logLine in expectedLogLines {
            testCase.processLog(logLine)
        }
        XCTAssertEqual(expectedLogLines, testCase.log)
        XCTAssertEqual(1, testCase.failureMessages.count)

    }
    
}
