//
//  DatosTarjetaViewController.swift
//  XCARET!
//
//  Created by YEiK on 12/05/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit
import AVFoundation
import TapCardScanner_iOS
import SwiftSVG

class DatosTarjetaViewController: UIViewController {
    
    weak var delegateFinalBuyStepGoTicket: FinalBuyStepGoTicket?
    
    var itemCarShoop : [ItemCarShoop] = [ItemCarShoop]()
    var buyItem: ItemCarshop = ItemCarshop()
    var allItems : ItemListCarshop = ItemListCarshop()
    var itemCompradorAllItems = ItemCarShoop()
    @IBOutlet weak var viewImgBack: UIView!
    @IBOutlet weak var cardConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var cardConstraintWidth: NSLayoutConstraint!
//    @IBOutlet weak var camaraView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var camaraView: UIButton!
    
    @IBOutlet weak var editarTarjetaButton: UIButton!
    @IBOutlet weak var collectionConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var tituloMesesLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var tarjetasParticipantesBtn: UIButton!
    @IBOutlet weak var collectionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentInsertDataView: UIView!
    @IBOutlet weak var siguienteButton: UIButton!
    @IBOutlet weak var siguienteView: UIView!
    @IBOutlet weak var visaMasterIcon: UIImageView!
    @IBOutlet weak var bankLogo: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var viewShadowCard: UIView!
    @IBOutlet weak var viewContentData: UIView!
    //    @IBOutlet weak var viewCardColores: GradientView!
    @IBOutlet weak var viewCardColores: Gradient!
    let layerGradient = CAGradientLayer()
    var colors = [CGColor]()
    
    var yPositionMaxField: CGFloat = 0.0
    var dataUserCard = true
    var cardNumberSave : String = ""
    var apiIsOK = true
    var apiCardOk = true
    
