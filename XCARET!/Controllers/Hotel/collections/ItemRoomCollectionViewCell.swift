//
//  ItemRoomCollectionViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 7/1/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemRoomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageRoom: UIImageView!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    open func configureCell(itemDetail : ItemDetailImages){
        self.imageRoom.image = UIImage(named: "Hotel/hxc_\(itemDetail.urlImage!)")
        self.imageIcon.image = UIImage(named: "Hotel/icons/\(itemDetail.urlImage!)")
        self.lblTitle.text = itemDetail.name
    }
}
