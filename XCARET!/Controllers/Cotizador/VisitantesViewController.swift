//
//  VisitantesViewController.swift
//  XCARET!
//
//  Created by Yeik on 08/03/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit
import DropDown

class VisitantesViewController: UIViewController {
    
    weak var delegate: ManageCitizador?
    
    @IBOutlet weak var viewImgBack: UIView!
    @IBOutlet weak var viewContentInfo: UIView!
    @IBOutlet weak var viewContentSubTotal: UIView!
    @IBOutlet weak var constraintCarritoX: NSLayoutConstraint!
    @IBOutlet weak var contentCurrency: UIView!
    @IBOutlet weak var constraintDrop: NSLayoutConstraint!
    @IBOutlet weak var contentDrop: UIView!
    @IBOutlet weak var paxesLbl: UILabel!
    
    @IBOutlet weak var adultoLabel: UILabel!
    @IBOutlet weak var adultoLbl: UILabel!
    @IBOutlet weak var niniosLabel: UILabel!
    @IBOutlet weak var niniosLbl: UILabel!
    @IBOutlet weak var infantesLabel: UILabel!
    @IBOutlet weak var infantesLbl: UILabel!
    @IBOutlet weak var fechaLbl: UILabel!
    @IBOutlet weak var tuAhorroLbl: UILabel!
    @IBOutlet weak var ahorroLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var fijoAdultoLbl: UILabel!
    @IBOutlet weak var fijoNinioLbl: UILabel!
    @IBOutlet weak var btnMenosAdulto: UIButton!
    @IBOutlet weak var seleccionaPaxes: UILabel!
    @IBOutlet weak var freeLabel: UILabel!
    
    @IBOutlet weak var adultosViewContent: UIView!
    @IBOutlet weak var niniosViewContent: UIView!
    @IBOutlet weak var infantesViewContent: UIView!
    
    @IBOutlet weak var siguienteBtn: UIButton!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    var itemCarShoop = ItemCarShoop()
    var allotmentAvail = AllotmentAvail()
    
    let mesesES = Constants.CALENDAR.mesesES
    let mesesEN = Constants.CALENDAR.mesesEN
    let diasES = Constants.CALENDAR.diasES
    let diasEN = Constants.CALENDAR.diasEN
    let diasMes = Constants.CALENDAR.diasMes
    
    var adultos = 1
    var ninios = 0
    var infantes = 0
    
