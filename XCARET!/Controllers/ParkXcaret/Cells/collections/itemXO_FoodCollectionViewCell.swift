//
//  itemXO_FoodCollectionViewCell.swift
//  XCARET!
//
//  Created by Jacobo Díaz on 26/12/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class itemXO_FoodCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var imgBgMenu: UIImageView!
    @IBOutlet weak var imgPlatoMenu: UIImageView!
    @IBOutlet weak var lblTitleMenu: UILabel!
    @IBOutlet weak var lblOptions1: UILabel!
    @IBOutlet weak var lblOptions2: UILabel!
    @IBOutlet weak var layoutLeadingOption1: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgPlatoMenu.dropShadow(color: UIColor.black, opacity: 0.3, offSet: CGSize(width: 0, height: 5), radius:3, scale: true, corner: 20, backgroundColor: UIColor.clear)
        viewContent.dropShadow(color: UIColor.gray, opacity: 0.7, offSet: CGSize(width: 0, height: 5), radius:3, scale: true, corner: 20, backgroundColor: UIColor.clear)
        
    }
    
    public func configureCell(itemActivity : ItemActivity){
        var imageNameBG = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/\(itemActivity.act_image ?? "")_bg")
        if imageNameBG == nil{
            imageNameBG = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ok")
        }
        self.imgBgMenu.image = imageNameBG
        
        var imageNamePlato = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/\(itemActivity.act_image ?? "")")
        if imageNamePlato == nil{
            imageNamePlato = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ok")
        }
        self.imgPlatoMenu.image = imageNamePlato
        
        lblTitleMenu.text = itemActivity.details.name
        
        let options = itemActivity.details.include.components(separatedBy: "\n")
        var strOptions = ""
        if options.count < 5 {
            strOptions = ""
            lblOptions2.text = ""
            lblOptions2.isHidden = true
            for option in options {
                strOptions += "\(option)\n"
            }
            lblOptions1.text = strOptions
            layoutLeadingOption1.constant = -80
        }else{
            lblOptions2.isHidden = false
            let middle = options.count / 2
            var includeLeft = ""
            var includeRight = ""
            for (index, option) in options.enumerated() {
                if(index > middle){
                    includeRight += "\(option)\n"
                }else {
                    includeLeft += "\(option)\n"
                }
            }
            layoutLeadingOption1.constant = 15
             lblOptions1.text = includeLeft
             lblOptions2.text = includeRight
        }
    }
}
