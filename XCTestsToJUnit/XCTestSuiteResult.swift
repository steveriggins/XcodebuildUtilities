//
//  XCTestSuiteResult.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/1/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

class XCTestSuiteResult {
    let summary:XCTestSummaryResult
    let suiteName:String

    init(summary:XCTestSummaryResult, suiteName:String) {
        self.summary = summary
        self.suiteName = suiteName
    }

}
