//
//  Item360TableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 6/27/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import CTPanoramaView

class Item360TableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var panoramaView: CTPanoramaView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var compassView: CTPieSliceView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    open func configTableCell(itemInfo: ItemInfoHotel){
        self.lblTitle.text = itemInfo.title
        self.lblDescription.text = itemInfo.subtitle
        self.panoramaView.controlMethod = .motion
        self.panoramaView.compass = compassView
        self.panoramaView.image = UIImage(named: "360/HX/spa")
    }
}
