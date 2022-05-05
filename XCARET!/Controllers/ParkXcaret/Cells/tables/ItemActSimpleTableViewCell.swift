//
//  ItemActSimpleTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 8/14/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemActSimpleTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContentImage: UIView!
    @IBOutlet weak var imgActivity: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var viewSeparacion: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewContentImage.dropShadow(color: UIColor.gray, opacity: 0.5, offSet: CGSize(width: 0, height: 3), radius: 3, scale: true, corner: 20, backgroundColor: UIColor.clear)
        imgActivity.layer.cornerRadius = 15
        configDarkModeCustom()
       
    }
    
    func configDarkModeCustom(){
        if appDelegate.itemParkSelected.code == "XF" {
            viewContentImage.dropShadow(color: UIColor.black, opacity: 0.7, offSet: CGSize(width: 0, height: 5), radius:3, scale: true, corner: 20, backgroundColor: UIColor.black)
            lblTitle.textColor = UIColor(red: 255/255, green: 68/255, blue: 0/255, alpha: 1.00)
            lblCategory.textColor = .white
            viewSeparacion.backgroundColor = UIColor(red: 255/255, green: 68/255, blue: 0/255, alpha: 1.00)
        }else{
            viewContentImage.dropShadow(color: UIColor.gray, opacity: 0.7, offSet: CGSize(width: 0, height: 5), radius:3, scale: true, corner: 20, backgroundColor:  UIColor.gray)
            lblTitle.textColor = UIColor(red: 78/255, green: 117/255, blue: 163/255, alpha: 1.00)
            lblCategory.textColor = UIColor(red: 78/255, green: 117/255, blue: 163/255, alpha: 1.00)
            viewSeparacion.backgroundColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1.00)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInformation(itemActivity : ItemActivity, sectionFav: Bool){
        configDarkModeCustom()
        var imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/\(itemActivity.act_image ?? "")")
        if imageName == nil{
            imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")
        }
        self.imgActivity.image = imageName
        self.lblTitle.text = itemActivity.details.name
        
        if itemActivity.category.cat_code == "REST" {
            self.lblCategory.text = itemActivity.getSubcategory.name
        }else{
            self.lblCategory.text = itemActivity.getCategory.name
        }
    }
}
