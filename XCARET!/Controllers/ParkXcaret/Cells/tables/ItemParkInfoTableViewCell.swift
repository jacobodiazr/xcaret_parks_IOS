//
//  ItemParkInfoTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 13/07/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class ItemParkInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitlePark: UILabel!
    @IBOutlet weak var lblSloganPark: UILabel!
    @IBOutlet weak var lblDescPark: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setInfoView(listAddmission: [ItemAdmission]){
        let infoPark = appDelegate.itemParkSelected
        if infoPark.code.uppercased() == "XA" {
            self.lblTitlePark.text = infoPark.name
            self.lblSloganPark.text = infoPark.detail.slogan
            self.lblDescPark.text = infoPark.detail.description
        }else{
            if listAddmission.count > 0  {
                self.lblTitlePark.text = listAddmission[0].getDetail.name
                self.lblSloganPark.text = listAddmission[0].getDetail.slogan
                self.lblDescPark.text = listAddmission[0].getDetail.description
            }
        }
    }
}
