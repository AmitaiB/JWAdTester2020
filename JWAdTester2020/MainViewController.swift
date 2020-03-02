//
//  SwiftViewController.swift
//  JWAdTester2020
//
//  Created by Amitai Blickstein on 2/26/19.
//  Copyright © 2019 JWPlayer. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SCLAlertView
import KeychainSwift
import NotificationBannerSwift
import Popover


class MainViewController: UIViewController {
    @IBOutlet weak var playerContainerView: UIView!
    var player: JWPlayerController?
    private var config   = JWConfig()
    private var adConfig = JWAdConfig()
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var contentURLField: SkyFloatingLabelTextField!
    @IBOutlet weak var adTagURLField: SkyFloatingLabelTextField!
    @IBOutlet weak var adClientControl: UISegmentedControl!
    @IBOutlet weak var conoleOutputView: UITextView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conoleOutputView.isEditable = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        applyTheme()
        versionLabel.text?.append(" \(JWPlayerController.sdkVersion())")
        syncToDefaults()
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
        guard config.isValid else { print("invalid config"); return }
        config.advertising = adConfig.isValid ? adConfig : nil
        
        player = JWPlayerController(config: config, delegate: self)

        if let playerView = player?.view {
            playerContainerView.addSubview(playerView)
            playerView.constrainToSuperview()
        }
    }
    
    @IBAction func qrButtonTapped(_ sender: Any) {
        let qrVC = QRScannerViewController.instantiate()
        qrVC.delegate = self
        present(qrVC, animated: true)
    }
    
    @IBAction func consoleDoubleTapped(_ sender: Any) {
        conoleOutputView.text = ""
    }
    
    // Used to set the JWPlayerKey
    @IBAction func gearIconTapped(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            hideWhenBackgroundViewIsTapped: true,
            dynamicAnimatorActive: false
            )
        let keyEntryAlert = SCLAlertView(appearance: appearance)
        let inputField = keyEntryAlert.addTextField("License Key")
        keyEntryAlert.addButton("Save") {
            self.keyUpdated(to: inputField.text)
        }
        
        keyEntryAlert.showEdit("License Key", subTitle: "Enter your 48 character SDK License Key")
    }
    
    @IBOutlet var popupCell: UITableViewCell!
    @IBAction func fieldLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        guard sender.state == .began,
            let senderView = sender.view  as? UITextField
            else { return }
            
        let options: [PopoverOption] = [.type(.up),
                                        .showBlackOverlay(true)]
        let popover = Popover(options: options,
                              showHandler: nil,
                              dismissHandler: nil)
        
        popupCell.frame = CGRect(x: 0, y: 0,
                                 width: senderView.bounds.width * 0.9,
                                 height: 1)
        popupCell.textLabel?.numberOfLines = 0
        popupCell.textLabel?.text = senderView.text
        popupCell.sizeToFit()

        popover.show(popupCell, fromView: senderView)
    }
    
    // TODO: Expand Validation
    private func keyUpdated(to newKey: String?) {
        guard
            let newKey = newKey?.trimmingCharacters(in: .whitespacesAndNewlines),
            newKey.count == 48
            else { return }
        
        keychain.set(newKey, forKey: L10n.licenseKey)
        JWPlayerController.setPlayerKey(newKey)
    }
    
    /// The unique name of the shared user defaults group for the apps of different frameworks.
    var groupDefaults: UserDefaults? { UserDefaults(suiteName: L10n.groupComJwplayerJWAdTester2020) }
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
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        let textInput = textField.text ?? ""
        
        switch textField {
            case contentURLField:
                config.file = textInput
            case adTagURLField:
                adConfig.schedule = [JWAdBreak(tag: textInput, offset: .pre)]
            default:
            break
        }
        
        saveToDefaults()
    }
    
    /// Save current values to the app groupd defaults.
    func saveToDefaults() {
        do {
            let data = try JSONEncoder().encode(memento)
            groupDefaults?.set(data, forKey: L10n.mementoKey)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Conform the current UI to those saved in the app group defaults.
    func syncToDefaults() {
        do {
            if let mementoData = groupDefaults?.object(forKey: L10n.mementoKey) as? Data {
                let memento = try JSONDecoder().decode(PlayerConfigMemento.self, from: mementoData)
                apply(memento: memento)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func applyTheme() {
        [contentURLField, adTagURLField].forEach {
            $0?.lineColor          = ColorName.abyss.color
            $0?.titleColor         = ColorName.fog.color
            $0?.selectedTitleColor = ColorName.fogDark.color
        }
        
        adClientControl.tintColor = ColorName.dahlia.color
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
        PlayerConfigMemento(contentURL: contentURLField.text,
                            adTagURL: adTagURLField.text,
                            isGoogima: adClientControl.selectedSegmentIndex == 1)
    }
        
    func apply(memento: PlayerConfigMemento?) {
        guard let memento = memento else { return }
        
        contentURLUpdated(to: memento.contentURL)
        adTagUpdated(to: memento.adTagURL)
        adConfig.client = memento.isGoogima ? .googima : .vast
    }
    
    private func contentURLUpdated(to newURL: String?) {
        guard let newURL = newURL else { return }
        contentURLField.text = newURL
        config.file = newURL
    }
    
    private func adTagUpdated(to newTag: String?) {
        guard let newTag = newTag else { return }
        adTagURLField.text = newTag
        adConfig.schedule = [JWAdBreak(tag: newTag, offset: "pre")]
    }
}

enum AdClient: Int, CaseIterable {
    case vast, googima
}

// for console output
// MARK: JWPlayerDelegate
extension MainViewController: JWPlayerDelegate {
    private func logToConsole(msg: String, shouldScroll: Bool = true) {
        conoleOutputView.text += "\n" + msg
        if shouldScroll {conoleOutputView.scrollToBottom()}
    }
    
    func onSeeked() {
        logToConsole(msg: #function)
    }
    
    func onComplete() {
        logToConsole(msg: #function)
    }
    
    func onBeforePlay() {
        logToConsole(msg: #function)
    }
    
    func onPlayAttempt() {
        logToConsole(msg: #function)
    }
    
    func onDisplayClick() {
        logToConsole(msg: #function)
    }
    
    func onBeforeComplete() {
        logToConsole(msg: #function)
    }
    
    func onPlaylistComplete() {
        logToConsole(msg: #function)
    }
    
    func onMeta(_ event: JWEvent & JWMetaEvent) {
        logToConsole(msg: #function)
    }
    
    func onSeek(_ event: JWEvent & JWSeekEvent) {
        logToConsole(msg: #function)
    }
    
    func onError(_ event: JWEvent & JWErrorEvent) {
        logToConsole(msg: #function)
    }
    
    func onReady(_ event: JWEvent & JWReadyEvent) {
        logToConsole(msg: #function)
    }
    
    func onAdMeta(_ event: JWAdEvent & JWMetaEvent) {
        logToConsole(msg: #function)
    }
    
    func onBuffer(_ event: JWEvent & JWBufferEvent) {
        logToConsole(msg: #function)
    }
    
    func onLevels(_ event: JWEvent & JWLevelsEvent) {
        logToConsole(msg: #function)
    }
    
    func onResize(_ event: JWEvent & JWResizeEvent) {
        logToConsole(msg: #function)
    }
    
    func onWarning(_ event: JWEvent & JWErrorEvent) {
        logToConsole(msg: #function)
    }
    
    func onAdError(_ event: JWAdEvent & JWErrorEvent) {
        logToConsole(msg: #function)
    }
    
    func onIdle(_ event: JWEvent & JWStateChangeEvent) {
        logToConsole(msg: #function)
    }
    
    func onPlay(_ event: JWEvent & JWStateChangeEvent) {
        logToConsole(msg: #function)
    }
    
    func onSetupError(_ event: JWEvent & JWErrorEvent) {
        logToConsole(msg: #function)
    }
    
    func onControls(_ event: JWEvent & JWControlsEvent) {
        logToConsole(msg: #function)
    }
    
    func onControlBarVisible(_ event: JWEvent & JWControlsEvent) {
        logToConsole(msg: #function)
    }
    
    func onPause(_ event: JWEvent & JWStateChangeEvent) {
        logToConsole(msg: #function)
    }
    
    func onPlaylist(_ event: JWEvent & JWPlaylistEvent) {
        logToConsole(msg: #function)
    }
    
    func onAdClick(_ event: JWAdEvent & JWAdDetailEvent) {
        logToConsole(msg: #function)
    }
    
    func onAudioTracks(_ event: JWEvent & JWLevelsEvent) {
        logToConsole(msg: #function)
    }
    
//    func onAdBreakEnd(_ event: JWAdEvent & JWAdBreakEvent) {
//        logToConsole(msg: #function)
//    }
//
    func onAdSkipped(_ event: JWAdEvent & JWAdDetailEvent) {
        logToConsole(msg: #function)
    }
    
    func onAdStarted(_ event: JWAdEvent & JWAdDetailEvent) {
        logToConsole(msg: #function)
    }
    
    func onAdComplete(_ event: JWAdEvent & JWAdDetailEvent) {
        logToConsole(msg: #function)
    }
    
    func onAdRequest(_ event: JWAdEvent & JWAdRequestEvent) {
        logToConsole(msg: #function)
    }
    
    func onFirstFrame(_ event: JWEvent & JWFirstFrameEvent) {
        logToConsole(msg: #function)
    }
    
    func onFullscreen(_ event: JWEvent & JWFullscreenEvent) {
        logToConsole(msg: #function)
    }
    
//    func onAdBreakStart(_ event: JWAdEvent & JWAdBreakEvent) {
//        logToConsole(msg: #function)
//    }
    
    func onAdPlay(_ event: JWAdEvent & JWAdStateChangeEvent) {
        logToConsole(msg: #function)
    }
    
    func onAdPause(_ event: JWAdEvent & JWAdStateChangeEvent) {
        logToConsole(msg: #function)
    }
    
    func onAdSchedule(_ event: JWAdEvent & JWAdScheduleEvent) {
        logToConsole(msg: #function)
    }
    
    func onBufferChange(_ event: JWEvent & JWBufferChangeEvent) {
        logToConsole(msg: #function)
    }
    
    func onCaptionsList(_ event: JWEvent & JWCaptionsListEvent) {
        logToConsole(msg: #function)
    }
    
    func onPlaylistItem(_ event: JWEvent & JWPlaylistItemEvent) {
        logToConsole(msg: #function)
    }
    
    func onAdCompanions(_ event: JWAdEvent & JWAdCompanionsEvent) {
        logToConsole(msg: #function)
    }
    
    func onAdImpression(_ event: JWAdEvent & JWAdImpressionEvent) {
        logToConsole(msg: #function)
    }
    
    func onLevelsChanged(_ event: JWEvent & JWLevelsChangedEvent) {
        logToConsole(msg: #function)
    }
    
    func onCaptionsChanged(_ event: JWEvent & JWTrackChangedEvent) {
        logToConsole(msg: #function)
    }
    
    func onAudioTrackChanged(_ event: JWEvent & JWTrackChangedEvent) {
        logToConsole(msg: #function)
    }
    
    func onFullscreenRequested(_ event: JWEvent & JWFullscreenEvent) {
        logToConsole(msg: #function)
    }
    
    func onPlaybackRateChanged(_ event: JWEvent & JWPlaybackRateEvent) {
        logToConsole(msg: #function)
    }
    
    func onRelatedOpen(_ event: JWRelatedEvent & JWRelatedOpenEvent) {
        logToConsole(msg: #function)
    }
    
    func onRelatedPlay(_ event: JWRelatedEvent & JWRelatedPlayEvent) {
        logToConsole(msg: #function)
    }
    
    func onRelatedClose(_ event: JWRelatedEvent & JWRelatedInteractionEvent) {
        logToConsole(msg: #function)
    }
}
