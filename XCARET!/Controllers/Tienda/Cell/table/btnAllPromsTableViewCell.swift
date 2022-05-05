//
//  btnAllPromsTableViewCell.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 19/02/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class btnAllPromsTableViewCell: UITableViewCell {
    weak var delegate : GoToPromBar?
    @IBOutlet weak var titleLbl: UIButton!
    
    @IBOutlet weak var btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.setTitle("lbl_all_promotions_shop".getNameLabel(), for: .normal)
    }
    
    @IBAction func btnAction(_ sender: Any) {
        appDelegate.itemParkSelected = ItemPark()
        delegate?.goToPromBar(item: 0)
    }
}
