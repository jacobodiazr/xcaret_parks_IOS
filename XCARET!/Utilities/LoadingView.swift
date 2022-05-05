//
//  LoadingView.swift
//  XCARET!
//
//  Created by Angelica Can on 11/7/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class LoadingView {
    static let shared = LoadingView()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var animateView = AnimationView()
    
    func showActivityIndicator(uiView: UIView, type: TypeJsonLottie = .load) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        animateView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        animateView.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        
        let av = Animation.named(type.rawValue)
        self.animateView.animation = av
        self.animateView.contentMode = .scaleAspectFit
        self.animateView.loopMode = .loop
        self.animateView.play()
        
        loadingView.addSubview(animateView)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    func hideActivityIndicator(uiView: UIView) {
        //activityIndicator.stopAnimating()
        self.animateView.stop()
        container.removeFromSuperview()
    }
    
    /*
     Define UIColor from hex value
     
     @param rgbValue - hex color value
     @param alpha - transparency level
     */
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}

