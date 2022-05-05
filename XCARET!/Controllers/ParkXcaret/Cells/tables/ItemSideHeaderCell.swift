//
//  ItemSideHeader.swift
//  XCARET!
//
//  Created by Angelica Can on 1/23/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemSideHeaderCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var lineSeparator: UIView!
    
    func setInfoCell(itemFilter: ItemFilterMap, tag: Int, section: Int){
        let imageicon = itemFilter.f_icon ?? ""
        self.iconImage.image = UIImage(named: "Icons/\(imageicon)")
        self.lblTitle.text = itemFilter.getDetail.name
    }
}
