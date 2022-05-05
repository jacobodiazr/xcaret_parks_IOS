//
//  DetailHeaderView.swift
//  XCARET!
//
//  Created by Angelica Can on 11/21/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cornerDropShadowView : UIView!
    @IBOutlet weak var btnAboutPark : UIButton!
    @IBOutlet weak var lblHelloBottomConstraint : NSLayoutConstraint!
    @IBOutlet weak var lblHello : UILabel!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var logoPark : UIImageView!
    @IBOutlet weak var viewDiscount : UIView!
    @IBOutlet weak var lblDiscount : UILabel!
    @IBOutlet weak var bottomCornerDrop: NSLayoutConstraint!
    @IBOutlet weak var toplogoPark: NSLayoutConstraint!
    weak var homeViewController : HomeViewController?
    let currentHourInt = Calendar.current.component(.hour, from: Date())
    var codePark = appDelegate.itemParkSelected.code!
    
    
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
            } else {
                imageView.image = nil
            }
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        switch appDelegate.itemParkSelected.code {
        case "XS":
            self.cornerDropShadowView.setTrapecioShadow()
            //self.bottomCornerDrop.constant = 0
        case "XV", "XA", "FE":
            self.bottomCornerDrop.constant = appDelegate.itemParkSelected.code == "XA" ? -10 : -1
            self.cornerDropShadowView.backgroundColor = UIColor.clear
            let imageName = "Headers/\(appDelegate.itemParkSelected.code ?? "XA")/textura"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: self.cornerDropShadowView.frame.size.width, height: 70)
            cornerDropShadowView.addSubview(imageView)
        case "XF":
            self.cornerDropShadowView.setOvalShadow(color: Constants.COLORS.GENERAL.customDarkMode)
            self.btnAboutPark.shadowColor = .black
        default:
            self.cornerDropShadowView.setOvalShadow()
        }
        toplogoPark.constant = UIDevice().getTopLogo()
        
    }
    
    @IBAction func btnSendDetail(_ sender: UIButton) {
         if !CheckInternet.Connection() {
            UpAlertView(type: .error, message: "lblErrNotNetwork".localized()).show {
                print("Error de conexión")
            }
        }else{
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.goBooking.rawValue)
            let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_ParkBuy": true]
            (AppDelegate.getKruxTracker()).trackPageView("HomePark", pageAttributes:pageAttr, userAttributes:nil)
            self.homeViewController?.showDetailPark()
        }
    }
    
    func setNameButton(){
        
        let logoUrl = appDelegate.itemParkSelected.code == "FE" ? "Logos/logoHome\(codePark)" : "Logos/logo\(codePark)"
        self.lblHello.text = "lbl_hello".getNameLabel()
        self.logoPark.image = UIImage(named: logoUrl)
        if codePark == "XV" {
            logoPark.heightAnchor.constraint(equalTo: logoPark.widthAnchor, multiplier: 1.0/2.0).isActive = true
        }
        let provider = AppUserDefaults.value(forKey: .UserProvider, fallBackValue: "Firebase")
        if provider != "Firebase" {
            lblName.text = AppUserDefaults.value(forKey: .UserName).stringValue
        }else{
            lblName.text = ""
        }
        print(self.codePark)
        getCupons()
        getHourLauchApp()
    }
    
    private func getHourLauchApp(){
        let dateDay : Int = 6
        let dateNoon : Int = 12
        let dateNight : Int = 18
        let midnight : Int = 17
        let midday : Int = 5
        
        if codePark == "XC"{
            if currentHourInt >= dateDay && currentHourInt < dateNoon {
                self.imageView.image = UIImage(named: "Headers/\(codePark)/dia")
            }else if currentHourInt >= dateNoon && currentHourInt < dateNight {
                self.imageView.image = UIImage(named: "Headers/\(codePark)/tarde")
            }else{
                self.imageView.image = UIImage(named: "Headers/\(codePark)/noche")
            }
        }else if codePark == "XH" {
            if currentHourInt >= midday && currentHourInt < midnight {
                self.imageView.image = UIImage(named: "Headers/\(codePark)/dia")
            }else {
                self.imageView.image = UIImage(named: "Headers/\(codePark)/tarde")
            }
        }else {
            self.imageView.image = UIImage(named: "Headers/\(codePark)/dia")
        }
    }
    
    func reloadCodePark() {
        self.codePark = appDelegate.itemParkSelected.code!
        self.cornerDropShadowView.backgroundColor = UIColor.clear
        if codePark == "XF" {
            self.cornerDropShadowView.setOvalShadow(color: Constants.COLORS.GENERAL.customDarkMode)
            self.btnAboutPark.shadowColor = .black
        }else{
            self.cornerDropShadowView.setOvalShadow(color: .white)
            self.btnAboutPark.shadowColor = .gray
        }
    }
    
    private func getCupons(){
        var name = "btn_buy".getNameLabel()
        switch codePark {
        case "FE":
            name = "lbl_booking_online".getNameLabel()
        default:
            name = "btn_buy".getNameLabel()
            break
        }
        self.btnAboutPark.setTitle(name, for: .normal)
        
        // Validamos que esté habilitada la
        // venta para el parque seleccionado (buy_status)
        if !appDelegate.itemParkSelected.buy_status {
            self.btnAboutPark.isHidden = true
            self.viewDiscount.isHidden = true
            self.lblDiscount.isHidden = true
        }else{
            self.btnAboutPark.isHidden = false
            //Validamos el código de promocion
            let intoThePark = LocationSingleton.shared.inThePark()
            FirebaseBR.shared.getCodePromo(inPark: intoThePark) { (cupon) in
                if self.codePark == "FE"{
                    self.viewDiscount.isHidden = true
                }else{
                    if !cupon.code.isEmpty {
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
        }
    }
}
