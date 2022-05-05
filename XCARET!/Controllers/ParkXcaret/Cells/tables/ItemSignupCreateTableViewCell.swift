//
//  ItemSignupCreateTableViewCell.swift
//  XCARET!
//
//  Created by Angelica Can on 9/10/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import RSSelectionMenu
import Firebase
import SwiftUI
import Kingfisher

protocol UserPassLoginDelegate : class {
    func getUserPassLogin(type: String, userApp: UserApp, pass: String)
}

class ItemSignupCreateTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitleCreateAccount: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordConfirm: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var btnCreateAccount: UIButton!
    weak var delegateUserPassLogin : UserPassLoginDelegate?
    var textFields: [UITextField]!
    var countryList : [Country] = [Country]()
    var countrySelected : [Country] = [Country]()
    var mainViewController : UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.textFields = [txtEmail, txtPassword, txtPasswordConfirm, txtName, txtCountry]
        
        self.lblTitleCreateAccount.text = "lblCreateUserLogin".localized()
        self.btnCreateAccount.setTitle("lblBtnCreateAccount".localized(), for: .normal)
        self.txtEmail.delegate = self
        self.txtLastName.delegate = self
        self.txtPassword.delegate = self
        self.txtPasswordConfirm.delegate = self
        self.txtName.delegate = self
        self.txtCountry.delegate = self
        
        self.getCountryList()
        
//        self.txtEmail.text = "jacobo.diaz1@hotmail.com"
//        self.txtName.text = "Jacobo"
//        self.txtPassword.text = "prueba123"
//        self.txtPasswordConfirm.text = "prueba123"
//        self.txtLastName.text = "Diaz"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardTable)))
    }
    
    override func layoutSubviews() {
        self.txtEmail.setBottonLineDefault()
        self.txtName.setBottonLineDefault()
        self.txtPassword.setBottonLineDefault()
        self.txtPasswordConfirm.setBottonLineDefault()
        self.txtLastName.setBottonLineDefault()
        self.txtCountry.setBottonLineDefault()
        
        self.txtEmail.placeholder = "txt_email".getNameLabel()
        self.txtName.placeholder = "txt_name".getNameLabel()
        self.txtPassword.placeholder = "txt_password".getNameLabel()
        self.txtPasswordConfirm.placeholder = "txt_confirm_password".getNameLabel()
        self.txtLastName.placeholder = "txt_last_name".getNameLabel()
        self.txtCountry.placeholder = "txt_country".getNameLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setConfigCell(){
        
    }
    
    @objc func hideKeyboardTable() {
        self.txtEmail.resignFirstResponder()
        self.txtLastName.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        self.txtPasswordConfirm.resignFirstResponder()
        self.txtName.resignFirstResponder()
        self.txtCountry.resignFirstResponder()
    }
    
    func getCountryList() {
        //self.bt.isEnabled = false
        self.txtCountry.isEnabled = false
        //LoadingView.shared.showActivityIndicator(uiView: self.view)
        FirebaseDB.shared.getListCountries { (countriesList) in
            //LoadingView.shared.hideActivityIndicator(uiView: self.view)
            //self.btnCreateAccount.isEnabled = true
            if countriesList.count > 0 {
                self.countryList = countriesList
                self.txtCountry.isEnabled = true
            }else{
                self.txtCountry.isHidden = true
                //self.txtPhone.returnKeyType = UIReturnKeyType.go
            }
        }
    }
    
    @IBAction func btnCreate(_ sender: UIButton) {
        if validForm(){
            let user = self.getUserInfo()
            self.delegateUserPassLogin?.getUserPassLogin(type: "UP", userApp: user, pass: txtPasswordConfirm.text!)
        }
    }
    
    func getUserInfo() -> UserApp{
        let newUser : UserApp = UserApp()
        let userAuth = Auth.auth().currentUser
        newUser.country = self.countrySelected[0].name
        newUser.email = self.txtEmail.text!
        newUser.lastname = self.txtName.text!
        newUser.name = self.txtLastName.text!
        if let userAuthx = userAuth {
            newUser.uid = userAuthx.uid
            newUser.provider = userAuthx.providerID
        }
        return newUser
    }
    
    func validForm() -> Bool{
        var isValidForm = true
        var message : String = ""
        
        if !txtEmail.isValidEmailAddress() {
            isValidForm = false
            message = "txt_alert_email".getNameLabel()//"alertEmail".localized()
        }else if (txtPassword.text?.isEmpty)! {
            isValidForm = false
            message = "txt_alert_pass".getNameLabel()//"alertPass".localized()
        }else if (txtPasswordConfirm.text?.isEmpty)!{
            isValidForm = false
            message = "txt_alert_confirm".getNameLabel()//"alertConfirm".localized()
        }
        else if(txtPassword.text != txtPasswordConfirm.text){
            isValidForm = false
            message = "txt_alert_not_match".getNameLabel()//alertNotMatch".localized()
        }else if(txtName.text?.isEmpty)!{
            isValidForm = false
            message = "txt_alert_name".getNameLabel()//"alertName".localized()
        }else if(txtLastName.text?.isEmpty)!{
            message = "txt_alert_last_ame".getNameLabel()//alertLastName".localized()
            isValidForm = false
        }else if(txtCountry.text?.isEmpty)!{
            message = "txt_alert_country".getNameLabel()//alertCountry".localized()
            isValidForm = false
        }
        
        if(!isValidForm){
            UpAlertView(type: .warning, message: message).show {
                print("Falta Información")
            }
        }
        return isValidForm
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
            self.frame.origin.y = moveScrollY
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
                if yPositionMaxField > Ymax{
                    moveScroll = -keyboardRect
                }
            }
        }
        
        return moveScroll
    }
    
    func showCountries(){
        let selectionMenu = RSSelectionMenu(dataSource: countryList) { (cell, country, indexPath) in
            cell.textLabel?.text = country.name
        }
        
        selectionMenu.setSelectedItems(items: countrySelected) { (text, selected, selectedItem) in
            self.countrySelected = selectedItem
            self.txtCountry.text = self.countrySelected[0].name
        }
        
        selectionMenu.showSearchBar { (searchText) -> ([Country]) in
            return self.countryList.filter({$0.name.lowercased().hasPrefix(searchText.lowercased())})
        }
        
        selectionMenu.show(style: .Formsheet, from: self.mainViewController)
        
    }
}

extension ItemSignupCreateTableViewCell : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtCountry {
            txtCountry.resignFirstResponder()
            self.showCountries()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case txtEmail:
            txtPassword.becomeFirstResponder()
        case txtPassword:
            txtPasswordConfirm.becomeFirstResponder()
        case txtPasswordConfirm:
            txtName.becomeFirstResponder()
        case txtName:
            txtLastName.becomeFirstResponder()
        case txtLastName:
            if txtCountry.returnKeyType == UIReturnKeyType.go{
                txtCountry.resignFirstResponder()
                //self.sendUserRegister()
            }else{
                //self.showCountries()
            }
        default:
            textField.resignFirstResponder()
        }
        
        
        return true
    }
}
