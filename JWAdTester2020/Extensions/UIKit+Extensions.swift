//
//  UIView+Extensions.swift
//  JWAdTester2020
//
//  Created by Amitai Blickstein on 1/22/20.
//  Copyright © 2020 JWPlayer. All rights reserved.
//

import Foundation

extension UIView {
    /// Constrains the view to its superview, if it exists, using Autolayout.
    /// - precondition: For player instances, JWP SDK 3.3.0 or higher.
    @objc func constrainToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[thisView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: ["thisView": self])
        
        let verticalConstraints   = NSLayoutConstraint.constraints(withVisualFormat: "V:|[thisView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: ["thisView": self])
        
        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
    }
}

extension UITextView {
    func scrollToBottom() {
        guard !text.isEmpty else { return }
        
        let bottom = NSRange(location: text.count - 1, length: 1)
        scrollRangeToVisible(bottom)
    }
}
