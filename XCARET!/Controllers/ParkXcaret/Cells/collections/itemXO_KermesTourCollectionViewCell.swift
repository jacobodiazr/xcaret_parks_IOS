//
//  itemXO_KermesTourCollectionViewCell.swift
//  XCARET!
//
//  Created by Jacobo Díaz on 06/01/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class itemXO_KermesTourCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UITextView!
    //    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var viewImgs: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewImg.dropShadow(color: UIColor.gray, opacity: 0.7, offSet: CGSize(width: 0, height: 5), radius:3, scale: true, corner: 20, backgroundColor: UIColor.clear)
    }
    
    public func configureCellIMGS(count : Int, item : ItemActivity){
        
        lblTitle.text = item.details.name//"lblTitleXOKermes_\(count)".localized()
        lblDescription.text = item.details.description//"lblDescription_\(count)".localized()
        
        var imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/\(item.act_image!)")
        if imageName == nil{
            imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")
        }
        self.viewImgs.image = imageName
    }

}
