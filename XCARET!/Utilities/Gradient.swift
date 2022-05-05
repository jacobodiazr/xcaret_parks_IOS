//
//  Gradient.swift
//  HotelXcaretMexico
//
//  Created by Jairo López Gutiérrez on 31/03/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class Gradient: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }

}

@IBDesignable
class ModalGradient: Gradient{
    override func awakeFromNib() {
        self.updateGradient()
        
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    func updateGradient(){
        startColor = UIColor(named: "bgBaseA") ?? #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        endColor = UIColor(named: "bgBaseB") ?? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        startLocation = 0.5
        endLocation = 0.7
    }
}

@IBDesignable
class RoseButton: UIButton{
    var sShadowRadius: CGFloat = 5.0
    var sOpacity: Float = 1
    var sShadowOffset: CGSize = CGSize(width: 1, height: 1)
    var sShadowColor: UIColor = #colorLiteral(red: 0.7046605945, green: 0.5578252673, blue: 0.351049304, alpha: 1)
    
    override func awakeFromNib() {
        layer.shadowColor = sShadowColor.cgColor
        layer.shadowOpacity = sOpacity
        layer.shadowOffset = sShadowOffset
        layer.shadowRadius = sShadowRadius
        layer.cornerRadius = self.frame.height/2
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
