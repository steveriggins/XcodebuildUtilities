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
    if let (outputString, llvmCovArgs) = runner.getLLVMCovOutputWithCommandLineArgs(Process.arguments) {
        let summaryCoverage = outputString.parseLLVMCovOutput(llvmCovArgs)
        summaryCoverage.saveXML(llvmCovArgs)
    }
}

main()