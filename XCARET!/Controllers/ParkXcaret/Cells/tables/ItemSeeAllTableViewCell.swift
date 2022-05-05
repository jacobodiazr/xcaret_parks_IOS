//
//  ItemSeeAllTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 2/28/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

protocol ItemSeeAllCellDelegate : class {
    func getAction(_sender: ItemSeeAllTableViewCell)
}

class ItemSeeAllTableViewCell: UITableViewCell {
    weak var delegate : ItemSeeAllCellDelegate?
    @IBOutlet weak var btnSeeAll: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
   
    @IBAction func btnGoSeeAll(_ sender: UIButton) {
        delegate?.getAction(_sender: self)
    }
    
    func setCell(){
        self.btnSeeAll.setTitle("lbl_see_all".getNameLabel(), for: .normal)//("lblAll".localized(), for: .normal)
        self.btnSeeAll.imageView?.tintColor = Constants.COLORS.GENERAL.bgBtnGrad1B
    }
}
