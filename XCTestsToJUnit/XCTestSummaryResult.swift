//
//  XCTestSummaryResult.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/1/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

class XCTestSummaryResult: XMLible {

    var testSuiteResults:[XCTestSuiteResult] = []

    var failureCount:Int {
        return testSuiteResults.reduce(0, combine: { $0 + $1.failureCount })
    }

    private var currentTestSuiteResult:XCTestSuiteResult?
    private var currentTestCaseResult:XCTestCaseResult?

    init() {
    }

    func processLine(line:String, verbose:Bool) {
        if let lineType = LineType.parse(line) {
            switch lineType {
            case .SuiteStarted(let suiteName, let timestamp):
                processStartSuite(line, verbose:verbose, suiteName:suiteName, timestamp:timestamp)
            case .SuiteFinished(let suiteName, let timestamp, let success):
                processFinishSuite(line, verbose:verbose, suiteName:suiteName, timestamp:timestamp, success:success)
            case .CaseStarted(let suiteName, let caseName):
                processStartCase(line, verbose:verbose, suiteName:suiteName, caseName:caseName)
            case .CaseFinished(let suiteName, let caseName, let duration, let success):
                processFinishCase(line, verbose:verbose, suiteName:suiteName, caseName:caseName, duration:duration, success:success)
            }
        } else {
            processOtherLine(line, verbose:verbose)
        }
    }

    private func processStartSuite(line:String, verbose:Bool, suiteName:String, timestamp:NSDate) {
        if currentTestSuiteResult != nil {
            print("ERROR: New suite started before previous suite finished, continuing with new suite: \(line)")
        }
        let suiteResult = XCTestSuiteResult(testSummaryResult:self, suiteName:suiteName, timestamp:timestamp)
        suiteResult.startLine = line
        if (verbose) {
            print("Suite started: \(suiteResult)")
        }
        testSuiteResults.append(suiteResult)
        currentTestSuiteResult = suiteResult
    }

    private func processFinishSuite(line:String, verbose:Bool, suiteName:String, timestamp:NSDate, success:Bool) {
        if let currentTestSuiteResult = currentTestSuiteResult {
            currentTestSuiteResult.finishLine = line
            if (verbose) {
                print("Suite finished: \(currentTestSuiteResult)")
            }
        } else {
            print("ERROR: Suite finished without a current suite, ignoring suite: \(line)")
        }
        currentTestSuiteResult = nil
    }

    private func processStartCase(line:String, verbose:Bool, suiteName:String, caseName:String) {
        guard let currentTestSuiteResult = currentTestSuiteResult else {
            print("ERROR: TestCase started without a current suite, ignoring case: \(line)")
            return
        }

        if currentTestCaseResult != nil {
            print("ERROR: New case started before previous case finished, continuing with new case: \(line)")
        }
        let testCaseResult = XCTestCaseResult(testSuiteResult: currentTestSuiteResult, methodName: caseName)
        testCaseResult.startLine = line
        if (verbose) {
            print("Case started: \(testCaseResult)")
        }
        currentTestSuiteResult.testCaseResults.append(testCaseResult)
        currentTestCaseResult = testCaseResult
    }

    private func processFinishCase(line:String, verbose:Bool, suiteName:String, caseName:String, duration:NSTimeInterval, success:Bool) {
        if let currentTestCaseResult = currentTestCaseResult {
            currentTestCaseResult.finishLine = line
            if (verbose) {
                print("Case finished: \(currentTestCaseResult)")
            }
        } else {
            print("ERROR: Case finished without a current case, ignoring case: \(line)")
        }
        currentTestCaseResult = nil
    }
    
    private func processOtherLine(line:String, verbose:Bool) {
        if let currentTestCaseResult = currentTestCaseResult {
            currentTestCaseResult.processLog(line)
        } else if let _ = currentTestSuiteResult {
            print("WARNING: ignoring line inside suite results: \(line)")
        }
    }

    // MARK: - XMLible

    func xmlElement() -> NSXMLElement {

// <xs:element name="testsuites">
// <xs:complexType>
// <xs:sequence>
// <xs:element ref="testsuite" minOccurs="0" maxOccurs="unbounded"/>
// </xs:sequence>
// <xs:attribute name="name" type="xs:string" use="optional"/>
// <xs:attribute name="time" type="xs:string" use="optional"/>
// <xs:attribute name="tests" type="xs:string" use="optional"/>
// <xs:attribute name="failures" type="xs:string" use="optional"/>
// <xs:attribute name="disabled" type="xs:string" use="optional"/>
// <xs:attribute name="errors" type="xs:string" use="optional"/>
// </xs:complexType>
// </xs:element>

        let result = NSXMLElement(name:"testsuites")

        result.addAttributeWithName("name", value: "Summary")
        result.addAttributeWithName("failures", value: "\(failureCount)")

        for testSuiteResult in testSuiteResults {
            result.addChild(testSuiteResult.xmlElement())
        }

        return result
    }
}