    @IBOutlet weak var collectionViewData: UICollectionView!{
        didSet{
            self.collectionViewData.register(UINib.init(nibName: "InputCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InputCollectionViewCell")
            self.collectionViewData.register(UINib.init(nibName: "MesesSICollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MesesSI")
        }
    }
    
    
    var inputs: [InputType] = [.cardNumber, .name, .expirationDate, .cvv]
    var userCard = CreditCard()
    var msiSelected = 0
    
    var banksInfo: Banks?
    var cardInfo : ItemCardInfo?
    var banks: Bank?
    var finishDataCard = false
    
    var buyAll = false
    
    lazy var fullScanner:TapFullScreenCardScanner = TapFullScreenCardScanner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        siguienteView.isHidden = true
        titleLbl.text = "lbl_payment_title".getNameLabel()
        editarTarjetaButton.setTitle("lbl_add_plus_edit_card".getNameLabel(), for: .normal)
        siguienteButton.setTitle("lbl_buy_buy".getNameLabel(), for: .normal)
        tarjetasParticipantesBtn.setTitle("lbl_add_plus_participating_cards".getNameLabel(), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        collectionViewData.delegate = self
        collectionViewData.dataSource = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        self.viewImgBack.addGestureRecognizer(tapRecognizer)
        
        camaraView.isHidden = false
        
        editarTarjetaButton.isHidden = true
        tituloMesesLbl.isHidden = true
        totalLbl.isHidden = true
        tarjetasParticipantesBtn.isHidden = true
        
        siguienteButton.isHidden = false
        siguienteView.isHidden = true
        visaMasterIcon.isHidden = true
        bankLogo.isHidden = true
        
        collectionTopConstraint.constant = -10
        
        cardConstraintWidth.constant = UIScreen.main.bounds.width * 0.92
        cardConstraintHeight.constant = 220//UIScreen.main.bounds.height * 0.32
        collectionConstraintHeight.constant = 100// UIScreen.main.bounds.height * 0.1
        
        requestInfoBanks()
        
        
    }
    func udpdateGradientLayer(colors: [CGColor]){
        self.colors = colors
        layerGradient.removeFromSuperlayer()
        layerGradient.frame = viewCardColores.bounds
        layerGradient.colors = colors
        layerGradient.cornerRadius = 15
        layerGradient.startPoint = CGPoint(x: 0, y: 1) // Top left corner.
        layerGradient.endPoint = CGPoint(x: 1, y: 0) // Bottom right corner.
        viewCardColores.layer.insertSublayer(layerGradient, below: camaraView.layer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let colorShadow = UIColor(red: 135/255, green: 171/255, blue: 192/255, alpha: 1.0)
        let colorDefault = UIColor(red: 105/255, green: 159/255, blue: 224/255, alpha: 1.0)
        viewShadowCard.dropShadow(color: colorShadow, opacity: 0.8, offSet: CGSize(width: 0, height: 10), radius:10, scale: true, corner: 15, backgroundColor: colorDefault)
        self.focusIn(index: 0)
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        FirebaseDB.shared.getListCarShop (completion : {(itemListCarshop) in
            appDelegate.listItemListCarshop = itemListCarshop
            self.allItems = itemListCarshop.first ?? ItemListCarshop()
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
        })
    }
    
    func requestInfoBanks(){
        FirebaseBR.shared.getBanksInfo(itemsCarShoop : self.itemCarShoop.first ?? ItemCarShoop() , completion: { (isSuccess, banks) in
            if isSuccess {
                self.banksInfo = banks
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
            }else{
                self.dismiss(animated: true, completion: nil)
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                let mainNC = AppStoryboard.AlertDefault.instance.instantiateViewController(withIdentifier: "AlertDefault") as! AlertDefaultViewController
                mainNC.modalPresentationStyle = .overFullScreen
                mainNC.modalTransitionStyle = .crossDissolve
                mainNC.configAlert(type: .disconnectionAPI, heightC: 250, texto: "lbl_dialog_card_api_error".getNameLabel())
                self.present(mainNC, animated: true, completion: nil)
                
            }
            
        })
    }
    
    
//    @objc func keyboardWillShow(sender: NSNotification) {
//        print("Muestra Teclado")
//        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//            return
//        }
////        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
////            self.view.frame.origin.y = -70 // Move view 150 points upward
////        }
//    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.75, animations: { () -> Void in
                print(self.setScrollViewPosition(keyboardRect: keyboardHeight))
            self.viewContentData.frame.origin.y = self.setScrollViewPosition(keyboardRect: keyboardHeight)
            })
        }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
//        if finishDataCard {
            UIView.animate(withDuration: 0.75, animations: { () -> Void in
             self.viewContentData.frame.origin.y = 0 // Move view to original position
            })
//        }
    }
    
