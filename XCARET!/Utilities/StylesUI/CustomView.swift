//
//  RoundView.swift
//  XCARET!
//
//  Created by Angelica Can on 11/22/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    var imageLayer: CALayer!
    var image: UIImage? {
        didSet { refreshImage() }
    }
    
    override var intrinsicContentSize:
        CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func refreshImage() {
        if let imageLayer = imageLayer, let image = image {
            imageLayer.contents = image.cgImage
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageLayer == nil {
            //let radius: CGFloat = 20, offset: CGFloat = 8
            let path = UIBezierPath(ovalIn: self.bounds)
            let shadowLayer = CALayer()
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = path.cgPath //UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
            shadowLayer.shadowOffset = CGSize(width: 0, height: 10)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3
            layer.addSublayer(shadowLayer)
            
            let maskLayer = CAShapeLayer()
            maskLayer.borderWidth = 4
            maskLayer.borderColor = UIColor.black.cgColor
            maskLayer.path = path.cgPath
            
            imageLayer = CALayer()
            imageLayer.mask = maskLayer
            imageLayer.frame = bounds
            imageLayer.backgroundColor = UIColor.red.cgColor
            imageLayer.contentsGravity = .resizeAspectFill
            
            layer.addSublayer(imageLayer)
        }
        
        
        refreshImage()
    }
    
}

class SquareView: UIView {
    
    var imageLayer: CALayer!
    var image: UIImage? {
        didSet { refreshImage() }
    }
    
    override var intrinsicContentSize:
        CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func refreshImage() {
        if let imageLayer = imageLayer, let image = image {
            imageLayer.contents = image.cgImage
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageLayer == nil {
            let radius: CGFloat = 20, offset: CGFloat = 8
            
            let shadowLayer = CALayer()
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
            shadowLayer.shadowOffset = CGSize(width: offset, height: offset)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            layer.addSublayer(shadowLayer)
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
            
            imageLayer = CALayer()
            imageLayer.mask = maskLayer
            imageLayer.frame = bounds
            imageLayer.backgroundColor = UIColor.red.cgColor
            imageLayer.contentsGravity = .resizeAspectFill //kCAGravityResizeAspectFill
            layer.addSublayer(imageLayer)
        }
        
        
        refreshImage()
    }
    
}
