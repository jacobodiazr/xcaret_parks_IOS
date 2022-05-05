//
//  ItemHeaderProdTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 20/01/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class ItemHeaderProdTableViewCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var lblHeaderProd: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        self.dropShadow(color: UIColor.gray, opacity: 0.2, offSet: CGSize(width: 0, height: 3), radius: 2, scale: true, corner: 20, backgroundColor: UIColor.clear)
    }

    /*override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/
    
}
