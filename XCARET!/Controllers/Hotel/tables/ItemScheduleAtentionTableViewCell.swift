//
//  ItemScheduleAtentionTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 10/12/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemScheduleAtentionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configTableCell(){
        self.lblTitle.text = "lbl_call_title".getNameLabel()//"lblCallTitle".localized()
        self.lblDescription.text = "lbl_call_description".getNameLabel()//"lblCallDescription".localized()
    }

}
