//
//  Home2GroupsViewController.swift
//  XCARET!
//
//  Created by Hate on 19/08/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInAppMessaging
import Lottie
import MarketingCloudSDK
import AdSupport
import AppTrackingTransparency

class Home2GroupsViewController: UIViewController, InAppMessagingDisplayDelegate, GoViewInAap {
    var delegateGoToBuy : TicketsViewController?
    var listHome: [ItemHome] = [ItemHome]()
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var sizeLeftButtonProm: NSLayoutConstraint!
    @IBOutlet weak var sizeButtonProm: NSLayoutConstraint!
    @IBOutlet weak var AnimationViewProm: AnimationView!
    @IBOutlet weak var contentAnimation: UIView!
    @IBOutlet weak var constraintTopDevice: NSLayoutConstraint!
    
    let sizeScreen = UIScreen.main.bounds.width / 4
    @IBOutlet weak var tblHome: UITableView! {
        didSet{
            tblHome.register(UINib(nibName: "ItemActTableViewCell", bundle: nil), forCellReuseIdentifier: "cellActivity")
            tblHome.register(UINib(nibName: "homePrefTableViewCell", bundle: nil), forCellReuseIdentifier: "cellHomePref")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblHome.delegate = self
        self.tblHome.dataSource = self
        self.tabBar.delegate = self
        constraintTopDevice.constant = UIDevice().getTopHome()
        appDelegate.optionsHome = true
        appDelegate.itemParkSelected.code = ""
        loadInformation()
        configItemsButton()
        
        if Tools.shared.ask4PermissionApp(){
            let myFiamDelegate = appDelegate.myFiamDelegate
            InAppMessaging.inAppMessaging().delegate = myFiamDelegate;
            myFiamDelegate?.delegateGoViewInAap = self
            appDelegate.delegateGoViewInAap = self
            
            Analytics.logEvent("link_app_promociones", parameters: [:])
            InAppMessaging.inAppMessaging().triggerEvent("link_app_promociones")
        }
        
        appDelegate.requestReview()
        ArgAppUpdater.getSingleton().showUpdateConfirmInit()
        
        self.sizeLeftButtonProm.constant = sizeScreen
        self.sizeButtonProm.constant = sizeScreen
        
        let av = Animation.named("tienda")
        self.AnimationViewProm.animation = av
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToProm))
        contentAnimation.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActiveNotification(notification:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        // Authorized
                        let idfa = ASIdentifierManager.shared().advertisingIdentifier
                        print("identifier: \(idfa.uuidString)")
                    case .denied,
                            .notDetermined,
                            .restricted:
                        break
                    @unknown default:
                        break
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
//        FirebaseDB.shared.getListCarShopObserve (completion : {(itemsPickup) in
//            print("Cambio en carshop...")
//        })
    }
    
    @objc func handleAppDidBecomeActiveNotification(notification: Notification) {
        self.AnimationViewProm.play(fromProgress: 0, toProgress: 0.9, loopMode: LottieLoopMode.loop)
        
        tblHome.reloadData()
    }
    
