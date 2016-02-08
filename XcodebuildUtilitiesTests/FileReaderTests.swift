//
//  FileReaderTests.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/2/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import XCTest

class FileReaderTests: XCTestCase {

    func temporaryFileURL() -> NSURL {
        let directory = NSTemporaryDirectory()
        let fileName = NSUUID().UUIDString
        return NSURL.fileURLWithPathComponents([directory, fileName])!
    }

    func testReadLineNoTrailingNL() {
        let delimiter = "\n"
        let lines = ["line 1", "line 2", "line 3"]
        let data = lines.joinWithSeparator(delimiter).dataUsingEncoding(NSUTF8StringEncoding)

        let fileURL = temporaryFileURL()
        data?.writeToURL(fileURL, atomically: true)
        print("fileURL=\(fileURL)")

        let reader = FileReader(fileURL: fileURL, delimiter: delimiter)
        XCTAssertEqual(lines[0], reader.readLine())
        XCTAssertEqual(lines[1], reader.readLine())
        XCTAssertEqual(lines[2], reader.readLine())
        XCTAssertNil(reader.readLine())
        XCTAssertTrue(reader.EOF)
    }
    
    func testReadLineWithTrailingNL() {
        let delimiter = "\n"
        let lines = ["line 1", "line 2"]
        let string = lines.joinWithSeparator(delimiter) + delimiter
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)

        let fileURL = temporaryFileURL()
        data?.writeToURL(fileURL, atomically: true)
        print("fileURL=\(fileURL)")

        let reader = FileReader(fileURL: fileURL, delimiter: delimiter)
        XCTAssertEqual(lines[0], reader.readLine())
        XCTAssertEqual(lines[1], reader.readLine())
        XCTAssertNil(reader.readLine())
        XCTAssertTrue(reader.EOF)
    }
    
}
