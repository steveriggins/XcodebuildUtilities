//
//  FileReader.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/2/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

class FileReader {
    let encoding = NSUTF8StringEncoding
    let delimiter:String
    let fileURL:NSURL
    lazy var inputFile:NSFileHandle = self.initializeInputFile()
    var EOF:Bool = false
    var buffer = ""

    init(fileURL:NSURL, delimiter:String) {
        self.fileURL = fileURL
        self.delimiter = delimiter
    }

    func initializeInputFile() -> NSFileHandle {
        do {
            return try NSFileHandle(forReadingFromURL: fileURL)
        } catch let error {
            print("Could not read from url: \(fileURL)")
            print("Error: \(error)")
            exit(1)
        }
    }

    func readLine() -> String? {
        if EOF {
            return nil
        }

        while !EOF {
            if let range = buffer.rangeOfString(delimiter) {
                let result = buffer.substringToIndex(range.startIndex)
                let nextIndex = range.startIndex.advancedBy(delimiter.lengthOfBytesUsingEncoding(encoding))
                buffer = buffer.substringFromIndex(nextIndex)
                return result
            } else {
                let data = self.inputFile.availableData
                if data.length == 0 {
                    EOF = true
                    if buffer == "" {
                        return nil // handle trailing NL case
                    }
                } else {
                    if let s = String(data: data, encoding:encoding) {
                        buffer += s
                    } else {
                        print("Error: could not convert data to string")
                        exit(1)
                    }
                }
            }
        }

        return buffer
    }
}
