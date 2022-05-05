//
//  ItemInfoHotelTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 6/26/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemInfoHotelTableViewCell: UITableViewCell {

    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtSubtitle: UILabel!
    @IBOutlet weak var txtSchedule: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    open func configureCell(itemHotel: ItemPark){
        self.txtTitle.text = itemHotel.name
        self.txtSubtitle.text = itemHotel.detail.slogan
        self.txtSchedule.text = itemHotel.detail.p_schelude
        self.txtDescription.text = itemHotel.detail.description
        print("description \(itemHotel.detail.description!)")
    }
}