    @objc func goToProm(){
        AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: TagsContentAnalytics.MainNavigation.rawValue, title: TagsID.mainTienda.rawValue)
        let mainNC = AppStoryboard.Tienda.instance.instantiateViewController(withIdentifier: "Tienda") as! TiendaViewController
        mainNC.modalPresentationStyle = .fullScreen
//        mainNC.delegateGoMenuTickets = self
        self.present(mainNC, animated: true, completion: nil)
    }
    
    func goViewInAap(url: String) {
        print(url)
        var idDirection = ""
        var idAction = ""
        appDelegate.URLDynamicLink = ""
        if url.isEmpty || url.contains("http"){
            let allArray = url.components(separatedBy: "://")
            if allArray.count > 1 {
                let arrayData = allArray[1].components(separatedBy: "/")
                if arrayData.count > 1{
                    
                    for element in arrayData {
                        print(element)
                    }
                    
                        switch arrayData[1] {
                        case "home":
                            if arrayData.indices.contains(3){
                            idDirection = arrayData[3]
                            appDelegate.idAction = arrayData[3]
                            }
                        case "park":
                            if arrayData[2] == "promotion" {
                                if arrayData.indices.contains(3){
                                    let id = arrayData[3].components(separatedBy: "-")
                                    if id.indices.contains(1){
                                        idDirection = id[0]
                                        idAction = id[1]
                                        appDelegate.idAction = idAction
                                    }
                                }
                            }else{
                                if arrayData.indices.contains(2){
                                    idDirection = arrayData[2]
                                }
                                
                            }
                        default:
                            idDirection = ""
                        }
                    
                }
               
                let park = appDelegate.listAllParks.filter({$0.code == idDirection})
                let prom = appDelegate.listlangsPromotions.filter({$0.uid == Constants.LANG.current && $0.prod_code == idDirection && $0.status == true})
                
                if park.count > 0 {
                    print("park")
                    
                    if park.first?.status == true {
                        self.sendItemPark(itemPark: park.first ?? ItemPark())
                    }else{appDelegate.idAction = ""}
                }
                
                if prom.count > 0 {
                    print("prom")
                    if prom.first?.status == true {
                        AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: TagsContentAnalytics.MainNavigation.rawValue, title: TagsID.mainPromotions.rawValue)
                        let mainNC = AppStoryboard.Promociones.instance.instantiateViewController(withIdentifier: "Prom") as! PromocionesViewController
    //                    mainNC.inAppPromotionCode = (prom.first?.prod_code)!
                        mainNC.modalPresentationStyle = .fullScreen
                        mainNC.delegateGoMenuTickets = self
                        self.present(mainNC, animated: true, completion: nil)
                    }else{
                        appDelegate.idAction = ""
                    }
                }
            }
        }else{
            let array = url.components(separatedBy: "://")
            if array.count > 1 && array[0] == "prom"{
                AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: TagsContentAnalytics.MainNavigation.rawValue, title: TagsID.mainPromotions.rawValue)
                idDirection = array[1]
                appDelegate.idAction = idDirection
                if array[1].contains("-"){
                    let id = array[1].components(separatedBy: "-")
                    idDirection = id[0]
                    idAction = id[1]
                    appDelegate.idAction = idAction
                    appDelegate.itemParkSelected = appDelegate.listAllParks.filter({ $0.code == idDirection }).first ?? ItemPark()
                }
                
                let prom = appDelegate.listlangsPromotions.filter({$0.uid == Constants.LANG.current && $0.prod_code == idAction && $0.status == true})
                if prom.first?.status == false {
                    appDelegate.idAction = ""
                }
                
                let mainNC = AppStoryboard.Promociones.instance.instantiateViewController(withIdentifier: "Prom") as! PromocionesViewController
                mainNC.inAppSelectNo = Int(array[1]) ?? 0
                mainNC.modalPresentationStyle = .fullScreen
                mainNC.delegateGoMenuTickets = self
                self.present(mainNC, animated: true, completion: nil)
            }else if array.count > 1 && array[0] == "park"{
                let parkSelect = appDelegate.listAllParks.filter({$0.code.uppercased() == array[1]})
                let aux = parkSelect
                print(aux)
                if parkSelect.first?.status == true {
                    self.sendItemPark(itemPark: parkSelect.first ?? ItemPark())
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
//        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.tintColor = UIColor(red: 78/255, green: 117/255 , blue: 163/255, alpha: 1.00)
        UITabBar.appearance().barTintColor = UIColor.white
        appDelegate.optionsHome = true
        appDelegate.itemParkSelected.code = ""
        tblHome.reloadData()
        configItemsButton()
        loadInformation()
        
        self.AnimationViewProm.play(fromProgress: 0, toProgress: 0.9, loopMode: LottieLoopMode.loop)
        
        if appDelegate.idAction == "promTicket" {
            AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: TagsContentAnalytics.MainNavigation.rawValue, title: TagsID.mainPromotions.rawValue)
            let mainNC = AppStoryboard.Promociones.instance.instantiateViewController(withIdentifier: "Prom") as! PromocionesViewController
            mainNC.modalPresentationStyle = .fullScreen
            mainNC.delegateGoMenuTickets = self
            self.present(mainNC, animated: true, completion: nil)
        }
        
        if appDelegate.goTicketsBuy {
            let mainNC = AppStoryboard.Tickets.instance.instantiateViewController(withIdentifier: "TicketsNC")
            mainNC.modalPresentationStyle = .fullScreen
            self.present(mainNC, animated: true, completion: nil)
            appDelegate.goTicketsBuy = false
        }
        
//        if appDelegate.withMarketingCloud {
            let sesion = AppUserDefaults.value(forKey: .UserIsLogged, fallBackValue: false).boolValue
            var name = AppUserDefaults.value(forKey: .UserName).stringValue
            var email = AppUserDefaults.value(forKey: .UserEmail).stringValue
            let userUID = AppUserDefaults.value(forKey: .UserUID).stringValue
            var country = AppUserDefaults.value(forKey: .UserCountry).stringValue
            
            FirebaseDB.shared.getUserByUID(uid: userUID) { (exist, userAppExist) in
                print(userAppExist)
                
                if exist {
                    email = userAppExist.email
                    name = userAppExist.name
                    country = userAppExist.country
                }
                
                if sesion, name != "Guest", name != "Invitado", !email.contains("privaterelay"){
                    print("NO GUEST")
                    MarketingCloudSDK.sharedInstance().sfmc_setContactKey(email)
                    MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("EmailAddress", value: email)
                    MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("NombreCompleto", value: name)
                    MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("Origen", value: "App_Xcaret")
                    MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("Country", value: country)
                }else{
                    if sesion {
                        print("ok")
                        if userUID != "" {
                            print(userUID)
                            MarketingCloudSDK.sharedInstance().sfmc_setContactKey(userUID)
                            MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("Origen", value: "App_Xcaret")
                        }else{
                            let uid = UUID().uuidString
                            AppUserDefaults.save(value: uid, forKey: .UserUID)
                            print(uid)
                            MarketingCloudSDK.sharedInstance().sfmc_setContactKey(uid)
                            MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("Origen", value: "App_Xcaret")
                        }
                    }
                }
            }
        }
