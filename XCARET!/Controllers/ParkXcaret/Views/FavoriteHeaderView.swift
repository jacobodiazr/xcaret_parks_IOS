//
//  FavoriteHeaderView.swift
//  XCARET!
//
//  Created by Angelica Can on 11/28/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit

class FavoriteHeaderView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cornerDropShadowView : UIView!
    @IBOutlet weak var topLogoContraint: NSLayoutConstraint!
    @IBOutlet weak var logoPark : UIImageView!
    @IBOutlet weak var bottomCornerDrop: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewGradient : GradientView!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
       configDarkModeCustom()
    }
    
    func configDarkModeCustom(){
        self.lblName.isHidden = true
        switch appDelegate.itemParkSelected.code {
        case "XS":
            self.cornerDropShadowView.setTrapecioShadow()
            //self.lblName.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 23)
            //self.bottomCornerDrop.constant = 0
            self.viewGradient.isHidden = true
        case "XV":
            self.cornerDropShadowView.backgroundColor = UIColor.clear
            let imageName = "Headers/XV/textura"
            let image = UIImage(named: imageName)
            let imageViewC = UIImageView(image: image!)
            imageViewC.frame = CGRect(x: 0, y: 0, width: self.cornerDropShadowView.frame.size.width, height: 70)
            cornerDropShadowView.addSubview(imageViewC)
        case "XF":
            self.cornerDropShadowView.setOvalShadow(color: Constants.COLORS.GENERAL.customDarkMode)
        default:
            self.cornerDropShadowView.setOvalShadow()
        }
        self.topLogoContraint.constant = UIDevice().getTopLogo()
        self.logoPark.image = UIImage(named: "Logos/logo\(appDelegate.itemParkSelected.code ?? "Logos/logoGroup")")
        self.imageView.image = UIImage(named: "Headers/\(appDelegate.itemParkSelected.code!)/default")
        self.layoutIfNeeded()
    }
}
