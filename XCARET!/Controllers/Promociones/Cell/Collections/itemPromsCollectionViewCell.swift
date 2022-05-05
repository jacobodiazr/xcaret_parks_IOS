//
//  itemPromsCollectionViewCell.swift
//  XCARET!
//
//  Created by Hate on 20/08/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class itemPromsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var CVOpciones: UICollectionView!
    @IBOutlet weak var topCVContraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.CVOpciones.removeFromSuperview()
        self.topCVContraint.constant = 0
    }

}
