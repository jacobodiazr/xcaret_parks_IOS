//
//  popUpPreBuyViewController.swift
//  XCARET!
//
//  Created by Hate on 03/09/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit


class popUpPreBuyViewController: UIViewController {
    weak var delegatePreBuyProm : ManageBuyPromDelegate?
    weak var delegateGoBooking: GoBooking?
    var itemsPreciosSelect : [ItemProdProm] = [ItemProdProm]()
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblNoAplica: UILabel!
    @IBOutlet weak var textViewContentInfo: UITextView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var itemsProm : [ItemProdProm] = [ItemProdProm]()
    var buyItem : ItemCarshop = ItemCarshop()
    var dataCarShop : [ItemCarShoop] = [ItemCarShoop]()
    
    var acceptTerm = true
    var buyAll = false
    
    @IBOutlet weak var terminos: UILabel!
    @IBOutlet weak var viewTerminos: UIView!
    
    @IBOutlet weak var viewImgCheck: UIView!
    @IBOutlet weak var imgPalomaCheck: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.widthConstraint.constant = UIScreen.main.bounds.width * 0.85
        self.heghtConstraint.constant = UIScreen.main.bounds.height * 0.75
        
        var item = appDelegate.listlangsPromotions.filter({$0.uid.lowercased() == Constants.LANG.current.lowercased() && $0.prod_code.lowercased() == buyItem.promotionName.lowercased()})
        
        if item.count == 0 {
            item = appDelegate.listlangsPromotions.filter({$0.uid.lowercased() == Constants.LANG.current.lowercased() && $0.prod_code.lowercased() == "app"})
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ckecTerminos))
        self.viewImgCheck.addGestureRecognizer(tapRecognizer)
        
        let tapRecognizerGo = UITapGestureRecognizer(target: self, action: #selector(goTerminos))
        self.viewTerminos.addGestureRecognizer(tapRecognizerGo)
        
        lblTitle.text = "lbl_title_wininfo".getNameLabel()
        lblSubTitle.text = "lbl_subtitle_wininfo".getNameLabel()
//        lblDescription.text = item.first?.info_window
        lblNoAplica.text = "lbl_wininfo_noaplica".getNameLabel()
        btnOK.setTitle("lbl_accept".getNameLabel(), for: .normal)
        btnBack.setTitle("btn_back".getNameLabel(), for: .normal)
        terminos.text = "lbl_promotion_terms_and_condition".getNameLabel()
        var imagen = UIImage(named: "Promociones/images/promociones/id_pagos")
        
        
        textViewContentInfo.text = "\(item.first?.info_window ?? "")"
        
        
        if item.first?.prod_code == "Vivo_en_Quintana_Roo"{
            lblTitle.text = "lbl_title_wininfo_qroo".getNameLabel()
            lblSubTitle.text = "lbl_subtitle_wininfo_qroo".getNameLabel()
            imagen = UIImage(named:
            "Promociones/images/promociones/id_quintanaroo")
        }
        
        if imagen == nil{
            imagen = UIImage(named: "Parks/\(String(describing: itemsProm.first?.code_park.uppercased()))/Activities/ThumbsNew/ok")
        }
        self.img.image = imagen
        
        
        

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popUpCheck" {
            if let vc = segue.destination as? PopUpHomeViewController{
                vc.typePopUP = "tyc"
                vc.itemsPreciosSelect = self.itemsPreciosSelect
                vc.itemProdProm = self.itemsProm
            }
        }
    }
    
    
    var timerForShowScrollIndicator: Timer?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        startTimerForShowScrollIndicator()
    }
    
    @objc func showScrollIndicatorsInContacts() {
        UIView.animate(withDuration: 0.001) {
            self.textViewContentInfo.flashScrollIndicators()
        }
    }
    
    func startTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: true)
    }
    
    @objc func ckecTerminos(){
        
        if acceptTerm {
            imgPalomaCheck.isHidden = true
            viewImgCheck.borderWidth = 1
            viewImgCheck.borderColor = .lightGray
            viewImgCheck.backgroundColor = .clear
            btnOK.isEnabled = false
            btnOK.alpha = 0.5
        }else{
            imgPalomaCheck.isHidden = false
            viewImgCheck.borderWidth = 0
            viewImgCheck.backgroundColor = .systemGreen
            btnOK.isEnabled = true
            btnOK.alpha = 1
        }
        acceptTerm = !acceptTerm
    }
    
    
    @objc func goTerminos(){
        performSegue(withIdentifier: "popUpCheck", sender: nil)
    }
   
    
    @IBAction func btnRegresar(_ sender: Any) {
        self.dismiss(animated: true)
//        self.delegatePreBuyProm?.sendPreBuyPromBook()
    }
    
    @IBAction func btnAceptar(_ sender: Any) {
        self.dismiss(animated: true){
            
            if !CheckInternet.Connection() {
                UpAlertView(type: .error, message: "lbl_err_not_network".getNameLabel()).show {
                    print("Error")
                }
            }else{
                if self.buyAll {
                    self.delegateGoBooking?.goBookingAll()
                }else{
                    self.delegateGoBooking?.goBooking(buyItem: self.buyItem, dataCarShop: self.dataCarShop)
                }
//                let item = self.itemsProm
//                if appDelegate.optionsHome {
//                    AnalyticsBR.shared.saveEventContentsTypePromoPopUp(ItemName: item.first?.code_park.uppercased() ?? "", promotionID: item.first?.code_landing ?? "", promotionName: item.first?.code_promotion ?? "", coupon: item.first?.cupon_promotion ?? "", contentType: "HM_\(TagsContentAnalytics.Navigation.rawValue)")
//                }else{
//                    AnalyticsBR.shared.saveEventContentsTypePromoPopUp(ItemName: item.first?.code_park.uppercased() ?? "", promotionID: item.first?.code_landing ?? "", promotionName: item.first?.code_promotion ?? "", coupon: item.first?.cupon_promotion ?? "", contentType: "\(item.first?.code_park.uppercased() ?? "")_\(TagsContentAnalytics.Navigation.rawValue)")
//                }
////                self.dismiss(animated: true)
//                self.delegatePreBuyProm?.sendPreBuyProm(itemProm: item)
            }
        }
    }
    
    
}
