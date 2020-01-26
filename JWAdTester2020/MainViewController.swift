//
//  SwiftViewController.swift
//  JWAdTester2020
//
//  Created by Amitai Blickstein on 2/26/19.
//  Copyright © 2019 JWPlayer. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var playerContainerView: UIView!
    var player: JWPlayerController?
    private var config   = JWConfig()
    private var adConfig = JWAdConfig()
    
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
    
    // build config and create player
    @IBAction func applyButtonTapped(_ sender: Any) {
        guard config.isValid else { return }
        config.advertising = adConfig.isValid ? adConfig : nil

        player = JWPlayerController(config: config, delegate: self)

        if let playerView = player?.view {
            playerContainerView.addSubview(playerView)
            playerView.constrainToSuperview()
        }
    }
}

extension MainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let qrScannerVC = segue.destination as? QRScannerViewController {
            qrScannerVC.delegate = self
        }
    }
}

// for console output
// MARK: QRScannerDelegate
extension MainViewController: QRScannerDelegate {
    func didGetString(_ string: String) {
        UIPasteboard.general.string = string
        print("\(string) copied to pasteboard!")
    }
}

// MARK: JWPlayerDelegate
extension MainViewController: JWPlayerDelegate {
    
}

// for jwconfig builder pattern
// MARK: UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
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

// For console output
// MARK: UITextViewDelegate
extension MainViewController: UITextViewDelegate {
    
}

// MARK: State Saving and Restoring
extension MainViewController: PlayerConfigMementoConvertible {
    // Store in Group Container when any field is updated
    var memento: PlayerConfigMemento {
        PlayerConfigMemento(key: licenseKeyField.text,
                            contentURL: contentURLField.text,
                            adTagURL: adTagURLField.text,
                            isGoogima: adClientControl.selectedSegmentIndex == 1)
    }
        
    func apply(memento: PlayerConfigMemento?) {
        guard let memento = memento else { return }
        
        memento        .key.ifSome { licenseKeyField.text = $0 }
        memento .contentURL.ifSome { contentURLField.text = $0 }
        memento   .adTagURL.ifSome { adTagURLField.text = $0 }
        adConfig.client = memento.isGoogima ? .googima : .vast
    }
}


enum AdClient: Int, CaseIterable {
    case vast, googima
}
