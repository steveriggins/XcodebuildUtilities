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

    func testLineType_TestSuitePackage_started() {
        let expectedPackageName = "ASDA-Tests"
        let expectedSuiteName = expectedPackageName + XCTTestToJUnitConstants.XCTestPackageSuffix
        let expectedTimestampStr = "2016-02-01 10:25:04.388"
        let expectedTimestamp = LineType.dateFormatter.dateFromString(expectedTimestampStr)
        let line = "Test Suite '\(expectedSuiteName)' started at \(expectedTimestampStr)"

        guard let actualType = LineType.parse(line) else {
            XCTFail("Expected line to be return value: \(line)")
            return
        }

        switch actualType {
        case .SuitePackageStarted(let actualPackageName, let actualTimestamp):
            XCTAssertEqual(expectedPackageName, actualPackageName)
            XCTAssertEqual(expectedTimestamp, actualTimestamp)
        default:
            XCTFail("Expected .SuiteStarted(\(expectedSuiteName),\(expectedTimestampStr)), found: \(actualType)")
        }
    }

    func testLineType_TestSuitePackage_passed() {
        let expectedPackageName = "ASDA-Tests"
        let expectedSuiteName = expectedPackageName + XCTTestToJUnitConstants.XCTestPackageSuffix
        let expectedTimestampStr = "2016-02-01 10:25:04.396"
        let expectedTimestamp = LineType.dateFormatter.dateFromString(expectedTimestampStr)
        let expectedSuccess = true
        let line = "Test Suite '\(expectedSuiteName)' passed at \(expectedTimestampStr)"

        guard let actualType = LineType.parse(line) else {
            XCTFail("Expected line to be return value: \(line)")
            return
        }

        switch actualType {
        case .SuitePackageFinished(let actualPackageName, let actualTimestamp, let actualSuccess):
            XCTAssertEqual(expectedPackageName, actualPackageName)
            XCTAssertEqual(expectedTimestamp, actualTimestamp)
            XCTAssertEqual(expectedSuccess, actualSuccess)
        default:
            XCTFail("Expected .SuiteFinished(\(expectedSuiteName),\(expectedTimestampStr),\(expectedSuccess)), found: \(actualType)")
        }
    }

    func testLineType_TestSuitePackage_failed() {
        let expectedPackageName = "ASDA-Tests"
        let expectedSuiteName = expectedPackageName + XCTTestToJUnitConstants.XCTestPackageSuffix
        let expectedTimestampStr = "2016-02-02 16:46:41.170"
        let expectedTimestamp = LineType.dateFormatter.dateFromString(expectedTimestampStr)
        let expectedSuccess = false
        let line = "Test Suite '\(expectedSuiteName)' failed at \(expectedTimestampStr)"

        guard let actualType = LineType.parse(line) else {
            XCTFail("Expected line to be return value: \(line)")
            return
        }

        switch actualType {
        case .SuitePackageFinished(let actualPackageName, let actualTimestamp, let actualSuccess):
            XCTAssertEqual(expectedPackageName, actualPackageName)
            XCTAssertEqual(expectedTimestamp, actualTimestamp)
            XCTAssertEqual(expectedSuccess, actualSuccess)
        default:
            XCTFail("Expected .SuiteFinished(\(expectedSuiteName),\(expectedTimestampStr),\(expectedSuccess)), found: \(actualType)")
        }
    }
    
    func testLineType_TestSuite_started() {
        let expectedSuiteName = "ASDA-Tests"
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
    
    func testLineType_TestCase_started() {
        let expectedCaseClassName = "ASDA_iPhone_UI_Tests.browseTaxonomyNotSignedIn_iPhone"
        let expectedCaseMethodName = "testPagination"
        let line = "Test Case '-[\(expectedCaseClassName) \(expectedCaseMethodName)]' started."

        guard let actualType = LineType.parse(line) else {
            XCTFail("Expected line to be return value: \(line)")
            return
        }

        switch actualType {
        case .CaseStarted(let actualCaseClassName, let actualCaseMethodName):
            XCTAssertEqual(expectedCaseClassName, actualCaseClassName)
            XCTAssertEqual(expectedCaseMethodName, actualCaseMethodName)
        default:
            XCTFail("Expected .CaseStarted(\(expectedCaseClassName),\(expectedCaseMethodName)), found: \(actualType)")
        }
    }

    func testLineType_TestCase_passed() {
        let expectedCaseClassName = "ASDA_iPhone_UI_Tests.browseTaxonomyNotSignedIn_iPhone"
        let expectedCaseMethodName = "testPagination"
        let expectedDuration = 27.127
        let expectedSuccess = true
        let line = "Test Case '-[\(expectedCaseClassName) \(expectedCaseMethodName)]' passed (\(expectedDuration) seconds)."

        guard let actualType = LineType.parse(line) else {
            XCTFail("Expected line to be return value: \(line)")
            return
        }

        switch actualType {
        case .CaseFinished(let actualCaseClassName, let actualCaseMethodName, let actualDuration, let actualSuccess):
            XCTAssertEqual(expectedCaseClassName, actualCaseClassName)
            XCTAssertEqual(expectedCaseMethodName, actualCaseMethodName)
            XCTAssertEqual(expectedDuration, actualDuration)
            XCTAssertEqual(expectedSuccess, actualSuccess)
        default:
            XCTFail("Expected .CaseFinished(\(expectedCaseClassName),\(expectedCaseMethodName),\(expectedDuration),\(expectedSuccess)), found: \(actualType)")
        }
    }

    func testLineType_TestCase_failed() {
        let expectedCaseClassName = "XcodebuildUtilitiesTests.FileReaderTests"
        let expectedCaseMethodName = "testReadLineWithTrailingNL"
        let expectedDuration = 44.679
        let expectedSuccess = false
        let line = "Test Case '-[\(expectedCaseClassName) \(expectedCaseMethodName)]' failed (\(expectedDuration) seconds)."

        guard let actualType = LineType.parse(line) else {
            XCTFail("Expected line to be return value: \(line)")
            return
        }

        switch actualType {
        case .CaseFinished(let actualCaseClassName, let actualCaseMethodName, let actualDuration, let actualSuccess):
            XCTAssertEqual(expectedCaseClassName, actualCaseClassName)
            XCTAssertEqual(expectedCaseMethodName, actualCaseMethodName)
            XCTAssertEqual(expectedDuration, actualDuration)
            XCTAssertEqual(expectedSuccess, actualSuccess)
        default:
            XCTFail("Expected .CaseFinished(\(expectedCaseClassName),\(expectedCaseMethodName),\(expectedDuration),\(expectedSuccess)), found: \(actualType)")
        }

    }
    
}
