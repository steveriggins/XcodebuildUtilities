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
    var currentSuiteResult:XCTestSuiteResult?

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

        let reader = FileReader(fileURL: fileURL, delimiter: "\n")

        while let line = reader.readLine() {
            processLine(line)
        }

        return XCTestSummaryResult()
    }

    func processLine(line:String) {
        if let lineType = LineType.parse(line) {
            switch lineType {
            case .SuiteStarted(let suiteName, let timestamp):
                startSuite(suiteName, timestamp:timestamp)
            case .SuiteFinished(let suiteName, let timestamp, let success):
                finishSuite(suiteName, timestamp:timestamp, success:success)
            case .CaseStarted(let suiteName, let caseName):
                startCase(suiteName, caseName:caseName)
            case .CaseFinished(let suiteName, let caseName, let duration, let success):
                finishCase(suiteName, caseName:caseName, duration:duration, success:success)
            }
        }
    }

    func startSuite(suiteName:String, timestamp:NSDate) {
        print("startSuite: \(suiteName), timestamp=\(timestamp)")
    }

    func finishSuite(suiteName:String, timestamp:NSDate, success:Bool) {
        print("finishSuite: \(suiteName), timestamp=\(timestamp), success=\(success)")
    }

    func startCase(suiteName:String, caseName:String) {
        print("startCase: \(suiteName) \(caseName)")
    }

    func finishCase(suiteName:String, caseName:String, duration:NSTimeInterval, success:Bool) {
        print("finishCase: \(suiteName) \(caseName), duration=\(duration), success=\(success)")
    }

}
