//
//  ItemActHorizontalTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 11/27/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit

class ItemActHorizontalTableViewCell: UITableViewCell {
    weak var delegate : UpdateTableDelegate?
    weak var delegateMap : GoRouteMapDelegate?
    var contentID : String!
    @IBOutlet weak var viewContentImage: UIView!
    @IBOutlet weak var imgActivity: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblRoute: UILabel!
    @IBOutlet weak var lblInclude: UILabel!
    @IBOutlet weak var btnFavorite: FavoriteSimpleButton!
    @IBOutlet weak var rightBtnGoConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnGo: GoButton!
    @IBOutlet weak var lblIncludeRigthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContentImage.dropShadow(color: UIColor.gray, opacity: 0.5, offSet: CGSize(width: 0, height: 3), radius: 3, scale: true, corner: 20, backgroundColor: UIColor.clear)
        imgActivity.layer.cornerRadius = 15
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setInformation(itemActivity : ItemActivity, sectionFav: Bool){
        self.btnGo.itemActivity = itemActivity
        self.lblRoute.text = ""
        if appDelegate.optionsHome {
            btnGo.isHidden = true
        }
        
        print(appDelegate.itemParkSelected.code!)
        if appDelegate.itemParkSelected.code == ""{
            
            let parkSelect = appDelegate.listAllParks.filter({$0.uid == itemActivity.act_keyPark})
            var imageName = UIImage(named: "Parks/\(parkSelect.first?.code! ?? "")/Activities/ThumbsNew/\(itemActivity.act_image!)")
            if imageName == nil{
                imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")
            }
            self.imgActivity.image = imageName
        }else{
            var imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/\(itemActivity.act_image ?? "")")
            if imageName == nil{
                imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")
            }
            self.imgActivity.image = imageName
        }
        
        
        self.lblTitle.text = itemActivity.details.name
        
        if itemActivity.category.cat_code == "REST" {
            self.lblCategory.text = itemActivity.getSubcategory.name
        }else{
            self.lblCategory.text = itemActivity.getCategory.name
        }
        if !itemActivity.getRoute.name.isEmpty && !itemActivity.getRoute.color.isEmpty{
            self.lblRoute.text = "\(itemActivity.getRoute.name) (\(itemActivity.getRoute.color))"
        }
        
        //Si viene de la seccion de favoritos habilitar la imagen
        //Si viene de otra seccion habilitar el boton
        
        if sectionFav {
            self.rightBtnGoConstraint.constant = -30
            self.btnFavorite.isHidden = true
        }else{
            self.rightBtnGoConstraint.constant = 20
            self.btnFavorite.isHidden = false
            self.btnFavorite.uid = itemActivity.uid
            self.btnFavorite.name = itemActivity.nameES
        }
        
        if itemActivity.act_aditionalCost{
            self.lblInclude.text = "lbl_not_include".getNameLabel()//"lblNotInclude".localized()
            self.lblInclude.textColor = Constants.COLORS.ITEMS_CELLS.titleNotInclude
        }else{
            self.lblInclude.text = "lbl_include".getNameLabel()//"lblInclude".localized()
            self.lblInclude.textColor = Constants.COLORS.ITEMS_CELLS.titleInclude
        }
        if appDelegate.itemParkSelected.code == "XV" {
            if itemActivity.category.cat_code == "BASIC" {
                self.lblInclude.text = "xv_lbl_include_basic".getNameLabel()//"lblIncludeBasicXV".localized()
            }else if itemActivity.category.cat_code == "XTREME"{
                self.lblInclude.text = "xv_lbl_lnclude_all_inclusive".getNameLabel()//"lblIncludeAllInclusiveXV".localized()
            }
            
            self.rightBtnGoConstraint.constant = -30
            self.btnGo.isHidden = true
            self.lblInclude.textColor = Constants.COLORS.ITEMS_CELLS.titleInclude
            self.lblIncludeRigthConstraint.constant = -35
        }
    }
    
    
    @IBAction func btnGoMap(_ sender: GoButton) {
        AnalyticsBR.shared.saveEventContentFBByPark(content: contentID, title: TagsID.showLocation.rawValue)
        self.delegateMap?.goToMap(activity: sender.itemActivity)
    }
}
