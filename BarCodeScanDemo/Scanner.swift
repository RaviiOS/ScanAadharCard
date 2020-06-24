//
//  Scanner.swift
//  BarCodeScanDemo
//
//  Created by Ravi Kumar Yaganti on 18/04/19.
//  Copyright © 2019 Ravi Kumar Yaganti. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation
open class ScannerObject: NSObject{
    private var viewController: UIViewController
    private var scanView: ScannerOverlayView!
    private var captureSession: AVCaptureSession!
    private var codeOutPutHandler: (_ code: String) -> Void
    private var scanFrameRect: CGRect!
    
    public init(withViewController viewController: UIViewController, view: ScannerOverlayView,frame: CGRect, codeOutPutHandler:@escaping (String) -> Void) {
        self.viewController = viewController
        self.scanView = view
        self.scanFrameRect = frame
        self.codeOutPutHandler = codeOutPutHandler
        super.init()
        captureession()
        if let captureSession = self.captureSession
        {
            let previewLayer = self.createPreviewLayer(withCaptureSession: captureSession, view: self.scanView)
            self.scanView.layer.addSublayer(previewLayer)
        }else{
            debugPrint("**** Session not created ****")
        }
    }
    public func createCaptureSession() -> AVCaptureSession?
    {
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return nil
        }
        do{
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            let metaDataOutput = AVCaptureMetadataOutput()
            //Add device input
            if captureSession.canAddInput(deviceInput){
                captureSession.addInput(deviceInput)
            }else{
                return nil
            }
            //Add meta data output
            if captureSession.canAddOutput(metaDataOutput){
                captureSession.addOutput(metaDataOutput)
                if let viewController = self.viewController as? AVCaptureMetadataOutputObjectsDelegate{
                    metaDataOutput.setMetadataObjectsDelegate(viewController, queue: DispatchQueue.main)
                    metaDataOutput.metadataObjectTypes = self.metaObjectTypes()
                }else{
                    return nil
                }
            }
        }catch{
            return nil
        }
        return captureSession
    }
    private func captureession(){
        self.captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (self.captureSession.canAddInput(videoInput)) {
            self.captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (self.captureSession.canAddOutput(metadataOutput)) {
            self.captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self.viewController as? AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = self.metaObjectTypes()
        } else {
            failed()
            return
        }
        
    }
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.viewController.present(ac, animated: true)
        captureSession = nil
    }
    public func metaObjectTypes() -> [AVMetadataObject.ObjectType]
    {
        return [.qr,
                .code128,
                .code39,
                .code39Mod43,
                .code93,
                .ean13,
                .ean8,
                .interleaved2of5,
                .itf14,
                .pdf417,
                .upce,
        ]
    }
    public func createPreviewLayer(withCaptureSession captureSession: AVCaptureSession,view: UIView) -> AVCaptureVideoPreviewLayer
    {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = UIScreen.main.bounds
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }
    
    public func  requestCaptureSessionStartRunning()
    {
        guard let captureSession = self.captureSession else {
            return
        }
        if !captureSession.isRunning{
            scanView.strokeColor = .white
            captureSession.startRunning()
        }
    }
    public func requesCaptureSessionStopRunning()
    {
        guard let captureSession = self.captureSession else {
            return
        }
        if captureSession.isRunning{
            scanView.strokeColor = .white
            captureSession.stopRunning()
        }
    }
    public func scannerDelegate(_ output: AVCaptureMetadataOutput, didOutput metatdataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        self.requesCaptureSessionStopRunning()
        if let metaDataObject = metatdataObjects.first
        {
            guard let readableObject = metaDataObject as? AVMetadataMachineReadableCodeObject else{
                return
            }
            guard let stringValue = readableObject.stringValue else{
                return
            }
            scanView.strokeColor = .green
            self.codeOutPutHandler(stringValue)
        }
    }
}
