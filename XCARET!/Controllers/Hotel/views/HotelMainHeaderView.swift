//
//  HotelMainHeaderView.swift
//  XCARET!
//
//  Created by Angelica Can on 6/26/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class HotelMainHeaderView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cornerDropShadowView: UIView!
    @IBOutlet weak var btnVideo : UIButton!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.cornerDropShadowView.setOvalShadow()
    }
 
}
