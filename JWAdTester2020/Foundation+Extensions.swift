//
//  Foundation+Extensions.swift
//  JWAdTester2020
//
//  Created by Amitai Blickstein on 1/22/20.
//  Copyright © 2020 JWPlayer. All rights reserved.
//

import Foundation

// MARK: String
extension String {
    static var pre : String {"pre" }
    static var post: String {"post"}
}

extension String {
    var isValidURL: Bool {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            else { return false }
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

