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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            versionLabel.text?.append(" \(JWPlayerController.sdkVersion())")
        
        if
            let mementoData = groupDefaults?.object(forKey: kMementoKey) as? Data,
            let memento = try? JSONDecoder().decode(PlayerConfigMemento.self, from: mementoData)
        {
            apply(memento: memento)
        }
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
    
    var groupDefaults: UserDefaults? { UserDefaults(suiteName: "group.com.jwplayer.JWAdTester2020") }
    var kMementoKey: String {"mementoKey"}
}

extension MainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let qrScannerVC = segue.destination as? QRScannerViewController {
            qrScannerVC.delegate = self
        }
    }
}

// MARK: QRScannerDelegate
extension MainViewController: QRScannerDelegate {
    func didGetString(_ string: String) {
        UIPasteboard.general.string = string
        print("\(string) copied to pasteboard!")
    }
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
        
        let data = try? JSONEncoder().encode(memento)
        groupDefaults?.set(data, forKey: kMementoKey)
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

// for console output
// MARK: JWPlayerDelegate
extension MainViewController: JWPlayerDelegate {
    func onSeeked() {
        conoleOutputView.text += #function + "\n"
    }
    
    func onComplete() {
        conoleOutputView.text += #function + "\n"
    }
    
    func onBeforePlay() {
        conoleOutputView.text += #function + "\n"
    }
    
    func onPlayAttempt() {
        conoleOutputView.text += #function + "\n"
    }
    
    func onDisplayClick() {
        conoleOutputView.text += #function + "\n"
    }
    
    func onBeforeComplete() {
        conoleOutputView.text += #function + "\n"
    }
    
    func onPlaylistComplete() {
        conoleOutputView.text += #function + "\n"
    }
    
    func onMeta(_ event: JWEvent & JWMetaEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onSeek(_ event: JWEvent & JWSeekEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onError(_ event: JWEvent & JWErrorEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onReady(_ event: JWEvent & JWReadyEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAdMeta(_ event: JWAdEvent & JWMetaEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onBuffer(_ event: JWEvent & JWBufferEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onLevels(_ event: JWEvent & JWLevelsEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onResize(_ event: JWEvent & JWResizeEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onWarning(_ event: JWEvent & JWErrorEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAdError(_ event: JWAdEvent & JWErrorEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onIdle(_ event: JWEvent & JWStateChangeEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onPlay(_ event: JWEvent & JWStateChangeEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onSetupError(_ event: JWEvent & JWErrorEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onControls(_ event: JWEvent & JWControlsEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onControlBarVisible(_ event: JWEvent & JWControlsEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onPause(_ event: JWEvent & JWStateChangeEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onPlaylist(_ event: JWEvent & JWPlaylistEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAdClick(_ event: JWAdEvent & JWAdDetailEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAudioTracks(_ event: JWEvent & JWLevelsEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAdBreakEnd(_ event: JWAdEvent & JWAdBreakEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAdSkipped(_ event: JWAdEvent & JWAdDetailEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAdStarted(_ event: JWAdEvent & JWAdDetailEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAdComplete(_ event: JWAdEvent & JWAdDetailEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAdRequest(_ event: JWAdEvent & JWAdRequestEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onFirstFrame(_ event: JWEvent & JWFirstFrameEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onFullscreen(_ event: JWEvent & JWFullscreenEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAdBreakStart(_ event: JWAdEvent & JWAdBreakEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAdPlay(_ event: JWAdEvent & JWAdStateChangeEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAdPause(_ event: JWAdEvent & JWAdStateChangeEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAdSchedule(_ event: JWAdEvent & JWAdScheduleEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onBufferChange(_ event: JWEvent & JWBufferChangeEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onCaptionsList(_ event: JWEvent & JWCaptionsListEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onPlaylistItem(_ event: JWEvent & JWPlaylistItemEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAdCompanions(_ event: JWAdEvent & JWAdCompanionsEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAdImpression(_ event: JWAdEvent & JWAdImpressionEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onLevelsChanged(_ event: JWEvent & JWLevelsChangedEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onCaptionsChanged(_ event: JWEvent & JWTrackChangedEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onAudioTrackChanged(_ event: JWEvent & JWTrackChangedEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onFullscreenRequested(_ event: JWEvent & JWFullscreenEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onPlaybackRateChanged(_ event: JWEvent & JWPlaybackRateEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onRelatedOpen(_ event: JWRelatedEvent & JWRelatedOpenEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onRelatedPlay(_ event: JWRelatedEvent & JWRelatedPlayEvent) {
        conoleOutputView.text += #function + "\n"
    }
    
    func onRelatedClose(_ event: JWRelatedEvent & JWRelatedInteractionEvent) {
        conoleOutputView.text += #function + "\n"
    }
}
