//
//  ItemContactHotelTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 7/2/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemContactHotelTableViewCell: UITableViewCell {
    

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configTableCell(itemDirectory: ItemDirectory){
        print("type \(itemDirectory.type)")
        self.lblCity.text = itemDirectory.type == .phone ? "\(itemDirectory.name!) :" : ""
        self.lblContact.attributedText =  NSAttributedString(string: itemDirectory.dataInfo, attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
}
