//
//  ItemTProductTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 20/01/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit


class ItemTProductTableViewCell: UITableViewCell {
    weak var delegateComp : GoDetailComponent?
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblNameProduct: UILabel!
    @IBOutlet weak var lblCountAdults: UILabel!
    @IBOutlet weak var lblNoAdults: UILabel!
    @IBOutlet weak var lblCountChilds: UILabel!
    @IBOutlet weak var lblNoChilds: UILabel!
    @IBOutlet weak var lblCountInfants: UILabel!
    @IBOutlet weak var lblNoInfants: UILabel!
    @IBOutlet weak var btnDetComponent: ButtonDetComponent!
    @IBOutlet weak var viewLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblNoAdults.text = "lbl_ticket_adults".getNameLabel()//"lblAdults".localized()
        self.lblNoChilds.text = "lbl_ticket_childrens".getNameLabel()//"lblChildrens".localized()
        self.lblNoInfants.text = "lbl_ticket_infants".getNameLabel()//"lblInfants".localized()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func btnGoDetComponent(_ sender: ButtonDetComponent) {
        delegateComp?.goComponent(sender: sender)
    }
    
    func setInfoView(itemComponent: ItemComponent){
        self.lblCountAdults.text = "\(itemComponent.adults)"
        self.lblCountChilds.text = "\(itemComponent.childrens)"
        self.lblCountInfants.text = "\(itemComponent.infants)"
        self.lblDay.text = Tools.shared.castDayTicket(dateStr: itemComponent.visitDate)
        self.lblDate.text = Tools.shared.castMonthYearTicket(dateStr: itemComponent.visitDate)
        self.lblNameProduct.text = itemComponent.productName
        self.btnDetComponent.itemComponent = itemComponent
        self.btnDetComponent.isHidden = !itemComponent.detailComponent
    }
    
    func setInfoView(itemProduct: ItemProduct){
        self.lblCountAdults.text = "\(itemProduct.adults)"
        self.lblCountChilds.text = "\(itemProduct.childrens)"
        self.lblCountInfants.text = "\(itemProduct.infants)"
        self.lblDay.text = Tools.shared.castDayTicket(dateStr: itemProduct.visitDate)
        self.lblDate.text = Tools.shared.castMonthYearTicket(dateStr: itemProduct.visitDate)
        self.lblNameProduct.text = itemProduct.productName
        self.btnDetComponent.itemProduct = itemProduct
        self.btnDetComponent.isHidden = !itemProduct.detailComponent
    }
}
