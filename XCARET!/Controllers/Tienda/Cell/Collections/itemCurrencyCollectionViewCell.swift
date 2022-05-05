//
//  itemCurrencyCollectionViewCell.swift
//  XCARET!
//
//  Created by YEiK on 04/10/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class itemCurrencyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemCurrencyContent: UIView!
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    var itemCurrenciesData = ItemCurrencies()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemCurrencyContent.dropShadow(color: UIColor.lightGray, opacity: 0.5, offSet: CGSize(width: 0, height: 3), radius:3, scale: true, corner: 10, backgroundColor: UIColor.white)
    }
    
    func configCurrency(itemCurrencies : ItemCurrencies){
        itemCurrenciesData = itemCurrencies
        titleLbl.text = itemCurrencies.currency
        flagImg.image = UIImage(named: "Icons/flags/ic_\(itemCurrencies.flag ?? "Icons/flags/ic_es")")
    }

}
