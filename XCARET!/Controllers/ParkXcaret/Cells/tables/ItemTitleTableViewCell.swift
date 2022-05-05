//
//  ItemTitleTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 12/4/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit

class ItemTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var topsSizeHome: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        if appDelegate.optionsHome{
            self.topsSizeHome.constant = 30
        }
    }
    
    func configDarkModeCustom(){
        lblTitle.textColor = UIColor(red: 255/255, green: 68/255, blue: 0/255, alpha: 1.00)
        if appDelegate.itemParkSelected.code == "XF" {
            lblTitle.textColor = UIColor(red: 255/255, green: 68/255, blue: 0/255, alpha: 1.00)
        }else{
            lblTitle.textColor = UIColor(red: 78/255, green: 117/255, blue: 163/255, alpha: 1.00)
        }
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
