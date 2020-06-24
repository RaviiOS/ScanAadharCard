//
//  ScannerOverlayView.swift
//  BarCodeScanDemo
//
//  Created by Ravi Kumar Yaganti on 30/04/19.
//  Copyright © 2019 Ravi Kumar Yaganti. All rights reserved.
//

import UIKit
@IBDesignable
public class ScannerOverlayView: UIView{
    var path: UIBezierPath!
    lazy var blurredEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
       let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.bounds
        return blurredEffectView
    }()
    lazy var maskShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        maskBazierPath.append(rectangleShapeBazierPath)
        maskBazierPath.usesEvenOddFillRule = true
        layer.path = maskBazierPath.cgPath
        layer.fillRule = .evenOdd
        layer.opacity = 0.8
        return layer
    }()
    lazy var maskBazierPath: UIBezierPath = {
        let bazierPath = UIBezierPath (
            roundedRect: self.bounds,
            cornerRadius: 0)
        return bazierPath
    }()
    lazy var rectangleShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = rectangleShapeBazierPath.cgPath
        layer.lineWidth = 2
        return layer
    }()
    lazy var rectangleShapeBazierPath: UIBezierPath = {
        let frameHeight = bounds.height
        let frameWidth = bounds.width
        let drawRect = CGRect(x: (frameWidth * 0.15),y: (frameHeight * 0.30),width: (frameWidth * 0.7),height: (frameHeight * 0.4))
        let rectangle:UIBezierPath = UIBezierPath(rect: drawRect)
        return rectangle
    }()
   public var strokeColor: UIColor? {
        didSet {setNeedsDisplay()}
    }
    override public func draw(_ rect: CGRect) {
        self.createFrame()
        self.layoutIfNeeded()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func createFrame() {
        addSubview(blurredEffectView)
        blurredEffectView.layer.addSublayer(rectangleShapeLayer)
        blurredEffectView.layer.mask = maskShapeLayer
        rectangleShapeLayer.strokeColor = strokeColor?.cgColor
    }
}
