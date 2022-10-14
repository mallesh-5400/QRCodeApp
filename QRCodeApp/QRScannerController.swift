//
//  QRScannerViewController.swift
//  QRCodeApp
//
//  Created by Mallesha Holeyache 14/10/2022.
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController {
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var topBar: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        view.bringSubviewToFront(messageLabel)
        view.bringSubviewToFront(topBar)
        
        qrCodeFrameView = UIView()

        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }

        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get device's back camera")
            return
        }
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(input)
            
        } catch {
            print(error)
            return
        }
        
        let captureMetaDataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetaDataOutput)
        
        captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetaDataOutput.metadataObjectTypes = [.qr]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        captureSession.startRunning()
        
    }
}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }

        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds

            guard let metaData =  metadataObj.stringValue else {
                print("MetaData Value is : \(String(describing: metadataObj.stringValue))")
                return
            }
            
            messageLabel.text = metaData
            errorLabel.isHidden = metaData.isBTCAddressValid()
            
            if !errorLabel.isHidden {
                errorLabel.text = "Error: Address is not of BTC format"
            }
        }
    }
}

