//
//  IntroLottieViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 7/29/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit
import Lottie
import FirebaseInAppMessaging
import Firebase

class IntroLottieViewController: UIViewController {

    @IBOutlet weak var viewLogo: AnimationView!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lblCopyright: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorView.isHidden = true
        
        // Do any additional setup after loading the view.
        let av = Animation.named("splash")
        self.viewLogo.animation = av
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        loadIntro()
    }
    
    
    @objc func appMovedToForeground() {
        print("App moved to ForeGround!")
        self.playAnimation()
    }

    func loadIntro(){
        //Cargamos info
        self.lblVersion.text = appDelegate.enviromentProduction == TypeEnviroment.production
            ? Tools.shared.version()
        : "\(Tools.shared.version() ?? "")(\(Tools.shared.build() ?? "")) Dev."
//        self.lblVersion.text = Tools.shared.version()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        let allRightsReserved = String(format: "lblCopyright".localized(), arguments: [yearString])
        self.lblCopyright.text = allRightsReserved
        self.showInfoUser()
        self.playAnimation()
    }
    
    private func playAnimation(){
        self.viewLogo.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: .playOnce) { (finished) in
                            if finished{
                                print("Animation Complete")
                                self.setInitViewController()
                            }else{
                                print("Animation cancelled")
                                self.viewLogo.stop()
                            }
        }
    }
    
    
    func setInitViewController(){
//        self.sfdate()
        if !CheckInternet.Connection() {
            UpAlertView(type: .error, message: "lblErrNotNetwork".localized()).show {
                print("Error")
            }
        }else{
            self.indicatorView.isHidden = false
//            self.indicatorView.hidesWhenStopped = true
            self.indicatorView.startAnimating()
            FirebaseBR.shared.getParksGroup {
                VentaInAPP.shared.getDataParksPrice {
                    self.manageVC()
//                    self.indicatorView.stopAnimating()
                }
            }
        }
        
    }
    
    private func manageVC(){
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        guard let rootViewController = window.rootViewController else {
            return
        }
        //Verificamos si el usuario está logueado
        let userLogged = AppUserDefaults.value(forKey: .UserIsLogged, fallBackValue: false).boolValue
        var mainNC : UIViewController = UIViewController()
        //print("token actual \(FirebaseDB.shared.getToken())")
        if userLogged == true {
            let userApp: UserApp = getInfoUserAuth()
            if !userApp.uid.isEmpty {
                print("StatusSF: authenticateUserApp IntroLottie")
                FirebaseBR.shared.authenticateUserApp(user: userApp, completion: { (isSave, userApp) in
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    if isSave{
                        print("Se guardó usuario")
                    }else{
                        print("No se guardó")
                    }
                    DispatchQueue.main.async {
                        mainNC = AppStoryboard.HomeParks.instance.instantiateViewController(withIdentifier: "HomeParksNC")
                        mainNC.view.frame = rootViewController.view.frame
                        mainNC.view.layoutIfNeeded()
                        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            window.rootViewController = mainNC
                        })
                    }
                })
            }
        }else{
            mainNC = AppStoryboard.SignUp.instance.instantiateViewController(withIdentifier: "SignupNC")
            mainNC.view.frame = rootViewController.view.frame
            mainNC.view.layoutIfNeeded()
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = mainNC
            })
        }
        self.indicatorView.hidesWhenStopped = true
    }
    
    private func showInfoUser(){
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .transitionCurlUp, animations: {
            self.lblCopyright.alpha = 1
            self.lblVersion.alpha = 1
        })
    }
    
    func sfdate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "M"
        let month = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "d"
        let day = dateFormatter.string(from: date)
        
        let userAttr = ["Xcaret_Day": day, "Xcaret_Month": month, "Xcaret_Year": year, "XC_VisitEvent": true] as [String : Any]
        (AppDelegate.getKruxTracker()).trackPageView("StartingApp", pageAttributes:nil, userAttributes:userAttr)
    }
    
    private func getInfoUserAuth() -> UserApp{
        let userApp : UserApp = UserApp()
        let userAuth = Auth.auth().currentUser
        
        if userAuth != nil {
            if let userIdUser = userAuth?.uid{
                userApp.uid = userIdUser
            }
            
            if (userAuth?.isAnonymous)! {
                let name = ((Constants.LANG.current == "es") ? "Invitado" : "Guest")
                userApp.name = name
                userApp.email = "\(name.lowercased().replacingOccurrences(of: "ó", with: "o"))@\(Date().string(format: "yyyyMMddHHmmss"))"
                userApp.provider = (userAuth?.providerID)!
            }else{
                if let providerUser = userAuth?.providerData[0].providerID {
                    userApp.provider = providerUser
                }
                
                if let emailUser = userAuth?.providerData[0].email{
                    userApp.email = emailUser
                }
                if let nameUser = userAuth?.providerData[0].displayName {
                    userApp.name = nameUser
                }
                if let phoneUser = userAuth?.providerData[0].phoneNumber {
                    userApp.phone = phoneUser
                }
                if let photoProfile = userAuth?.providerData[0].photoURL{
                    print("url Photo\(photoProfile)")
                }
            }
        }
        return userApp
    }
}
