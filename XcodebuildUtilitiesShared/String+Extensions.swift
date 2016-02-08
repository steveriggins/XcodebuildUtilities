//
//  String+extensions.swift
//  XcodebuildUtilities
//
//  Created by Douglas Sjoquist on 2/3/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

extension String {

    var length: Int {
        return characters.count
    }

    func matches(pattern:String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            return regex.numberOfMatchesInString(self, options:[], range:NSMakeRange(0, self.length)) > 0
        } catch let error {
            print("Error in regex: \(error)")
            return false
        }
    }

}