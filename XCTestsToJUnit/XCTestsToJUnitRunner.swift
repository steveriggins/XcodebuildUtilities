//
//  XCTestsToJUnitRunner.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/1/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

struct XCTestsToJUnitArguments {
    let inputFilePath:String
    let outputDirectory:String
    let verbose:Bool

    var description: String {
        return "XCTestsToJUnitArguments"
            + "\n\tinputFilePath=\(inputFilePath)"
            + "\n\toutputDirectory=\(outputDirectory)"
            + "\n\tverbose=\(verbose)"
    }
}

class XCTestsToJUnitRunner {

    typealias NextArgFunction = (value:String) -> Void

    init() {
    }

    func showSyntax() {
        print("XCTestsToJUnit [-inputFile pathToXcodebuildOutput] [-verbose] [-output outputDirectory]")
        exit(1)
    }

    func parseCommandLineArgs(originalArgs:[String]) -> XCTestsToJUnitArguments? {
        var args = originalArgs
        args.removeFirst()

        var errors:[String] = []
        var inputFilePath:String?
        var outputDirectory:String?
        var verbose = false
        var nextArgs:[NextArgFunction] = []
        var lastArg:String?

        for arg in args {
            if nextArgs.count > 0 {
                if arg.hasPrefix("-") {
                    errors.append("Did not expect option \(arg) here")
                    nextArgs = []
                } else {
                    let nextArg = nextArgs.removeFirst()
                    nextArg(value:arg)
                }
            } else if arg == "-inputFile" {
                nextArgs = []
                nextArgs.append({ anArg in inputFilePath = anArg })
            } else if arg == "-output" {
                nextArgs = []
                nextArgs.append({ anArg in outputDirectory = anArg })
            } else if arg == "-verbose" {
                verbose = true
            } else {
                errors.append("Unknown argument: \(arg)")
            }
            lastArg = arg
        }
        if nextArgs.count > 0 {
            errors.append("Missing value\(nextArgs.count > 1 ? "s" : "") after \(lastArg)")
        }
        if inputFilePath == nil {
            errors.append("-inputFile is required")
        }
        if outputDirectory == nil {
            errors.append("-output is required")
        }
        if errors.count > 0 {
            for error in errors {
                print(error)
            }
            return nil
        }
        let result = XCTestsToJUnitArguments(inputFilePath:inputFilePath!, outputDirectory:outputDirectory!, verbose:verbose)
        if verbose {
            print("Current directory=\(NSFileManager.defaultManager().currentDirectoryPath)")
            print(result.description)
        }
        return result
    }

    func processFile(args:XCTestsToJUnitArguments) -> XCTestSummaryResult {
        let fileURL = NSURL.fileURLWithPath(args.inputFilePath)

        let result = XCTestSummaryResult()
        if let reader = StreamReader(fileURL: fileURL) {
            defer {
                reader.close()
            }
            while let line = reader.nextLine() {
                result.processLine(line, verbose:args.verbose)
            }
        }

        return result
    }

}
