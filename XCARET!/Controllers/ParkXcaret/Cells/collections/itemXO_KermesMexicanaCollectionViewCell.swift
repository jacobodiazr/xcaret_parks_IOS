//
//  itemXO_KermesMexicanaCollectionViewCell.swift
//  XCARET!
//
//  Created by Jacobo Díaz on 23/12/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class itemXO_KermesMexicanaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewImg: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configureCell(itemActivity : ItemActivity){
        lblTitle.text = itemActivity.details.name
        lblDescription.text = itemActivity.details.description
        var imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/\(itemActivity.act_image ?? "")")
        if imageName == nil{
            imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ok")
        }
        self.viewImg.image = imageName
    }

}
