//
//  InputCollectionViewCell.swift
//  XCARET!
//
//  Created by YEiK on 12/05/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit

class InputCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
//    InputDelegate
    weak var delegateInput: InputDelegate?
    

    @IBOutlet var input: UITextField!
    @IBOutlet weak var trailingICon: NSLayoutConstraint!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var nameTyoeLbl: UILabel!
    //    var inputDelegate: InputDelegate!
    var index: Int!
    var inputType: InputType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        input.delegate = self
        input.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.contentView.clipsToBounds = false
        self.contentView.layer.masksToBounds = false
    }

    func inputConfiguration(_ inputType: InputType, index: Int, text: String){
        self.index = index
        self.inputType = inputType
        input.autocapitalizationType = .none
        
        switch inputType {
        case .name:
            nameTyoeLbl.text = "lbl_add_plus_full_name".getNameLabel()
            input.keyboardType = .namePhonePad
            input.isSecureTextEntry = false
            input.autocorrectionType = .no
            input.autocapitalizationType = .words
        case .cardNumber:
            nameTyoeLbl.text = "lbl_add_plus_card_number".getNameLabel()
            input.keyboardType = .numberPad
            input.autocorrectionType = .no
            input.isSecureTextEntry = false
        case .expirationDate:
            nameTyoeLbl.text = "lbl_add_plus_date_expiry".getNameLabel()
            input.textAlignment = .center
            input.keyboardType = .numberPad
            input.autocorrectionType = .no
            input.isSecureTextEntry = false
        case .cvv:
            nameTyoeLbl.text = "lbl_add_plus_cvv".getNameLabel()
            input.textAlignment = .center
            input.keyboardType = .numberPad
            input.autocorrectionType = .no
            input.isSecureTextEntry = true
        }
        self.input.text = text
        
        self.updateInfoIcon(self.inputType)
    }
    
    func updateInfoIcon(_ inputType: InputType){
        switch inputType {
        case .name, .cardNumber, .expirationDate:
            trailingICon.constant = -16
            infoBtn.isHidden = true
        case .cvv:
            infoBtn.isHidden = false
            trailingICon.constant = 30
        }
        self.layoutIfNeeded()
    }
    
    func addToolBar(){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 95/255, green: 137/255, blue: 178/255, alpha: 1)
        
        let sigButton = UIBarButtonItem(title: "lbl_client_data_next".getNameLabel(), style: .done, target: self, action: #selector(nextInput))
        let beforeButton = UIBarButtonItem(title: "lbl_client_data_previous".getNameLabel(), style: .done, target: self, action: #selector(beforeInput))
        let doneButton = UIBarButtonItem(title: "lbl_client_data_close".getNameLabel(), style: .done, target: self, action: #selector(finished))
        let cancelButton = UIBarButtonItem(title: "lbl_client_data_cancel".getNameLabel(), style: .plain, target: self, action: #selector(cancel))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        var buttons: [UIBarButtonItem] = [spaceButton]
        
        if inputType == .cardNumber{
            buttons.insert(cancelButton, at: 0)
            buttons.append(sigButton)
        }else if inputType == .cvv{
            buttons.insert(beforeButton, at: 0)
            buttons.append(doneButton)
        }else{
            buttons.insert(beforeButton, at: 0)
            buttons.append(sigButton)
        }
        
        toolBar.setItems(buttons, animated: false)
        toolBar.isUserInteractionEnabled = true
            toolBar.sizeToFit()

        input.inputAccessoryView = toolBar
    }
    
    @objc func beforeInput(){
        input.resignFirstResponder()
        delegateInput?.focusThePrevious(index: index)
    }
    
    @objc func nextInput(){
        input.resignFirstResponder()
        delegateInput?.focusInNext(index: index)
    }
    
    @objc func finished(){
        self.endEditing(true)
        delegateInput?.finalizeCapturing()
    }
    
    @objc func cancel(){
//        self.endEditing(true)
        delegateInput?.cancel()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegateInput?.focusIn(index: index)
        self.addToolBar()
    }
    
    @objc func textFieldDidChange(){
        delegateInput?.enterTextEvent(text: input.text ?? "", kind: self.inputType)
        if self.inputType == .expirationDate{
            input.text = input.text!.grouping(every: 2, with: "/")
        }else if self.inputType == .cardNumber{
            input.text = input.text!.grouping(every: 4, with: " ")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        guard let text = textField.text, let textRange = Range(range, in: text) else {
            return false
        }
            
        if self.inputType == .cardNumber || self.inputType == .cvv || self.inputType == .expirationDate{
            guard allowedCharacters.isSuperset(of: characterSet) else{
                print("No ingreso un número")
                return false
            }
            
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if self.inputType == .cardNumber{
                return !(updatedText.count > 19)
            }else if self.inputType == .cvv{
                return !(updatedText.count > 4)
            }else {
                guard updatedText.count < 6 else {
                    return false
                }
                
                if updatedText.count == 1, let toInt = Int(updatedText){
                    return toInt <= 1
                }else if updatedText.count == 2, let toInt = Int(updatedText){
                    return toInt <= 12
                }else {
                    let separedString = string.components(separatedBy: "")
                    
                    if updatedText.count == 3, let last = separedString.last, let toInt = Int(last){
                        return toInt > 1 && toInt < 4
                    }else{
                        if separedString.indices.contains(2), separedString.indices.contains(3), let toInt = Int("\(separedString[2])\(separedString[3])"){
                            return toInt > 20 && toInt < 402
                        }
                    }
                }
                
                
            }
            
        }else if self.inputType == .name{
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                 return regex.firstMatch(in: updatedText, options: [], range: NSMakeRange(0, updatedText.count)) == nil
            } catch {
                return false
            }
        }
        
        return true
    }
    
    func focus(){
        self.input.becomeFirstResponder()
    }
}