//    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if appDelegate.URLDynamicLink != "" {
            
            self.goViewInAap(url: appDelegate.URLDynamicLink)
        }
        
    }
    
    func callWebXafety() {
        let mainNC = AppStoryboard.Xafety.instance.instantiateViewController(withIdentifier: "XafetyViewController")
        mainNC.modalPresentationStyle = .fullScreen
        self.present(mainNC, animated: true, completion: nil)
    }
    
    func configItemsButton(){
        
        let deSelectImageTickets = UIImage(named: "Icons/tab/tickets_over")
        //let selectImageTickets = UIImage(named: "Icons/tab/tickets")
        tabBarItem = self.tabBar.items?[0]
        tabBarItem.title = NSLocalizedString("lbl_title_tickets".getNameLabel(), comment: "Tickets")
        tabBarItem.image = deSelectImageTickets
        tabBarItem = self.tabBar.items?[1]
        tabBarItem.title = NSLocalizedString("lbl_store".getNameLabel(), comment: "Promociones")//NSLocalizedString("lbl_title_shop".getNameLabel(), comment: "Promociones")
        
        let deSelectImageSearch = UIImage(named: "Icons/tab/search_over")
        tabBarItem = self.tabBar.items?[2]
        tabBarItem.title = NSLocalizedString("lbl_tb_search".getNameLabel(), comment: "Buscar")
        tabBarItem.image = deSelectImageSearch
        
        let deSelectImageMenu = UIImage(named: "Icons/tab/menu_over")
        tabBarItem = self.tabBar.items?[3]
        tabBarItem.title = NSLocalizedString("lbl_tb_menu".getNameLabel(), comment: "Menu")
        tabBarItem.image = deSelectImageMenu
    }
    
    func loadInformation(){
        FirebaseBR.shared.getListInfoHome(keyPark: "HOME") { (listHome) in
            self.listHome = listHome
            self.tblHome.reloadData()
        }
    }
    
    
    func sendItemPark(itemPark: ItemPark) {
        appDelegate.optionsHome = false
        appDelegate.itemParkSelected = itemPark
        //Analytics FB
        AnalyticsBR.shared.saveEventContentFB(content: TagsContentAnalytics.ListMain.rawValue, title: itemPark.code.uppercased())
        /*SF*/
        let pageAttr = ["\(itemPark.code.uppercased())_HomeList": itemPark.code.uppercased()]
        (AppDelegate.getKruxTracker()).trackPageView("HomeGroup", pageAttributes:pageAttr, userAttributes:nil)
        /**/
        switch itemPark.p_type {
        case "H": //Cuando es Hotel
            let HotelVC = AppStoryboard.Hotel.instance.instantiateViewController(withIdentifier: "HotelNC")
            HotelVC.modalPresentationStyle = .fullScreen
            self.present(HotelVC, animated: false)
        default: //Cuando es Parque
            LoadingView.shared.showActivityIndicator(uiView: self.view)
                FirebaseBR.shared.getInfoByParkSelected {
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    let parkVC = AppStoryboard.ParkXcaret.instance.instantiateViewController(withIdentifier: "XcaretTBC")
                    parkVC.modalPresentationStyle = .fullScreen
                    self.present(parkVC, animated: false)
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSearch" {
            if segue.destination is PopUpHomeViewController{
                
            }
        }
    }
}



