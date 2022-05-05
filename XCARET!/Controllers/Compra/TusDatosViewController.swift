//
//  TusDatosViewController.swift
//  XCARET!
//
//  Created by Yeik on 01/04/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class TusDatosViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var viewImgBack: UIView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var title18aniosLbl: UILabel!
    @IBOutlet weak var titleDataVisitorLbl: UILabel!
    @IBOutlet weak var titleSameBuyerLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var titleUserView: UIView!
    @IBOutlet weak var paisUserView: UIView!
    @IBOutlet weak var estadoUserView: UIView!
    @IBOutlet weak var titleUserViewVisitante: UIView!
    @IBOutlet weak var paisUserViewVisitante: UIView!
    @IBOutlet weak var estadoUserViewVisitante: UIView!
    
    
    @IBOutlet weak var mayor18Switch: UISwitch!
    @IBOutlet weak var mismosDatosSwitch: UISwitch!
    @IBOutlet weak var DataVisitantesView: UIView!
    
    @IBOutlet weak var titleValueTextF: UITextField!
    @IBOutlet weak var apellidoValueTextF: UITextField!
    @IBOutlet weak var nameValueTextF: UITextField!
    @IBOutlet weak var emailValueTextF: UITextField!
    @IBOutlet weak var paisValueTextF: UITextField!
    @IBOutlet weak var estadoValueTextF: UITextField!
    @IBOutlet weak var ciudadvalueTextF: UITextField!
    @IBOutlet weak var cpValueTextF: UITextField!
    @IBOutlet weak var telefonoValueTextF: UITextField!
    @IBOutlet weak var ladaValueTextF: UITextField!
    
    @IBOutlet weak var titleValueTextFVisitante: UITextField!
    @IBOutlet weak var nameValueTextFVisitante: UITextField!
    @IBOutlet weak var apellidoValueTextFVisita: UITextField!
    @IBOutlet weak var emailValueTextFVisitante: UITextField!
    @IBOutlet weak var paisValueTextFVisitante: UITextField!
    @IBOutlet weak var estadoValueTextFVisitante: UITextField!
    @IBOutlet weak var ciudadvalueTextFVisitante: UITextField!
    @IBOutlet weak var cpValueTextFVisitante: UITextField!
    @IBOutlet weak var telefonoValueTextFVisitante: UITextField!
    @IBOutlet weak var ladaValueTextFVisitante: UITextField!
    
    var mayor18Años = false
    var mismosDatos = false
    
    var idDataPopUp = ""
    
    var buyAll = false
    
    var itemCarShoop = [ItemCarShoop]()
    var buyItem: ItemCarshop = ItemCarshop()
    var allItems : ItemListCarshop = ItemListCarshop()
    var itemCompradorAllItems = ItemCarShoop()
    
    var itemSelectDataTitleUser = ItemLangTitle()
    var itemSelectDataTitleVisitante = ItemLangTitle()
    var itemSelectDataPaisUser = ItemLangCountry()
    var itemSelectDataPaisVisitante = ItemLangCountry()
    var itemSelectDataStatesUser = ItemStates()
    var itemSelectDataStatesVisitante = ItemStates()
    var itemSelectdataLadaUser = ItemPhoneCode()
    var itemSelectdataLadaVisitante = ItemPhoneCode()
    
    var itemsDataStates = [ItemStates]()
    var textFields: [UITextField]!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let aux = itemCarShoop
//        let aux2 = allItems
//        let aux3 = buyAll
        
        //TEST
        if appDelegate.enviromentProduction == TypeEnviroment.develop {
            nameValueTextF.text = "TEST"
            apellidoValueTextF.text = "APP"
            emailValueTextF.text = "test-accept@xcaret.com"
            ciudadvalueTextF.text = "Ciudad de México"
            cpValueTextF.text = "02780"
            telefonoValueTextF.text = "5539147005"
            ladaValueTextF.text = "+ 52"
        }
