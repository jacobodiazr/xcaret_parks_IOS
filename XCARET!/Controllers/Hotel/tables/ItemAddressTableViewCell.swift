//
//  ItemAddressTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 7/1/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ItemAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imageAddressView: UIImageView!
    @IBOutlet weak var topTitleConstraint: NSLayoutConstraint!
    var mapByPark : ItemMapInfo = ItemMapInfo()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configTableCell(itemInfo: ItemInfoHotel){
        self.lblTitle.text = itemInfo.title
        self.lblDescription.text = itemInfo.subtitle
        self.imageAddressView.image = UIImage(named: itemInfo.listDetailImages[0].urlImage)
        self.topTitleConstraint.constant = 0
    }
    
    func setInfoView(itemPark: ItemHome){
        self.lblTitle.text = itemPark.name
        self.lblDescription.text = itemPark.description
        self.imageAddressView.image = UIImage(named: "Parks/\(appDelegate.itemParkSelected.code!)/howarrive")
        //self.imageAddressView.image = UIImage(named: "Parks/XI/Activities/ThumbsNew/xi_mapa")
        mapByPark = appDelegate.itemMapSelected
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goGoogleMaps))
        imageAddressView.isUserInteractionEnabled = true
        imageAddressView.addGestureRecognizer(tapGestureRecognizer)
        self.topTitleConstraint.constant = 15
    }
    
    
    @objc func goGoogleMaps(){
        let lat = mapByPark.latitude
        let lon = mapByPark.longitude
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?daddr=\(lat ?? 20.6842899),\(lon ?? -88.569971300000005)&directionsmode=driving")!, options: [:], completionHandler: nil)
        } else {
            print("Can't use comgooglemaps://")
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps/dir/?daddr=\(lat ?? 20.6842899),\(lon ?? -88.569971300000005)&directionsmode=driving")!, options: [:], completionHandler: nil)
        }
    }
}
