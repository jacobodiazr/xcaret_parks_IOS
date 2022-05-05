//
//  infoPriceFETableViewCell.swift
//  XCARET!
//
//  Created by YEiK on 26/01/22.
//  Copyright © 2022 Angelica Can. All rights reserved.
//

import UIKit

class infoPriceFETableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUSDAdulto: UILabel!
//    @IBOutlet weak var lblMXNAdulto: UILabel!
    @IBOutlet weak var lblUSDMenor: UILabel!
//    @IBOutlet weak var lblMXNMenor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configInfo(listPriceFE : ListPriceFE){
        switch listPriceFE.namePromotion.lowercased() {
        case "app":
            lblTitle.text = listPriceFE.title
            break
        default:
            lblTitle.text = listPriceFE.namePromotion.lowercased() == "inapam" ? "\(listPriceFE.title ?? "")\n\(listPriceFE.namePromotion ?? "")" : listPriceFE.title
        }
        //lblTitle.text = listPriceFE.namePromotion.lowercased() == "inapam" ? "\(listPriceFE.title ?? "")\n\(listPriceFE.namePromotion ?? "")" : listPriceFE.title
        lblUSDAdulto.text = (Double(listPriceFE.adultoPrice ?? "0.00") ?? 0.00) > 0.00 ? Double(listPriceFE.adultoPrice ?? "0.0")?.currencyFormat() : "N/A"
        lblUSDMenor.text = (Double(listPriceFE.menorPrice ?? "0.00") ?? 0.00) > 0.00 ? Double(listPriceFE.menorPrice ?? "0.0")?.currencyFormat() : "N/A"
    }
    
}
