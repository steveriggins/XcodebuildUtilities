//
//  String+ExtensionTests.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/3/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import XCTest

class String_ExtensionTests: XCTestCase {

    func testMatchTestCaseName() {
        let pattern = "\\-\\[.* .*\\]"
        XCTAssertTrue("-[ClassName methodName]".matches(pattern))
        XCTAssertFalse("[ClassName methodName]".matches(pattern))
        XCTAssertFalse("-ClassName".matches(pattern))
        XCTAssertFalse("-[ClassNamemethodName]".matches(pattern))
    }

    func testMatchDuration() {
        let pattern = "\\([0-9]*\\.[0-9]*\\)"
        XCTAssertTrue("(123.45)".matches(pattern))
        XCTAssertTrue("(123.0)".matches(pattern))
        XCTAssertTrue("(0.1)".matches(pattern))
        XCTAssertTrue("(.)".matches(pattern))
        XCTAssertFalse("()".matches(pattern))
        XCTAssertFalse("123.45".matches(pattern))
    }

}
