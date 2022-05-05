//
//  itemsBenefitTableViewCell.swift
//  XCARET!
//
//  Created by Hate on 01/09/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class itemsBenefitTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(itemBenefit : ItemsLangBenefit){

        self.lblDescription.text = itemBenefit.description
        
        if itemBenefit.image != "" {
            var imagen = UIImage(named: "Promociones/beneficios/\(itemBenefit.image ?? "")")
            if imagen == nil{
                imagen = UIImage(named: "Promociones/beneficios/alimentos")
            }
            self.img.image = imagen
        }else{
            img.isHidden = true
            lblConstraint.constant = 0
        }
            
        
        
//        if itemBenefit.image == "" {
//            img.isHidden = true
//            lblConstraint.constant = 0
//        }
        
    }
    
}
