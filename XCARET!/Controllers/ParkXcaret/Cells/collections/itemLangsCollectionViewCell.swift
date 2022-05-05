//
//  itemLangsCollectionViewCell.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 25/07/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class itemLangsCollectionViewCell: UICollectionViewCell {
    weak var delegate : ModalChangeLangHandler?
    @IBOutlet weak var imgBandera: UIImageView!
    @IBOutlet weak var lblPais: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(item: language){
        self.lblPais.text = item.lang_name
        
        let imagen: UIImage? = UIImage(named: "Icons/ic_\(item.lang_twoLetterCode!)")
        if imagen != nil {
           self.imgBandera.image = imagen
        }else{
//            self.img.image = UIImage(named: "ProgramaDeMano/escenas/default")
        }
        
    }

}
