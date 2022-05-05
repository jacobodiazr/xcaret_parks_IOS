//
//  AdmissionHeaderView.swift
//  XCARET!
//
//  Created by Angelica Can on 08/07/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class AdmissionHeaderView: UIView {
    
    var namedImage = "ok"
    var imageName: String = "ok" {
        didSet{
            self.namedImage = "Parks/\(appDelegate.itemParkSelected.code!)/Entradas/\(imageName)"
            
            if let imageTD = UIImage(named: namedImage) {
                imageView.image = imageTD
            } else {
                imageView.image = nil
            }
        }
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var imageViewTexture: UIImageView!
    
    
    override func draw(_ rect: CGRect) {
        
    }
}
