//
//  XCTestCase+XMLExtensions.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/13/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import XCTest

extension XCTestCase {

    func expectAttribute(xmlElement:NSXMLElement, name:String, stringValue:String? = nil, file:String = __FILE__, function:String = __FUNCTION__) {
        if let xmlAttribute = xmlElement.attributeForName(name) {
            if let stringValue = stringValue {
                XCTAssertEqual(stringValue, xmlAttribute.stringValue, "Expected stringValue to equal '\(stringValue)' in \(function)/\(file)")
            } else {
                XCTAssertNil(xmlAttribute.stringValue, "Expected stringValue to be nil in \(function)/\(file)")
            }
        } else {
            XCTFail("Expected attribute '\(name)' in \(function)/\(file)")
        }
    }
}