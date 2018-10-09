//
//  ScannerViewController.swift
//  BKI
//
//  Created by srachha on 24/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController {

    var captureSession = AVCaptureSession()
    @IBOutlet weak var scanBtn: UIBarButtonItem!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    @IBOutlet var messageLabel:UILabel!
    weak var delegate:ScannerDelegate!
    var scanData:AVMetadataMachineReadableCodeObject?
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanBtn.isEnabled = false
        startScaning()
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func startScaning() {
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = supportedCodeTypes
        } else {
            failed()
            return
        }
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        var frame = view.layer.bounds
        let height = frame.size.height - 40.0
        frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
        videoPreviewLayer!.frame = frame
        videoPreviewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        ///captureSession = nil
    }
    
    @IBAction func scanAction(_ sender: Any) {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
        captureSession.startRunning()
    }
    
    @IBAction func cancelScanner(_ sender: Any) {
        captureSession.stopRunning()
        self.dismiss(animated: true) {
            self.delegate.scanDidCompletedWith!(nil)
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true) {
            guard self.scanData != nil else {
                self.delegate.scanDidCompletedWith!(nil)
                return
            }
            self.delegate.scanDidCompletedWith!(self.scanData!)
        }
    }
    
}


extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        captureSession.stopRunning()
        scanBtn.isEnabled = true

        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            let userInfoDict = [ NSLocalizedDescriptionKey :  "No QR code is detected."]
            let error = NSError(domain:"", code:404, userInfo:userInfoDict)
            self.dismiss(animated: false) {
                self.delegate.scanDidCompletedWith!(output, didError: error, from: connection)
            }
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        self.scanData = metadataObj
        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
}

@objc protocol ScannerDelegate
{
    @objc optional func scanDidCompletedWith(_ data:AVMetadataMachineReadableCodeObject?)
    @objc optional func scanDidCompletedWith(_ output: AVCaptureMetadataOutput, didError error: Error, from connection: AVCaptureConnection)
}

