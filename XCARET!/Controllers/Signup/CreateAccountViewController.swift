//
//  CreateAccountViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 10/07/18.
//  Copyright © 2018 Experiencias Xcaret. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAuth
import RSSelectionMenu

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var constraintCreateAccount: NSLayoutConstraint!
    
    var countryList : [Country] = [Country]()
    var countrySelected : [Country] = [Country]()
    var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constraintCreateAccount.constant = UIDevice().getTopCreateAccount()
        
        self.imgBackground.image = UIImage(named: "\(UIDevice().getFolder())signup")
        textFields = [txtEmail, txtPass, txtConfirmPass, txtName, txtPhone, txtCountry]
        self.extensionGestureHideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.getCountryList()
        
        /*self.txtEmail.text = "acan09@xcaret.com"
        self.txtPass.text = "prueba123"
        self.txtConfirmPass.text = "prueba123"
        self.txtName.text = "Angelica"
        self.txtPhone.text = "Can"*/
        
    }

    override func viewDidLayoutSubviews() {
        self.txtEmail.setBottonLineDefault()
        self.txtName.setBottonLineDefault()
        self.txtPass.setBottonLineDefault()
        self.txtConfirmPass.setBottonLineDefault()
        self.txtPhone.setBottonLineDefault()
        self.txtCountry.setBottonLineDefault()
        
        self.txtEmail.placeholder = "txt_email".getNameLabel()
        self.txtName.placeholder = "txt_name".getNameLabel()
        self.txtPass.placeholder = "txt_password".getNameLabel()
        self.txtConfirmPass.placeholder = "txt_confirm_password".getNameLabel()
        self.txtPhone.placeholder = "txt_last_name".getNameLabel()
        self.txtCountry.placeholder = "txt_country".getNameLabel()//"txt_country_optional".getNameLabel()
    }
    
    func getCountryList() {
        self.btnCreateAccount.isEnabled = false
        self.txtCountry.isEnabled = false
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        FirebaseDB.shared.getListCountries { (countriesList) in
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
            self.btnCreateAccount.isEnabled = true
            if countriesList.count > 0 {
                self.countryList = countriesList
                self.txtCountry.isEnabled = true
            }else{
                self.txtCountry.isHidden = true
                self.txtPhone.returnKeyType = UIReturnKeyType.go
            }
        }
    }
    
    func validForm() -> Bool{
        var isValidForm = true
        var message : String = ""
        if !txtEmail.isValidEmailAddress() {
            isValidForm = false
            message = "txt_alert_email".getNameLabel()//"alertEmail".localized()
        }else if (txtPass.text?.isEmpty)! {
            isValidForm = false
            message = "txt_alert_pass".getNameLabel()//"alertPass".localized()
        }else if (txtConfirmPass.text?.isEmpty)!{
            isValidForm = false
            message = "txt_alert_confirm".getNameLabel()//"alertConfirm".localized()
        }else if(txtPass.text != txtConfirmPass.text){
            isValidForm = false
            message = "txt_alert_not_match".getNameLabel()//alertNotMatch".localized()
        }else if(txtPass.text?.count ?? 0 < 6){
            isValidForm = false
            message = Constants.LANG.current == "es" ? "La contraseña debe tener 6 caracteres o más." : "The password must be 6 characters long or more."
        }else if(txtName.text?.isEmpty)!{
            isValidForm = false
            message = "txt_alert_name".getNameLabel()//"alertName".localized()
        }else if(txtPhone.text?.isEmpty)!{
            message = "txt_alert_last_ame".getNameLabel()//"alertLastName".localized()
            isValidForm = false
        }
        
        if(!isValidForm){
            UpAlertView(type: .warning, message: message).show {
                print("Falta Información")
            }
        }
        return isValidForm
    }

    @IBAction func btnSignUp(_ sender: UIButton) {
        view.endEditing(true)
        self.btnCreateAccount.isEnabled = false
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        self.sendUserRegister()
    }
    
    @IBAction func btnBackLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func sendUserRegister(){
        let email = txtEmail.text
        let pass = txtPass.text
        var userApp = UserApp()
        if validForm(){
            Auth.auth().createUser(withEmail: email!, password: pass!) { (user, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    let message = "lbl_err_account_exist".getNameLabel()//"alertAccountExist".localized()
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    UpAlertView(type: .warning, message: message).show {
                        print("Falta Información")
                        self.btnCreateAccount.isEnabled = true
                    }
                    
                }else{
                    userApp = self.getInfoUserAuth()
                    userApp.provider = "password"
                    print("StatusSF: authenticateUserApp CreateAccount")
                    FirebaseBR.shared.authenticateUserApp(user: userApp, completion: { (isSuccess, userApp) in
                        if isSuccess{
                            guard let window = UIApplication.shared.keyWindow else {
                                return
                            }
                            guard let rootViewController = window.rootViewController else {
                                return
                            }
                            
                            let mainNC = AppStoryboard.HomeParks.instance.instantiateViewController(withIdentifier: "HomeParksNC")
                            mainNC.view.frame = rootViewController.view.frame
                            mainNC.view.layoutIfNeeded()
                            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            window.rootViewController = mainNC
                                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                self.btnCreateAccount.isEnabled = true
                            })
                        }
                    })
                    
                }
            }
        }else{
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
            self.btnCreateAccount.isEnabled = true
        }
    }
    
    func getInfoUserAuth() -> UserApp{
        let user = Auth.auth().currentUser
        var email = ""
        var phone = ""
        var uid = ""
        var provider = ""
        var name = ""
        var lastName = ""
        var firstName = ""
        var country = ""
        
        print(user!)
        if let userx = user {
            email = userx.email!
            uid = userx.uid
            provider = userx.providerID
            name = "\(self.txtName.text!) \(self.txtPhone.text!)"
            phone = ""
            firstName = self.txtName.text!
            lastName = self.txtPhone.text!
            country = self.countrySelected.first?.name ?? ""
        }
        
        let userApp = UserApp()
        userApp.email = email
        userApp.name = name
        userApp.lastname = lastName
        userApp.phone = phone
        userApp.device = ""
        userApp.platform = ""
        userApp.version = ""
        userApp.lang = ""
        userApp.token =  ""
        userApp.registered = ""
        userApp.uid = uid
        userApp.provider = provider
        userApp.country = country
        userApp.firstname = firstName
        
        return userApp
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
        
        selectionMenu.show(style: .Formsheet, from: self)
        
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
                if yPositionMaxField > Ymax{
                    moveScroll = -keyboardRect
                }
            }
        }
        
        return moveScroll
    }
}

extension CreateAccountViewController : UITextFieldDelegate {
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
            txtPass.becomeFirstResponder()
        case txtPass:
            txtConfirmPass.becomeFirstResponder()
        case txtConfirmPass:
            txtName.becomeFirstResponder()
        case txtName:
            txtPhone.becomeFirstResponder()
        case txtPhone:
            if txtPhone.returnKeyType == UIReturnKeyType.go{
                txtPhone.resignFirstResponder()
                self.sendUserRegister()
            }else{
                self.showCountries()
            }
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
