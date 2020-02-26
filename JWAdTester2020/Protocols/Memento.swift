//
//  Memento.swift
//  JWAdTester2020
//
//  Created by Amitai Blickstein on 1/24/20.
//  Copyright © 2020 JWPlayer. All rights reserved.
//

import Foundation

struct PlayerConfigMemento: Codable {
    var contentURL: String?
    var adTagURL: String?
    var isGoogima = false
}

protocol PlayerConfigMementoConvertible {
    var memento: PlayerConfigMemento { get }
    func apply(memento: PlayerConfigMemento?)
}
