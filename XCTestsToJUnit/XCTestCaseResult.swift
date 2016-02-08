//
//  XCTestCaseResult.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/1/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

class XCTestCaseResult {
    let testSuite:XCTestSuiteResult
    let className:String

    var log:[String] {
        return _log
    }

    var errors:[String] {
        return _errors
    }

    private var _log:[String] = []
    private var _errors:[String] = []
    
    init(testSuite:XCTestSuiteResult, className:String) {
        self.testSuite = testSuite
        self.className = className
    }

    func processLog(line:String) {
        _log.append(line)
    }
}