//    @objc func keyboardWillchange(notification: Notification){
//        var moveScrollY : CGFloat = 0
//        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//            return
//        }
//
//        if notification.name == UIResponder.keyboardWillShowNotification ||
//            notification.name == UIResponder.keyboardWillChangeFrameNotification {
//            moveScrollY = self.setScrollViewPosition(keyboardRect: keyboardRect.height)
//        }
//
//        UIView.animate(withDuration: 0.75, animations: { () -> Void in
//            self.view.frame.origin.y = moveScrollY
//        })
//    }
    
    func setScrollViewPosition(keyboardRect: CGFloat) -> CGFloat{
        var moveScroll: CGFloat = 0
//        //Calculamos la altura de la pantalla
//        let screenSize : CGRect = UIScreen.main.bounds
//        let screenHeight : CGFloat = screenSize.height
//        let heightContent = 504.0//contentInsertDataView.bounds.height
//        let auxheightContent = contentInsertDataView.bounds.height
//        let auxheightContent2 = contentInsertDataView.layer.bounds.height
//        let auxheightContent3 = contentInsertDataView.layer.frame.height
//        let yPositioncollectionView = collectionViewData.layer.frame.origin.y
//        let heightField = collectionViewData.collectionViewLayout.collectionViewContentSize.height - yPositioncollectionView
//        let Ymax = keyboardRect + 50
//
//        let yPositionContent = heightContent - heightField
        
        moveScroll = UIDevice().getTopKeyBoardDataCard()
        
        
//        if yPositionMaxField == 0.0 {
//            yPositionMaxField = heightContent - heightField
//        }
//
////        let Ymax = keyboardRect + 50
//        let aux = yPositionMaxField
//        if yPositionMaxField > Ymax {
//            moveScroll = Ymax - yPositionMaxField
//        }
        
        return moveScroll
    }
    
    @IBAction func goTP(_ sender: Any) {
        performSegue(withIdentifier: "goTP", sender: nil)
    }
    
    @objc func goBack(){
        appDelegate.listItemListCarshopReservation.removeAll()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showCVVInfo(){
        performSegue(withIdentifier: "goCCV", sender: nil)
    }
    
    @IBAction func goAnimateBuy(_ sender: Any) {
        
        let aux = cardInfo
        let cardNumber = userCard.cardNumber.replacingOccurrences(of: " ", with: "")
        let expirationdate = userCard.expirationDate.components(separatedBy: "/")
        if buyAll {
            itemCompradorAllItems.itemCreditCard.creditCard = userCard
            itemCompradorAllItems.itemCreditCard.creditCard.cardNumber = cardNumber
            itemCompradorAllItems.itemCreditCard.creditCard.expirationDateMonth = expirationdate[0]
            itemCompradorAllItems.itemCreditCard.creditCard.expirationDateYear = expirationdate[1]
            itemCompradorAllItems.itemCreditCard.itemCardInfo = cardInfo ?? ItemCardInfo()
            itemCompradorAllItems.itemCreditCard.banks.cardTypes = banksInfo?.cardTypes.filter({ $0.cardTypeCode == cardInfo?.cardTypeCode}) ?? [CardType]() //(banksInfo?.cardTypes.filter({ $0.idCardType == cardInfo?.cardTypeCode}))! //?? [CardType]()
            var bankId = banksInfo?.banks.filter({ $0.idBank == Int(cardInfo?.idBanco ?? "0")}) ?? [Bank]()
            if bankId.count == 0 {
                bankId = banksInfo?.banks.filter({ $0.idBank == 109}) ?? [Bank]()
            }
            itemCompradorAllItems.itemCreditCard.banks.banks = bankId//banksInfo?.banks.filter({ $0.idBank == Int(cardInfo?.idBanco ?? "0")}) ?? [Bank]()
            banks?.status = itemCarShoop.first?.itemCreditCard.bank.status
            banks?.bankInstallmentsIndexSelect = itemCarShoop.first?.itemCreditCard.bank.bankInstallmentsIndexSelect
            itemCompradorAllItems.itemCreditCard.bank = banks ?? Bank()
        }else{
            itemCarShoop.first?.itemCreditCard.creditCard = userCard
            itemCarShoop.first?.itemCreditCard.creditCard.cardNumber = cardNumber
            itemCarShoop.first?.itemCreditCard.creditCard.expirationDateMonth = expirationdate[0]
            itemCarShoop.first?.itemCreditCard.creditCard.expirationDateYear = expirationdate[1]
            itemCarShoop.first?.itemCreditCard.itemCardInfo = cardInfo ?? ItemCardInfo()
            itemCarShoop.first?.itemCreditCard.banks.cardTypes = banksInfo?.cardTypes.filter({ $0.cardTypeCode == cardInfo?.cardTypeCode}) ?? [CardType]() //(banksInfo?.cardTypes.filter({ $0.idCardType == cardInfo?.cardTypeCode}))! //?? [CardType]()
            var bankId = banksInfo?.banks.filter({ $0.idBank == Int(cardInfo?.idBanco ?? "0")}) ?? [Bank]()
            if bankId.count == 0 {
                bankId = banksInfo?.banks.filter({ $0.idBank == 109}) ?? [Bank]()
            }
            itemCarShoop.first?.itemCreditCard.banks.banks = bankId// banksInfo?.banks.filter({ $0.idBank == Int(cardInfo?.idBanco ?? "0")}) ?? [Bank]()
            banks?.status = itemCarShoop.first?.itemCreditCard.bank.status
            banks?.bankInstallmentsIndexSelect = itemCarShoop.first?.itemCreditCard.bank.bankInstallmentsIndexSelect
            itemCarShoop.first?.itemCreditCard.bank = banks ?? Bank()
//            itemCarShoop.first?.itemCreditCard.bank.bankInstallmentsIndexSelect = itemCarShoop.first?.itemCreditCard.bank.bankInstallmentsIndexSelect
//            itemCarShoop.first?.itemCreditCard.bank.status = itemCarShoop.first?.itemCreditCard.bank.status
        }
        performSegue(withIdentifier: "goAnimateBuy", sender: nil)
    }
    
    @IBAction func editDataCard(_ sender: Any) {
        editDC()
    }
    
    func editDC(){
        collectionViewData.isHidden = false
        collectionConstraintHeight.constant = UIScreen.main.bounds.height * 0.10
        dataUserCard = true
        camaraView.isHidden = false
        
        editarTarjetaButton.isHidden = true
        tituloMesesLbl.isHidden = true
        totalLbl.isHidden = true
        tarjetasParticipantesBtn.isHidden = true
        
        siguienteButton.isHidden = true
        siguienteView.isHidden = true
        visaMasterIcon.isHidden = true
        bankLogo.isHidden = true
        
        collectionTopConstraint.constant = -10
        collectionConstraintHeight.constant = 100
        collectionViewData.reloadData()
        enterTextEvent(text: userCard.cardNumber, kind: .cardNumber)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goAnimateBuy" {
            if let vc = segue.destination as? AnimateBuyViewController{
                vc.itemCarShoop = itemCarShoop
                vc.buyItem = buyItem
                vc.buyAll = buyAll
                vc.allItems = allItems
                vc.delegateFinalBuyStepGoTicket = self
                vc.delegateFinalBuyStepReintentar = self
                vc.itemCompradorAllItems = itemCompradorAllItems
            }
        }
    }
    
    @IBAction func showScanner(_ sender: Any) {
        self.openScanner()
    }
    
    func openScanner(with customiser: TapFullScreenUICustomizer = .init()){
        // First grant the authorization to use the camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] response in
            if response {
                //access granted
                DispatchQueue.main.async {[weak self] in
                    do {
                        try self?.fullScanner.showModalScreen(presenter: self!,tapCardScannerDidFinish: { [weak self] (scannedCard) in
                            
                            let alert:UIAlertController = UIAlertController(title: "lbl_cam_card_data".getNameLabel(),
                                                                            message: "\("lbl_add_plus_card_number".getNameLabel()): \(scannedCard.tapCardNumber ?? "")\n\("lbl_add_plus_full_name".getNameLabel()): \(scannedCard.tapCardName ?? "")\n\("lbl_add_plus_date_expiry".getNameLabel()): \(scannedCard.tapCardExpiryMonth ?? "")/\(scannedCard.tapCardExpiryYear ?? "")\n", preferredStyle: .alert)
                            
                            let cancelAlertAction: UIAlertAction = UIAlertAction(title: "lbl_cam_cancel".getNameLabel(), style: .destructive) { (_) in
                                
                            }
                            
                            let stopAlertAction: UIAlertAction = UIAlertAction(title: "lbl_cam_add".getNameLabel(), style: .cancel) { (_) in
                                self?.userCard.cardNumber = scannedCard.tapCardNumber ?? ""
                                self?.userCard.expirationDate = "\(scannedCard.tapCardExpiryMonth ?? "")/\(scannedCard.tapCardExpiryYear ?? "")"
                                self?.userCard.name = scannedCard.tapCardName ?? ""
                                self?.fillFromObject(isCallingFromCapture: true)
                                self?.collectionViewData.reloadData()
                            }
                            
                            alert.addAction(stopAlertAction)
                            alert.addAction(cancelAlertAction)
                            
                            DispatchQueue.main.async { [weak self] in
                                self?.present(alert, animated: true, completion: nil)
                            }
                        },scannerUICustomization: customiser)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }else {
                
            }
        }
    }
    
}


