//
//  XCTestSuiteResult.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/1/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

class XCTestSuiteResult: XMLible {
    let testSummaryResult:XCTestSummaryResult
    let suiteName:String
    let timestamp:NSDate
    var startLine:String?
    var finishLine:String?
    var testCaseResults:[XCTestCaseResult] = []

    var failureCount:Int {
        return testCaseResults.reduce(0, combine: { $0 + $1.failureMessages.count })
    }
    var logLines:[String] {
        get {
            var result:[String] = []
            if let startLine = startLine {
                result.append(startLine)
            }
            for testCaseResult in testCaseResults {
                result.appendContentsOf(testCaseResult.logLines)
            }
            if let finishLine = finishLine {
                result.append(finishLine)
            }
            return result
        }
    }

    init(testSummaryResult:XCTestSummaryResult, suiteName:String, timestamp:NSDate) {
        self.testSummaryResult = testSummaryResult
        self.suiteName = suiteName
        self.timestamp = timestamp
    }

    // MARK: - XMLible

    func xmlElement() -> NSXMLElement {

// <testsuite errors="0" failures="2" hostname="ASDAs-Mac-Pro.local" name="DummyObjCAllFailuresTests" tests="2" time="0.002" timestamp="2016-02-04 09:12:33 -0800">
// <testcase classname='DummyObjCAllFailuresTests' name='testFailure1' time='0.001'>
// <failure message='failed - Failure 1' type='Failure'>/Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummyObjCAllFailuresTests.m:19</failure>
// </testcase>
// <testcase classname='DummyObjCAllFailuresTests' name='testFailure2' time='0.001'>
// <failure message='((@"wrong answer") equal to (a)) failed: ("wrong answer") is not equal to ("testFailure2")' type='Failure'>/Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummyObjCAllFailuresTests.m:25</failure>
// </testcase>
// </testsuite>

// <xs:element name="testsuite">
// <xs:complexType>
// <xs:sequence>
// <xs:element ref="properties" minOccurs="0" maxOccurs="1"/>
// <xs:element ref="testcase" minOccurs="0" maxOccurs="unbounded"/>
// <xs:element ref="system-out" minOccurs="0" maxOccurs="1"/>
// <xs:element ref="system-err" minOccurs="0" maxOccurs="1"/>
// </xs:sequence>
// <xs:attribute name="name" type="xs:string" use="required"/>
// <xs:attribute name="tests" type="xs:string" use="required"/>
// <xs:attribute name="failures" type="xs:string" use="optional"/>
// <xs:attribute name="errors" type="xs:string" use="optional"/>
// <xs:attribute name="time" type="xs:string" use="optional"/>
// <xs:attribute name="disabled" type="xs:string" use="optional"/>
// <xs:attribute name="skipped" type="xs:string" use="optional"/>
// <xs:attribute name="timestamp" type="xs:string" use="optional"/>
// <xs:attribute name="hostname" type="xs:string" use="optional"/>
// <xs:attribute name="id" type="xs:string" use="optional"/>
// <xs:attribute name="package" type="xs:string" use="optional"/>
// </xs:complexType>
// </xs:element>

        let result = NSXMLElement(name:"testsuite")

        result.addAttributeWithName("name", value: "\(suiteName)")
        result.addAttributeWithName("failures", value: "\(failureCount)")
        result.addAttributeWithName("timestamp", value: "\(timestamp)")

        for testCaseResult in testCaseResults {
            result.addChild(testCaseResult.xmlElement())
        }

        for logLine in logLines {
            result.addChild(NSXMLElement(name:"system-out", stringValue:logLine))
        }

        return result
    }
}