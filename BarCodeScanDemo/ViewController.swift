//
//  ViewController.swift
//  BarCodeScanDemo
//
//  Created by Ravi Kumar Yaganti on 18/04/19.
//  Copyright © 2019 Ravi Kumar Yaganti. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var scannerView: ScannerOverlayView!
    var scanner: ScannerObject?
    var isScanning = false
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeScanner()
    }
    private func initializeScanner(){
        self.scanner = ScannerObject(withViewController: self, view: self.scannerView, frame: CGRect(x: self.scannerView.frame.origin.x, y: self.scannerView.frame.origin.y, width: self.scannerView.frame.width, height: self.scannerView.frame.height), codeOutPutHandler: self.handleCode)
        if let scanner = self.scanner{
            scanner.requestCaptureSessionStartRunning()
            isScanning = true
//            self.scanningStatusLable.text = "Scanning Barcode..."
        }
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.scanner?.scannerDelegate(output, didOutput: metadataObjects, from: connection)
    }
    func handleCode(code: String)
    {
        isScanning = false
        print("Scanned Bar Code ===>>> \(code)")
//        let parser = XMLParser(data: code)
        let parser = MyParser(xml: code)
        let barcodes = parser.parseAPXML() // array of barcodes
        barcodes.first // your barcode
//        self.scanningStatusLable.text = "Verifying Barcode..."
        let ac = UIAlertController(title: "Output", message: code, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func retry(_ sender: Any) {
        self.scanner?.requestCaptureSessionStartRunning()
        isScanning = true
//        self.scanningStatusLable.text = "Scanning Barcode..."
    }
}
