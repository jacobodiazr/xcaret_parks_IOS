//
//  SearchHeaderView.swift
//  XCARET!
//
//  Created by Angelica Can on 11/28/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit

class SearchHeaderView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cornerDropShadowView : UIView!
    @IBOutlet weak var bottomCornerDrop: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewGradient : GradientView!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.lblName.isHidden = true
        switch appDelegate.itemParkSelected.code {
        case "XS":
            self.cornerDropShadowView.setTrapecioShadow()
            //self.lblName.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 23)
            //self.bottomCornerDrop.constant = 0
            self.viewGradient.isHidden = true
        default:
            self.cornerDropShadowView.setOvalShadow()
        }
        if appDelegate.optionsHome {
            self.imageView.image = UIImage(named: "Headers/XC/default")
        }else{
            self.imageView.image = UIImage(named: "Headers/\(appDelegate.itemParkSelected.code!)/default")
        }
    }

}
