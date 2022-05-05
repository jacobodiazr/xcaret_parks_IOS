//
//  ForgotPasswordViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 10/07/18.
//  Copyright © 2018 Experiencias Xcaret. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var buttonSendEmail: UIButton!
    @IBOutlet weak var constraintTopEmail: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionGestureHideKeyboard()
        self.imgBackground.image = UIImage(named: "\(UIDevice().getFolder())signup")
        constraintTopEmail.constant = UIDevice().getTopEmail()
    }

    override func viewDidLayoutSubviews() {
        self.txtEmail.setBottonLineDefault()
    }

    @IBAction func btnLogin(_ sender: UIButton) {
        self.sendEmail()
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func sendEmail(){
        if validateForm(){
            let email = txtEmail.text
            txtEmail.resignFirstResponder()
            buttonSendEmail.isEnabled = false
            Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
                if error != nil{
                    UpAlertView(type: .error, message: "txt_alert_email_not_exist".getNameLabel()).show{//"alertEmailNotExist".localized()).show{
                        print("error \(error ?? "prueba" as! Error)")
                        self.buttonSendEmail.isEnabled = true
                    }
                }else{
                    UpAlertView(type: .success, message: "alertSendEmail".localized()).show{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func validateForm() -> Bool{
        var isValidForm = true
        var message : String = ""
        
        if !txtEmail.isValidEmailAddress(){
            isValidForm = false
            message = "alertEmail".localized()
        }
        
        if(!isValidForm){
            UpAlertView(type: .warning, message: message).show {
                print("Falta Información")
            }
        }
        return isValidForm
    }
}

extension ForgotPasswordViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == UIReturnKeyType.go{
            self.sendEmail()
        }
        return true
    }
    
}
