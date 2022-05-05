//
//  HomeViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 11/13/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import UIKit
import SilentScrolly

class HomeViewController: UIViewController, SilentScrollable{
    
    private var tableHeaderViewHeight: CGFloat = 0 // CODE CHALLENGE: make this height dynamic with the height of the VC - 3/4 of the height
    private let tableHeaderViewCutaway: CGFloat = 0
    var headerView: HomeHeaderView!
   // var headerMaskLayer: CAShapeLayer!
    var listHome: [ItemHome] = [ItemHome]()
    var itemActivitySelected = ItemActivity()
    var listActivitiesSelected = [ItemActivity]()
    var itemAdmissionSelected = ItemAdmission()
    var itemEventSelected = ItemEvents()
    var indexActivitySelected = Int()
    let buttonBack = UIButton()
    var typeItemBuyXV : String = ""
    var colorBack: UIColor = UIColor()
    var listParks : [ItemPark] = [ItemPark]()
    var indexSelectProm = 0
    var idAction = ""
    var promFrom = ""
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var tblHome: UITableView! {
        didSet{
            tblHome.register(UINib(nibName: "ItemActTableViewCell", bundle: nil), forCellReuseIdentifier: "cellActivity")
            tblHome.register(UINib(nibName: "ItemActExtraTableViewCell", bundle: nil), forCellReuseIdentifier: "cellActExtra")
            tblHome.register(UINib(nibName: "ItemMapTableViewCell", bundle: nil), forCellReuseIdentifier: "cellTVMap")
            tblHome.register(UINib(nibName: "ItemButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSeeAll")
            tblHome.register(UINib(nibName: "ItemSlideTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSlide")
            tblHome.register(UINib(nibName: "ItemSeeAllTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSee")
            tblHome.register(UINib(nibName: "ItemConSinTableViewCell", bundle: nil), forCellReuseIdentifier: "cellConSin")
            tblHome.register(UINib(nibName: "SwitchXPTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSwitchXP")
            tblHome.register(UINib(nibName: "itemTitleDescriptionBasicTableViewCell", bundle: nil), forCellReuseIdentifier: "cellTitleXN")
            tblHome.register(UINib(nibName: "ItemAwardTableViewCell", bundle: nil), forCellReuseIdentifier: "cellItemAward")
            tblHome.register(UINib(nibName: "segmentRecomendationsTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSegmentRecomendations")
            tblHome.register(UINib(nibName: "ItemAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "cellAddress")
            tblHome.register(UINib(nibName: "itemButtonPMTableViewCell", bundle: nil), forCellReuseIdentifier: "cellPMXC")
            tblHome.register(UINib(nibName: "ItemParkInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "cellInfoParkShort")
            tblHome.register(UINib(nibName: "ItemScheduleAdmissionTableViewCell", bundle: nil), forCellReuseIdentifier: "cellScheduleAdmission")
            tblHome.register(UINib(nibName: "ItemLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "cellLocation")
            tblHome.register(UINib(nibName: "tablePriceFETableViewCell", bundle: nil), forCellReuseIdentifier: "cellTablePriceFE")
        }
    }
    var silentScrolly: SilentScrolly?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appDelegate.idAction != "" {
            self.idAction = appDelegate.idAction
//            appDelegate.idAction = ""
        }
        
        buttonBack.setImage(UIImage(named:"Icons/ico_back")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonBack.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        buttonBack.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -10)
        buttonBack.sizeToFit()
        buttonBack.addTarget(self, action: #selector(self.unloadPark), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonBack)
        
        self.tableHeaderViewHeight = (self.view.frame.height * 0.70)
        self.tblHome.rowHeight = 500
        self.tblHome.estimatedRowHeight = 500
        self.tblHome.showsVerticalScrollIndicator = false
        self.tblHome.delegate = self
        self.tblHome.dataSource = self
        self.configHeaderTableView()
        
        FirebaseDB.shared.getToken { (token) in
            print("Token: \(token)")
        }
        self.colorBack = appDelegate.itemParkSelected.code == "XF" ? Constants.COLORS.GENERAL.customDarkMode : .white
        tblHome.backgroundColor = self.colorBack
        
        if appDelegate.itemParkSelected.code == "XN" || appDelegate.itemParkSelected.code == "XI" {
            self.tabBarController?.tabBar.isHidden = true
            self.tabBarController?.tabBar.layer.zPosition = -1
        }else{
            self.tabBarController?.tabBar.isHidden = false
            self.tabBarController?.tabBar.layer.zPosition = 0
        }
        
        getPrice()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActiveNotification(notification:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)


    }
    
    @objc func handleAppDidBecomeActiveNotification(notification: Notification) {
//        let tabBarController = UITabBarController()
//        tabBarController.reloadInputViews()
    }
    
    func getPrice(){
        let listPrecios = appDelegate.listPrecios
        
        let itemPrecio = listPrecios.filter({$0.uid == "Regular"})
        let currencyPrecio = itemPrecio.first?.productos.filter({$0.key_park == appDelegate.itemParkSelected.uid})
        let price = currencyPrecio?.first?.adulto.filter({$0.key.lowercased() == Constants.CURR.current.lowercased()})
        
        if price?.first?.precio != 0.0 && price?.first?.precio != nil{
            self.lblPrice.isHidden = false
            self.lblPrice.text = "\("your_entry _from".getNameLabel()) \(price?.first?.precio.currencyFormat() ?? "")"
        }else{
           self.lblPrice.isHidden = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setStatusBarStyle(.lightContent)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = false
        buttonBack.setTitle("lbl_parks".getNameLabel(), for: .normal)//("lblParks".localized(), for: .normal)
        self.loadInformation()

        if indexSelectProm != 0 {
            self.tabBarController?.selectedIndex = indexSelectProm
        }
        
    }
    
    func loadInformation(){
        FirebaseBR.shared.getListInfoHome(keyPark: appDelegate.itemParkSelected.code) { (listHome) in
            self.listHome = listHome
            self.headerView.setNameButton()
            self.tblHome.reloadData()
        }
    }
    
    func configDarkModeCustom() {
        self.colorBack = appDelegate.itemParkSelected.code == "XF" ? Constants.COLORS.GENERAL.customDarkMode : .white
        tblHome.backgroundColor = self.colorBack
        
        if appDelegate.itemParkSelected.code == "XF" {
            self.tabBarController?.tabBar.tintColor = .white
            self.tabBarController?.tabBar.barTintColor = .black
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
        }else{
            self.tabBarController?.tabBar.tintColor = UIColor(red: 78/255, green: 117/255 , blue: 163/255, alpha: 1.00)
            self.tabBarController?.tabBar.barTintColor = .white
            self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(red: 78/255, green: 117/255 , blue: 163/255, alpha: 1.00)
        }
    }
    
    
    func showDetailPark(){
        if appDelegate.itemParkSelected.code == "FE"{
            
            let mainNC = AppStoryboard.AlertDefault.instance.instantiateViewController(withIdentifier: "AlertDefault") as! AlertDefaultViewController
            mainNC.modalPresentationStyle = .overFullScreen
            mainNC.modalTransitionStyle = .crossDissolve
            mainNC.enabledButton = true
            mainNC.textButton = "lbl_button_next_ferries".getNameLabel()
            mainNC.urlActionButton = "itms-apps://itunes.apple.com/app/id1610417142"
            mainNC.configAlert(type: .ferry, heightC: 290.0, texto: "msg_purchase_ferrires_ticket".getNameLabel())
            self.present(mainNC, animated: true, completion: nil)
        }else{
//            self.performSegue(withIdentifier: "goPopUpHome", sender: nil)
            AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: TagsContentAnalytics.MainNavigation.rawValue, title: TagsID.mainPromotions.rawValue)
            let mainNC = AppStoryboard.Promociones.instance.instantiateViewController(withIdentifier: "Prom") as! PromocionesViewController
            mainNC.promFrom = "homePark"
            promFrom = "homePark"
            mainNC.modalPresentationStyle = .fullScreen
            self.present(mainNC, animated: true, completion: nil)
        }
        
//        self.performSegue(withIdentifier: "goBooking", sender: nil)
    }
    
    func configHeaderTableView(){
        headerView = (tblHome.tableHeaderView as! HomeHeaderView)
        headerView.homeViewController = self
        tblHome.tableHeaderView = nil
        tblHome.addSubview(headerView)
        tblHome.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
        tblHome.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight - 0)
        
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
        tblHome.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
        tblHome.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
        updateHeaderView()
    }
    
    func updateHeaderView()
    {
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tblHome.bounds.width, height: tableHeaderViewHeight)
        
        if tblHome.contentOffset.y < -effectiveHeight {
            self.setBckStatusBarStryle(type: "clear")
            headerRect.origin.y = tblHome.contentOffset.y
            headerRect.size.height = -tblHome.contentOffset.y + tableHeaderViewCutaway/2
        }else{
            self.setBckStatusBarStryle(type: "")
        }
        headerView.frame = headerRect
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        silentDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSilentScrolly(tblHome, followBottomView: tabBarController?.tabBar)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goHomeMap" {
            if let mapController = segue.destination as? MapViewController {
                mapController.hideTabbar = true
                mapController.typeCallController = "ALL"
            }
        }else if segue.identifier == "goViewImg"{
            if segue.destination is ViewImgViewController {
            }
        }else if segue.identifier == "goContentPrograms" {
            if segue.destination is ContentProgramsViewController {
//                mapController.hideTabbar = true
//                mapController.typeCallController = "ALL"
            }
        }else if segue.identifier == "goDetailPark" {
            if let detailController = segue.destination as? DetailParkViewController {
                detailController.keyPark = "XC"
            }
        }else if segue.identifier == "goDetailActivity" {
            if let detailActivity = segue.destination as? DetailActivityViewController{
                if appDelegate.itemParkSelected.code == "XV" || appDelegate.itemParkSelected.code == "XF" || appDelegate.itemParkSelected.code == "XP" || appDelegate.itemParkSelected.code == "XA" || appDelegate.itemParkSelected.code == "FE"{
                    detailActivity.isCallToMap = true
                    detailActivity.isCallbtnAllActivities = true
                }
                detailActivity.itemActivity = itemActivitySelected
            }
        }else if segue.identifier == "goDetailBasicActivity"{
            if let detailEvent = segue.destination as? DetailBasicViewController{
                detailEvent.itemEventSelected =  self.itemEventSelected
            }
        }else if segue.identifier == "goBooking"{
            if let detailBooking = segue.destination as? BookingViewController{
                
                if appDelegate.itemCuponActive.percent > 0 {
                    detailBooking.titleWebView = "\(appDelegate.itemParkSelected.name!) - \(appDelegate.itemCuponActive.percent) %"
                }else{
                    detailBooking.titleWebView = "\(appDelegate.itemParkSelected.name!)"
                }
                if appDelegate.itemParkSelected.code == "XV" {
                    detailBooking.typeItemBuyXV = self.typeItemBuyXV
                }
                
                if appDelegate.optionsHome {
//                    detailBooking.analytics_price = appDelegate.listPrecios.
                }else{
                    let itemsRegular = appDelegate.listPrecios.filter({$0.uid == "Regular"})
                    let itemsProductos = itemsRegular.first?.productos.filter({$0.key_park == appDelegate.itemParkSelected.uid})
                    let price = itemsProductos?.first?.adulto.filter({$0.key == Constants.CURR.current.lowercased()})
                    detailBooking.analytics_price = String(price?.first?.precio ?? 0.0)
                }
                
            }
        }else if segue.identifier == "goXenses"{
            if let detailXenses = segue.destination as? ManagePageViewController {
                detailXenses.currentViewControllerIndex = indexActivitySelected
                detailXenses.dataSource = listActivitiesSelected
            }
        }else if segue.identifier == "goPopUpHome"{
            if let popupPreBuy = segue.destination as? popUpPreBuyViewController {
                popupPreBuy.delegatePreBuyProm = self
            }
        }else if segue.identifier == "goDetailAdmission"{
            if let detailActivity = segue.destination as? DetailAdmissionViewController{
                detailActivity.itemAdmission = self.itemAdmissionSelected
            }
        }
    }
    
    @objc func unloadPark(){
            self.dismiss(animated: true, completion: nil)
            FirebaseBR.shared.getResetInformation()
        }
    
    func reloadTableXP(dia: Bool) {
        self.listParks = appDelegate.listAllParksEnabled
        var itemPark: ItemPark = ItemPark()
        var keyPark = "XP"
        if dia {
            let indexOf = listParks.firstIndex{$0.code == "XP"}
            itemPark = listParks[indexOf!]
            keyPark = "XP"
        }else{
            let indexOf = listParks.firstIndex{$0.code == "XF"}
            itemPark = listParks[indexOf!]
            keyPark = "XF"
        }
        
        appDelegate.itemParkSelected = itemPark
        FirebaseBR.shared.getInfoByParkSelected {
            FirebaseBR.shared.getListInfoHome(keyPark: keyPark) { (listHome) in
                self.listHome = listHome
                self.headerView.reloadCodePark()
                self.headerView.setNameButton()
                self.configDarkModeCustom()
                let tabBarController = UITabBarController()
                tabBarController.reloadInputViews()
                UIView.transition(with: self.tblHome,
                duration: 0.6,
                options: .transitionCrossDissolve,
                animations: { self.tblHome.reloadData() })
            }
        }
      
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource, ItemButtonTableViewCellDelegate, ItemSlideTableViewCellDelegete, ManageControllersDelegate, ItemSeeAllCellDelegate, GoRoadDelegate, GoBookingXVDelegate, ManageControllersDelegateXO, ManageBuyPromDelegate {
    func sendBuyProm(itemProm: [ItemProdProm]) {
        
    }
    
    func sendPreBuyProm(itemProm: [ItemProdProm]) {
        self.typeItemBuyXV = ""
        self.performSegue(withIdentifier: "goBooking", sender: nil)
    }
    
    func sendPreBuyPromBook(){
        print("OK...")
    }
    
    func goBookingXV(typeItemBuyXV: String) {
        self.typeItemBuyXV = typeItemBuyXV
        self.performSegue(withIdentifier: "goBooking", sender: nil)
    }
    
    func addCar(itemProm: [ItemProdProm]) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listHome.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = 10 + indexPath.row
        let itemHome = listHome[indexPath.row]
        
        switch itemHome.typeCell {
        case .cellActivity:
            let cell : ItemActTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActTableViewCell
            cell.collectionView.tag = tag
            cell.setInfoView(itemHome: itemHome)
            cell.delegate = self
            return cell
        case .cellMap:
            let cell : ItemMapTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellTVMap", for: indexPath) as! ItemMapTableViewCell
            cell.setInfoView(type: "MAP")
            return cell
            
        case .cellConSin:
            //Filtramos la informacion para los circuitos consentido y sinsentido
            //$0.category.cat_code == "AEXT" && $0.category.cat_code == "ADISC"
            let listSin = itemHome.listActivities.filter({$0.category.cat_code == "SINSENT"})
            let listCon = itemHome.listActivities.filter({$0.category.cat_code == "CONSENT"})
            let listGen = itemHome.listActivities.filter({$0.category.cat_code == "GENERAL"})
            let cell : ItemConSinTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellConSin", for: indexPath) as! ItemConSinTableViewCell
            cell.setInfoView(listActCon: listCon, listActSin: listSin, listActGen: listGen)
            cell.delegate = self
            return cell
            
        case .cellRestaurants:
            let cell : ItemSlideTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellSlide", for: indexPath) as! ItemSlideTableViewCell
            cell.configInfoView()
            cell.delegate = self
            return cell
        case .cellExtra:
            let cell : ItemActExtraTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActExtra", for: indexPath) as! ItemActExtraTableViewCell
            cell.collectionView.tag = tag
            cell.setInfoView(itemHome: itemHome, newHeight: cell.bounds.height)
            cell.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
            cell.delegate = self
            return cell
        case .cellSeeAll:
            let cell : ItemSeeAllTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellSee", for: indexPath) as! ItemSeeAllTableViewCell
            cell.delegate = self
            cell.setCell()
            return cell
        case .cellCallCenter, .cellInfoPark:
            let cell : ItemButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellSeeAll", for: indexPath) as! ItemButtonTableViewCell
            let currentCode = itemHome.typeCell == .cellCallCenter ? "PARKS" : "INFO"
            cell.setCell(code: currentCode)
            cell.delegate = self
            return cell
        case .cellbasicXV:
            let cell : ItemActTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActTableViewCell
            cell.collectionView.tag = 100
            cell.setInfoView(itemHome: itemHome)
            cell.delegate = self
//            cell.layer.borderColor = UIColor.red.cgColor
//            cell.layer.borderWidth = 5
            return cell
        case .cellAllInclusiveXV:
            let cell : ItemActTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActTableViewCell
            cell.collectionView.tag = 101
            cell.setInfoView(itemHome: itemHome)
            cell.delegate = self
            return cell
        case .cellTipoEntrada:
            let cell : ItemActTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActTableViewCell
            cell.collectionView.tag = 102
            cell.setInfoView(itemHome: itemHome)
            cell.delegate = self
            cell.delegateXV = self
            return cell
        case .cellSwichXP:
            let cell : SwitchXPTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellSwitchXP", for: indexPath) as! SwitchXPTableViewCell
            cell.homeViewController = self
            return cell
        case .cellProgramaMano:
        let cell : itemButtonPMTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellPMXC", for: indexPath) as! itemButtonPMTableViewCell
            cell.configTitle()
        return cell
        case .cellEvents:
            let cell : ItemActTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActTableViewCell
            cell.collectionView.tag = 103
            cell.setInfoView(itemHome: itemHome)
            cell.delegateXO = self
            return cell
        case .cellXOKermesMexicana:
            let cell : ItemActTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActTableViewCell
            cell.collectionView.tag = 104
            cell.setInfoView(itemHome: itemHome)
            return cell
        case .cellXOKerMexIMG:
            let cell : ItemActTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActTableViewCell
            cell.collectionView.tag = 106
            cell.setInfoView(itemHome: itemHome)
            cell.kerMexNumbeItems = 4
            return cell
        case .cellXOMenu:
            let cell : ItemActTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActTableViewCell
            cell.collectionView.tag = 105
            cell.setInfoView(itemHome: itemHome)
            return cell
        case .cellTitleXN:
            let cell : itemTitleDescriptionBasicTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellTitleXN", for: indexPath) as! itemTitleDescriptionBasicTableViewCell
//            cell.collectionView.tag = 107
            cell.setInfoView(itemHome: itemHome)
            return cell
        case .cellActivityBasic:
            let cell : ItemActTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActTableViewCell
            cell.collectionView.tag = 107
            cell.setInfoView(itemHome: itemHome)
            return cell
        case .cellAwardXenotes:
            let cell : ItemAwardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellItemAward", for: indexPath) as! ItemAwardTableViewCell
            cell.setInfoView(itemHome: itemHome)
            return cell
        case .cellRecomendacionesXN:
            let cell : segmentRecomendationsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellSegmentRecomendations", for: indexPath) as! segmentRecomendationsTableViewCell
            cell.setInfoView(itemPark: itemHome)
            return cell
        case .cellEventsXI:
            let cell : ItemActTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActTableViewCell
            cell.collectionView.tag = 108
            cell.setInfoView(itemHome: itemHome)
            return cell
        case .cellCenoteXI:
            let cell : ItemActTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ItemActTableViewCell
            cell.collectionView.tag = 109
            cell.setInfoView(itemHome: itemHome)
            return cell
        case .cellAddress:
            let cell : ItemAddressTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellAddress", for: indexPath) as! ItemAddressTableViewCell
            cell.setInfoView(itemPark: itemHome)
            return cell
        case .cellInfoParkShort:
            let cell : ItemParkInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellInfoParkShort", for: indexPath) as! ItemParkInfoTableViewCell
            cell.setInfoView(listAddmission: itemHome.listAdmissions)
            return cell
        case .cellScheduleAdmission:
            let cell : ItemScheduleAdmissionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellScheduleAdmission", for: indexPath) as! ItemScheduleAdmissionTableViewCell
            cell.setInfoView(listAdmission: itemHome.listAdmissions)
            return cell
        case .cellLocation:
            let cell : ItemLocationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellLocation", for: indexPath) as! ItemLocationTableViewCell
            cell.setInfoView(itemHome: itemHome)
           return cell
        case .cellPriceTableFE:
            let cell : tablePriceFETableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellTablePriceFE", for: indexPath) as! tablePriceFETableViewCell
            cell.setInfoView(itemHome: itemHome)
           return cell
        default:
            let cell : ItemAddressTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellAddress", for: indexPath) as! ItemAddressTableViewCell
            cell.setInfoView(itemPark: itemHome)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listHome[indexPath.row].typeCell == .cellMap {
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.goMap.rawValue)
            
            if listHome[indexPath.row].itemPark.code.lowercased() == "xs" {
                print("GoMapXENSES")
                self.sfHomePark(idEvent: "map")
                self.performSegue(withIdentifier: "goViewImg", sender: nil)
            }else{
                self.sfHomePark(idEvent: "map")
                self.performSegue(withIdentifier: "goHomeMap", sender: nil)
            }
        }else if listHome[indexPath.row].typeCell == .cellProgramaMano {
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.goProgramaMano.rawValue)
            self.performSegue(withIdentifier: "goContentPrograms", sender: nil)
        }else if listHome[indexPath.row].typeCell == .cellRestaurants{
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.goRestaurant.rawValue)
            self.sfHomePark(idEvent: "goRestaurants")
            if appDelegate.itemParkSelected.code == "XS"{
                let listRest = appDelegate.listActivitiesByPark.filter({$0.category.cat_code == "REST"})
                self.listActivitiesSelected = listRest
                self.indexActivitySelected = 0
                self.performSegue(withIdentifier: "goXenses", sender: nil)
            }else{
                self.performSegue(withIdentifier: "goRestaurants", sender: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemHome = listHome[indexPath.row]
        switch itemHome.typeCell {
        case .cellInfoPark, .cellCallCenter:
            print("height \(itemHome.sizeCell.height)")
            return itemHome.sizeCell.height
//        case .cellScheduleAdmission:
//             let cell = tableView.cellForRow(at: indexPath) as! ItemScheduleAdmissionTableViewCell
//                
//                let lblHeight: CGFloat = cell.lblTitle.frame.height
//                let firstCollectionHeight: CGFloat = cell.collectionViewDestinationA.collectionViewLayout.collectionViewContentSize.height
//                let secondCollectionHeight: CGFloat = cell.collectionViewDestinationB.collectionViewLayout.collectionViewContentSize.height
//                let spacesBetweenViews: CGFloat = 119
//                let mapsHeight: CGFloat = cell.imageViewMapA.frame.height + cell.imageViewMapB.frame.height
//                
//                return lblHeight + firstCollectionHeight + secondCollectionHeight + spacesBetweenViews + mapsHeight
            
            
        default:
           return UITableView.automaticDimension
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
        silentDidScroll()
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        showNavigationBar()
        return true
    }
    
    func getAction(_sender: ItemButtonTableViewCell) {
        if _sender.codeCell == "PARKS"{
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.listNew.rawValue)
            self.sfHomePark(idEvent: "parkCall")
            self.performSegue(withIdentifier: "goModalCallCenter", sender: nil)
        }else{
            AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.goDetailPark.rawValue)
            self.sfHomePark(idEvent: "about")
            self.performSegue(withIdentifier: "goDetailPark", sender: nil)
        }
    }
    
    func getAction(_sender: ItemSeeAllTableViewCell) {
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.callNow.rawValue)
        self.sfHomePark(idEvent: "goHomeAll")
        self.performSegue(withIdentifier: "goHomeAll", sender: nil)
    }
    
    func getRestaurants(_sender: ItemSlideTableViewCell) {
        AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: TagsID.goRestaurant.rawValue)
        if appDelegate.itemParkSelected.code == "XS"{
            let listRest = appDelegate.listActivitiesByPark.filter({$0.category.cat_code == "REST"})
            self.listActivitiesSelected = listRest
            self.indexActivitySelected = 0
            self.performSegue(withIdentifier: "goXenses", sender: nil)
        }else{
            self.performSegue(withIdentifier: "goRestaurants", sender: nil)
        }
    }
    
    func sendDetailActivity(activity: ItemActivity, idEvent: String){
        print("Prueba se seleccion \(activity.details.name)")
        sfHomePark(idEvent: idEvent)
         AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: idEvent)
        if appDelegate.itemParkSelected.code == "XS"{
            self.listActivitiesSelected = [activity]
            self.indexActivitySelected = 0
            self.performSegue(withIdentifier: "goXenses", sender: nil)
        }else{
            self.itemActivitySelected = activity
            self.performSegue(withIdentifier: "goDetailActivity", sender: nil)
        }
    }
    
    func sendDetailAdmission(admission: ItemAdmission){
        self.itemAdmissionSelected = admission
        self.performSegue(withIdentifier: "goDetailAdmission", sender: nil)
    }
    
    func sendDetailBasicActivity(activity: ItemEvents, idEvent: String){
        print("Prueba se seleccion \(activity.getDetail.name)")
         AnalyticsBR.shared.saveEventContentFBByPark(content: TagsContentAnalytics.Home.rawValue, title: idEvent)
        if appDelegate.itemParkSelected.code == "XO"{
            self.itemEventSelected = activity
            self.performSegue(withIdentifier: "goDetailBasicActivity", sender: nil)
        }
//        if appDelegate.itemParkSelected.code == "XO"{
//            self.listActivitiesSelected = [activity]
//            self.indexActivitySelected = 0
//            self.performSegue(withIdentifier: "goXenses", sender: nil)
//        }else{
//            self.itemActivitySelected = activity
//            self.performSegue(withIdentifier: "goDetailActivity", sender: nil)
//        }
    }
    
    func goToRoadActivities(itemSelected: Int, listActivities: [ItemActivity]) {
        self.listActivitiesSelected = listActivities
        self.indexActivitySelected = itemSelected
        self.performSegue(withIdentifier: "goXenses", sender: nil)
    }
    
    func sfHomePark(idEvent: String) {
        print("Selected \(idEvent)")
        var pageAttr = [String : Any]()
        
        switch idEvent {
        case "listNew":
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_New": "Nuevas"]
        case "listMustDo":
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_Essentials": "esenciales"]
        case "listAttractions":
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_Discover": "por_descubrir"]
        case "map":
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_Map": "mapa"]
        case "listExtraordinary":
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_Extraordinary": "extraordinarias"]
        case "about":
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_About": "acerca_de"]
        case "listPerformance":
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_Spectacle": "espectáculos"]
        case "goHomeAll":
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_All": "todas"]
        case "goRestaurants":
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_Restaurants": "restaurantes"]
        case "parkCall":
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_ParkCall": true]
        default:
            pageAttr = ["\(appDelegate.itemParkSelected.code.uppercased())_default": "default"]
        }
        
        (AppDelegate.getKruxTracker()).trackPageView("HomePark", pageAttributes:pageAttr, userAttributes:nil)
    }
    
}
