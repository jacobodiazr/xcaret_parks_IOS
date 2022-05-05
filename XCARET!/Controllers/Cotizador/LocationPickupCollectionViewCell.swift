//
//  LocationPickupCollectionViewCell.swift
//  XCARET!
//
//  Created by YEiK on 22/10/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class LocationPickupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titlelLbl: UILabel!
    @IBOutlet weak var lineSelectView: UIView!
    
    func configItem(item : ItemLocations){
        var titleName = item.name
        if item.name == "Riviera" {
            titleName = "Riviera Maya"
        }
        titlelLbl.text = titleName
        lineSelectView.isHidden = true
        
        titlelLbl.font = UIFont.boldSystemFont(ofSize: 16.0)
        titlelLbl.textColor = UIColor(red: 122/255, green: 139/255, blue: 159/255, alpha: 1.0)
    }
    
    override var isSelected: Bool{
        didSet{
                if self.isSelected{
                    titlelLbl.font = UIFont.boldSystemFont(ofSize: 16.0)
                    titlelLbl.textColor = UIColor(red: 78/255, green: 117/255, blue: 163/255, alpha: 1.0)
                    self.lineSelectView.isHidden = false
                    
                }else{
                    titlelLbl.font = UIFont.systemFont(ofSize: 16.0)
                    titlelLbl.textColor = UIColor(red: 122/255, green: 139/255, blue: 159/255, alpha: 1.0)
                    self.lineSelectView.isHidden = true
                }

        }
    }
    
}
