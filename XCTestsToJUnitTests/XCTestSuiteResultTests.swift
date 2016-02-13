//
//  XCTestSuiteResultTests.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/7/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import XCTest

class XCTestSuiteResultTests: XCTestCase {
    
    func testInit() {
        let expectedSuiteName = "SuiteA"

        let testSuite = XCTestSuiteResult(testSummary:XCTestSummaryResult(), suiteName:expectedSuiteName)

        XCTAssertNotNil(testSuite.testSummary)
        XCTAssertNotNil(expectedSuiteName, testSuite.suiteName)

    }

}
