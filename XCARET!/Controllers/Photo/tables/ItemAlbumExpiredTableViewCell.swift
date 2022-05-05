//
//  ItemAlbumExpiredTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 26/04/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class ItemAlbumExpiredTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblLeyendVisit: UILabel!
    @IBOutlet weak var lblDateVisit: UILabel!
    @IBOutlet weak var lblLeyendExpired: UILabel!
    @IBOutlet weak var imgPark: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(isBook: Bool,itemDetail : ItemAlbumDetail){
        self.lblLeyendVisit.text = "lbl_visit_date".getNameLabel()
        self.lblDateVisit.text = itemDetail.visitDate.dateFormat(format: "yyyy/MM/dd")
        self.lblLeyendExpired.text = "lbl_expirate_photopass".getNameLabel()
        self.imgPark.image = UIImage(named: "Photo/logo/logo\(itemDetail.parkId ?? 1)")
    }
    
}
