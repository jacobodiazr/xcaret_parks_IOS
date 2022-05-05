//
//  PopUpHomeViewController.swift
//  XCARET!
//
//  Created by Hate on 31/08/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class PopUpHomeViewController: UIViewController {
    var typePopUP = ""
    var typePromotion = ""
    var itemsPreciosSelect : [ItemProdProm] = [ItemProdProm]()
    var itemProdProm : [ItemProdProm] = [ItemProdProm]()
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.widthConstraint.constant = UIScreen.main.bounds.width * 0.85
        self.heghtConstraint.constant = UIScreen.main.bounds.height * 0.85
        config()
        
    }
    
    func config(){
        print(typePopUP)
        if typePopUP == "tyc"{
            self.lblTitle.text = "lbl_terms_and_conditions".getNameLabel()
            let items = itemsPreciosSelect
            let aux = appDelegate.listlangsPromotions.filter({$0.uid == Constants.LANG.current})
            let item = appDelegate.listlangsPromotions.filter({$0.uid == Constants.LANG.current && $0.prod_code == items.first?.code_promotion})
            lblDescription.text = item.first?.term_conditions
            //            print(items)
        }else{
            self.lblTitle.text = "lbl_what_your_ticket_includes".getNameLabel()
            let itemProdProm = self.itemProdProm
            let itemPark = appDelegate.listAllParks.filter({$0.code.lowercased() == itemProdProm.first?.code_park})
            lblDescription.text = "\n\(itemPark.first!.detail.p_schelude!) \n \n\(itemPark.first!.detail.include!) \n \n \("lbl_recomendations".getNameLabel().uppercased()): \n\(itemPark.first!.detail.recomendations!)"
            print(itemProdProm)
        }
        
        
    }
    
    @IBAction func btnClose(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    
}
