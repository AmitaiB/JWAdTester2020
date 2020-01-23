//
//  RoundedButton.swift
//  JWAdTester2020
//
//  Created by Amitai Blickstein on 1/22/20.
//  Copyright © 2020 JWPlayer. All rights reserved.
//

import Foundation

@IBDesignable
class RoundedButton: UIButton {
    @IBInspectable
    var cornerRadius: CGFloat = 0 { didSet { cornerRadiusDidChange() }}
    
    func cornerRadiusDidChange() {
        layer.cornerRadius = cornerRadius
    }
}
