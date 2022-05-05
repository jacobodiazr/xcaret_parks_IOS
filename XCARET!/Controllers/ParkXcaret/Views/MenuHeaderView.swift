//
//  MenuHeaderView.swift
//  XCARET!
//
//  Created by Angelica Can on 1/8/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import Kingfisher

class MenuHeaderView: UIView {
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var gradientView : UIView!
    @IBOutlet weak var cornerDropShadowView : UIView!
    @IBOutlet weak var imageAvatar : UIImageView!
    @IBOutlet weak var lblNameUser : UILabel!
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        configDarkModeCustom()
    }
    
    func configDarkModeCustom(){
        lblNameUser.textColor = UIColor(red: 78/255, green: 117/255, blue: 163/255, alpha: 1.0)
        switch appDelegate.itemParkSelected.code {
        case "XS":
            self.cornerDropShadowView.setTrapecioShadow()
            //self.lblNameUser.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 23)
            self.lblNameUser.backgroundColor = UIColor.clear
            self.gradientView.isHidden = true
        case "XV":
            self.cornerDropShadowView.backgroundColor = UIColor.clear
            let imageName = "Headers/XV/textura"
            let image = UIImage(named: imageName)
            let imageViewC = UIImageView(image: image!)
            imageViewC.frame = CGRect(x: 0, y: 0, width: self.cornerDropShadowView.frame.size.width, height: 70)
            cornerDropShadowView.addSubview(imageViewC)
        case "XF":
            self.cornerDropShadowView.backgroundColor = UIColor.clear
            self.cornerDropShadowView.setOvalShadow(color: Constants.COLORS.GENERAL.customDarkMode)
            self.lblNameUser.backgroundColor = Constants.COLORS.GENERAL.customDarkMode
            self.lblNameUser.textColor = .white
        default:
            self.cornerDropShadowView.setOvalShadow()
            self.lblNameUser.backgroundColor = UIColor.white
        }
        self.bringSubviewToFront(imageAvatar)
        print(appDelegate.optionsHome)
        if appDelegate.optionsHome {
            self.imageView.image = UIImage(named: "Headers/XC/default")
        }else{
            self.imageView.image = UIImage(named: "Headers/\(appDelegate.itemParkSelected.code!)/default")
        }
        self.cornerDropShadowView.shadowColor = .clear
    }
    
    func setImage() {
        let urlImage = FirebaseDB.shared.getUrlImageUser()
        let url = URL(string: urlImage)
        self.imageAvatar.kf.setImage(with: url, placeholder : UIImage(named: "Icons/ico_noprofile"))
    }
    
    func setNameGuest(){
        let provider = AppUserDefaults.value(forKey: .UserProvider, fallBackValue: "Firebase")
        if provider != "Firebase" {
            self.lblNameUser.text = AppUserDefaults.value(forKey: .UserName).stringValue
        }else{
            self.lblNameUser.text = "btn_guest".getNameLabel()//"lblGuest".localized()
        }
    }
}
