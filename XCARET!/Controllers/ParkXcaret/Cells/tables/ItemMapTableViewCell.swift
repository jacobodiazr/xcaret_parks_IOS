//
//  MapTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 11/16/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit

class ItemMapTableViewCell: UITableViewCell {

    @IBOutlet weak var viewGradient: GradientView!
    @IBOutlet weak var viewContentImage: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblSeeMap: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContentImage.dropShadow(color: Constants.COLORS.ITEMS_CELLS.shadowItems, opacity: 0.7, offSet: CGSize(width: 0, height: 5), radius: 3, scale: true, corner: 20, backgroundColor: Constants.COLORS.ITEMS_CELLS.circlemust)
        imgView.layer.cornerRadius = 20
        viewGradient.clipsToBounds = false
        viewGradient.layer.cornerRadius = 20
        viewGradient.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setInfoView(type: String){
        switch type {
        case "MAP":
            lblSeeMap.text = "lbl_see_map".getNameLabel().uppercased()//"lblSeeMap".localized().uppercased()
            self.imgView.image = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/map_thumb")
        default:
            self.imgView.image = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/map_thumb")
        }
    }
}
