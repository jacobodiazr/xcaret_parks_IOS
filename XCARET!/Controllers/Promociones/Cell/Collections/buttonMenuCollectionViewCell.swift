//
//  buttonMenuCollectionViewCell.swift
//  XCARET!
//
//  Created by Hate on 20/08/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class buttonMenuCollectionViewCell: UICollectionViewCell {
    
    var tresParques = false
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblItemMenu: UILabel!
    @IBOutlet weak var constraintWidht: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if tresParques {
            self.constraintWidht.constant = 80
        }else{
            self.constraintWidht.constant = 117
        }
        
    }
    
    func configureCell(listPrecios: ItemPrecios){
        let txtMenu = listPrecios.uid.replacingOccurrences(of: "_", with: " ")
        lblItemMenu.text = txtMenu
        
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected{
                viewContent.backgroundColor =  UIColor(red: 78/255, green: 117/255, blue: 163/255, alpha: 1.00)
                lblItemMenu.font = .boldSystemFont(ofSize: 16.0)
                lblItemMenu.textColor = .white
            }else{
                viewContent.backgroundColor = .clear
                lblItemMenu.font = .systemFont(ofSize: 16.0)
                lblItemMenu.textColor = UIColor(red: 78/255, green: 117/255, blue: 163/255, alpha: 1.00)
                
            }
        }
    }

}

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 0
    @IBInspectable var rightInset: CGFloat = 0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
