//
//  itemOpcionesPagoTableViewCell.swift
//  XCARET!
//
//  Created by Hate on 01/09/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class itemOpcionesPagoTableViewCell: UITableViewCell {

//    @IBOutlet weak var viewContentDescuentos: UIView!
//    @IBOutlet weak var topConstraint: NSLayoutConstraint!
//    @IBOutlet weak var lblDescuentos: UILabel!
//    @IBOutlet weak var lblSubTitleDescuentos: UILabel!
    @IBOutlet weak var lblMeses: UILabel!
    @IBOutlet weak var lblSubtitle1: UILabel!
    @IBOutlet weak var lblSubtitle2: UILabel!
    @IBOutlet weak var lblMultiplesOpciones: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//        lblDescuentos.text = "lbl_discounts_on_your_purchase".getNameLabel()
//        lblSubTitleDescuentos.text = "lbl_months_without_interest_subtitle".getNameLabel()
        lblMeses.text = "lbl_months_without_interest".getNameLabel()
        lblSubtitle1.text = "lbl_months_without_interest_subtitle_one".getNameLabel()
        lblSubtitle2.text = "lbl_months_without_interest_subtitle_two".getNameLabel()
        lblMultiplesOpciones.text = "lbl_multiple_choices".getNameLabel()
    }
    
    func config(itemPrecios : ItemProdProm){
        print(itemPrecios)
//        self.viewContentDescuentos.isHidden = false
//        self.topConstraint.constant = 10
//        if itemPrecios.code_promotion == "Soy_Mexicano" {
//            self.topConstraint.constant = 0
//            self.viewContentDescuentos.isHidden = true
//            lblDescuentos.text = ""
//            lblSubTitleDescuentos.text = ""
//
//        }
    }

}
