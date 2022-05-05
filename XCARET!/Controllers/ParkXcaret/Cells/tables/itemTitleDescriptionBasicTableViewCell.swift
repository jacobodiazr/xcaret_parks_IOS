//
//  itemTitleDescriptionBasicTableViewCell.swift
//  XCARET!
//
//  Created by Jacobo Díaz on 07/01/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class itemTitleDescriptionBasicTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSlogan: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewContentview: UIView!
    @IBOutlet weak var topTitleConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setInfoView(itemHome: ItemHome){
        topTitleConstraint.constant = 20
        self.viewContentview.backgroundColor = appDelegate.itemParkSelected.code == "XF" ? Constants.COLORS.GENERAL.customDarkMode : .white
        if itemHome.itemPark.code == "XF" {
            self.lblDescription.textColor = .white
            self.lblTitle.textColor = UIColor(red: 255/255, green: 68/255, blue: 0/255, alpha: 1.00)
        }else if itemHome.itemPark.code == "FE" {
            self.lblTitle.textColor = Constants.COLORS.ITEMS_CELLS.titleCell
            topTitleConstraint.constant = 0
//            self.lblDescription.font = UIFont.systemFont(ofSize: 17.0)
        }
        lblTitle.text = itemHome.name
        lblSlogan.text = itemHome.subTitle
        lblDescription.text = itemHome.description
    }
    
}
