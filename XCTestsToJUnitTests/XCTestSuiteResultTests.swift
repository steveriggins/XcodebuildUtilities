//
//  XCTestSummaryResultTests.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/7/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import XCTest

class XCTestSummaryResultTests: XCTestCase {
    
    func testInit() {
        let testSummaryResult = XCTestSummaryResult()
        XCTAssertTrue(testSummaryResult.testSuiteResults.isEmpty)
    }
    
}
