//
//  ItemTPhotoPassTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 20/01/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class ItemTPhotoPassTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblPhotoPass: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblPhotoPass.text = "tickets_lbl_photopass".getNameLabel()//"lblThanksPhotopass".localized()
    }
    
}
