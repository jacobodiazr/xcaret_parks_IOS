//
//  MesesSICollectionViewCell.swift
//  XCARET!
//
//  Created by YEiK on 17/05/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class MesesSICollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentMSI: UIView!
    @IBOutlet weak var titleMSI: UILabel!
    @IBOutlet weak var lineSelectMSIView: UIView!
    @IBOutlet weak var constraintLineSelectMSI: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configBtnMSI(itemBankInstallment : BankInstallment){
        var textMSI = itemBankInstallment.installmentName.rawValue
        textMSI = textMSI.replacingOccurrences(of: "MESES", with: "\(Constants.LANG.current == "es" ? "MSI" : "MSI")")
        textMSI = textMSI.replacingOccurrences(of: "SOLO PAGO", with: "\(Constants.LANG.current == "es" ? "PAGO" : "PAYMENT")")
        self.titleMSI.text = textMSI
        print(itemBankInstallment.installmentName)
    }
    
    override var isSelected: Bool{
        didSet{
                if self.isSelected{
                    self.contentMSI.backgroundColor = UIColor(red: 105/255, green: 159/255, blue: 224/255, alpha: 1.0)
                    self.contentMSI.borderWidth = 0
                    self.titleMSI.textColor = .white
                    self.lineSelectMSIView.backgroundColor = .white
                    constraintLineSelectMSI.constant = 60
                }else{
                    self.contentMSI.borderWidth = 1
                    self.contentMSI.borderColor = UIColor(red: 95/255, green: 137/255, blue: 178/255, alpha: 1.0)
                    self.contentMSI.backgroundColor = .white
                    self.titleMSI.textColor = UIColor(red: 95/255, green: 137/255, blue: 178/255, alpha: 1.0)
                    self.lineSelectMSIView.backgroundColor = UIColor(red: 95/255, green: 137/255, blue: 178/255, alpha: 1.0)
                    constraintLineSelectMSI.constant = 30
                }
            
        }
    }

}
