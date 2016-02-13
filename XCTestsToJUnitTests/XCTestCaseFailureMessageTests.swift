//
//  XCTestCaseFailureMessageTests.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/8/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import XCTest

class XCTestCaseFailureMessageTests: XCTestCase {

    func testFailureLogLine() {
        let line = "/dir/file.xyz:15: error: -[file method] : failed - Failure 1"
        if let actualValue = XCTestCaseFailureMessage(line:line) {
            XCTAssertEqual("/dir/file.xyz", actualValue.sourceFilepath)
            XCTAssertEqual(15, actualValue.sourceLineNumber)
            XCTAssertEqual("Failure 1", actualValue.message)
        } else {
            XCTFail("Line should be a failure log line: \(line)")
        }
    }

    func testNonFailureLogLine() {
        let line = "/dir/file.xyz:15: error shows up in log in other format"
        let actualValue = XCTestCaseFailureMessage(line:line)
        XCTAssertNil(actualValue, "Line should NOT be a failure log line: \(line)")
    }

    func testXMLElement() {
        let line = "/dir/file.xyz:15: error: -[file method] : failed - Failure 1"
        let failureMessage = XCTestCaseFailureMessage(line:line)

        // <failure message='failed - Failure 1' type='Failure'>/Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummyObjCSomeFailuresTests.m:19</failure>
        let xmlElement = failureMessage!.xmlElement()

        XCTAssertEqual("failure", xmlElement.name)
        expectAttribute(xmlElement, name:"message", stringValue:"Failure 1")
        expectAttribute(xmlElement, name:"type", stringValue:"Failure")
        XCTAssertEqual(line, xmlElement.stringValue)
    }

}