    var subtotal = 0.0
    var ahorro = 0.0
    
    
    let menu : DropDown = {
        let menu = DropDown()
        var imgCurrency = [String]()
        for itemCurrency in appDelegate.listCurrenct{
            
            menu.dataSource.append(itemCurrency.currency)
            imgCurrency.append("ic_\(itemCurrency.country ?? "ic_es")")
        }
        
        menu.cellNib = UINib(nibName: "DropDownTableViewCell", bundle: nil)
        menu.customCellConfiguration = {index, title, cell in
            guard let cell = cell as? DropDownTableViewCell else {
                return
            }
            cell.imgFlag.image = UIImage(named:  "Icons/\(imgCurrency[index])")
        }
        return menu
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.text = "lbl_cart_visitant_title".getNameLabel()
        seleccionaPaxes.text = "lbl_cart_visitant_subtitle".getNameLabel()
        tuAhorroLbl.text = "lbl_cart_save".getNameLabel()
        subTotalLbl.text = "lbl_cart_total".getNameLabel()
        siguienteBtn.setTitle("lbl_cart_next".getNameLabel(), for: .normal)
        adultoLabel.text = "lbl_ticket_adults".getNameLabel()
        niniosLabel.text = "\("lbl_ticket_childrens".getNameLabel())\(Constants.LANG.current == "es" ? "(5-11 años)" : "(5-11 years)")"
        infantesLabel.text = "\("lbl_ticket_infants".getNameLabel())\(Constants.LANG.current == "es" ? "(0-4 años)" : "(0-4 years)")"
        freeLabel.text = Constants.LANG.current == "es" ? "Gratis" : "Free"
        
        contentCurrency.isHidden = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        self.viewImgBack.addGestureRecognizer(tapRecognizer)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.changeCurrency))
        self.contentCurrency.addGestureRecognizer(gesture)
        
        self.constraintDrop.constant = 0
        
        menu.anchorView = contentDrop
        menu.backgroundColor = .white
        menu.selectRow(menu.dataSource.firstIndex(of: Constants.CURR.current) ?? 0)
        menu.selectionAction = { index, title in
            
            UserDefaults.standard.set(title, forKey: "UserCurrency")
            UserDefaults.standard.synchronize()
            Constants.CURR.current = title
            
            self.configNavCurrency()
            
        }
        
        self.paxesLbl.text = "\(self.adultos) \(Constants.LANG.current == "es" ? "Adulto" : "Adult")"
        self.fechaLbl.text = "\(Constants.LANG.current == "es" ? self.mesesES[self.itemCarShoop.itemDiaCalendario.mes].prefix(3) : self.mesesEN[self.itemCarShoop.itemDiaCalendario.mes].prefix(3)) \(String(describing: self.itemCarShoop.itemDiaCalendario.diaNumero!)), \(String(describing: self.itemCarShoop.itemDiaCalendario.year!))"
        
        self.fijoAdultoLbl.text = self.itemCarShoop.itemDiaCalendario.subtotalAdulto.currencyFormat()
        self.fijoNinioLbl.text = self.itemCarShoop.itemDiaCalendario.subtotalChildren.currencyFormat()
        
        self.adultos = self.itemCarShoop.itemVisitantes.adulto
        self.ninios = self.itemCarShoop.itemVisitantes.ninio
        self.infantes = self.itemCarShoop.itemVisitantes.infantes
        
        self.subtotal = ((Double(self.adultos) * self.itemCarShoop.itemDiaCalendario.subtotalAdulto) + (Double(self.ninios) * self.itemCarShoop.itemDiaCalendario.subtotalChildren))
        self.ahorro = ((Double(self.adultos) * self.itemCarShoop.itemDiaCalendario.ahorroAdulto) + (Double(self.ninios) * self.itemCarShoop.itemDiaCalendario.ahorroChildren))
        
        self.subtotalLbl.text = self.subtotal.currencyFormat()
        self.ahorroLbl.text = self.ahorro.currencyFormat()
        
        self.configLabelsPaxes()
        
    }
    
    
    
    
    @objc func changeCurrency(sender : UITapGestureRecognizer) {
        self.constraintDrop.constant = 45
        menu.show()
        self.constraintDrop.constant = 0
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
        self.delegate?.fechaVisitas()
    }
    
    @IBAction func goComplementos(_ sender: Any) {
        
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        let itemVisitantes = ItemVisitantes()

        itemVisitantes.adulto = self.adultos
        itemVisitantes.ninio = self.ninios
        itemVisitantes.infantes = self.infantes
        itemCarShoop.itemVisitantes = itemVisitantes
        let aux = itemCarShoop
        let aux2 = allotmentAvail
        print(aux)
        print(aux2)
        
        
//        if allotmentAvail.allotment {
            FirebaseBR.shared.getAllotment(itemCarShoop : itemCarShoop, completion: { (isSuccess, allotmentAvail) in
                if isSuccess {
                    if allotmentAvail.activityAvail.status.lowercased() == "open" {
                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                        self.dismiss(animated: true, completion: nil)
                        self.delegate?.complementos(itemVisitantes : itemVisitantes, productAllotment : true, rateKey : "")
                    }else{
                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                        let mainNC = AppStoryboard.AlertDefault.instance.instantiateViewController(withIdentifier: "AlertDefault") as! AlertDefaultViewController
                        mainNC.modalPresentationStyle = .overFullScreen
                        mainNC.modalTransitionStyle = .crossDissolve
//                        let textAlertDisponibe = "Por el momento no contamos con disponiblidad la disponibilidad requerida para ese día \n\nTe invitamos a seleccionar otro día"
                        mainNC.configAlert(type: .allotment, heightC: 290.0, texto: "lbl_cart_no_availability".getNameLabel())
                        self.present(mainNC, animated: true, completion: nil)
                    }
                }else{
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    let mainNC = AppStoryboard.AlertDefault.instance.instantiateViewController(withIdentifier: "AlertDefault") as! AlertDefaultViewController
                    mainNC.modalPresentationStyle = .overFullScreen
                    mainNC.modalTransitionStyle = .crossDissolve
                    mainNC.configAlert()
                    self.present(mainNC, animated: true, completion: nil)
                }
            })
//        }
//        else{
//            LoadingView.shared.hideActivityIndicator(uiView: self.view)
//            self.dismiss(animated: true, completion: nil)
//            self.delegate?.complementos(itemVisitantes : itemVisitantes, productAllotment : false, rateKey: "")
//        }
        
        
//        FirebaseBR.shared.getRateKeyAllotment(itemCarShoop : itemCarShoop, completion: { (isSuccess, allotment, rateKey, allowedCustomerConfigPax) in
//            if isSuccess && allotment == "allotment" {
//                print(rateKey)
//                FirebaseBR.shared.getReservedAllotment(itemCarShoop : self.itemCarShoop, rateKey : rateKey, completion: { (isSuccess, prodAllotment) in
//                    if isSuccess {
//                        if prodAllotment.status.lowercased() == "reserved" {
//                            LoadingView.shared.hideActivityIndicator(uiView: self.view)
//                            self.dismiss(animated: true, completion: nil)
//                            self.delegate?.complementos(itemVisitantes : itemVisitantes, productAllotment : true, rateKey : rateKey)
//                        }else{
//                            LoadingView.shared.hideActivityIndicator(uiView: self.view)
//                            let alert = UIAlertController(title: "Error", message: "No se pueden reservar los lugares", preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }else{
//                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
//                        let alert = UIAlertController(title: "Error", message: "Ocurrio un error inesperado, vuelva a intenralo mas tarde", preferredStyle: UIAlertController.Style.alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                })
//            }else if isSuccess && allotment == "noAllotment"{
//                LoadingView.shared.hideActivityIndicator(uiView: self.view)
//                self.dismiss(animated: true, completion: nil)
//                self.delegate?.complementos(itemVisitantes : itemVisitantes, productAllotment : false, rateKey: "")
//            }else{
//                LoadingView.shared.hideActivityIndicator(uiView: self.view)
//                let alert = UIAlertController(title: "Error", message: "Ocurrio un error inesperado, vuelva a intenralo mas tarde", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
//        })

    }
        
    override func viewWillAppear(_ animated: Bool) {
        
        self.constraintCarritoX.constant = UIDevice().getHeightCarrito()
        self.viewContentSubTotal.dropShadow(color: UIColor.lightGray, opacity: 0.5, offSet: CGSize(width: -2, height: -3), radius:3, scale: true, corner: 0, backgroundColor: UIColor.white)
        
        FirebaseBR.shared.getAllotment(itemCarShoop : itemCarShoop, completion: { (isSuccess, allotmentAvail) in
            if isSuccess  {
                
                self.adultosViewContent.isUserInteractionEnabled = allotmentAvail.allowedCustomerConfigPax.adults
                self.adultosViewContent.alpha = allotmentAvail.allowedCustomerConfigPax.adults ? 1.0 : 0.5
                self.niniosViewContent.isUserInteractionEnabled = allotmentAvail.allowedCustomerConfigPax.children
                self.niniosViewContent.alpha = allotmentAvail.allowedCustomerConfigPax.children ? 1.0 : 0.5
                self.infantesViewContent.isUserInteractionEnabled = allotmentAvail.allowedCustomerConfigPax.infants
                self.infantesViewContent.alpha = allotmentAvail.allowedCustomerConfigPax.infants ? 1.0 : 0.5
                
                self.allotmentAvail = allotmentAvail
                self.configLabelsPaxes()
            }
        })

    }
    
    func configNavCurrency(){
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.changeCurrency))
        self.contentCurrency.addGestureRecognizer(gesture)
        
    }
    
    
    
    @IBAction func adultosBtnMenos(_ sender: Any) {
        if adultos > 1 {
            adultos = adultos - 1
            if adultos == 0 {
                adultos = 1
            }
            configLabelsPaxes()
            subtotal = subtotal - itemCarShoop.itemDiaCalendario.subtotalAdulto
            ahorro = ahorro - itemCarShoop.itemDiaCalendario.ahorroAdulto
            self.subtotalLbl.text = subtotal.currencyFormat()
            self.ahorroLbl.text = ahorro.currencyFormat()
        }
    }
    
    @IBAction func adultoBtnMas(_ sender: Any) {
        if adultos < 25 && avail(){
            adultos = adultos + 1
            configLabelsPaxes()
            subtotal = subtotal + itemCarShoop.itemDiaCalendario.subtotalAdulto
            ahorro = ahorro + itemCarShoop.itemDiaCalendario.ahorroAdulto
            self.subtotalLbl.text = subtotal.currencyFormat()
            self.ahorroLbl.text = ahorro.currencyFormat()
        }
    }
    
    
    @IBAction func niniosBtnMenos(_ sender: Any) {
        if ninios > 0 {
            ninios = ninios - 1
            configLabelsPaxes()
            subtotal = subtotal - itemCarShoop.itemDiaCalendario.subtotalChildren
            ahorro = ahorro - itemCarShoop.itemDiaCalendario.ahorroChildren
            self.subtotalLbl.text = subtotal.currencyFormat()
            self.ahorroLbl.text = ahorro.currencyFormat()
        }
    }
    
    @IBAction func niniosBtnMas(_ sender: Any) {
        if ninios < 25 && avail(){
            ninios = ninios + 1
            configLabelsPaxes()
            subtotal = subtotal + itemCarShoop.itemDiaCalendario.subtotalChildren
            ahorro = ahorro + itemCarShoop.itemDiaCalendario.ahorroChildren
            self.subtotalLbl.text = subtotal.currencyFormat()
            self.ahorroLbl.text = ahorro.currencyFormat()
        }
    }
    
    @IBAction func infantesBtnMenos(_ sender: Any) {
        if infantes > 0 {
            infantes = infantes - 1
            configLabelsPaxes()
        }
    }
    
    @IBAction func infantesBtnMas(_ sender: Any) {
        if infantes < 1000 {
            infantes = infantes + 1
            configLabelsPaxes()
        }
    }
    
    func avail() -> Bool{
        if itemCarShoop.itemDiaCalendario.allotment.status {
            let totalLugares = itemCarShoop.itemDiaCalendario.allotment.avail
            let totalRequeridos = adultos + ninios
            if totalRequeridos >= totalLugares! {
                return false
            }else{
                return true
            }
        }else{
            return true
        }
    }
    
    func configLabelsPaxes(){
        
        adultoLbl.text = "\(adultos)"
        niniosLbl.text = "\(ninios)"
        infantesLbl.text = "\(infantes)"
        
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
        UIView.transition(with: self.view, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.paxesLbl.text = "\(labelpaxesAdultos)\(labelpaxesninios)\(labelpaxesInfantes)"
        })
        
    }
    
}
