//
//  ItemPinterestCollectionViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 1/31/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemPinterestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnHeart: FavoriteButton!
    @IBOutlet weak var viewGradient: GradientView!
    @IBOutlet weak var imgExtra: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var leadingLeftLblTitleConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.dropShadow(color: UIColor.gray, opacity: 0.7, offSet: CGSize(width: 0, height: 5), radius: 3, scale: true, corner: 20, backgroundColor: UIColor.clear)
        imageView.layer.cornerRadius = 20
        viewGradient.layer.cornerRadius = 20
        viewGradient.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    public func configureCell(itemActivity : ItemActivity){
        if !itemActivity.act_extra {
            self.imgExtra.isHidden = true
            self.leadingLeftLblTitleConstraint.constant = -30
        }
        self.btnHeart.uid = itemActivity.uid
        self.btnHeart.name = itemActivity.nameES
        //self.btnHeart.viewClicFav = tag
        self.imgExtra.isHidden = !itemActivity.act_extra
        self.lblTitle.text = itemActivity.details.name
        
        var imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/\(itemActivity.act_image ?? "")")
        if imageName == nil{
            imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")
        }
        self.imageView.image = imageName
    }
}
