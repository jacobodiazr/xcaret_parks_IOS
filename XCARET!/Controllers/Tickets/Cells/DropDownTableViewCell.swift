//
//  DropDownTableViewCell.swift
//  XCARET!
//
//  Created by Hate on 11/11/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit
import DropDown

class DropDownTableViewCell: DropDownCell {

    @IBOutlet weak var imgFlag: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIColor(red: 78/255, green: 117/255, blue: 163/255, alpha: 1.00)
        // Configure the view for the selected state
    }
    
}
