//
//  XCTestSummaryResultTests.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/7/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import XCTest

class XCTestSummaryResultTests: XCTestCase {

    func testInit() {
        let testSummaryResult = XCTestSummaryResult()
        XCTAssertTrue(testSummaryResult.testSuiteResults.isEmpty)
    }

    let simpleLines = [
        "Test Suite 'All tests' started at 2016-02-01 10:25:04.387",
        "Test Suite 'Suite1' started at 2016-02-01 10:25:04.388",
        "Test Case '-[Suite1 methodA]' started.",
        "Line A",
        "Tests.swift:15: error: -[ASDA_Tests.Suite1 methodA] : failed - Failure 1",
        "Line B",
        "Test Case '-[ASDA_Tests.Suite1 methodA]' failed (1.234 seconds).",
        "Test Suite 'Suite1' failed at 2016-02-01 10:25:04.388"
    ]

    func testSimpleLinesSuites() {
        let expectedSuiteCount = 1
        let expectedFailureCount = 1

        let testSummaryResult = XCTestSummaryResult()
        for line in simpleLines {
            testSummaryResult.processLine(line, verbose: false)
        }

        XCTAssertEqual(expectedSuiteCount, testSummaryResult.testSuiteResults.count)
        XCTAssertEqual(expectedFailureCount, testSummaryResult.failureCount)
    }
    
    func testSimpleLinesXml() {
        let expectedName = "Summary"
        let expectedSuiteCount = 1
        let expectedFailureCount = 1
        let testSummaryResult = XCTestSummaryResult()
        for line in simpleLines {
            testSummaryResult.processLine(line, verbose: false)
        }

        let xmlElement = testSummaryResult.xmlElement()
        XCTAssertEqual("testsuites", xmlElement.name)
        expectAttribute(xmlElement, name:"name", stringValue:expectedName)
        expectAttribute(xmlElement, name:"failures", stringValue:"\(expectedFailureCount)")

        var testsuiteElements:[NSXMLNode] = []
        var otherElements:[NSXMLNode] = []
        if let children = xmlElement.children {
            for childElement in children {
                let childName = childElement.name ?? ""
                switch childName {
                case "testsuite":
                    testsuiteElements.append(childElement)
                default:
                    otherElements.append(childElement)
                }
            }
        }
        XCTAssertEqual(expectedSuiteCount, testsuiteElements.count)
        XCTAssertEqual(0, otherElements.count)
    }
    
}
