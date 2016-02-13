//
//  XCTestSuiteResult.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/1/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

class XCTestSuiteResult {
    let testSummary:XCTestSummaryResult
    let suiteName:String
    var testCases:[XCTestCaseResult] = []

    init(testSummary:XCTestSummaryResult, suiteName:String) {
        self.testSummary = testSummary
        self.suiteName = suiteName
    }

}
