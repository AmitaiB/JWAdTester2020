//
//  SwiftViewController.swift
//  JWAdTester2020
//
//  Created by Amitai Blickstein on 2/26/19.
//  Copyright © 2019 JWPlayer. All rights reserved.
//

import UIKit

class SwiftViewController: UIViewController {
    @IBOutlet weak var playerContainerView: UIView!
    var player: JWPlayerController?
    var config = JWConfig()
    var adConfig = JWAdConfig()
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var licenseKeyField: UITextField!
    @IBOutlet weak var contentURLField: UITextField!
    @IBOutlet weak var adTagURLField: UITextField!
    @IBOutlet weak var adClientControl: UISegmentedControl!
    @IBOutlet weak var conoleOutputView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config = JWConfig()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        versionLabel.text?.append(" \(JWPlayerController.sdkVersion())")
        
//        if let playerView = player?.view {
//            playerContainerView.addSubview(playerView)
//            playerView.constrainToSuperview()
//        }
    }
    
    @IBAction func adClientValueChanged(_ sender: UISegmentedControl) {
        guard let selectedClient = AdClient(rawValue: sender.selectedSegmentIndex)
            else { return }
        
        switch selectedClient {
            case .vast:
                adConfig.client = .vast
            case .googima:
               adConfig.client  = .googima
        }
    }
}

// MARK: Helper methods
extension SwiftViewController {
    
}

extension SwiftViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let textInput = textField.text ?? ""
        
        switch textField {
            case licenseKeyField:
                JWPlayerController.setPlayerKey(textInput)
            case contentURLField:
                config.file = textInput
            case adTagURLField:
                adConfig.schedule = [JWAdBreak(tag: textInput, offset: .pre)]
            default:
            break
        }
    }
}

extension SwiftViewController: UITextViewDelegate {
    
}


enum AdClient: Int, CaseIterable {
    case vast, googima
}

extension String {
    static var pre : String {"pre" }
    static var post: String {"post"}
}
