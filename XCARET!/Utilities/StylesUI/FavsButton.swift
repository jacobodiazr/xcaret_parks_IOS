//
//  FavsButton.swift
//  XCARET!
//
//  Created by Angelica Can on 12/5/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit

@IBDesignable class FavsButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override lazy @IBInspectable var cornerRadius: CGFloat = 2.0 {
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
