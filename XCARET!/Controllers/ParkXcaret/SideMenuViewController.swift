//
//  SideMenuViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 11/13/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit
import Firebase
import SilentScrolly
import MessageUI
import PMAlertController
import StoreKit

protocol ModalChangeLangHandler : class {
    func changeLang(lang: String)
}

class SideMenuViewController: UIViewController, SilentScrollable{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //var userName : String = ""
    var listMenu : [ItemMenu] = [ItemMenu]()
    var selectedMenu = ItemMenu()
    var typeAlertView : TypeAlertView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewContentBack: UIView!
    @IBOutlet weak var constraintBack: NSLayoutConstraint!
    
    @IBOutlet weak var tblMenu: UITableView! {
        didSet{
            tblMenu.register(UINib(nibName: "ItemMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
            tblMenu.register(UINib(nibName: "ItemPhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "cellPhoto")
        }
    }
    
    private let tableHeaderViewHeight: CGFloat = UIDevice().getHeightSideMenu()  // CODE CHALLENGE: make this height dynamic with the height of the VC - 3/4 of the height
    private let tableHeaderViewCutaway: CGFloat = 0
    var headerView: MenuHeaderView!
    var silentScrolly: SilentScrolly?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblMenu.estimatedRowHeight = UITableView.automaticDimension
        self.tblMenu.showsVerticalScrollIndicator = false
        //self.userName = AppUserDefaults.value(forKey: .UserName).stringValue
        self.tblMenu.delegate = self
        self.tblMenu.dataSource = self
        self.viewContentBack.isHidden = true
        self.configHeaderTableView()
        self.loadInfoMenu()
        self.configDarkModeCustom()
        //self.getCodesAyB()
        if appDelegate.optionsHome {
            self.viewContentBack.isHidden = false
            constraintBack.constant = UIDevice().getHeightHomeMenu()
        }
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        self.viewBack.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    /*func getCodesAyB(){
        if appDelegate.listCodeAyB.count == 0{
            FirebaseBR.shared.getCodesAyB {
                print("Llenamos los datos")
            }
        }
    }*/
    
    func configDarkModeCustom(){
        headerView.configDarkModeCustom()
        tblMenu.reloadData()
        tblMenu.backgroundColor = appDelegate.itemParkSelected.code == "XF" ? Constants.COLORS.GENERAL.customDarkMode : .white
    }
    
    func loadInfoMenu(){
        
        FirebaseBR.shared.getSectionsGeneral { (listMenu) in
            self.listMenu = listMenu
            self.tblMenu.reloadData()
        }
    }
    
    func configHeaderTableView(){
        headerView = (tblMenu.tableHeaderView as! MenuHeaderView)
        headerView.setImage()
        headerView.setNameGuest()
        tblMenu.tableHeaderView = nil
        tblMenu.addSubview(headerView)
        tblMenu.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
        tblMenu.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 0)
        updateHeaderView()
    }
    
    func updateHeaderView()
    {
        
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
        var headerRect = CGRect()
        
        headerRect = CGRect(x: 0, y: -effectiveHeight, width: tblMenu.bounds.width, height: tableHeaderViewHeight)
        
        
        if tblMenu.contentOffset.y < -effectiveHeight {
            self.setBckStatusBarStryle(type: "clear")
            headerRect.origin.y = tblMenu.contentOffset.y
            headerRect.size.height = (-tblMenu.contentOffset.y) + tableHeaderViewCutaway/2

        }else{
            self.setBckStatusBarStryle(type: "")
        }
        
        if appDelegate.optionsHome{
            headerRect.size.height = (headerRect.size.height + UIDevice().getHeightViewCode())
        }
        
        headerView.frame = headerRect
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        silentDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = false
        self.configDarkModeCustom()
        if appDelegate.goShop {
            self.dismiss(animated: true, completion: nil)
            appDelegate.goShop = false
        }
        if appDelegate.listItemListCarshop.count == 0 {
            LoadingView.shared.showActivityIndicator(uiView: self.view)
            FirebaseDB.shared.getListCarShop (completion : {(listCarshop) in
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
            })
        }
        self.tblMenu.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSilentScrolly(tblMenu, followBottomView: tabBarController?.tabBar)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        silentWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        silentDidDisappear()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        silentWillTranstion()
    }
    
    func logoutApp(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            FirebaseDB.shared.reserUserDefautls()
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            guard let rootViewController = window.rootViewController else {
                return
            }
            
            let mainNC = AppStoryboard.SignUp.instance.instantiateViewController(withIdentifier: "SignupNC")
            mainNC.view.frame = rootViewController.view.frame
            mainNC.view.layoutIfNeeded()
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = mainNC
            })
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goLegals" {
            if let vc = segue.destination as? LegalsViewController{
               vc.code = selectedMenu.code
            }
        }else if segue.identifier == "goCall" {
            if let vc = segue.destination as? ContactViewController{
                vc.typeAlertView = self.typeAlertView
                vc.delegate = self
            }
        }else if segue.identifier == "goSignup"{
            if let vc = segue.destination as? SignUpPopUpViewController{
                vc.delegate = self
            }
        }else if segue.identifier == "goLangs" {
            if let vc = segue.destination as? LangsViewController{
                vc.modalPresentationStyle = .overFullScreen
                vc.delegate = self
            }
        }
    }
}

