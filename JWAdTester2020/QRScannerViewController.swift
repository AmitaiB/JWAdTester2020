//
//  ScannerViewController.swift
//  JWAdTester2020
//
//  Created by Amitai Blickstein on 1/24/20.
//  Copyright © 2020 JWPlayer. All rights reserved.
//

import AVFoundation
import UIKit

protocol QRScannerDelegate: class {
    func didGetString(_ string: String)
}

class QRScannerViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    weak var delegate: QRScannerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .clear
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.layer.bounds
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if captureSession.isRunning == false {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession.isRunning == true {
            captureSession.stopRunning()
        }
    }
    
    // Initialize QR Code Frame to highlight the QR code
    lazy var qrCodeFrameView: UIView = {
        let qrFrame = UIView()
        qrFrame.layer.borderColor = UIColor.green.cgColor
        qrFrame.layer.borderWidth = 2
        view.addSubview(qrFrame)
        view.bringSubviewToFront(qrFrame)
        return qrFrame
    }()
    
    override var prefersStatusBarHidden: Bool {true}
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {.portrait}
}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        
        guard let metadataObject = metadataObjects.first else {return}

        if
            let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
            let stringValue = readableObject.stringValue
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            found(code: stringValue)
        }
        
        if let barcodeObj = previewLayer.transformedMetadataObject(for: metadataObject) {
            qrCodeFrameView.frame = barcodeObj.bounds.insetBy(dx: -5, dy: 5)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
        delegate?.didGetString(code)
    }
}
