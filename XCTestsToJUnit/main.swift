//
//  main.swift
//  XCTestsToJUnit
//
//  Created by Douglas Sjoquist on 2/1/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

func main()  {
    let runner = XCTestsToJUnitRunner()
    if let args = runner.parseCommandLineArgs(Process.arguments) {
        let summaryResult = runner.processFile(args)
        summaryResult.saveXML(args)
    }
}

main()