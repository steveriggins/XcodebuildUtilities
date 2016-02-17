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
        let expectedPackageName = "Package"
        let expectedTimestamp = NSDate()

        let testSuiteResult = XCTestSuiteResult(testSummaryResult:XCTestSummaryResult(), suiteName:expectedSuiteName, packageName:expectedPackageName, timestamp:expectedTimestamp)

        XCTAssertNotNil(testSuiteResult.testSummaryResult)
        XCTAssertNil(testSuiteResult.startLine)
        XCTAssertNil(testSuiteResult.finishLine)
        XCTAssertEqual(expectedSuiteName, testSuiteResult.suiteName)
        XCTAssertEqual(expectedPackageName, testSuiteResult.packageName)
        XCTAssertEqual(expectedTimestamp, testSuiteResult.timestamp)
        XCTAssertTrue(testSuiteResult.testCaseResults.isEmpty)
    }


    static let expectedTestSuiteStartLine = "TestSuite Start line"
    static let expectedTestCaseStartLine1 = "TestCase Start line 1"
    static let expectedTestCaseLogLine1 = "TestCase Log line 1"
    static let expectedTestCaseFinishLine1 = "TestCase Finish line 1"
    static let expectedTestCaseStartLine2 = "TestCase Start line 2"
    static let expectedTestCaseLogLine2 = "/Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummySwiftAllFailuresTests.swift:15: error: -[ASDA_Tests.DummySwiftAllFailuresTests testFailure1] : failed - Failure 1"
    static let expectedTestCaseFinishLine2 = "TestCase Finish line 2"
    static let expectedTestSuiteFinishLine = "TestSuite Finish line"

    let expectedLogLines = [
        expectedTestSuiteStartLine,
        expectedTestCaseStartLine1,
        expectedTestCaseLogLine1,
        expectedTestCaseFinishLine1,
        expectedTestCaseStartLine2,
        expectedTestCaseLogLine2,
        expectedTestCaseFinishLine2,
        expectedTestSuiteFinishLine
    ]

    func buildTestSuiteResult(suiteName:String,packageName:String?,timestamp:NSDate) -> XCTestSuiteResult {
        let testSuiteResult = XCTestSuiteResult(testSummaryResult:XCTestSummaryResult(), suiteName:suiteName, packageName:packageName, timestamp:timestamp)
        testSuiteResult.startLine = XCTestSuiteResultTests.expectedTestSuiteStartLine
        testSuiteResult.finishLine = XCTestSuiteResultTests.expectedTestSuiteFinishLine

        let testCaseResult1 = XCTestCaseResult(testSuiteResult:testSuiteResult,methodName:"method1")
        testCaseResult1.startLine = XCTestSuiteResultTests.expectedTestCaseStartLine1
        testCaseResult1.processLog(XCTestSuiteResultTests.expectedTestCaseLogLine1)
        testCaseResult1.finishLine = XCTestSuiteResultTests.expectedTestCaseFinishLine1
        testSuiteResult.testCaseResults.append(testCaseResult1)

        let testCaseResult2 = XCTestCaseResult(testSuiteResult:testSuiteResult,methodName:"method2")
        testCaseResult2.startLine = XCTestSuiteResultTests.expectedTestCaseStartLine2
        testCaseResult2.processLog(XCTestSuiteResultTests.expectedTestCaseLogLine2)
        testCaseResult2.finishLine = XCTestSuiteResultTests.expectedTestCaseFinishLine2
        testSuiteResult.testCaseResults.append(testCaseResult2)

        return testSuiteResult
    }

    func testTestSuiteLogLines() {
        let testSuiteResult = buildTestSuiteResult("suite", packageName:nil, timestamp:NSDate())
        let expectedFailureCount = 1
        XCTAssertEqual(XCTestSuiteResultTests.expectedTestSuiteStartLine, testSuiteResult.startLine)
        XCTAssertEqual(XCTestSuiteResultTests.expectedTestSuiteFinishLine, testSuiteResult.finishLine)
        XCTAssertEqual(expectedLogLines, testSuiteResult.logLines)
        XCTAssertEqual(expectedFailureCount, testSuiteResult.failureCount)
    }

    func testXMLElement() {
        let expectedSuiteName = "testSuite"
        let expectedPackageName = "Package"
        let expectedTimestamp = NSDate()
        let expectedFailureCount = 1
        let testSuiteResult = buildTestSuiteResult(expectedSuiteName, packageName:expectedPackageName, timestamp:expectedTimestamp)

        // <testcase classname='DummyObjCSomeFailuresTests' name='testFailure1' time='0.001'>
        // <failure message='failed - Failure 1' type='Failure'>/Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummyObjCSomeFailuresTests.m:19</failure>
        // </testcase>
        // <testcase classname='DummyObjCSomeFailuresTests' name='testSuccess1' time='0.0' />
        let xmlElement = testSuiteResult.xmlElement()

        XCTAssertEqual("testsuite", xmlElement.name)
        expectAttribute(xmlElement, name:"name", stringValue:expectedSuiteName)
        expectAttribute(xmlElement, name:"package", stringValue:expectedPackageName)
        expectAttribute(xmlElement, name:"failures", stringValue:"\(expectedFailureCount)")
        expectAttribute(xmlElement, name:"timestamp", stringValue:"\(expectedTimestamp)")

        var testcaseElements:[NSXMLNode] = []
        var systemOutElements:[NSXMLNode] = []
        var otherElements:[NSXMLNode] = []
        if let children = xmlElement.children {
            for childElement in children {
                let childName = childElement.name ?? ""
                switch childName {
                case "testcase":
                    testcaseElements.append(childElement)
                case "system-out":
                    systemOutElements.append(childElement)
                default:
                    otherElements.append(childElement)
                }
            }
        }
        XCTAssertEqual(2, testcaseElements.count)
        XCTAssertEqual(1, systemOutElements.count)
        let expectedSystemOut = expectedLogLines.joinWithSeparator("\n")
        XCTAssertEqual(expectedSystemOut, systemOutElements[0].stringValue)
        XCTAssertEqual(0, otherElements.count)
    }
    
}
