//
//  LocationCollectionViewCell.swift
//  XCARET!
//
//  Created by Yeik on 17/04/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var hrs: UILabel!
    @IBOutlet weak var check: NSLayoutConstraint!
    @IBOutlet weak var checkSelectLocation: UIView!
    var acceptTerm = false
    @IBOutlet weak var imgPalomaCheck: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        widthConstraint.constant = UIScreen.main.bounds.width - 60
        
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ckecTerminos))
//        self.checkSelectLocation.addGestureRecognizer(tapRecognizer)
        
        imgPalomaCheck.isHidden = true
        checkSelectLocation.borderWidth = 1
        checkSelectLocation.borderColor = .lightGray
        checkSelectLocation.backgroundColor = .clear
        
    }
    
    func configLabelLocation(itemLocation : ItemLocation){
        
        let strNameLocation = itemLocation.name.lowercased()
        location.text = strNameLocation.capitalized
        
        var strHrsLocation = itemLocation.pickUps.time.dropLast(3)
        let ampm = strHrsLocation < "12:00" ? "am" : "pm"
        if strHrsLocation[strHrsLocation.index(strHrsLocation.startIndex, offsetBy: 0)] == "0" {
            strHrsLocation.remove(at: strHrsLocation.startIndex)
        }
        hrs.text = "\(strHrsLocation) \(ampm)"
    }

    override var isSelected: Bool{
        didSet{
                if self.isSelected{
                    imgPalomaCheck.isHidden = false
                    checkSelectLocation.borderWidth = 0
                    checkSelectLocation.backgroundColor = .systemGreen
                }else{
                    imgPalomaCheck.isHidden = true
                    checkSelectLocation.borderWidth = 1
                    checkSelectLocation.borderColor = .lightGray
                    checkSelectLocation.backgroundColor = .clear
                    
                }
        }
    }

}
