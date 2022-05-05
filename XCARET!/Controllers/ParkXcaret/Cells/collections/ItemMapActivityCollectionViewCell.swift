//
//  ItemMapActivityCollectionViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 1/2/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import Kingfisher

class ItemMapActivityCollectionViewCell: UICollectionViewCell {
    weak var delegate : GoRouteMapDelegate?
    @IBOutlet weak var imgExtra: UIImageView!
    @IBOutlet weak var imgActivity: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblRoute: UILabel!
    @IBOutlet weak var btnHeart: FavoriteSimpleButton!
    @IBOutlet weak var btnGo: GoButton!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblInclude: UILabel!
    //var tagClicFav : TagsClicTo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configureCell(itemActivity: ItemActivity){
        self.imgExtra.isHidden = itemActivity.act_extra ? false : true
        self.lblNumber.text = "\(itemActivity.act_number ?? 0)"
        self.btnHeart.uid = itemActivity.uid
        self.btnHeart.name = itemActivity.nameES
        self.lblRoute.text = ""
        var imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/\(itemActivity.act_image ?? "")")
        if imageName == nil{
            imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")
        }
        self.imgActivity.image = self.cropToBounds(image: imageName!, width: 80, height: 80)
        
        self.lblTitle.text = itemActivity.details.name
        self.lblCategory.text = itemActivity.getCategory.name
        if !itemActivity.getRoute.name.isEmpty && !itemActivity.getRoute.color.isEmpty{
            self.lblRoute.text = "\(itemActivity.getRoute.name) (\(itemActivity.getRoute.color))"
        }
        self.btnGo.itemActivity = itemActivity
        
        if itemActivity.act_aditionalCost{
            self.lblInclude.text = "lbl_not_include".getNameLabel()
            self.lblInclude.textColor = Constants.COLORS.ITEMS_CELLS.titleNotInclude
        }else{
            self.lblInclude.text = "lbl_include".getNameLabel()
            self.lblInclude.textColor = Constants.COLORS.ITEMS_CELLS.titleInclude
        }
    }

    @IBAction func btnSendGo(_ sender: GoButton) {
        delegate?.goToMap(activity: sender.itemActivity)
    }
    
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
}
