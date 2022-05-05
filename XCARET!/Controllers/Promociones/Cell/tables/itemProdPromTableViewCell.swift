//
//  itemProdPromTableViewCell.swift
//  XCARET!
//
//  Created by Hate on 20/08/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit

class itemProdPromTableViewCell: UITableViewCell {
    weak var delegateProm : ManageUpdatePromDelegate?
    weak var delegateBuyProm : ManageBuyPromDelegate?
    weak var delegatePreBuyProm : ManageBuyPromDelegate?
    @IBOutlet weak var lblNamePark: UILabel!
    @IBOutlet weak var lblcurrency: UILabel!
    @IBOutlet weak var lblPrince: UILabel!
    @IBOutlet weak var lblIncluye: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblDescuento: UILabel!
    @IBOutlet weak var lblCurrencyDescuento: UILabel!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var ConstraintWImg: NSLayoutConstraint!
    @IBOutlet weak var ConstraintHImg: NSLayoutConstraint!
    @IBOutlet weak var buyPromButton: UIButton!
    @IBOutlet weak var incluyeConstraintTop: NSLayoutConstraint!
    
    var sendProm : [ItemProdProm] = [ItemProdProm]()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        lblIncluye.isUserInteractionEnabled = true
        lblIncluye.addGestureRecognizer(tap)
        lblIncluye.text = "lbl_what_your_ticket_includes".getNameLabel()
        btnBuy.setTitle("lbl_add_to_cart_shop".getNameLabel(), for: .normal)
        
        ConstraintWImg.constant = (UIScreen.main.bounds.width / 2) - 30
        ConstraintHImg.constant = (UIScreen.main.bounds.width / 2) - 30
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        delegateProm!.sendProm(itemProm: self.sendProm)
    }
    
    @IBAction func buttonBuyProm(_ sender: Any) {
        
        if sendProm.first?.code_product != "" && sendProm.first?.descripcionEs != "" {
            AnalyticsBR.shared.saveEventListShop(id: (sendProm.first?.code_product)!, name: (sendProm.first?.descripcionEs.lowercased().capitalized)!)
        }
        
        if appDelegate.optionsHome {
            AnalyticsBR.shared.saveEventContentsTypePromotions(itemName: sendProm.first?.code_park.uppercased() ?? "", promotionID: sendProm.first?.code_landing ?? "", contentType: "HM_\(TagsContentAnalytics.Navigation.rawValue)")
        }else{
            AnalyticsBR.shared.saveEventContentsTypePromotions(itemName: sendProm.first?.code_park.uppercased() ?? "", promotionID: sendProm.first?.code_landing ?? "", contentType: "\(sendProm.first?.code_park.uppercased() ?? "")_\(TagsContentAnalytics.Navigation.rawValue)")
        }
        
        if sendProm.first?.product_childs != nil && self.sendProm.first?.product_childs.count ?? 0 > 1 {
            delegateBuyProm!.addCar(itemProm: self.sendProm)
        }else{
            delegatePreBuyProm!.sendPreBuyProm(itemProm: self.sendProm)
        }
        
    }
    
    
    @IBAction func buttonAddCar(_ sender: Any) {
        delegateBuyProm!.addCar(itemProm: self.sendProm)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(itemPrecios : ItemProdProm){
        
        self.sendProm = [itemPrecios]
        
//        if itemPrecios.product_childs != nil && itemPrecios.product_childs.count > 1 {
            buyPromButton.isHidden = true
//        }else{
//            buyPromButton.isHidden = false
//        }
        
        let dataCurrency = appDelegate.listCurrencies.filter({ $0.currency == Constants.CURR.current }).first
        
        self.lblNamePark.text = Constants.LANG.current == "es" ? itemPrecios.descripcionEs.capitalized : itemPrecios.descripcionEn.capitalized
        self.lblcurrency.text = Constants.CURR.current
        self.lblCurrencyDescuento.text = ""
        
        let price = itemPrecios.adulto.filter({$0.key == Constants.CURR.current})
        if price.count > 0{
        if (price.first?.precioDescuento)! > 0.0 && price.first?.precioDescuento != price.first?.precio{
            
            self.lblPrince.text = price.first!.precioDescuento.currencyFormatWithoutLetters()
            self.lblDescuento.text = price.first!.precio.currencyFormatWithoutLetters()
            
            let attributeDescuento: NSMutableAttributedString =  NSMutableAttributedString(string: self.lblDescuento.text ?? "")
            attributeDescuento.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeDescuento.length))
            
            self.lblCurrencyDescuento.text = Constants.CURR.current
            let attriCurrencyDescuento: NSMutableAttributedString =  NSMutableAttributedString(string: self.lblCurrencyDescuento.text ?? "")
            attriCurrencyDescuento.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attriCurrencyDescuento.length))
            
            lblDescuento.attributedText = attributeDescuento
            lblCurrencyDescuento.attributedText = attriCurrencyDescuento;
            
            incluyeConstraintTop.constant = 5
            
        }else{
            self.lblPrince.text = price.first!.precio.currencyFormatWithoutLetters()
            self.lblDescuento.text = ""
            
            if price.first?.precio == 0.0 {
                self.lblPrince.text = ""
                self.lblcurrency.text = ""
            }

            incluyeConstraintTop.constant = 10
        }
        }
        
        if itemPrecios.code_promotion == "INAPAM"{
            var imagen = UIImage(named: "Promociones/imgPromociones/INAPAM/\(itemPrecios.code_park!)_\(itemPrecios.type_prod!)")
            if imagen == nil{
                imagen = UIImage(named: "Promociones/images/parques/default")
            }
            self.img.image = imagen
        }else{
            var imagen = UIImage(named: "Promociones/imgPromociones/\(itemPrecios.code_park!)_\(itemPrecios.type_prod!)")
            if imagen == nil{
                imagen = UIImage(named: "Promociones/images/parques/default")
            }
            self.img.image = imagen
        }
        
        
        
        print(itemPrecios)
    }
    
}
