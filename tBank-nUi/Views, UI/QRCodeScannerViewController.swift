//
//  QRCodeScannerViewController.swift
//  tBank-nUi
//
//  Created by Jakub Iwaszek on 13/03/2020.
//  Copyright © 2020 Jakub Iwaszek. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, Storyboarded {
    
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var currentUser: User! = nil
    var scan: Bool = false
    
    weak var coordinator: MainCoordinator?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let captureSession = AVCaptureSession()

        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            self.showAlert(title: "Error", message: "Failed to get camera access")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession.startRunning()
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1)
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {
            print(error)
            return
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else { return }
        //if metadataObj.type == AVMetadataObject.ObjectType.qr {
        let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
        qrCodeFrameView?.frame = barCodeObject!.bounds
        if metadataObj.stringValue != nil && self.viewIfLoaded?.window != nil && !self.view.isHidden && !(self.navigationController?.visibleViewController?.isKind(of: NewTransferViewController.self))! && scan{
            let stringValue = metadataObj.stringValue!
            guard let names = stringValue.components(separatedBy: "+").first else { return }
            guard let bankAccountNumber = stringValue.components(separatedBy: "+").last else { return }
                
            let friend = Friend(bankAccountNumber: bankAccountNumber, name: names)
            
            guard let currentUser = currentUser else { return }
            scan = false
            coordinator?.makeNewTransferFromFriendsView(currentUser: currentUser, tappedFriend: friend)
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scan = true
    }
}

