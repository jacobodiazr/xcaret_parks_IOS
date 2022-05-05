//
//  ItemMapServiceCollectionViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 1/24/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemMapServiceCollectionViewCell: UICollectionViewCell {
    weak var delegate : GoRouteServDelegate!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRoute: UILabel!
    @IBOutlet weak var lblSchedule: UILabel!
    @IBOutlet weak var imageIconGral: UIImageView!
    @IBOutlet weak var btnGoMap: GoServButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configureCell(item: ItemServicesLocation){
        self.imageIcon.isHidden = true
        self.imageIconGral.isHidden = true
        
        if !item.s_photo.isEmpty{
            self.imageIcon.isHidden = false
            var imageName = UIImage(named: "Services/\(appDelegate.itemParkSelected.code!)Xelfies/\(item.s_photo ?? "")")
            if imageName == nil{
                imageName = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/Activities/ThumbsNew/ok")!
            }
            self.imageIcon.image = imageName
        }else{
            self.imageIconGral.isHidden = false
            self.imageIconGral.image = UIImage(named: "Icons/\(item.service.serv_icon ?? "")")!
        }
        
        
        self.lblTitle.text = item.getDetail.name
        self.lblRoute.text = "\(item.service.getDetail.name)"
        if Tools.shared.isFormatHours24() {
            self.lblSchedule.text = item.s_schedule24
        }else{
            self.lblSchedule.text = item.s_schedule12
        }
        
        self.btnGoMap.itemServiceLocation = item
    }
    
    @IBAction func goRouteMap(_ sender: GoServButton) {
        delegate.goToServ(service: sender.itemServiceLocation)
    }
}
