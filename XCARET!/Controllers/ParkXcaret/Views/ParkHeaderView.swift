//
//  ParkHeaderView.swift
//  XCARET!
//
//  Created by Angelica Can on 7/15/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ParkHeaderView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cornerDropShadowView : UIView!
    @IBOutlet weak var topLogoContraint: NSLayoutConstraint!
    @IBOutlet weak var logoPark : UIImageView!
    @IBOutlet weak var btnBooking : UIButton!
    @IBOutlet weak var viewDiscount : UIView!
    @IBOutlet weak var lblDiscount : UILabel!
    let codePark = appDelegate.itemParkSelected.code!
//    @IBOutlet weak var bottomCornerDrop: NSLayoutConstraint!
    
    weak var detailParkViewController : DetailParkViewController?
    var typeView : String! {
        didSet{
            setImageBackground()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        switch appDelegate.itemParkSelected.code {
        case "XS":
            self.cornerDropShadowView.setTrapecioShadow()
        case "XV":
            self.cornerDropShadowView.backgroundColor = UIColor.clear
            let imageName = "Headers/XV/textura"
            let image = UIImage(named: imageName)
            let imageViewC = UIImageView(image: image!)
            imageViewC.frame = CGRect(x: 0, y: 0, width: self.cornerDropShadowView.frame.size.width, height: 70)
            cornerDropShadowView.addSubview(imageViewC)
        default:
            self.cornerDropShadowView.setOvalShadow()
        }
        self.topLogoContraint.constant = UIDevice().getTopLogo()
        self.logoPark.image = UIImage(named: "Logos/logo\(appDelegate.itemParkSelected.code ?? "Logos/logoGroup")")
        self.layoutIfNeeded()
        if appDelegate.itemParkSelected.code == "XV" || appDelegate.itemParkSelected.code == "XO"{
            logoPark.heightAnchor.constraint(equalTo: logoPark.widthAnchor, multiplier: 1.0/2.0).isActive = true
        }
        if appDelegate.itemParkSelected.code == "XF" {
            self.cornerDropShadowView.setOvalShadow(color: Constants.COLORS.GENERAL.customDarkMode)
            self.btnBooking.shadowColor = .black
        }
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        if appDelegate.itemParkSelected.code == "XH" && year == 2020 {
            self.logoPark.image = UIImage(named: "Logos/logo\(appDelegate.itemParkSelected.code ?? "Logos/logoGroup")25")
            logoPark.heightAnchor.constraint(equalTo: logoPark.widthAnchor, multiplier: 3.0/4.0).isActive = true
        }
    }
    
    @IBAction func btnSendDetail(_ sender: UIButton) {
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.ParkDetail.rawValue, title: TagsID.goBooking.rawValue)
        /*SF*/
        let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_ParkBuy": true]
        (AppDelegate.getKruxTracker()).trackPageView("ParkDetail", pageAttributes:pageAttr, userAttributes:nil)
        /**/
//        self.detailParkViewController?.showDetailPark()
        
        
        if !CheckInternet.Connection() {
            UpAlertView(type: .error, message: "lblErrNotNetwork".localized()).show {
                print("Error de conexión")
            }
        }else{
//            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.goBooking.rawValue)
//            let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_ParkBuy": true]
//            (AppDelegate.getKruxTracker()).trackPageView("HomePark", pageAttributes:pageAttr, userAttributes:nil)
//            self.homeViewController?.showDetailPark()
            self.detailParkViewController?.showDetailPark()
        }
    }
    
    func setImageBackground(){
        
        let name = "lbl_booking".getNameLabel().uppercased()//"lblBooking".localized().uppercased()
        self.btnBooking.setTitle(name, for: .normal)
        
        let uriImage = "Headers/\(appDelegate.itemParkSelected.code!)/park"
        self.imageView.image = UIImage(named: uriImage)
        
        if !appDelegate.itemParkSelected.buy_status {
            self.btnBooking.isHidden = true
            self.viewDiscount.isHidden = true
            self.lblDiscount.isHidden = true
        }else{
            self.btnBooking.isHidden = false
            //Validamos el código de promocion
            let intoThePark = LocationSingleton.shared.inThePark()
            FirebaseBR.shared.getCodePromo(inPark: intoThePark) { (cupon) in
                if !cupon.code.isEmpty && !(self.codePark == "XN" || self.codePark == "XI" || self.codePark == "XV") {
                    if cupon.percent > 0 {
                        self.viewDiscount.isHidden = false
                        self.lblDiscount.text = "-\(cupon.percent)%"
                    }else{
                        self.viewDiscount.isHidden = true
                    }
                }else{
                    self.viewDiscount.isHidden = true
                    self.lblDiscount.isHidden = true
                }
            }
        }
        
//        let intoThePark = LocationSingleton.shared.inThePark()
//
//        FirebaseBR.shared.getCodePromo(inPark: intoThePark) { (cupon) in
//            if !cupon.code.isEmpty && !(self.codePark == "XN" || self.codePark == "XI" || self.codePark == "XV"){
//                self.btnBooking.isHidden = false
//                if cupon.percent > 0 {
//                    self.viewDiscount.isHidden = false
//                    self.lblDiscount.text = "-\(cupon.percent)%"
//                }else{
//                    self.viewDiscount.isHidden = true
//                }
//                //self.lblDiscount.text = "-\(cupon.percent)%"
//                //self.viewDiscount.isHidden = false
//            }else{
//                self.btnBooking.isHidden = true
//                self.viewDiscount.isHidden = true
//            }
//        }
        
    }

}
