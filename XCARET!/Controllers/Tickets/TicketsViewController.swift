//
//  TicketsViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 28/08/18.
//  Copyright © 2018 Experiencias Xcaret. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class TicketsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var walletView: WalletView!
    @IBOutlet weak var viewTicketEmpty: UIView!
    @IBOutlet weak var lblBuyTickets: UILabel!
    @IBOutlet weak var btnBuyNow: UIButton!
    @IBOutlet weak var walletViewBottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var backgroundTickets: UIImageView!
    @IBOutlet weak var ViewBtnBuy: UIView!
    @IBOutlet weak var ViewBtnBuyHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ViewBtnBuyBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewKeyboardTop: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblClose: UILabel!
    @IBOutlet weak var lblButtonAddTickets: UILabel!
    
    @IBOutlet weak var textEmailTickets: SkyFloatingLabelTextField!
    @IBOutlet weak var textFolioTickets: SkyFloatingLabelTextField!
    @IBOutlet weak var buttonAddTicket: UIButton!
    
    @IBOutlet weak var constraintButtonAddTicketWallet: NSLayoutConstraint!
    @IBOutlet weak var buttonAddTicketWallet: UIView!
    @IBOutlet weak var buttonCloseAddTicket: UIView!
    
    @IBOutlet weak var ViewNoTickets: UIView!
    
    var itemsCardViews = [ColoredCardView]()
    var isLoadInfo : Bool = true
    var ticketsList : [ItemTicket] = [ItemTicket]()
    var isFirstLoad: Bool = true
    var buttonHiden = false
    var textFolio = false
    var textEmail = false
    var tried = 0
    var ticketNew = [ItemTicket]()
    var ticketPre = [ItemTicket]()
    
    var ticket360 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        textEmailTickets.delegate = self
        textFolioTickets.delegate = self
        
        //Configuramos NavController
        self.backgroundTickets.image = UIImage(named: "\(UIDevice().getFolder())tickets")
        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = .clear

            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.alpha = 0.4
            blurEffectView.frame = self.backgroundTickets.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundTickets.addSubview(blurEffectView)
        } else {
            view.backgroundColor = .black
        }
        
        
        self.lblTitle.text = "lbl_title_form_ticket".getNameLabel()
        self.buttonAddTicket.setTitle("lbl_validate_form_ticket".getNameLabel(), for: .normal)
        self.lblClose.text = "lbl_close_form_ticket".getNameLabel()
        self.textFolioTickets.placeholder = "lbl_code_form_ticket".getNameLabel()
        self.textEmailTickets.placeholder = "lbl_email_form_ticket".getNameLabel()
        self.lblButtonAddTickets.text = "lbl_add_form_ticket".getNameLabel()
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "Icons/photo/ic_regresar"), style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "Icons/ic_telefono"), style: .plain, target: self, action: #selector(goCallCenter))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        let walletHeader = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 0))
        walletHeader.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        walletHeader.textAlignment = .center
        walletHeader.textColor = UIColor.white
        walletHeader.text = NSLocalizedString("lblTickets", comment: "")
        walletView.walletHeader?.isHidden = true
        
        buttonAddTicket.isEnabled = false
        buttonAddTicketWallet.isHidden = true
        buttonCloseAddTicket.isHidden = true
        
        textFolioTickets.textAlignment = .center
        textEmailTickets.textAlignment = .center
        
        
        
        let gestureAdd = UITapGestureRecognizer(target: self, action: #selector(self.addTicketWallet))
        self.buttonAddTicketWallet.addGestureRecognizer(gestureAdd)
        let gestureClose = UITapGestureRecognizer(target: self, action: #selector(self.closeAddTicketWallet))
        self.buttonCloseAddTicket.addGestureRecognizer(gestureClose)
        
        textFolioTickets.addTarget(self, action: #selector(textFieldDidChangeFolio(_:)), for: .editingChanged)
        textEmailTickets.addTarget(self, action: #selector(textFieldDidChangeEmail(_:)), for: .editingChanged)
        
        constraintButtonAddTicketWallet.constant = UIScreen.main.bounds.width / 1.5
        
        let park = appDelegate.listAllParks.filter({$0.code.lowercased() == appDelegate.itemParkSelected.code.lowercased()})
                if park.isEmpty {
                    self.btnBuyNow.setTitle("lbl_buy".getNameLabel(), for: .normal)
                }else{
                    self.btnBuyNow.setTitle("\("lbl_buy".getNameLabel()) \(park.first?.name ?? "")", for: .normal)
                }
        self.ViewBtnBuyHeightConstraint.constant = UIDevice().getHeightViewCode()
        self.ViewBtnBuyBottomConstraint.constant = UIDevice().getBottomViewBuy()
        
        self.ViewNoTickets.isHidden = !self.ticket360
//        self.buttonAddTicketWallet.isHidden = !self.ticket360
        if appDelegate.listCodeAyB.count == 0{
            FirebaseBR.shared.getCodesAyB {
                print("Llenamos los datos")
                self.loadTickets()
            }
        }else{
            loadTickets()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.viewKeyboardTop.frame.origin.y == 0 {
//                self.viewKeyboardTop.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.viewKeyboardTop.frame.origin.y != 0 {
//            self.viewKeyboardTop.frame.origin.y = 0
//        }
//    }
    
    @objc func addTicketWallet() {
        
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.walletView.isHidden = true
            self.buttonAddTicketWallet.isHidden = true
            self.viewTicketEmpty.isHidden = false
            self.textEmailTickets.text = ""
            self.textFolioTickets.text = ""
            self.buttonCloseAddTicket.isHidden = false
           })
        
    }
    
    @objc func closeAddTicketWallet(){
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.walletView.isHidden = false
            self.buttonAddTicketWallet.isHidden = false
            self.viewTicketEmpty.isHidden = true
            self.buttonCloseAddTicket.isHidden = true
        })
    }
    
    
    @objc func textFieldDidChangeFolio(_ textfield: UITextField) {
            if let text = textfield.text {
                if let floatingLabelTextField = textFolioTickets {
                    floatingLabelTextField.placeholderColor = Constants.COLORS.TICKETS.colorTextFieldBlue
                    floatingLabelTextField.textColor = Constants.COLORS.TICKETS.colorTextFieldBlue
                    if !text.isValidFolioTicket() {
                        textFolio = false
//                        floatingLabelTextField.errorMessage = "lbl_code_form_ticket".getNameLabel()
                        if text.count == 0 {
                            floatingLabelTextField.errorMessage = ""
                            floatingLabelTextField.placeholder = "lbl_code_form_ticket".getNameLabel()
                        }
                    }else {
                        textFolio = true
                        floatingLabelTextField.placeholder = "lbl_code_form_ticket".getNameLabel()
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        validationButton()
    }
    
    
    @objc func textFieldDidChangeEmail(_ textfield: UITextField) {
            if let text = textfield.text {
                if let floatingLabelTextField = textEmailTickets {
                    floatingLabelTextField.placeholderColor = Constants.COLORS.TICKETS.colorTextFieldBlue
                    floatingLabelTextField.textColor = Constants.COLORS.TICKETS.colorTextFieldBlue
//                    floatingLabelTextField.placeholder?.lowercased()
                    if(!text.isValidEmail()) {
                        textEmail = false
//                        floatingLabelTextField.errorMessage = "lbl_email_form_ticket".getNameLabel()
                        if text.count == 0 {
                            floatingLabelTextField.errorMessage = ""
                            floatingLabelTextField.placeholder = "lbl_email_form_ticket".getNameLabel()
                        }
                    }else {
                        textEmail = true
                        floatingLabelTextField.placeholder = "lbl_email_form_ticket".getNameLabel()
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        validationButton()
    }
    
    
    func validationButton(){
        if textEmail && textFolio {
            buttonAddTicket.backgroundColor = Constants.COLORS.TICKETS.colorTextFieldBlue
            buttonAddTicket.borderColor = Constants.COLORS.TICKETS.colorTextFieldBlue
            buttonAddTicket.setTitleColor(.white, for: .normal)
            buttonAddTicket.isEnabled = true
        }else{
            buttonAddTicket.backgroundColor = .clear
            buttonAddTicket.borderColor = Constants.COLORS.TICKETS.colorTextFieldOrage
            buttonAddTicket.setTitleColor( Constants.COLORS.TICKETS.colorTextFieldOrage , for: .normal)
            buttonAddTicket.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    @IBAction func AddTicket(_ sender: Any) {
        
        LoadingView.shared.showActivityIndicator(uiView: self.view, type: .loadTicket)
        print("\(textFolioTickets.text ?? "") - \(textEmailTickets.text ?? "")")
        ticketsSendUser(ticket: textFolioTickets.text!, email: textEmailTickets.text!)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc public func goBack() {
        if !appDelegate.optionsHome{
            appDelegate.optionsHome = false
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func goCallCenter(){
        /*SF*/
        let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_Xcaret_Call": true]
        (AppDelegate.getKruxTracker()).trackPageView("E-Commerce", pageAttributes:pageAttr, userAttributes:nil)
        /**/
        let contactModal = AppStoryboard.ParkXcaret.instance.instantiateViewController(withIdentifier: "ContactModal") as? ContactViewController
        if self.tried == 3 {
            contactModal?.messageTicketTried = true
        }
        self.tried = 0
        self.present(contactModal!, animated: true)
    }
    
    func loadTickets(){
        LoadingView.shared.showActivityIndicator(uiView: self.view, type: .loadTicket)
        FirebaseBR.shared.getTickets { (ticketListFB) in
            if self.isFirstLoad {
                self.isFirstLoad = false
                self.viewTicketEmpty.isHidden = true
                self.ticketsList = appDelegate.listTickets
                if self.ticketsList.count > 0 {
                    FirebaseBR.shared.updateTickets(listTicketsUpdate: ticketListFB, completion: { (listTickets) in
                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                        self.ticketsList = listTickets
                        self.settingView()
                    })
                }else{
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    //                    self.viewTicketEmpty.isHidden = false
                    self.buttonAddTicketWallet.isHidden = !self.ticket360
                    self.ViewNoTickets.isHidden = self.ticket360
                    self.viewTicketEmpty.isHidden = !self.ticket360
                    
                }
            }
        }
        
        /*FirebaseBR.shared.getTickets { (ticketListFB) in
            if self.isFirstLoad {
                self.isFirstLoad = false
                self.viewTicketEmpty.isHidden = true
                self.ticketsList = appDelegate.listTickets
                if self.ticketsList.count > 0 {
                    
                    FirebaseBR.shared.updateTickets(listTicketsUpdate: ticketListFB, completion: { (listTickets) in
                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                        self.ticketsList = listTickets
                        self.settingView()
                    })
                }else{
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    //                    self.viewTicketEmpty.isHidden = false
                    self.buttonAddTicketWallet.isHidden = !self.ticket360
                    self.ViewNoTickets.isHidden = self.ticket360
                    self.viewTicketEmpty.isHidden = !self.ticket360
                    
                }
                
                
            }
        }*/
    }
    
    func ticketsSendUser(ticket: String, email: String){
        
        FirebaseBR.shared.updateTicket(listTicketsUpdate: [ItemTicket()], ticket: ticket, email: email , completion: { listTickets, result   in
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
            
            if result == "folio"{
                self.tried = self.tried + 1
                if let floatingLabelTextField = self.textFolioTickets {
                    floatingLabelTextField.errorMessage = "lbl_code_form_ticket".getNameLabel()
                    floatingLabelTextField.text = ""
                    floatingLabelTextField.placeholderColor = Constants.COLORS.TICKETS.colorTextFieldRed
                    floatingLabelTextField.placeholder = "lbl_error_code_form_ticket".getNameLabel()
                    self.textFolio = false
                }
            }
            if result == "email"{
                self.tried = self.tried + 1
                if let floatingLabelTextField = self.textEmailTickets {
                    floatingLabelTextField.errorMessage = "lbl_email_form_ticket".getNameLabel()
                    floatingLabelTextField.text = ""
                    floatingLabelTextField.placeholderColor = Constants.COLORS.TICKETS.colorTextFieldRed
                    floatingLabelTextField.placeholder = "lbl_error_email_form_ticket".getNameLabel()
                    self.textEmail = false
                }
            }
            
            self.validationButton()
            if self.tried == 3 {
                self.goCallCenter()
            }
            
            if result == "success"{
               
                self.viewTicketEmpty.isHidden = true
                self.isFirstLoad = true
                self.ticketNew = listTickets
                self.ticketPre = self.ticketsList
                self.loadTickets()
            }
        })
    }
    
    func settingView(){
            //Reiniciamos el view wallet
            if self.ticketsList.count > 0 {
                //Reiniciamos la lista
                
                walletView.remove(cardViews: itemsCardViews)
//                itemsCardViews.removeAll()
//                itemsCardViews = [ColoredCardView]()
                if ticketNew.count > 0 {
                    let itemNew = ticketPre.filter({$0.barCode == ticketNew.first?.barCode})
                    if itemNew.count == 0 {
                        ticketsList.removeAll()
                        ticketsList.append(contentsOf: self.ticketNew)
                        //Analytics FB Event A
                        let uidUser = AppUserDefaults.value(forKey: .UserUID, fallBackValue: "")
                        AnalyticsBR.shared.saveEventContentFBTickets(content: self.ticketNew.first?.idCanalVenta ?? "", title: uidUser.stringValue, name: self.ticketNew.first?.barCode ?? "")
                        //Analytics FB Event B
                        AnalyticsBR.shared.saveEventContentFB(content: TagsID.tickets.rawValue, title: self.ticketNew.first?.idCanalVenta ?? "")
                    }else{
                        ticketsList.removeAll()
                    }
                }
                
                //Recorremos los tickets
                    for itemTicket in ticketsList{
                            let itemCard = ColoredCardView.nibForClass()
                            itemCard.itemTicket = itemTicket
                            itemCard.imgBarCode.image = Tools.shared.otherGenerateBarCode(string: itemTicket.barCode, barcodeMode: .Barcode)
                            itemCard.lblCodeBar.text = "\(itemTicket.barCode!)"
                            itemCard.statusTicket = itemTicket.status
                            itemCard.ticketViewController = self
                            itemsCardViews.append(itemCard)
                    }
                    let walletViewFrame = UIDevice().getHeightWalletSize()
                    let screenSize = UIScreen.main.bounds.size.height
                    walletViewBottomConstrain.constant =  (screenSize - walletViewFrame)
                    self.walletView.isHidden = false
                buttonAddTicketWallet.isHidden = !self.ticket360
                    walletView.reload(cardViews: itemsCardViews)
//                self.reloadInputViews()
            }
        }
    
    func openDetailComponent(sender: ButtonDetComponent){
        self.performSegue(withIdentifier: "toDetailTicket", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailTicket"{
            if let go = segue.destination as? DetailTicketViewController {
                //go.itemComponent = (sender as! ButtonDetComponent).itemComponent
                go.itemProduct = (sender as! ButtonDetComponent).itemProduct
            }
        }
    }
    
    
    @IBAction func btnActionOpenBuy(_ sender: UIButton) {
        print("Comprar")
        
        if appDelegate.optionsHome {
            let pageAttr = ["home_Xcaret_Buy": true]
            (AppDelegate.getKruxTracker()).trackPageView("E-Commerce", pageAttributes:pageAttr, userAttributes:nil)
            
            if !appDelegate.optionsHome{
                appDelegate.optionsHome = false
            }
            appDelegate.idAction = "promTicket"
            self.dismiss(animated: true)
            
            
        }else{
            let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_Xcaret_Buy": true]
            (AppDelegate.getKruxTracker()).trackPageView("E-Commerce", pageAttributes:pageAttr, userAttributes:nil)
            
            let mainNC = AppStoryboard.ParkXcaret.viewController(viewControllerClass: BookingViewController.self)
            if appDelegate.itemCuponActive.percent > 0 {
                mainNC.titleWebView = "\(appDelegate.itemParkSelected.name!) - \(appDelegate.itemCuponActive.percent) %"
            }else{
                mainNC.titleWebView = "\(appDelegate.itemParkSelected.name!)"
            }
            mainNC.callingCode = "Ticket"
            self.navigationController?.pushViewController(mainNC, animated: true)
        }
        
        
    }
    
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



