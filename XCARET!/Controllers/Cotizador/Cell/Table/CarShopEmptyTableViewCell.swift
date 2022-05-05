//
//  CarShopEmptyTableViewCell.swift
//  XCARET!
//
//  Created by YEiK on 07/07/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class CarShopEmptyTableViewCell: UITableViewCell {
    
    weak var delegate: ManageCitizador?
    
    @IBOutlet weak var contentConstraintView: NSLayoutConstraint!
    @IBOutlet weak var buttonType: UIButton!
    @IBOutlet weak var mensajeLbl: UILabel!
    @IBOutlet weak var imgLogo: UIView!
    
    var typeMensaje = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentConstraintView.constant = UIScreen.main.bounds.height - 120.0
    }
    
    func configMensaje(type : String) {
        typeMensaje = type
        if typeMensaje == "empty"{
            imgLogo.isHidden = false
            mensajeLbl.text = "lbl_cart_not_element_title".getNameLabel()
            
            buttonType.backgroundColor = .systemOrange
            buttonType.setTitleColor( .white , for: .normal)
            buttonType.setTitle("lbl_cart_not_element_button".getNameLabel(), for: .normal)
        }else{
            imgLogo.isHidden = true
            mensajeLbl.text = "error, Lorem Ipsum is simply dummy text of the printing and typesetting industry."
            
            buttonType.backgroundColor = .clear
            buttonType.setTitleColor( .systemBlue , for: .normal)
            buttonType.setTitle("Reintentar", for: .normal)
        }
        
    }
    
    @IBAction func actionButton(_ sender: Any) {
        delegate?.emptyError(type: typeMensaje)
    }
    
    
}
