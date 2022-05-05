//
//  ItemAllFunCollectionViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 7/1/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemAllFunCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageLogo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(itemDetail : ItemDetailImages){
        self.imageLogo.image = UIImage(named: itemDetail.urlImage!)
    }
}
