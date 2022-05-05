//
//  ItemCircleCollectionViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 11/14/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit

class ItemCircleCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var viewContentImage: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgActivity: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configureCell(itemActivity : ItemActivity){
        self.lblTitle.text = itemActivity.details.name
        var imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/3D2/\(itemActivity.act_image ?? "")")
        if imageName == nil{
            imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")
        }
        self.imgActivity.image = imageName
    }
}
