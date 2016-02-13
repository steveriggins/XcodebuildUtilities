//
//  XCTestCaseResult.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/1/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

class XCTestCaseResult: XMLible {
    let testSuiteResult:XCTestSuiteResult
    var suiteName:String {
        return self.testSuiteResult.suiteName
    }
    let methodName:String
    var duration:NSTimeInterval = 0

    var startLine:String?
    var finishLine:String?
    var logLines:[String] {
        return _logLines
    }

    var failureMessages:[XCTestCaseFailureMessage] {
        return _failureMessages
    }

    var status:String {
        return failureMessages.count > 0 ? "Failure" : "Success"
    }

    private var _logLines:[String] = []
    private var _failureMessages:[XCTestCaseFailureMessage] = []
    
    init(testSuiteResult:XCTestSuiteResult, methodName:String) {
        self.testSuiteResult = testSuiteResult
        self.methodName = methodName
    }

    func processLog(line:String) {
        _logLines.append(line)
        if let failureMessage = XCTestCaseFailureMessage(line:line) {
            _failureMessages.append(failureMessage)
        }
    }

    // MARK: - XMLible

    func xmlElement() -> NSXMLElement {

// <testcase classname='DummyObjCSomeFailuresTests' name='testFailure1' time='0.001'>
// <failure message='failed - Failure 1' type='Failure'>/Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummyObjCSomeFailuresTests.m:19</failure>
// </testcase>
// <testcase classname='DummyObjCSomeFailuresTests' name='testSuccess1' time='0.0' />

// <xs:element ref="system-out" minOccurs="0" maxOccurs="unbounded"/>

// <xs:attribute name="name" type="xs:string" use="required"/>
// <xs:attribute name="assertions" type="xs:string" use="optional"/>
// <xs:attribute name="time" type="xs:string" use="optional"/>
// <xs:attribute name="classname" type="xs:string" use="optional"/>
// <xs:attribute name="status" type="xs:string" use="optional"/>

        let result = NSXMLElement(name:"testcase")

        result.addAttributeWithName("name", value: "\(methodName)")
        result.addAttributeWithName("time", value: "\(duration)")
        result.addAttributeWithName("classname", value: "\(suiteName)")
        result.addAttributeWithName("status", value: "\(status)")

        for failureMessage in failureMessages {
            result.addChild(failureMessage.xmlElement())
        }

        for logLine in logLines {
            result.addChild(NSXMLElement(name:"system-out", stringValue:logLine))
        }

        return result
    }
}