extension SideMenuViewController: ModalChangeLangHandler {
    func changeLang(lang : String) {
          if !Constants.LANG.current.contains(lang) {
            
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Menu.rawValue, title: "lang\(lang.uppercased())")
            
            print(Constants.LANG.current)
            LoadingView.shared.showActivityIndicator(uiView: self.view)
            
            Constants.LANG.current = Constants.LANG.current == "es" ? "en" : "es"
            UserDefaults.standard.set(["\(Constants.LANG.current)"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            Bundle.setLanguage(lang: Constants.LANG.current)
//            if let currency = UserDefaults.standard.string(forKey: "UserCurrency") {
//                Constants.CURR.current = currency
//            }else{
//                let locale = Locale.current
//                if Constants.LANG.current == "es" && locale.regionCode == "MX" {
//                    Constants.CURR.current = "MXN"
//                }else{
//                    Constants.CURR.current = "USD"
//                }
//            }
            
            
            
            
//            FirebaseDB.shared.getLangLabelOther{
//                FirebaseDB.shared.getListLangsCatopcpromOther{
//                    FirebaseDB.shared.getListLangsPromotionsOther{
//                        FirebaseDB.shared.getListLangBenefitOther{
                            FirebaseBR.shared.getInfoByParkSelected {
                                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                self.loadInfoMenu()
                                if self.appDelegate.itemParkSelected.code.lowercased() == "xv" || self.appDelegate.itemParkSelected.code.lowercased() == "xp" || self.appDelegate.itemParkSelected.code.lowercased() == "xf" {
                                    self.tabBarController?.tabBar.items![0].title = "lbl_tb_home".getNameLabel()//"tbHome".localized()
                                    self.tabBarController?.tabBar.items![1].title = "lbl_tb_favorites".getNameLabel()//"tbFavorites".localized()
                                    self.tabBarController?.tabBar.items![2].title = "lbl_tb_menu".getNameLabel()//"tbMenu".localized()
//                                    self.tabBarController?.tabBar.items![1].title = "lbl_promotions".getNameLabel()//"tbSearch".localized()
//                                    if !self.appDelegate.itemParkSelected.buy_status {
//                                      self.tabBarController?.tabBar.items![1].title = "lbl_promotions".getNameLabel()//"tbSearch".localized()
//                                    }
                                }else if self.appDelegate.itemParkSelected.code.lowercased() == "xo" || self.appDelegate.itemParkSelected.code.lowercased() == "fe"{
                                    self.tabBarController?.tabBar.items![0].title = "lbl_tb_home".getNameLabel()//"tbHome".localized()
                                    self.tabBarController?.tabBar.items![1].title = "lbl_tb_menu".getNameLabel()//"tbMenu".localized()
//                                    self.tabBarController?.tabBar.items![1].title = "lbl_promotions".getNameLabel()//"tbSearch".localized()
//                                    if !self.appDelegate.itemParkSelected.buy_status {
//                                      self.tabBarController?.tabBar.items![1].title = "lbl_promotions".getNameLabel()//"tbSearch".localized()
//                                    }
                                    
                                }else{
                                    self.tabBarController?.tabBar.items![0].title = "lbl_tb_home".getNameLabel()//"tbHome".localized()
                                    self.tabBarController?.tabBar.items![1].title = "lbl_tb_favorites".getNameLabel()//"tbFavorites".localized()
                                    self.tabBarController?.tabBar.items![2].title = "lbl_tb_search".getNameLabel()//"tbSearch".localized()
                                    self.tabBarController?.tabBar.items![3].title = "lbl_tb_menu".getNameLabel()//"tbMenu".localized()
//                                    self.tabBarController?.tabBar.items![2].title = "lbl_promotions".getNameLabel()//"tbSearch".localized()
//                                    if !self.appDelegate.itemParkSelected.buy_status {
//                                        self.tabBarController?.tabBar.items![2].title = "lbl_promotions".getNameLabel()//"tbSearch".localized()
//                                    }
                                }
                                self.headerView.setNameGuest()
                            }
//                        }
                    
//                }
//            }
        }
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource, OpenPhotopassDelegate {
    func getAction(type: String) {
        if type == "P"{
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Menu.rawValue, title: TagsID.goPhotopass.rawValue)
            /*SF*/
            let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_Fotos": "fotos"]
            (AppDelegate.getKruxTracker()).trackPageView("HomePark", pageAttributes:pageAttr, userAttributes:nil)
            /**/
            let mainNC = AppStoryboard.Photo.instance.instantiateViewController(withIdentifier: "PhotoNC")
            mainNC.modalPresentationStyle = .fullScreen
            self.present(mainNC, animated: true, completion: nil)
        }else if type == "C"{
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Menu.rawValue, title: TagsID.goWallet.rawValue)
            /*SF*/
            let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_Carrito": "carrito"]
            (AppDelegate.getKruxTracker()).trackPageView("HomePark", pageAttributes:pageAttr, userAttributes:nil)
            /**/
            let mainNC = AppStoryboard.Cotizador.instance.instantiateViewController(withIdentifier: "Cotizador")
            mainNC.modalPresentationStyle = .fullScreen
            self.present(mainNC, animated: true, completion: nil)
        }else{
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Menu.rawValue, title: TagsID.goWallet.rawValue)
            /*SF*/
            let pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_MisTickets": "mis_tickets"]
            (AppDelegate.getKruxTracker()).trackPageView("HomePark", pageAttributes:pageAttr, userAttributes:nil)
            /**/
            let mainNC = AppStoryboard.Tickets.instance.instantiateViewController(withIdentifier: "TicketsNC")
            mainNC.modalPresentationStyle = .fullScreen
            self.present(mainNC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = listMenu[indexPath.row]
        if item.code == "photopass"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellPhoto", for: indexPath) as! ItemPhotoTableViewCell
            cell.delegate = self
            cell.setInfoView()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemMenuTableViewCell
            cell.configDarkModeCustom()
            cell.setInfoView(itemMenu: listMenu[indexPath.row])
            return cell
        }
    }
    
    func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {

        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = listMenu[indexPath.row]
        if !item.code.isEmpty {
            self.selectedMenu = item
            
            if item.code == "phone" {
                AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Menu.rawValue, title: TagsID.callNow.rawValue)
                self.typeAlertView = .contactCenterView
                performSegue(withIdentifier: "goCall", sender: nil)
            }
            
            if item.code == "email" {
                AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Menu.rawValue, title: TagsID.emailUs.rawValue)
                sendEmail(email: appDelegate.itemContact.email)
            }
            
            if item.code == "review" {
                AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Menu.rawValue, title: TagsID.reviewUs.rawValue)
                let url = URL(string: "itms-apps://itunes.apple.com/app/id1165654955")!
                if #available(iOS 10.0, *){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }else{
                    UIApplication.shared.openURL(url)
                }
            }
            
            if item.code == "download_hotel" {
                let customUrl = "AppHotelOpen://"
                if let url = URL(string: customUrl){
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.open(url)
                    }else{
                        let url = URL(string: "itms-apps://itunes.apple.com/app/1474819420")!
                        if #available(iOS 10.0, *){
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }else{
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }
            
            if item.code == "policy" || item.code == "terms"{
                AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Menu.rawValue, title: "\(item.code == "policy" ? TagsID.privacyPolicy.rawValue : TagsID.termsConditions.rawValue)")
                self.performSegue(withIdentifier: "goLegals", sender: self)
            }
            
            if item.code == "change" {
                performSegue(withIdentifier: "goLangs", sender: nil)
                
//                self.typeAlertView = .changeLang
//                performSegue(withIdentifier: "goCall", sender: nil)
                //changeToLanguage()
            }
            
            if item.code == "home" {
                AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.goMain.rawValue)
                self.dismiss(animated: true, completion: nil)
            }
            
            if item.code == "update"{
                guard let url = URL(string: appDelegate.appInfo.trackViewUrl) else {
                    return
                }
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
            if item.code == "logout" {
                let alertVC = PMAlertController( title: "lbl_logout".getNameLabel()/*"lblLogout".localized()*/ , description: "lbl_leyend_close".getNameLabel()/*"lblLeyendClose".localized()*/, image: nil , style: PMAlertControllerStyle.alert)
                alertVC.addAction(PMAlertAction(title: "lbl_cancel".getNameLabel()/*"lblCancel".localized()*/, style: .cancel))
                alertVC.addAction(PMAlertAction(title: "lbl_accept".getNameLabel()/*"lblAccept".localized()*/, style: .default, action: {
                    AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.logOut.rawValue)
                    self.logoutApp()
                }))
                
                self.present(alertVC, animated: true) {
                    print("Listo")
                }
            }
            
            if item.code == "signup" {
                 self.performSegue(withIdentifier: "goSignup", sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = listMenu[indexPath.row]
        var newHeight: CGFloat = 150.0
        if appDelegate.optionsHome {
            newHeight = newHeight + CGFloat(UIDevice().getHeightViewCode())
        }
        
        if item.code != "photopass"{
            newHeight = listMenu[indexPath.row].separatorHidden == true ? 40 : 50
        }
        
        return newHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
        silentDidScroll()
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        showNavigationBar()
        return true
    }
    
    func sendEmail(email : String){
        if MFMailComposeViewController.canSendMail() {
            let toRecipients = [email]
            let subject = "lbl_subject_email".getNameLabel()//"lblSubjectEmail".localized()
            let mail = configuredMailComposeViewController(recipients: toRecipients, subject: subject, body: "", isHtml: true, images: nil)
            presentMailComposeViewController(mailComposeViewController: mail)
        } else {
            // show failure alert
            print("show failure alert")
        }
    }
}

