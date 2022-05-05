//
//  ItemAwardCollectionViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 2/9/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemAwardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageAward: UIImageView!
    @IBOutlet weak var nameAward: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if appDelegate.itemParkSelected.code == "XF" {
            nameAward.textColor = .white
        }
    }

    func configCell(itemAward : ItemAward){
        print("Parks/XC/Awards/\(itemAward.icon ?? "")")
        self.imageAward.image = UIImage(named: "Parks/XC/Awards/\(itemAward.icon ?? "")")
        self.nameAward.text = itemAward.detail.name
    }
}
