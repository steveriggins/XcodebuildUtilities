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
        let expectedTimestamp = NSDate()

        let testSuiteResult = XCTestSuiteResult(testSummaryResult:XCTestSummaryResult(), suiteName:expectedSuiteName, timestamp:expectedTimestamp)

        XCTAssertNotNil(testSuiteResult.testSummaryResult)
        XCTAssertNil(testSuiteResult.startLine)
        XCTAssertNil(testSuiteResult.finishLine)
        XCTAssertEqual(expectedSuiteName, testSuiteResult.suiteName)
        XCTAssertEqual(expectedTimestamp, testSuiteResult.timestamp)
        XCTAssertTrue(testSuiteResult.testCaseResults.isEmpty)
    }

    func testXMLElement() {
        let expectedLogLines = [
            "Line A",
            "/Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummySwiftAllFailuresTests.swift:15: error: -[ASDA_Tests.DummySwiftAllFailuresTests testFailure1] : failed - Failure 1",
            "Line B"
        ]

        let dummySuiteResult = XCTestSuiteResult(testSummaryResult:XCTestSummaryResult(), suiteName:"suiteName", timestamp:NSDate())
        let testCaseResult = XCTestCaseResult(testSuiteResult:dummySuiteResult,methodName:"methodName")
        testCaseResult.duration = 123.4

        for logLine in expectedLogLines {
            testCaseResult.processLog(logLine)
        }

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
