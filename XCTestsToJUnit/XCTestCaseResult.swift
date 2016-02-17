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
    var className:String {
        return testSuiteResult.className
    }
    let methodName:String
    var duration:NSTimeInterval = 0

    var startLine:String?
    var finishLine:String?
    var success:Bool = false
    var logLines:[String] {
        get {
            var result = _logLines
            if let startLine = startLine {
                result.insert(startLine, atIndex: 0)
            }
            if let finishLine = finishLine {
                result.append(finishLine)
            }
            return result
        }
    }

    var failureMessages:[XCTestCaseFailureMessage] {
        return _failureMessages
    }

    var status:String {
        return success ? "Success" : "Failure"
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
        result.addAttributeWithName("classname", value: "\(className)")
        result.addAttributeWithName("status", value: "\(status)")

        for failureMessage in failureMessages {
            result.addChild(failureMessage.xmlElement())
        }

        result.addChild(NSXMLElement(name:"system-out", stringValue:logLines.joinWithSeparator("\n")))

        return result
    }
}