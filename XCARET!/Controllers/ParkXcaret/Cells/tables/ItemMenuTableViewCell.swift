//
//  ItemMenuTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 1/8/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import SwiftSVG

class ItemMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var leftImgViewContraint: NSLayoutConstraint!
    var lineColorSeparator = UIColor()
    var lineColorSubSeparator = UIColor()
    var colorText = UIColor()
    var colorIcon = UIColor()
    override func awakeFromNib() {
        super.awakeFromNib()
       configDarkModeCustom()
    }
    
    func configDarkModeCustom(){
        if appDelegate.itemParkSelected.code == "XF" {
                   colorText = .white
                   viewImage.tintColor = .white
                   lineColorSeparator = UIColor(red: 255/255, green: 68/255, blue: 0/255, alpha: 1.00)
                   lineColorSubSeparator = UIColor(red: 255/255, green: 68/255, blue: 0/255, alpha: 1.00)
                   colorIcon = .white
               }else{
                   lineColorSeparator = Constants.COLORS.GENERAL.lineGray
                   colorIcon = Constants.COLORS.GENERAL.colorLine
                   lineColorSubSeparator = Constants.COLORS.ITEMS_CELLS.bgSubFilter
                   colorText = Constants.COLORS.GENERAL.colorLine
               }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setInfoView(itemMenu : ItemMenu){
        for view in viewImage.subviews{
            view.removeFromSuperview()
        }
        
        let icon = UIView(SVGNamed: itemMenu.icon){ (svgLayer) in
            svgLayer.fillColor = self.colorIcon.cgColor
            svgLayer.resizeToFit(CGRect(x: 0, y: 0, width: self.viewImage.frame.width, height: self.viewImage.frame.height))
            
        }
        
        self.leftImgViewContraint.constant = 20
        self.viewImage.addSubview(icon)
        self.lblTitle.text = itemMenu.name
        self.lblTitle.textColor = colorText//Constants.COLORS.GENERAL.colorLine
        self.viewSeparator.backgroundColor = lineColorSeparator//Constants.COLORS.GENERAL.lineGray
        self.viewSeparator.isHidden = itemMenu.separatorHidden
    }
    
    func setInfoView(itemFilter: ItemSubFilter){
        self.imgIcon.image = UIImage(named: "Icons/\(itemFilter.sf_icon ?? "")")
        self.leftImgViewContraint.constant = 35
        self.lblTitle.text = itemFilter.name
        self.viewSeparator.backgroundColor = lineColorSeparator//Constants.COLORS.GENERAL.lineGray
        self.viewSeparator.isHidden = false
        self.backgroundColor = lineColorSubSeparator//Constants.COLORS.ITEMS_CELLS.bgSubFilter
    }
}
