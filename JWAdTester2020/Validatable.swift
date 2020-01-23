//
//  Validatable.swift
//  JWAdTester2020
//
//  Created by Amitai Blickstein on 1/22/20.
//  Copyright © 2020 JWPlayer. All rights reserved.
//

import Foundation

// MARK: Validatable
protocol Validatable {
    var isValid: Bool { get }
}

extension Validatable {
    var isValid: Bool { true }
}


// MARK: JWValidatable
extension JWConfig: Validatable {
    var isValid: Bool { file?.isValidURL ?? false }
}

// if exists and is non-empty, true
extension JWAdConfig: Validatable {
    var isValid: Bool { schedule?.isEmpty == false }
}
