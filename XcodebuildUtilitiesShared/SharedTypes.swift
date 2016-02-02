//
//  SharedTypes.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/1/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

enum Result<T> {
    case Success(T)
    case Error(ErrorType)
}

struct XcodebuildUtilities {
    static let PathSeparator = "/"
    static let ErrorDomain = "XcodebuildUtilities"
}

