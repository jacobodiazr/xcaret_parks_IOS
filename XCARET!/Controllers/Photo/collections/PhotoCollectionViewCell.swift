//
//  PhotoCollectionViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 4/10/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPhotAlbum: UIImageView!
    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var iconMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    open func configureCell(urlPhoto: String, isSelected : Bool = false, optSelected : Bool){
        let urlImage = urlPhoto
        let url = URL(string: urlImage)
        self.imgPhotAlbum.kf.setImage(with: url, placeholder : UIImage(named: "Icons/photo/ic_default"))
        self.viewGradient.isHidden = true
        if optSelected {
            self.iconMark.isHidden = false
            if isSelected {
                self.iconMark.image = UIImage(named: "Icons/photo/ic_check")
                //self.viewGradient.isHidden = false
            }else{
                self.iconMark.image = UIImage(named: "Icons/photo/ic_uncheck")
                //self.viewGradient.isHidden = true
            }
        }else{
            self.iconMark.isHidden = true
            //self.viewGradient.isHidden = true
        }
    }
}