extension Home2GroupsViewController : UITableViewDelegate, UITableViewDataSource, ManageControllersDelegateHome, ManageControllersDelegateXafety{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listHome.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemHome = listHome[indexPath.row]
        
        switch itemHome.typeCell {
        case .cellPrefHome:
            let cell : homePrefTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellHomePref", for: indexPath) as! homePrefTableViewCell
            cell.setInfoView(itemHome: itemHome)
            cell.delegateHome = self
            cell.delegateXafety = self
            return cell
        case .cellHome:
            let cell : ItemActTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActTableViewCell
            cell.collectionView.tag = 111
            cell.setInfoView(itemHome: itemHome)
            cell.delegateHome = self
            return cell
        default:
            let cell : ItemMapTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellTVMap", for: indexPath) as! ItemMapTableViewCell
            cell.setInfoView(type: "MAP")
            return cell
        }
    }
}

extension Home2GroupsViewController: UITabBarDelegate, GoMenuTickets{
    
    func goMenuTickets() {
//        let mainNC = AppStoryboard.Tickets.instance.instantiateViewController(withIdentifier: "TicketsNC")
//        mainNC.modalPresentationStyle = .fullScreen
//        self.present(mainNC, animated: true, completion: nil)
        
        let mainNC = AppStoryboard.ParkXcaret.instance.instantiateViewController(withIdentifier: "MenuParksVC")
        mainNC.modalPresentationStyle = .fullScreen
        self.present(mainNC, animated: true, completion: nil)

    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: TagsContentAnalytics.MainNavigation.rawValue, title: TagsID.mainTickets.rawValue)
            let mainNC = AppStoryboard.Tickets.instance.instantiateViewController(withIdentifier: "TicketsNC")
            mainNC.modalPresentationStyle = .fullScreen
            self.present(mainNC, animated: true, completion: nil)
        case 1:
//            AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: TagsContentAnalytics.MainNavigation.rawValue, title: TagsID.mainPromotions.rawValue)
//            let mainNC = AppStoryboard.Promociones.instance.instantiateViewController(withIdentifier: "Prom") as! PromocionesViewController
//            mainNC.modalPresentationStyle = .fullScreen
//            mainNC.delegateGoMenuTickets = self
//            self.present(mainNC, animated: true, completion: nil)
        
            AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: TagsContentAnalytics.MainNavigation.rawValue, title: TagsID.mainTienda.rawValue)
            let mainNC = AppStoryboard.Tienda.instance.instantiateViewController(withIdentifier: "Tienda") as! TiendaViewController
            mainNC.modalPresentationStyle = .fullScreen
//            mainNC.delegateGoMenuTickets = self
            self.present(mainNC, animated: true, completion: nil)
        case 2:
            AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: TagsContentAnalytics.MainNavigation.rawValue, title: TagsID.mainSearch.rawValue)
            performSegue(withIdentifier: "goSearch", sender: nil)
        case 3:
            AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: TagsContentAnalytics.MainNavigation.rawValue, title: TagsID.mainMenu.rawValue)
            let mainNC = AppStoryboard.ParkXcaret.instance.instantiateViewController(withIdentifier: "MenuParksVC")
            mainNC.modalPresentationStyle = .fullScreen
            self.present(mainNC, animated: true, completion: nil)
        default:
            print(item.tag)
        }
    }
}

