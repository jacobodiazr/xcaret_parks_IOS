//
//  ItemParkCollectionViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 6/4/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemParkCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewPark: UIImageView!
    @IBOutlet weak var lblNamePark: UILabel!
    @IBOutlet weak var lblDescPark: UILabel!
    
    
    public func configureCell(itemPark : ItemPark){
        self.imageViewPark.image = UIImage(named: "Home/thumb\(itemPark.code!)")
        self.lblNamePark.text = itemPark.name.uppercased()
        self.lblDescPark.text = itemPark.detail.slogan
        
        if UIScreen.main.nativeBounds.height == 1136 || UIScreen.main.nativeBounds.height == 1334 {
            self.lblNamePark.font = UIFont.systemFont(ofSize: 25)
        }
    }
}
