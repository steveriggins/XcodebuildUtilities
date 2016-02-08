//
//  XCTestsToJUnitTypesTests.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/2/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import XCTest

class XCTestsToJUnitTypesTests: XCTestCase {

    override func setUp() {
         super.setUp()
    }

    func testLineTypeDateFormatter() {
        XCTAssertEqual(XCTTestToJUnitConstants.TimestampFormat, LineType.dateFormatter.dateFormat)
    }


    func testLineType_All_tests_started() {
        let line = "Test Suite 'All tests' started at 2016-02-01 10:25:04.387"
        let actualType = LineType.parse(line)
        XCTAssertNil(actualType, "Expected line to be ignored: \(line)")
    }

    func testLineType_Selected_tests_started() {
        let line = "Test Suite 'Selected tests' started at 2016-02-01 10:27:11.739"
        let actualType = LineType.parse(line)
        XCTAssertNil(actualType, "Expected line to be ignored: \(line)")
    }

    func testLineType_TestSuite_started() {
        let expectedSuiteName = "ASDA-Tests.xctest"
        let expectedTimestampStr = "2016-02-01 10:25:04.388"
        let expectedTimestamp = LineType.dateFormatter.dateFromString(expectedTimestampStr)
        let line = "Test Suite '\(expectedSuiteName)' started at \(expectedTimestampStr)"

        guard let actualType = LineType.parse(line) else {
            XCTFail("Expected line to be return value: \(line)")
            return
        }

        switch actualType {
        case .SuiteStarted(let actualSuiteName, let actualTimestamp):
            XCTAssertEqual(expectedSuiteName, actualSuiteName)
            XCTAssertEqual(expectedTimestamp, actualTimestamp)
        default:
            XCTFail("Expected .SuiteStarted(\(expectedSuiteName),\(expectedTimestampStr)), found: \(actualType)")
        }
    }

    func testLineType_TestSuite_passed() {
        let expectedSuiteName = "ASDAAddressBookModelTest"
        let expectedTimestampStr = "2016-02-01 10:25:04.396"
        let expectedTimestamp = LineType.dateFormatter.dateFromString(expectedTimestampStr)
        let expectedSuccess = true
        let line = "Test Suite '\(expectedSuiteName)' passed at \(expectedTimestampStr)"

        guard let actualType = LineType.parse(line) else {
            XCTFail("Expected line to be return value: \(line)")
            return
        }

        switch actualType {
        case .SuiteFinished(let actualSuiteName, let actualTimestamp, let actualSuccess):
            XCTAssertEqual(expectedSuiteName, actualSuiteName)
            XCTAssertEqual(expectedTimestamp, actualTimestamp)
            XCTAssertEqual(expectedSuccess, actualSuccess)
        default:
            XCTFail("Expected .SuiteFinished(\(expectedSuiteName),\(expectedTimestampStr),\(expectedSuccess)), found: \(actualType)")
        }
    }

    func testLineType_TestSuite_failed() {
        let expectedSuiteName = "FileReaderTests"
        let expectedTimestampStr = "2016-02-02 16:46:41.170"
        let expectedTimestamp = LineType.dateFormatter.dateFromString(expectedTimestampStr)
        let expectedSuccess = false
        let line = "Test Suite '\(expectedSuiteName)' failed at \(expectedTimestampStr)"

        guard let actualType = LineType.parse(line) else {
            XCTFail("Expected line to be return value: \(line)")
            return
        }

        switch actualType {
        case .SuiteFinished(let actualSuiteName, let actualTimestamp, let actualSuccess):
            XCTAssertEqual(expectedSuiteName, actualSuiteName)
            XCTAssertEqual(expectedTimestamp, actualTimestamp)
            XCTAssertEqual(expectedSuccess, actualSuccess)
        default:
            XCTFail("Expected .SuiteFinished(\(expectedSuiteName),\(expectedTimestampStr),\(expectedSuccess)), found: \(actualType)")
        }
    }

/*
    Test Case '-[ASDA_iPhone_UI_Tests.browseTaxonomyNotSignedIn_iPhone testPagination]' started.
    Test Case '-[ASDA_iPhone_UI_Tests.browseTaxonomyNotSignedIn_iPhone testPagination]' passed (27.127 seconds).
    Test Case '-[XcodebuildUtilitiesTests.FileReaderTests testReadLineWithTrailingNL]' started.
    Test Case '-[XcodebuildUtilitiesTests.FileReaderTests testReadLineWithTrailingNL]' failed (44.679 seconds).
*/

}