extension DatosTarjetaViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView.tag == 1{
//            return bankSelectedForPAy != nil ? bankSelectedForPAy!.bankInstallments.count : 0
//        }else{
            
//        }
        
        if dataUserCard {
            return inputs.count
        }else{
            return banks?.bankInstallments.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if dataUserCard {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InputCollectionViewCell", for: indexPath as IndexPath) as! InputCollectionViewCell
            
            var text = ""
            
            switch inputs[indexPath.item] {
            case .cardNumber:
                text = userCard.cardNumber
            case .cvv:
                text = userCard.cvv
                cell.infoBtn.addTarget(self, action: #selector(showCVVInfo), for: .touchUpInside)
            case .expirationDate:
                text = userCard.expirationDate
            case .name:
                text = userCard.name
            }
            
            cell.delegateInput = self
            cell.inputConfiguration(inputs[indexPath.item], index: indexPath.item, text: text)
            if indexPath.row == 0 {
                cell.focus()
            }
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MesesSI", for: indexPath as IndexPath) as! MesesSICollectionViewCell
            let msiOrder = banks?.bankInstallments.sorted(by: { $0.installments < $1.installments })
            cell.configBtnMSI(itemBankInstallment: (msiOrder?[indexPath.row]) ?? BankInstallment())
            if indexPath.row == 0 {
                let indexPath = IndexPath(item: 0 , section: 0)
                DispatchQueue.main.async {
                    self.collectionViewData.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if dataUserCard {
            let aux = inputs[indexPath.item]
            print(aux)
        }else{
            let aux = banks?.bankInstallments[indexPath.item]
            print(aux as Any)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionBounds = collectionView.bounds
        let height: CGFloat = collectionBounds.height
        
        if dataUserCard{
            switch inputs[indexPath.item] {
            case .cardNumber:
                return CGSize(width: 220, height: height)
            case .name:
                return CGSize(width: 250, height: height)
            case .expirationDate:
                return CGSize(width: 170, height: height)
            case .cvv:
                return CGSize(width: 150, height: height)
            }
        }else{
            return CGSize(width: UIScreen.main.bounds.width * 0.30, height: UIScreen.main.bounds.height * 0.09)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemCarShoop.first?.itemCreditCard.bank.bankInstallmentsIndexSelect = indexPath.row
    }
}

extension DatosTarjetaViewController: InputDelegate {
    
    func cancel() {
        dismiss(animated : true)
    }
    
    func enterTextEvent(text: String, kind: InputType) {
        switch kind {
        case .name:
            userCard.name = text
        case .cardNumber:
            userCard.cardNumber = text
        case .expirationDate:
            userCard.expirationDate = text
        case .cvv:
            userCard.cvv = text
        }
        self.fillFromObject()
    }
    
    func fillFromObject(isCallingFromCapture: Bool = false){
        msiSelected = 0
        var numberCardToShow = ""
        var userCardNumber = userCard.cardNumber.replacingOccurrences(of: " ", with: "")
        userCardNumber.enumerated().forEach { (index, character) in
            // Add space every 4 characters
            if index % 4 == 0 && index > 0 {
                numberCardToShow += "   "
            }
            
            if index < 12 {
                // Replace the first 12 characters by *
                numberCardToShow += "*"
            } else {
                // Add the last 4 characters to your final string
                numberCardToShow.append(character)
            }
        }
        
        cardNumber.text = numberCardToShow
        
        userCardNumber = userCardNumber.count >= 6
        ? String(userCardNumber.prefix(6))
        : ""
        
        print("El count de la tarjeta es \(userCardNumber)")
        
        if ((userCardNumber.count == 6 && userCardNumber.prefix(6) != cardNumberSave) || isCallingFromCapture){
            cardNumberSave = userCardNumber
            if self.banksInfo == nil {
                self.requestInfoBanks()
            }
            
            FirebaseBR.shared.getCardInfo2(bin: userCardNumber, completion: { (isSuccess, itemCardInfo, statusCode) in
                print(isSuccess)
                print(itemCardInfo)
                print(statusCode)
                if isSuccess {
                    self.apiIsOK = true
                    self.apiCardOk = true
                    self.cardInfo = itemCardInfo
                    
                    if let image = itemCardInfo.cardType(bankType: self.cardInfo?.cardTypeCode ?? ""){
                        UIView.animate(withDuration: 0.3) {
                            self.visaMasterIcon.isHidden = false
                            self.visaMasterIcon.image = image
                        }
                    }else{
                        self.visaMasterIcon.isHidden = true
                    }
                    
                    if let typeCard = itemCardInfo.imageBank(bank : self.cardInfo?.bank ?? "" ){
                        UIView.animate(withDuration: 0.3) {
                            self.bankLogo.isHidden = false
                            self.bankLogo.image = typeCard
                        }
                    }else{
                        self.bankLogo.isHidden = true
                    }
                    
                    UIView.animate(withDuration: 0.3) {
                        switch self.cardInfo?.cardTypeCode {
                        case "VI":
                            print("VI")
                            let colorVI2 = UIColor(red: 166/255, green: 169/255, blue: 218/255, alpha: 1.0).cgColor
                            let colorVI1 = UIColor(red: 255/255, green: 229/255, blue: 159/255, alpha: 1.0).cgColor
                            self.udpdateGradientLayer(colors: [colorVI1, colorVI2])
                        case "DN":
                            let colorDN2 = UIColor(red: 108/255, green: 156/255, blue: 218/255, alpha: 1.0).cgColor
                            let colorDN1 = UIColor(red: 172/255, green: 207/255, blue: 244/255, alpha: 1.0).cgColor
                            self.udpdateGradientLayer(colors: [colorDN1, colorDN2])
                        case "DS":
                            let colorDS2 = UIColor(red: 250/255, green: 184/255, blue: 146/255, alpha: 1.0).cgColor
                            let colorDS1 = UIColor(red: 255/255, green: 234/255, blue: 190/255, alpha: 1.0).cgColor
                            self.udpdateGradientLayer(colors: [colorDS1, colorDS2])
                        case "AX":
                            let colorAX2 = UIColor(red: 144/255, green: 193/255, blue: 235/255, alpha: 1.0).cgColor
                            let colorAX1 = UIColor(red: 248/255, green: 249/255, blue: 250/255, alpha: 1.0).cgColor
                            self.udpdateGradientLayer(colors: [colorAX1, colorAX2])
                        case "MC":
                            let colorMC3 = UIColor(red: 255/255, green: 151/255, blue: 162/255, alpha: 1.0).cgColor
                            let colorMC2 = UIColor(red: 255/255, green: 185/255, blue: 143/255, alpha: 1.0).cgColor
                            let colorMC1 = UIColor(red: 255/255, green: 216/255, blue: 161/255, alpha: 1.0).cgColor
                            self.udpdateGradientLayer(colors: [colorMC1, colorMC2, colorMC3])
                        case "JC":
                            let colorJC3 = UIColor(red: 202/255, green: 240/255, blue: 191/255, alpha: 1.0).cgColor
                            let colorJC2 = UIColor(red: 255/255, green: 183/255, blue: 197/255, alpha: 1.0).cgColor
                            let colorJC1 = UIColor(red: 179/255, green: 219/255, blue: 255/255, alpha: 1.0).cgColor
                            self.udpdateGradientLayer(colors: [colorJC1, colorJC2, colorJC3])
                        default:
                            print("default")
                            let colorDefault = UIColor(red: 105/255, green: 159/255, blue: 224/255, alpha: 1.0).cgColor
                            self.udpdateGradientLayer(colors: [colorDefault, colorDefault])
                        }
                    }
                    
                }else{
                    if statusCode == "" {
                        self.apiIsOK = false
                    }else if statusCode == "500"{
                        self.apiCardOk = false
                    }
                    
                }
            })
        }else if userCardNumber.count < 6{
            cardNumberSave = ""
            self.visaMasterIcon.isHidden = true
            self.bankLogo.isHidden = true
            let colorDefault = UIColor(red: 105/255, green: 159/255, blue: 224/255, alpha: 1.0).cgColor
            UIView.animate(withDuration: 0.3) {
                self.udpdateGradientLayer(colors: [colorDefault, colorDefault])
            }
        }
            
    }
    
    
    func focusInNext(index: Int){
        changeFocus(index: index)
    }
    
    func focusThePrevious(index: Int) {
        changeFocus(index: index, next: false)
    }
    
    func finalizeCapturing() {
        if userCard.cardNumber.count >= 15, !userCard.name.isEmpty, userCard.cvv.count >= 3, userCard.expirationDate.count == 5{
            self.view.frame.origin.y = 0
            self.verifyIfCanPayMsi()
        }else{
            UpAlertView(type: .error, message: "Ingrese todos los datos de su tarjeta").show {
                self.focusIn(index: 0)
            }
        }
    }
    
    
    
    func verifyIfCanPayMsi(){
        print("Encontro info de los bancos \(self.banksInfo == nil)?")
        if apiCardOk && apiIsOK {
            let idBanco = cardInfo?.idBanco
            if let banksInfoMSI = banksInfo?.banks.filter({String($0.idBank) == idBanco}){
                if (banksInfoMSI.first?.bankInstallments.count ?? 0) > 1 && cardInfo?.type.lowercased() != "debit"{
                    itemCarShoop.first?.itemCreditCard.bank.status = true
                    banks = banksInfoMSI.first
                    camaraView.isHidden = true
                    
                    editarTarjetaButton.isHidden = false
                    tituloMesesLbl.isHidden = false
                    tituloMesesLbl.text = "lbl_payment_month_pay".getNameLabel()
                    totalLbl.isHidden = false
                    tarjetasParticipantesBtn.isHidden = false
                    tarjetasParticipantesBtn.setTitle("lbl_add_plus_participating_cards".getNameLabel(), for: .normal)
                    siguienteButton.isHidden = false
                    siguienteView.isHidden = false
                    collectionConstraintHeight.constant = UIScreen.main.bounds.height * 0.10
                    collectionViewData.isHidden = false
                    collectionTopConstraint.constant = 98.5
                    dataUserCard = false
                    collectionViewData.reloadData()
                    itemCarShoop.first?.itemCreditCard.bank.bankInstallmentsIndexSelect = 0
                }else{
    //                siguienteButton.isHidden = false
    //                siguienteView.isHidden = false
                    itemCarShoop.first?.itemCreditCard.bank.status = false
                    camaraView.isHidden = true
                    editarTarjetaButton.isHidden = false
                    tituloMesesLbl.isHidden = false
                    tituloMesesLbl.text = "lbl_payment_total_pay".getNameLabel()
                    totalLbl.isHidden = false
                    tarjetasParticipantesBtn.isHidden = false
                    tarjetasParticipantesBtn.setTitle("lbl_payment_months_without_interest".getNameLabel(), for: .normal)
                    siguienteButton.isHidden = false
                    siguienteView.isHidden = false
                    collectionConstraintHeight.constant = 0//UIScreen.main.bounds.height * 0.10
                    collectionViewData.isHidden = true
                    collectionTopConstraint.constant = 98.5
                    dataUserCard = false
                }
            }else{
                siguienteButton.isHidden = false
                siguienteView.isHidden = false
            }
            let auxallItems = allItems
            let auxabuyItem = buyItem
            if buyAll {
                totalLbl.text = allItems.totalPrice.currencyFormat()
            }else{
                totalLbl.text = buyItem.discountPrice.currencyFormat()
            }
        }else{
            print(self.cardNumberSave)
            LoadingView.shared.showActivityIndicator(uiView: self.view)
            FirebaseBR.shared.getCardInfo2(bin: self.cardNumberSave, completion: { (isSuccess, itemCardInfo, statusCode) in
                if isSuccess {
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    self.apiIsOK = true
                    self.apiCardOk = true
                    self.verifyIfCanPayMsi()
                    self.cardInfo = itemCardInfo
                }else{
                    self.siguienteView.isHidden = true
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    if statusCode == "" {
                            let mainNC = AppStoryboard.AlertDefault.instance.instantiateViewController(withIdentifier: "AlertDefault") as! AlertDefaultViewController
                            mainNC.modalPresentationStyle = .overFullScreen
                            mainNC.modalTransitionStyle = .crossDissolve
                            mainNC.configAlert(type: .disconnectionAPI, heightC: 250.0, texto: "lbl_dialog_card_api_error".getNameLabel())
                            self.present(mainNC, animated: true, completion: nil)
                    }else if statusCode == "500"{
                        let mainNC = AppStoryboard.AlertDefault.instance.instantiateViewController(withIdentifier: "AlertDefault") as! AlertDefaultViewController
                        mainNC.modalPresentationStyle = .overFullScreen
                        mainNC.modalTransitionStyle = .crossDissolve
                        mainNC.configAlert(type: .errorCard, heightC: 250.0, texto: "lbl_dialog_card_error".getNameLabel())
                        self.present(mainNC, animated: true, completion: nil)
                    }
                    
                }
            })
        }
        
    }
    
    func focusIn(index: Int){
        collectionViewData.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally , animated: true)
    }
    
    
    func changeFocus(index: Int, next: Bool = true){
        let pos = next ? index+1 : index-1
        
        let next = IndexPath(item: pos, section: 0)
        collectionViewData.scrollToItem(at: next, at: .centeredHorizontally, animated: true)
        
        self.view.isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            if let cell = self.collectionViewData.cellForItem(at: next) as? InputCollectionViewCell{
                cell.focus()
            }
            
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func configPrice(){
        var subtotal = 0.0
        var ahorro = 0.0
        
//        let itemsAvailabilityStatus = appDelegate.listItemListCarshop.first?.detail
//        let itemsAvailabilityStatusAUX = appDelegate.listItemListCarshop
//
//        let aux = appDelegate.listItemListCarshop
        
        for itemsCarShoop in (appDelegate.listItemListCarshop.first?.detail.filter({$0.status == 1}) ?? [ItemCarshop]()) {
            if itemsCarShoop.products.count > 1{
                var availabilityStatusPack = true
                for itemsProducts in itemsCarShoop.products {
                    
                    if itemsProducts.availabilityStatus == false{
                        availabilityStatusPack = false
                    }
                }
                if availabilityStatusPack {
                    subtotal = subtotal + itemsCarShoop.discountPrice
                    ahorro = ahorro + itemsCarShoop.saving
                }else{
                    subtotal = subtotal + 0.0
                    ahorro = ahorro + 0.0
                }
            }else{
                if itemsCarShoop.products.first?.availabilityStatus ?? false {

                    subtotal = subtotal + itemsCarShoop.discountPrice
                    ahorro = ahorro + itemsCarShoop.saving
                }else{
                    subtotal = subtotal + 0.0
                    ahorro = ahorro + 0.0
                }
            }
        }
        
        updateTotalPrices(key: "totalPrice", value: subtotal)
        updateTotalPrices(key: "totalDiscountPrice", value: ahorro)
        
//        self.subTotalLbl.text = subtotal.currencyFormat()
//        self.ahorroLbl.text = ahorro.currencyFormat()
//
        FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
            appDelegate.listItemListCarshop = itemsPickup
            self.allItems = itemsPickup.first ?? ItemListCarshop()
        })
    }
    
    func updateTotalPrices(key : String, value : Double){
        FirebaseBR.shared.updateKeyCarShop(key: key, value : value, completion: { result in
            print(result)
        })
    }
    
}

extension DatosTarjetaViewController : FinalBuyStepReintentar, FinalBuyStepGoTicket {
    func reintentar() {
        
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        FirebaseDB.shared.getListCarShop (completion : {(itemListCarshop) in
            appDelegate.listItemListCarshop = itemListCarshop
            self.allItems = itemListCarshop.first ?? ItemListCarshop()
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
            self.configPrice()
            self.editDC()
            self.focusIn(index: 0)
        })
    }
    
    func goTicket() {
        self.dismiss(animated: false, completion: nil)
        self.delegateFinalBuyStepGoTicket?.goTicket()
    }
}
