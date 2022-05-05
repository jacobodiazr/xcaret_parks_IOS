//
//  MarkersView.swift
//  XCARET!
//
//  Created by Angelica Can on 1/28/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import Foundation
import UIKit
import SwiftSVG

class MarkerView {
    static let shared = MarkerView()
    
    func setPinActivity(title: Int, colorPin: UIColor, colorCode: String) -> UIView{
        let sizeCircle : CGFloat = 25
        let view = UIView(frame: CGRect(x: 0, y: 0, width: sizeCircle, height: sizeCircle))
        view.backgroundColor = colorPin //Constants.COLORS.MARKER_MAP.activity
        view.cornerRadius = view.frame.width / 2
        
        let text = UILabel(frame: CGRect(x: 0, y: 0, width: sizeCircle, height: sizeCircle))
        if colorCode.elementsEqual("WHITE") || colorCode.elementsEqual("GREEN"){
            text.textColor = UIColor.black
        }else{
            text.textColor = UIColor.white
        }
        
        text.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
        text.textAlignment = .center
        text.text = "\(title)"
        view.addSubview(text)
        return view
    }
    
    func setPinSelectActivity(title: Int, colorPin: UIColor, colorCode: String) -> UIView{
        let sizeCircle : CGFloat = 50
        let view = UIView(frame: CGRect(x: 0, y: 0, width: sizeCircle, height: sizeCircle))
        view.backgroundColor = colorPin //Constants.COLORS.MARKER_MAP.activity
        view.cornerRadius = view.frame.width / 2
        view.borderWidth = 2
        
        let text = UILabel(frame: CGRect(x: 0, y: 0, width: sizeCircle, height: sizeCircle))
        if colorCode.elementsEqual("WHITE") || colorCode.elementsEqual("GREEN"){
            text.textColor = UIColor.black
            view.borderColor = UIColor.black
        }else{
            text.textColor = UIColor.white
            view.borderColor = UIColor.white
        }
        text.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.medium)
        text.textAlignment = .center
        text.text = "\(title)"
        view.addSubview(text)
        return view
    }
    
    func setPinService(codeServ: String) -> UIView{
        let sizeCircle : CGFloat = 20
        let view = UIView(frame: CGRect(x: 0, y: 0, width: sizeCircle, height: sizeCircle))
        var colorbck = UIColor.white
        var borderColor = Constants.COLORS.MARKER_MAP.service
        
        switch codeServ {
        case "XELF":
            colorbck = Constants.COLORS.MARKER_MAP.xelfie
            borderColor = UIColor.black
        case "FIRSTA":
            colorbck = UIColor.white
            borderColor = UIColor.red
        default:
            colorbck = UIColor.white
            borderColor = Constants.COLORS.MARKER_MAP.service
        }
        
        view.backgroundColor = colorbck
        view.borderColor = borderColor
        view.cornerRadius = view.frame.width / 2
        view.borderWidth = 2
        
        return view
    }
    
    func setPinSelectedService(itemServiceLocation: ItemServicesLocation) -> UIView {
        let sizeCircle : CGFloat = 50
        let sizeIcon : CGFloat = 30
        let view = UIView(frame: CGRect(x: 0, y: 0, width: sizeCircle, height: sizeCircle))
        var borderColor = UIColor.white
        var imgColor = UIColor.white
        var bckColor = Constants.COLORS.MARKER_MAP.service
        var iconRename = itemServiceLocation.service.serv_icon!
        
        if itemServiceLocation.category.cat_code == "MOD" {
            iconRename = "ic_modulo"
        }
        
        switch itemServiceLocation.service.serv_code {
        case "XELF":
            borderColor = UIColor.black
            bckColor = Constants.COLORS.MARKER_MAP.xelfie
            iconRename = "\(iconRename)_pin"
            imgColor = UIColor.black
            
        case "FIRSTA":
            borderColor = UIColor.red
            bckColor = UIColor.white
            imgColor = UIColor.red
        default:
            borderColor = UIColor.white
            bckColor = Constants.COLORS.MARKER_MAP.service
            imgColor = UIColor.white
        }
        
        view.backgroundColor = bckColor
        view.borderColor = borderColor
        view.cornerRadius = view.frame.width / 2
        view.borderWidth = 2
        
        let icon = UIImageView(frame:CGRect(x: 10, y: 10, width: sizeIcon, height: sizeIcon))
        print("Icons/\(iconRename)")
        icon.image = UIImage(named: "Icons/\(iconRename)")
        icon.setImageColor(color: imgColor)
        icon.contentMode = .scaleAspectFill
        view.addSubview(icon)
        return view
    }
    
}
