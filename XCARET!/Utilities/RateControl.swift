//
//  RateControl.swift
//  XCARET!
//
//  Created by Javier Canto on 7/24/17.
//  Copyright © 2017 Experiencias Xcaret. All rights reserved.
//

import UIKit
import Foundation

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

class RateControl: UIControl {
    fileprivate let emptyStartSymbol = "☆"
    fileprivate let fillStartSymbol  = "★"

    fileprivate var label = UILabel()
    var rateMax: Int = 5
    var rate: Int? {
        didSet {
            var resultString = ""
            
            for index in 0..<rateMax {
                resultString += (index >= rate ? emptyStartSymbol : fillStartSymbol)
            }
        
            label.text = resultString
                
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.awakeFromNib()
    }

    override func awakeFromNib() {
        label.frame = self.bounds
        label.textColor = UIColor(red: 0.992, green: 0.667, blue: 0.161, alpha: 1.00)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 8
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(RateControl.pan(_:)))
            panGesture.minimumNumberOfTouches = 1
        
        label.addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RateControl.pan(_:)))

        label.addGestureRecognizer(panGesture)
        label.addGestureRecognizer(tapGesture)
        self.addSubview(label)
        rate = 0
    }
    
    @objc func pan(_ sender: UIGestureRecognizer) {
        switch sender.state {
        case .changed, .began, .ended:
            let translate = sender.location(in: sender.view!)
            rate = Int((translate.x / label.bounds.size.width) * CGFloat(rateMax + 1))
        default:
            return
        }
    }
    
    override func layoutSubviews() {
        label.font = UIFont.systemFont(ofSize: bounds.size.height - 0.1)
        label.sizeToFit()
        label.center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    }
}
