//
//  XCTestCaseResultTests.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/7/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import XCTest

class XCTestCaseResultTests: XCTestCase {
    
    func testInit() {
        let expectedSuiteName = "SuiteA"
        let expectedMethodName = "Method123"

        let dummySuiteResult = XCTestSuiteResult(testSummaryResult:XCTestSummaryResult(), suiteName:expectedSuiteName, packageName:nil, timestamp:NSDate())
        let testCaseResult = XCTestCaseResult(testSuiteResult:dummySuiteResult,methodName:expectedMethodName)

        XCTAssertNotNil(testCaseResult.testSuiteResult)
        XCTAssertNil(testCaseResult.startLine)
        XCTAssertNil(testCaseResult.finishLine)
        XCTAssertEqual(0, testCaseResult.duration)
        XCTAssertEqual(expectedSuiteName, testCaseResult.suiteName)
        XCTAssertEqual(expectedMethodName, testCaseResult.methodName)
        XCTAssertTrue(testCaseResult.logLines.isEmpty)
        XCTAssertTrue(testCaseResult.failureMessages.isEmpty)
    }

    func testProcessLogNoErrors() {
        let expectedLogLines = [
            "Line A",
            "Line B"
        ]

        let dummySuiteResult = XCTestSuiteResult(testSummaryResult:XCTestSummaryResult(), suiteName:"", packageName:nil, timestamp:NSDate())
        let testCaseResult = XCTestCaseResult(testSuiteResult:dummySuiteResult,methodName:"")

        for logLine in expectedLogLines {
            testCaseResult.processLog(logLine)
        }
        XCTAssertEqual(expectedLogLines, testCaseResult.logLines)
        XCTAssertTrue(testCaseResult.failureMessages.isEmpty)
    }

    func testProcessLogWithErrors() {
        let expectedLogLines = [
            "Line A",
            "/Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummySwiftAllFailuresTests.swift:15: error: -[ASDA_Tests.DummySwiftAllFailuresTests testFailure1] : failed - Failure 1",
            "Line B"
        ]

        let dummySuiteResult = XCTestSuiteResult(testSummaryResult:XCTestSummaryResult(), suiteName:"", packageName:nil, timestamp:NSDate())
        let testCaseResult = XCTestCaseResult(testSuiteResult:dummySuiteResult,methodName:"")

        for logLine in expectedLogLines {
            testCaseResult.processLog(logLine)
        }
        XCTAssertEqual(expectedLogLines, testCaseResult.logLines)
        XCTAssertEqual(1, testCaseResult.failureMessages.count)
        
    }

    func testProcessLogWithStartLine() {
        let logLines = [
            "Line A",
            "Line B"
        ]
        var expectedLogLines = logLines
        let expectedStartLine = "Start line"
        expectedLogLines.insert(expectedStartLine, atIndex: 0)

        let dummySuiteResult = XCTestSuiteResult(testSummaryResult:XCTestSummaryResult(), suiteName:"", packageName:nil, timestamp:NSDate())
        let testCaseResult = XCTestCaseResult(testSuiteResult:dummySuiteResult,methodName:"")

        testCaseResult.startLine = expectedStartLine
        for logLine in logLines {
            testCaseResult.processLog(logLine)
        }

        XCTAssertEqual(expectedStartLine, testCaseResult.startLine)
        XCTAssertNil(testCaseResult.finishLine)
        XCTAssertEqual(expectedLogLines, testCaseResult.logLines)
        XCTAssertTrue(testCaseResult.failureMessages.isEmpty)
        
    }

    func testProcessLogWithFinishLine() {
        let logLines = [
            "Line A",
            "Line B"
        ]
        var expectedLogLines = logLines
        let expectedFinishLine = "Finish line"
        expectedLogLines.append(expectedFinishLine)

        let dummySuiteResult = XCTestSuiteResult(testSummaryResult:XCTestSummaryResult(), suiteName:"", packageName:nil, timestamp:NSDate())
        let testCaseResult = XCTestCaseResult(testSuiteResult:dummySuiteResult,methodName:"")

        testCaseResult.finishLine = expectedFinishLine
        for logLine in logLines {
            testCaseResult.processLog(logLine)
        }

        XCTAssertNil(testCaseResult.startLine)
        XCTAssertEqual(expectedFinishLine, testCaseResult.finishLine)
        XCTAssertEqual(expectedLogLines, testCaseResult.logLines)
        XCTAssertTrue(testCaseResult.failureMessages.isEmpty)
        
    }

    func testXMLElement() {
        let logLines = [
            "Line A",
            "/Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummySwiftAllFailuresTests.swift:15: error: -[ASDA_Tests.DummySwiftAllFailuresTests testFailure1] : failed - Failure 1",
            "Line B"
        ]
        let expectedStartLine = "Start Line"
        let expectedFinishLine = "Finish Line"
        var expectedLogLines = logLines
        expectedLogLines.insert(expectedStartLine, atIndex: 0)
        expectedLogLines.append(expectedFinishLine)

        let dummySuiteResult = XCTestSuiteResult(testSummaryResult:XCTestSummaryResult(), suiteName:"suiteName", packageName:nil, timestamp:NSDate())
        let testCaseResult = XCTestCaseResult(testSuiteResult:dummySuiteResult,methodName:"methodName")
        testCaseResult.duration = 123.4

        testCaseResult.startLine = expectedStartLine
        for logLine in logLines {
            testCaseResult.processLog(logLine)
        }
        testCaseResult.finishLine = expectedFinishLine

        // <testcase classname='DummyObjCSomeFailuresTests' name='testFailure1' time='0.001'>
        // <failure message='failed - Failure 1' type='Failure'>/Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummyObjCSomeFailuresTests.m:19</failure>
        // </testcase>
        // <testcase classname='DummyObjCSomeFailuresTests' name='testSuccess1' time='0.0' />
        let xmlElement = testCaseResult.xmlElement()

        XCTAssertEqual("testcase", xmlElement.name)
        expectAttribute(xmlElement, name:"classname", stringValue:"suiteName")
        expectAttribute(xmlElement, name:"name", stringValue:"methodName")
        expectAttribute(xmlElement, name:"time", stringValue:"123.4")
        expectAttribute(xmlElement, name:"status", stringValue:"Failure")

        var failureElements:[NSXMLNode] = []
        var systemOutElements:[NSXMLNode] = []
        var otherElements:[NSXMLNode] = []
        if let children = xmlElement.children {
            for childElement in children {
                let childName = childElement.name ?? ""
                switch childName {
                case "failure":
                    failureElements.append(childElement)
                case "system-out":
                    systemOutElements.append(childElement)
                default:
                    otherElements.append(childElement)
                }
            }
        }
        XCTAssertEqual(1, failureElements.count)
        XCTAssertEqual(expectedLogLines.count, systemOutElements.count)
        for index in 0..<expectedLogLines.count {
            let logLine = expectedLogLines[index]
            let childElement:NSXMLNode? = index < systemOutElements.count ? systemOutElements[index] : nil
            XCTAssertEqual(logLine, childElement?.stringValue)
        }
        XCTAssertEqual(0, otherElements.count)
    }

}
