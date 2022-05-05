//
//  ContactViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 2/5/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {
    weak var delegate : ModalChangeLangHandler?
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var widthViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblCallInside: UILabel!
    @IBOutlet weak var lblCallFrom: UILabel!
    @IBOutlet weak var viewContactCenter: UIView!
    
    @IBOutlet weak var lblBtnSpanish: UIButton!
    @IBOutlet weak var lblBtnEnglish: UIButton!
    @IBOutlet weak var lblBtnUSACAN: UIButton!
    
    //View Language
    @IBOutlet weak var viewChangeLanguage: UIView!
    @IBOutlet weak var heightViewChangeConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitleLanguage: UILabel!
    @IBOutlet weak var lblBtnLangES: UIButton!
    @IBOutlet weak var lbBtnLangEN: UIButton!
    var typeAlertView : TypeAlertView = .contactCenterView
    
    var messageTicketTried = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.widthViewConstraint.constant = UIScreen.main.bounds.width - 100
        self.lblCallInside.text = "lbl_call_inside".getNameLabel()//"lblCallInside".localized()
        if messageTicketTried {
            self.lblCallInside.text = "\("lbl_title_dialog_problem_ticket".getNameLabel())\n\("lbl_call_inside".getNameLabel())"
        }
        self.lblCallFrom.text = "lbl_call_from".getNameLabel()//"lblCallFrom".localized()
        self.lblBtnEnglish.setTitle("btn_call_inglish".getNameLabel()/*"lblCallInglish".localized()*/, for: .normal)
        self.lblBtnSpanish.setTitle("btn_call_spanish".getNameLabel()/*"lblCallSpanish".localized()*/, for: .normal)
        self.lblBtnUSACAN.setTitle("btn_call_usa_can".getNameLabel()/*"lblCallUsaCan".localized()*/, for: .normal)
        
        self.lblTitleLanguage.text = "lbl_change_lang".getNameLabel()//"lblChangeLang".localized()
        self.lblBtnLangES.setTitle("lblLangEN".localized(), for: .normal)
        self.lbBtnLangEN.setTitle("lblLangES".localized(), for: .normal)
        loadAlertView()
    }
    
    func loadAlertView(){
        switch typeAlertView {
        case .contactCenterView:
            viewContactCenter.isHidden = false
        case .changeLang:
            imgContact.image = UIImage(named: "Alert/language")
            heightViewChangeConstraint.constant = 140
            viewChangeLanguage.isHidden = false
        default:
            viewContactCenter.isHidden = false
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func btnCallContactCenter(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            //Telefono Ingles
            //9988812731 PQ_APP_EN 173 47454 315
            //Tools.shared.callNumber(number: "(998)883-3143", ext: "2")
            Tools.shared.callNumber(number: appDelegate.itemContact.tel_english)
        case 2:
            //Telefono Español
            //9988812732 PQ_APP_ES 174 47455 316
            //Tools.shared.callNumber(number: "(998)883-3143")
            Tools.shared.callNumber(number: appDelegate.itemContact.tel_spanish)
        case 3:
            //Telefono USA CAN
            //Tools.shared.callNumber(number: "1-855-326-0682")
            Tools.shared.callNumber(number: appDelegate.itemContact.tel_usacan)
        default:
            //Tools.shared.callNumber(number: "(998)881-2731", ext: "17347454315")
            Tools.shared.callNumber(number: appDelegate.itemContact.tel_english)
        }
    }
    
    
    @IBAction func btnChangeLang(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            self.delegate?.changeLang(lang: sender.tag == 1 ? "en" : "es")
        }
    }
    

    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
