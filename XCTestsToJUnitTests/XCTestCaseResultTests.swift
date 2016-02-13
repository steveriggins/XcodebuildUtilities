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
        let expectedDuration:NSTimeInterval = 123.4

        let dummySuite = XCTestSuiteResult(testSummary:XCTestSummaryResult(), suiteName:expectedSuiteName)
        let testCase = XCTestCaseResult(testSuite:dummySuite,methodName:expectedMethodName, duration:expectedDuration)

        XCTAssertNotNil(testCase.testSuite)
        XCTAssertEqual(expectedSuiteName, testCase.suiteName)
        XCTAssertEqual(expectedMethodName, testCase.methodName)
        XCTAssertEqual(expectedDuration, testCase.duration)
        XCTAssertTrue(testCase.logLines.isEmpty)
        XCTAssertTrue(testCase.failureMessages.isEmpty)
    }

    func testProcessLogNoErrors() {
        let expectedLogLines = [
            "Line A",
            "Line B"
        ]

        let dummySuite = XCTestSuiteResult(testSummary:XCTestSummaryResult(), suiteName:"")
        let testCase = XCTestCaseResult(testSuite:dummySuite,methodName:"",duration:0)

        for logLine in expectedLogLines {
            testCase.processLog(logLine)
        }
        XCTAssertEqual(expectedLogLines, testCase.logLines)
        XCTAssertTrue(testCase.failureMessages.isEmpty)
    }

    func testProcessLogWithErrors() {
        let expectedLogLines = [
            "Line A",
            "/Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummySwiftAllFailuresTests.swift:15: error: -[ASDA_Tests.DummySwiftAllFailuresTests testFailure1] : failed - Failure 1",
            "Line B"
        ]

        let dummySuite = XCTestSuiteResult(testSummary:XCTestSummaryResult(), suiteName:"")
        let testCase = XCTestCaseResult(testSuite:dummySuite,methodName:"",duration:0)

        for logLine in expectedLogLines {
            testCase.processLog(logLine)
        }
        XCTAssertEqual(expectedLogLines, testCase.logLines)
        XCTAssertEqual(1, testCase.failureMessages.count)

    }

    func testXMLElement() {
        let expectedLogLines = [
            "Line A",
            "/Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummySwiftAllFailuresTests.swift:15: error: -[ASDA_Tests.DummySwiftAllFailuresTests testFailure1] : failed - Failure 1",
            "Line B"
        ]

        let dummySuite = XCTestSuiteResult(testSummary:XCTestSummaryResult(), suiteName:"suiteName")
        let testCase = XCTestCaseResult(testSuite:dummySuite,methodName:"methodName",duration:123.4)

        for logLine in expectedLogLines {
            testCase.processLog(logLine)
        }

        // <testcase classname='DummyObjCSomeFailuresTests' name='testFailure1' time='0.001'>
        // <failure message='failed - Failure 1' type='Failure'>/Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummyObjCSomeFailuresTests.m:19</failure>
        // </testcase>
        // <testcase classname='DummyObjCSomeFailuresTests' name='testSuccess1' time='0.0' />
        let xmlElement = testCase.xmlElement()

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
