//
//  itemButtonPMTableViewCell.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 04/06/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class itemButtonPMTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContentColor: UIView!
    @IBOutlet weak var lblTitulo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContentColor.dropShadowView(color: UIColor.gray, opacity: 0.5, offSet: CGSize(width: 0, height: 5))
    }
    
    func configTitle(){
        self.lblTitulo.text = appDelegate.contentPrograms.getDetail.description
    }

    
}
