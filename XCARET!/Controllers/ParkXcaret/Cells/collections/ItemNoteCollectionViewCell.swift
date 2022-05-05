//
//  ItemNoteCollectionViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 12/26/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit
import SwiftSVG

class ItemNoteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var svgImage: UIView!
    
    public func configureCell(note: ItemNote){
        self.lblCount.text = note.valueNote
        self.lblTitle.text = note.name
        for view in svgImage.subviews{
            view.removeFromSuperview()
        }
        if appDelegate.itemParkSelected.code == "XF" {
            self.lblCount.textColor = .white
            self.lblTitle.textColor = .white
        }
        
        let icon = UIView(SVGNamed: note.icon){ (svgLayer) in
            svgLayer.resizeToFit(self.svgImage.bounds)
        }
        self.svgImage.addSubview(icon)
    }
}
