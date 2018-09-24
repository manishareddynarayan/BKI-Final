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
        
        guard let captureDevice = self.getCaptureDevice() else
        {
            print("Device doesn't support for scaning.")
            scanBtn.isEnabled = false
            return
        }
        scanBtn.isEnabled = true

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self as AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        self.scanAction(self)
        // Move the message label and top bar to the front
        view.bringSubview(toFront: messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
        // Do any additional setup after loading the view.
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
    
    
    func getCaptureDevice() -> AVCaptureDevice? {
        
        if #available(iOS 10.2, *) {
            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
            guard let captureDevice = deviceDiscoverySession.devices.first else {
                print("Failed to get the camera device")
                return nil
            }
            return captureDevice

        } else {
            // Fallback on earlier versions
            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDuoCamera], mediaType: AVMediaType.video, position: .back)
            guard let captureDevice = deviceDiscoverySession.devices.first else {
                print("Failed to get the camera device")
                return nil
            }
            return captureDevice
        }
        
    }
    
    @IBAction func scanAction(_ sender: Any) {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
        captureSession.startRunning()
    }
    
    @IBAction func cancelScanner(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
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
    @objc optional func scanDidCompletedWith(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    @objc optional func scanDidCompletedWith(_ output: AVCaptureMetadataOutput, didError error: Error, from connection: AVCaptureConnection)

}