extension SideMenuViewController : MFMailComposeViewControllerDelegate {
    func configuredMailComposeViewController(recipients : [String]?, subject :
        String, body : String, isHtml : Bool = false,
                images : [UIImage]?) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // IMPORTANT
        
        mailComposerVC.setToRecipients(recipients)
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(body, isHTML: isHtml)
        
        
        return mailComposerVC
    }
    
    func presentMailComposeViewController(mailComposeViewController :
        MFMailComposeViewController) {
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController,
                         animated: true, completion: nil)
        } else {
            let sendMailErrorAlert = UIAlertController.init(title: "lbl_error".getNameLabel()/*"lblError".localized()*/,
                                                            message: "lbl_error_failed".getNameLabel()/*"lblErrorFailed".localized()*/, preferredStyle: .alert)
            self.present(sendMailErrorAlert, animated: true,
                         completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch (result) {
        case .cancelled:
            self.dismiss(animated: true, completion: nil)
        case .sent:
            self.dismiss(animated: true, completion: nil)
        case .failed:
            self.dismiss(animated: true, completion: {
                let sendMailErrorAlert = UIAlertController.init(title: "lbl_error_failed".getNameLabel()/*"lblErrorFailed".localized()*/,
                                                                message: "lbl_error_email".getNameLabel()/*"lblErrorEmail".localized()*/, preferredStyle: .alert)
                sendMailErrorAlert.addAction(UIAlertAction.init(title: "OK",
                                                                style: .default, handler: nil))
                self.present(sendMailErrorAlert,
                             animated: true, completion: nil)
            })
        default:
            break;
        }
        //dismiss(animated: true, completion: nil)
        //controller.dismiss(animated: true)
    }
}

extension SideMenuViewController : ModalHandler {
    func modalDismissed() {
        self.headerView.setImage()
        self.headerView.setNameGuest()
        self.loadInfoMenu()
    }
}
