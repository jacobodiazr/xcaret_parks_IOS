//
//  InfoCardCarShopTableViewCell.swift
//  XCARET!
//
//  Created by Yeik on 21/04/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class InfoCardCarShopTableViewCell: UITableViewCell {
    
    weak var delegateGoBookingInfo: GoBookingInfo?
    
    var adultos = 1
    var ninios = 0
    var infantes = 0
    
    let mesesES = Constants.CALENDAR.mesesES
    let mesesEN = Constants.CALENDAR.mesesEN
    let diasES = Constants.CALENDAR.diasES
    let diasEN = Constants.CALENDAR.diasEN
    let diasMes = Constants.CALENDAR.diasMes
    
    var itemProd = ProductsCarShop()
    var itemsCarShop = [ItemCarShoop]()

    @IBOutlet weak var fechaLbl: UILabel!
    @IBOutlet weak var alimentosLbl: UILabel!
    @IBOutlet weak var photoLbl: UILabel!
    @IBOutlet weak var paxesLbl: UILabel!
    @IBOutlet weak var transportacionLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var seguroIKELbl: UILabel!
//    @IBOutlet weak var constraintTrasporte: NSLayoutConstraint!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var heightHeaderConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoAllotmentLbl: UILabel!
    @IBOutlet weak var titleConstraintLbl: NSLayoutConstraint!
    @IBOutlet weak var imgLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imgWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentDataConstraint: NSLayoutConstraint!
    @IBOutlet weak var editBtnLbl: UIButton!
    @IBOutlet weak var diponibilidadLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var visitLbl: UILabel!
    @IBOutlet weak var photopassLbl: UILabel!
    @IBOutlet weak var transportacionLabel: UILabel!
    @IBOutlet weak var alimentosLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func editBtn(_ sender: Any) {
        delegateGoBookingInfo?.editItemInfo(IdItem : itemProd.key)
    }
    

    func configInfoCard(item : ProductsCarShop, itemCarShop : ItemCarShoop){
        
        editBtnLbl.setTitle( "lbl_cart_edit".getNameLabel(), for: .normal)
        diponibilidadLbl.text = "lbl_cart_no_availability".getNameLabel()
        dateLbl.text = "lbl_cart_date".getNameLabel()
        visitLbl.text = "lbl_cart_visitors".getNameLabel()
        alimentosLabel.text = "lbl_cart_food".getNameLabel()
//        photopassLbl.text = "lbl_cart_no_availability".getNameLabel()
        transportacionLabel.text = "lbl_cart_transportation".getNameLabel()
        
        itemProd = item
        infoAllotmentLbl.isHidden = true
        titleConstraintLbl.constant = 0
        imgLeftConstraint.constant = 0
        imgWidthConstraint.constant = 0
        img.isHidden = true
        heightHeaderConstraint.constant = 60
        contentDataConstraint.constant = 242
        if itemCarShop.itemDiaCalendario.allotmentAvail.activityAvail.status.lowercased() != "open" && itemCarShop.itemDiaCalendario.allotmentAvail.activityAvail.status.lowercased() != "" {
            infoAllotmentLbl.isHidden = false
            titleConstraintLbl.constant = -20
            imgLeftConstraint.constant = 15
            imgWidthConstraint.constant = 25
            img.isHidden = false
            heightHeaderConstraint.constant = 90
            contentDataConstraint.constant = 274
        }
        
        self.adultos = item.productVisitor.productAdult
        self.ninios = item.productVisitor.productChild
        self.infantes = item.productVisitor.productInfant
        
        if item.availabilityStatus {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let dateFormatterPrint = DateFormatter()
            let locat = Constants.LANG.current == "es" ? "es_MX" : "en_US"
            dateFormatterPrint.locale = Locale(identifier: locat)
            dateFormatterPrint.dateFormat = "MMM d, yyyy"
            
            let dateItem = dateFormatterGet.date(from: item.productDate)
            self.fechaLbl.textColor = UIColor(red: 95/255, green: 137/255, blue: 178/255, alpha: 1.0)
            self.fechaLbl.text = dateFormatterPrint.string(from: dateItem ?? Date()).capitalized
        }else {
            self.fechaLbl.textColor = .red
            self.fechaLbl.text = "Expirado"
        }
        
        self.nameLbl.text = item.productName.capitalized
        
        alimentosLbl.text = item.productFood ? "lbl_add_plus_included".getNameLabel() : "lbl_add_plus_not_included".getNameLabel()
        photoLbl.text = item.productPhotopass ? "lbl_add_plus_included".getNameLabel() : "lbl_add_plus_not_included".getNameLabel()
        transportacionLbl.text = item.productTransport ? "lbl_add_plus_included".getNameLabel() : "lbl_add_plus_not_included".getNameLabel()
//        constraintTrasporte.constant = -8
        transportacionLbl.textColor = UIColor(red: 95/255, green: 137/255, blue: 178/255, alpha: 1.0)
        if item.productTransport {
            if item.productApiRequest.transportCarShop.geographicName != ""{
                transportacionLbl.text = String(item.productApiRequest.transportCarShop.geographicName.capitalized)
                var horaLocation = item.productApiRequest.transportCarShop.timePickup.prefix(5)
                let amPm = horaLocation >= "12:00" ? "pm" : "am"
                let auxpre = item.productApiRequest.transportCarShop.timePickup.prefix(1)
                print(auxpre)
                if item.productApiRequest.transportCarShop.timePickup.prefix(1) == "0"{
                    horaLocation.remove(at: horaLocation.startIndex)
                }
                locationLbl.text = "\(String(item.productApiRequest.transportCarShop.nameHotel.capitalized)) (\(String(horaLocation)) \(amPm))"
            }else{
                transportacionLbl.textColor = .red
                transportacionLbl.text = "Necesario para su compra"
            }
            
        }
        
        configLabelsPaxes()
    }
    
    func configLabelsPaxes(){
        
//        let labelpaxesAdultos = adultos > 0 ? "\(adultos) \("Adultos")" : ""
//        var labelpaxesninios = ""
//        var labelpaxesInfantes = ""
//
//        if (infantes > 0 && ninios > 0) || (adultos > 0 && infantes > 0){
//            labelpaxesInfantes = " - \(infantes) \("Infantes")"
//        }else if infantes > 0 {
//            labelpaxesInfantes = "\(infantes) \("Infantes")"
//        }
//
//        if ninios > 0 && adultos > 0 {
//            labelpaxesninios = " - \(ninios) \("Niños")"
//        }else if ninios > 0 {
//            labelpaxesninios = "\(ninios) \("Niños")"
//        }
//        paxesLbl.text = "\(labelpaxesAdultos)\(labelpaxesninios)\(labelpaxesInfantes)"
        
        
        let labelpaxesAdultos = adultos > 1 ? "\(adultos) \(Constants.LANG.current == "es" ? "Adultos" : "Adults")" : "\(adultos) \(Constants.LANG.current == "es" ? "Adulto" : "Adult")"
        var labelpaxesninios = ""
        var labelpaxesInfantes = ""
        
        if (infantes > 0 && ninios > 0) || (adultos > 0 && infantes > 0){
            labelpaxesInfantes = " - \(infantes) \(Constants.LANG.current == "es" ? "Infante" : "Infant")"
            if infantes > 1 {
                labelpaxesInfantes = " - \(infantes) \(Constants.LANG.current == "es" ? "Infantes" : "Infants")"
            }
        }else if infantes > 1 {
            labelpaxesInfantes = "\(infantes) \(Constants.LANG.current == "es" ? "Infantes" : "Infants")"
        }
        
        if ninios > 0 && adultos > 0 {
            labelpaxesninios = " - \(ninios) \(Constants.LANG.current == "es" ? "Niño" : "Child")"
            if ninios > 1 {
                labelpaxesninios = " - \(ninios) \(Constants.LANG.current == "es" ? "Niños" : "Children")"
            }
        }else if ninios > 1 {
            labelpaxesninios = "\(ninios) \(Constants.LANG.current == "es" ? "Niños" : "Children")"
        }
//        UIView.transition(with: view, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.paxesLbl.text = "\(labelpaxesAdultos)\(labelpaxesninios)\(labelpaxesInfantes)"
//        })
    }
    
}
