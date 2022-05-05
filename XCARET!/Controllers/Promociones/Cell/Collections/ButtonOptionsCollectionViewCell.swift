//
//  ButtonOptionsCollectionViewCell.swift
//  XCARET!
//
//  Created by Hate on 31/08/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class ButtonOptionsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblItemMenu: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func config(listButtonOpciones: ItemsCatopcprom, count : Int){
        print(listButtonOpciones.name ?? "")
        lblItemMenu.text = listButtonOpciones.name
        lblItemMenu.font = .systemFont(ofSize: 16.0)
        viewContent.borderWidth = 0
    }
    
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected{
                viewContent.borderColor =  UIColor(red: 78/255, green: 117/255, blue: 163/255, alpha: 1.00)
                viewContent.borderWidth = 1
                lblItemMenu.font = .boldSystemFont(ofSize: 16.0)
            }else{
                lblItemMenu.font = .systemFont(ofSize: 16.0)
                viewContent.borderWidth = 0
            }
        }
    }
}
