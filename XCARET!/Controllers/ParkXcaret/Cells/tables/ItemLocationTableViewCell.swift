//
//  ItemLocationTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 27/07/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class ItemLocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var viewImageHeightConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewImageHeightConstant.constant = self.layer.bounds.width * 1.2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setInfoView(itemHome: ItemHome){
        let itemPark = appDelegate.itemParkSelected
        self.lblTitle.text = "embarcadero_title".getNameLabel()
        self.lblAddress.text = itemPark.detail.address
        self.lblDescription.text = "embarcadero_description".getNameLabel()
    }
}
