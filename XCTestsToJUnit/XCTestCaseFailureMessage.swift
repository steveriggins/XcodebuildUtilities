//
//  XCTestCaseFailureMessage.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/8/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

class XCTestCaseFailureMessage: XMLible {

    // /Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummySwiftAllFailuresTests.swift:15: error: -[ASDA_Tests.DummySwiftAllFailuresTests testFailure1] : failed - Failure 1

    let sourceFilepath:String
    let sourceLineNumber:Int
    let line:String
    let message:String

    init?(line:String) {
        var sourceFilepath:String?
        var sourceLineNumber:Int?
        var message:String?

        if line.matches(XCTestRegexPatterns.TestCaseFailureMessage) {
            let pieces = line.componentsSeparatedByString(":")
            if pieces.count > 4 {
                let failureTag = ": failed - "
                if let failureTagRange = line.rangeOfString(failureTag) {
                    sourceFilepath = pieces[0]
                    sourceLineNumber = Int(pieces[1])
                    message = line.substringFromIndex(failureTagRange.endIndex)
                }
            }
        }

        self.line = line
        if let sourceFilepath = sourceFilepath, sourceLineNumber = sourceLineNumber, message = message {
            self.sourceFilepath = sourceFilepath
            self.sourceLineNumber = sourceLineNumber
            self.message = message
        } else {
            self.sourceFilepath = ""
            self.sourceLineNumber = 0
            self.message = ""
            return nil
        }
    }

    // MARK: - XMLible

    func xmlElement() -> NSXMLElement {
        // <failure message='failed - Failure 1' type='Failure'>/Users/Shared/Jenkins/Home/jobs/dwsjoquist testing/workspace/ASDA-Tests/Common/DummyObjCSomeFailuresTests.m:19</failure>

        // <xs:element name="failure">
        // <xs:complexType mixed="true">
        // <xs:attribute name="type" type="xs:string" use="optional"/>
        // <xs:attribute name="message" type="xs:string" use="optional"/>
        // </xs:complexType>
        // </xs:element>

        let result = NSXMLElement(name:"failure", stringValue:line)

        result.addAttributeWithName("message", value: "\(message)")
        result.addAttributeWithName("type", value: "Failure")
        
        return result
    }
    
}