//        nameValueTextF.text = "TEST"
//        apellidoValueTextF.text = "APP"
//        emailValueTextF.text = "test-accept@xcaret.com"
//        ciudadvalueTextF.text = "Ciudad de México"
//        cpValueTextF.text = "02780"
//        telefonoValueTextF.text = "5539147005"
//        ladaValueTextF.text = "+ 52"
        
        titleLbl.text = "lbl_user_info_title".getNameLabel()
        title18aniosLbl.text = "lbl_user_info_age".getNameLabel()
        titleDataVisitorLbl.text = "lbl_user_info_visitor_title".getNameLabel()
        titleSameBuyerLbl.text = "lbl_user_info_visitor_subtitle".getNameLabel()
        nextBtn.setTitle("lbl_cart_next".getNameLabel(), for: .normal)
        
        let colorLabel = UIColor(red: 78/255, green: 117/255, blue: 163/255, alpha: 1.0)
        titleValueTextF.textColor = colorLabel
        nameValueTextF.textColor = colorLabel
        apellidoValueTextF.textColor = colorLabel
        emailValueTextF.textColor = colorLabel
        paisValueTextF.textColor = colorLabel
        estadoValueTextF.textColor = colorLabel
        ciudadvalueTextF.textColor = colorLabel
        cpValueTextF.textColor = colorLabel
        telefonoValueTextF.textColor = colorLabel
        ladaValueTextF.textColor = colorLabel
        
        titleValueTextFVisitante.textColor = colorLabel
        nameValueTextFVisitante.textColor = colorLabel
        apellidoValueTextFVisita.textColor = colorLabel
        emailValueTextFVisitante.textColor = colorLabel
        paisValueTextFVisitante.textColor = colorLabel
        estadoValueTextFVisitante.textColor = colorLabel
        ciudadvalueTextFVisitante.textColor = colorLabel
        cpValueTextFVisitante.textColor = colorLabel
        telefonoValueTextFVisitante.textColor = colorLabel
        ladaValueTextFVisitante.textColor = colorLabel
        
        
        let colorLabelPlaceholder = UIColor(red: 122/255, green: 139/255, blue: 159/255, alpha: 0.8)
        titleValueTextF.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_title".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        nameValueTextF.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_name".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        apellidoValueTextF.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_last_name".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        emailValueTextF.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_email".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        paisValueTextF.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_country".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        estadoValueTextF.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_state".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        ciudadvalueTextF.attributedPlaceholder = NSAttributedString(string: "lbl_client_city".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        cpValueTextF.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_cp".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        telefonoValueTextF.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_phone_number".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        ladaValueTextF.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_long_distance_code".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        
        titleValueTextFVisitante.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_title".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        nameValueTextFVisitante.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_name".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        apellidoValueTextFVisita.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_last_name".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        emailValueTextFVisitante.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_email".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        paisValueTextFVisitante.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_country".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        estadoValueTextFVisitante.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_state".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        ciudadvalueTextFVisitante.attributedPlaceholder = NSAttributedString(string: "lbl_client_city".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        cpValueTextFVisitante.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_cp".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        telefonoValueTextFVisitante.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_phone_number".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        ladaValueTextFVisitante.attributedPlaceholder = NSAttributedString(string: "lbl_client_data_long_distance_code".getNameLabel(), attributes: [NSAttributedString.Key.foregroundColor: colorLabelPlaceholder])
        
        textFields = [titleValueTextFVisitante, nameValueTextFVisitante, emailValueTextFVisitante, paisValueTextFVisitante, estadoValueTextFVisitante, ciudadvalueTextFVisitante, cpValueTextFVisitante, telefonoValueTextFVisitante, ladaValueTextFVisitante]
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        self.viewImgBack.addGestureRecognizer(tapRecognizer)
        
        let gestureTitleUser = UITapGestureRecognizer(target: self, action: #selector(titleUser))
        self.titleUserView.addGestureRecognizer(gestureTitleUser)
        
        let gesturePaisUser = UITapGestureRecognizer(target: self, action: #selector(paisUser))
        self.paisUserView.addGestureRecognizer(gesturePaisUser)
        
        let gestureEstadoUser = UITapGestureRecognizer(target: self, action: #selector(estadoUser))
        self.estadoUserView.addGestureRecognizer(gestureEstadoUser)
        
        
        let gesturetitleUserViewVisitante = UITapGestureRecognizer(target: self, action: #selector(titleUserVisitante))
        self.titleUserViewVisitante.addGestureRecognizer(gesturetitleUserViewVisitante)
        
        let gesturepaisUserViewVisitante = UITapGestureRecognizer(target: self, action: #selector(paisUserVisitante))
        self.paisUserViewVisitante.addGestureRecognizer(gesturepaisUserViewVisitante)
        
        let gestureestadoUserViewVisitante = UITapGestureRecognizer(target: self, action: #selector(estadoUserVisitante))
        self.estadoUserViewVisitante.addGestureRecognizer(gestureestadoUserViewVisitante)
        
        ladaValueTextF.isUserInteractionEnabled = false
        mayor18Switch.addTarget(self, action: #selector(mayor18SwitchChanged), for: UIControl.Event.valueChanged)
        mismosDatosSwitch.addTarget(self, action: #selector(mismosDatosSwitchChanged), for: UIControl.Event.valueChanged)
        
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
                    
    }
    
    @objc func keyboardWillchange(notification: Notification){
        var moveScrollY : CGFloat = 0
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            moveScrollY = self.setScrollViewPosition(keyboardRect: keyboardRect.height)
        }
        
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.view.frame.origin.y = moveScrollY
        })
        
    }
    
    func setScrollViewPosition(keyboardRect: CGFloat) -> CGFloat{
        var moveScroll: CGFloat = 0
        //Calculamos la altura de la pantalla
        let screenSize : CGRect = UIScreen.main.bounds
        let screenHeight : CGFloat = screenSize.height
        
        for textField in textFields {
            
            if textField.isFirstResponder {
                print(textField.placeholder!)
                
                // Calculamos la 'Y' máxima del UITextField
                let yPositionField = textField.frame.origin.y
                let heightField = textField.frame.size.height
                let yPositionMaxField = yPositionField + heightField
                
                // Calculamos la 'Y' máxima del View que no queda oculta por el teclado
                let Ymax = screenHeight - keyboardRect
                
                // Comprobamos si nuestra 'Y' máxima del UITextField es superior a la Ymax
//                if yPositionMaxField > Ymax{
                    moveScroll = -keyboardRect
//                }
            }
        }
        
        return moveScroll
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        appDelegate.listItemListCarshopReservation.removeAll()
        if segue.identifier == "goInfoFormBuy" {
            if let vc = segue.destination as? InfoFormBuyViewController{
                vc.idDataPopUp = self.idDataPopUp
                vc.delegateDataFormBuy = self
                vc.itemsDataStates = itemsDataStates
            }
        }
        
        if segue.identifier == "goDatosTarjeta" {
            if let vc = segue.destination as? DatosTarjetaViewController{
                vc.buyItem = self.buyItem
                vc.itemCarShoop = self.itemCarShoop//self.itemCarShoop
                vc.buyAll = buyAll
                vc.allItems = allItems
                vc.delegateFinalBuyStepGoTicket = self
                vc.itemCompradorAllItems = itemCompradorAllItems
            }
        }
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func titleUser(){
        idDataPopUp = "titleUser"
        performSegue(withIdentifier: "goInfoFormBuy", sender: nil)
    }
    
    @objc func paisUser(){
        idDataPopUp = "paisUser"
        performSegue(withIdentifier: "goInfoFormBuy", sender: nil)
    }
    
    @objc func estadoUser(){
        if (paisValueTextF.text?.isEmpty)! {
            UpAlertView(type: .warning, message: "Agrega un pais").show {
                print("Falta Información")
            }
        }else{
            idDataPopUp = "estadoUser"
            performSegue(withIdentifier: "goInfoFormBuy", sender: nil)
        }
    }
    
    @objc func titleUserVisitante(){
        idDataPopUp = "titleUserVisitante"
        performSegue(withIdentifier: "goInfoFormBuy", sender: nil)
    }
    
    @objc func paisUserVisitante(){
        idDataPopUp = "paisUserVisitante"
        performSegue(withIdentifier: "goInfoFormBuy", sender: nil)
    }
    
    @objc func estadoUserVisitante(){
        if (paisValueTextFVisitante.text?.isEmpty)!{
            UpAlertView(type: .warning, message: "Agrega un pais").show {
                print("Falta Información")
            }
        }else{
            idDataPopUp = "estadoUserVisitante"
            performSegue(withIdentifier: "goInfoFormBuy", sender: nil)
        }
    }
    
    @IBAction func goCredirCard(_ sender: Any) {
        if validarDatos() {
            print("formCorrecto")
            let itemComprador = ItemCarShoop()
            let itemVisitanteComprador = ItemCarShoop()
            
            itemComprador.itemComprador.titleValueTextF = itemSelectDataTitleUser
            itemComprador.itemComprador.nameValueTextF = nameValueTextF.text
            itemComprador.itemComprador.apellidoValueTextF = apellidoValueTextF.text
            itemComprador.itemComprador.emailValueTextF = emailValueTextF.text
            itemComprador.itemComprador.paisValueTextF = itemSelectDataPaisUser
            itemComprador.itemComprador.estadoValueTextF = itemSelectDataStatesUser
            itemComprador.itemComprador.ciudadvalueTextF = ciudadvalueTextF.text
            itemComprador.itemComprador.cpValueTextF = cpValueTextF.text
            itemComprador.itemComprador.ladaValuetextF = itemSelectdataLadaUser
            itemComprador.itemComprador.telefonoValueTextF = telefonoValueTextF.text
            if buyAll {
                itemCompradorAllItems.itemComprador = itemComprador.itemComprador
            }else{
                itemCarShoop.first?.itemComprador = itemComprador.itemComprador
            }
            if mismosDatos {
                if buyAll {
                    itemCompradorAllItems.itemVisitanteCompra = itemCompradorAllItems.itemComprador//itemCarShoop.first?.itemComprador ?? ItemUserShop()
                }else{
                    itemCarShoop.first?.itemVisitanteCompra = itemCarShoop.first?.itemComprador ?? ItemUserShop()
                }
            }else{
                itemVisitanteComprador.itemVisitanteCompra.titleValueTextF = itemSelectDataTitleVisitante
                itemVisitanteComprador.itemVisitanteCompra.nameValueTextF = nameValueTextFVisitante.text
                itemVisitanteComprador.itemVisitanteCompra.apellidoValueTextF = apellidoValueTextFVisita.text
                itemVisitanteComprador.itemVisitanteCompra.emailValueTextF = emailValueTextFVisitante.text
                itemVisitanteComprador.itemVisitanteCompra.paisValueTextF = itemSelectDataPaisVisitante
                itemVisitanteComprador.itemVisitanteCompra.estadoValueTextF = itemSelectDataStatesVisitante
                itemVisitanteComprador.itemVisitanteCompra.ciudadvalueTextF = ciudadvalueTextFVisitante.text
                itemVisitanteComprador.itemVisitanteCompra.cpValueTextF = cpValueTextFVisitante.text
                itemVisitanteComprador.itemVisitanteCompra.ladaValuetextF = itemSelectdataLadaVisitante
                itemVisitanteComprador.itemVisitanteCompra.telefonoValueTextF = telefonoValueTextFVisitante.text
                
                if buyAll {
                    itemCompradorAllItems.itemVisitanteCompra = itemVisitanteComprador.itemVisitanteCompra
                }else{
                    itemCarShoop.first?.itemVisitanteCompra = itemVisitanteComprador.itemVisitanteCompra
                }
            }
            
            performSegue(withIdentifier: "goDatosTarjeta", sender: nil)
            
        }
        
        
    }
    
    
    
    @objc func mayor18SwitchChanged(mySwitch: UISwitch) {
        mayor18Años = mySwitch.isOn
    }
    
    @objc func mismosDatosSwitchChanged(mySwitch: UISwitch) {
        mismosDatos = mySwitch.isOn
        if mismosDatos {
            DataVisitantesView.isHidden = true
            constraintHeight.constant = 100
            view.endEditing(true)
        }else{
            DataVisitantesView.isHidden = false
            constraintHeight.constant = 410
        }
       
    }
    
    func validarDatos() -> Bool{
        var isValidForm = true
        var isValidFormVisitante = true
        
        var message : String = ""
        
        if (self.titleValueTextF.text?.isEmpty)! {
            message = "Ingrese Sr, Sra..."
            isValidForm = false
        }else if (self.nameValueTextF.text?.isEmpty)!{
            isValidForm = false
            message = "txt_alert_name".getNameLabel()
        }else if (self.apellidoValueTextF.text?.isEmpty)!{
            isValidForm = false
            message = "Apellido"
        }else if !emailValueTextF.isValidEmailAddress() {
            isValidForm = false
            message = "txt_alert_email".getNameLabel()
        }else if (paisValueTextF.text?.isEmpty)!{
            isValidForm = false
            message = "Ingrese Pais"//.getNameLabel()
        }else if (estadoValueTextF.text?.isEmpty)!{
            isValidForm = false
            message = "Ingrese Estado"//.getNameLabel()
        }else if (ciudadvalueTextF.text?.isEmpty)!{
            isValidForm = false
            message = "Ingrese Ciudad"//.getNameLabel()
        }else if (cpValueTextF.text?.isEmpty)!{
            isValidForm = false
            message = " Ingrese CP"//.getNameLabel()
        }else if(telefonoValueTextF.text?.isEmpty)!{
            message = "txt_alert_last_ame".getNameLabel()
            isValidForm = false
        }else if !mayor18Años {
            message = "Es Mayor de 18 años?"
            isValidForm = false
        }else if !mismosDatos {
            if (self.titleValueTextFVisitante.text?.isEmpty)! {
                message = "Ingrese Sr, Sra..."
                isValidFormVisitante = false
                isValidForm = false
            }else if (self.nameValueTextFVisitante.text?.isEmpty)!{
                isValidFormVisitante = false
                isValidForm = false
                message = "txt_alert_name".getNameLabel()
            }else if (self.apellidoValueTextFVisita.text?.isEmpty)!{
                isValidFormVisitante = false
                isValidForm = false
                message = "Apellido"
            }else if !emailValueTextFVisitante.isValidEmailAddress() {
                isValidFormVisitante = false
                isValidForm = false
                message = "txt_alert_email".getNameLabel()
            }else if (paisValueTextFVisitante.text?.isEmpty)!{
                isValidFormVisitante = false
                isValidForm = false
                message = "Ingrese Pais"//.getNameLabel()
            }else if (estadoValueTextFVisitante.text?.isEmpty)!{
                isValidFormVisitante = false
                isValidForm = false
                message = "Ingrese Estado"//.getNameLabel()
            }else if (ciudadvalueTextFVisitante.text?.isEmpty)!{
                isValidFormVisitante = false
                isValidForm = false
                message = "Ingrese Ciudad"//.getNameLabel()
            }else if (cpValueTextFVisitante.text?.isEmpty)!{
                isValidFormVisitante = false
                isValidForm = false
                message = "Ingrese CP"//.getNameLabel()
            }else if(telefonoValueTextFVisitante.text?.isEmpty)!{
                message = "txt_alert_last_ame".getNameLabel()
                isValidFormVisitante = false
                isValidForm = false
            }
        }
        
        if(!isValidForm){
            UpAlertView(type: .warning, message: message).show {
                print("Falta Información")
            }
        }
        
        if(!isValidFormVisitante){
            UpAlertView(type: .warning, message: "Datos del Visitante: \(message)").show {
                print("Falta Información")
            }
        }
        return isValidForm
    }

}

extension TusDatosViewController : DataFormBuy {
    
    
    func dataFormBuyEstado(estado : String, itemEstado : ItemStates){
        if estado == "estadoUser" {
            estadoValueTextF.text = itemEstado.name
            itemSelectDataStatesUser = itemEstado
        }else if estado == "estadoUserVisitante"{
            estadoValueTextFVisitante.text = itemEstado.name
            itemSelectDataStatesVisitante = itemEstado
        }
    }
    
    func dataFormBuyTitle(title: String, itemTitle: ItemLangTitle) {
        if title == "titleUser" {
            titleValueTextF.text = itemTitle.name
            itemSelectDataTitleUser = itemTitle
        }else if title == "titleUserVisitante"{
            itemSelectDataTitleVisitante = itemTitle
            titleValueTextFVisitante.text = itemTitle.name
        }
    }
    
    func dataFormBuyPais(pais: String, itemPais: ItemLangCountry) {
        if pais == "paisUser" {
            paisValueTextF.text = itemPais.name
            estadoValueTextF.text = itemPais.states.first?.abbreviation
            itemSelectDataPaisUser = itemPais
            if itemPais.states.count == 1{
                
                itemSelectDataStatesUser = itemPais.states.first!
                estadoUserView.isUserInteractionEnabled = false
                estadoValueTextF.isUserInteractionEnabled = false
            }else{
                estadoValueTextF.isUserInteractionEnabled = true
                estadoUserView.isUserInteractionEnabled = true
                estadoValueTextF.text = ""
                itemsDataStates = itemPais.states
            }
            if let lada = appDelegate.listItemPhoneCode.filter({ $0.iso == itemPais.iSO}).first {
                ladaValueTextF.text = "+\(String(lada.code))"
                itemSelectdataLadaUser = lada
                ladaValueTextF.isUserInteractionEnabled = false
            }else{
                ladaValueTextF.isUserInteractionEnabled = true
            }
            
        }else if pais == "paisUserVisitante"{
            paisValueTextFVisitante.text = itemPais.name
            estadoValueTextFVisitante.text = itemPais.states.first?.abbreviation
            itemSelectDataPaisVisitante = itemPais
            if itemPais.states.count == 1{
                itemSelectDataStatesVisitante = itemPais.states.first!
                estadoUserViewVisitante.isUserInteractionEnabled = false
                estadoValueTextFVisitante.isUserInteractionEnabled = false
            }else{
                estadoUserViewVisitante.isUserInteractionEnabled = true
                estadoValueTextFVisitante.isUserInteractionEnabled = true
                estadoValueTextFVisitante.text = ""
                itemsDataStates = itemPais.states
            }
            if let lada = appDelegate.listItemPhoneCode.filter({ $0.iso == itemPais.iSO}).first {
                ladaValueTextFVisitante.text = "+\(String(lada.code))"
                ladaValueTextFVisitante.isUserInteractionEnabled = false
                itemSelectdataLadaVisitante = lada
            }else{
                ladaValueTextFVisitante.isUserInteractionEnabled = true
            }
            
        }
    }
    
    
}

extension TusDatosViewController : FinalBuyStepGoTicket{
    func goTicket() {
        self.dismiss(animated: false, completion: nil)
    }
}
