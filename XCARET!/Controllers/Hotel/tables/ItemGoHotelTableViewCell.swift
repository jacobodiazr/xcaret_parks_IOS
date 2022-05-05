//
//  ItemGoHotelTableViewCell.swift
//  XCARET!
//
//  Created by Hate on 23/11/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class ItemGoHotelTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblDescription.text = "lbl_know_hotel".getNameLabel()
    }
}
