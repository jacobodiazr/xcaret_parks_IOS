//
//  PromocionesViewController.swift
//  XCARET!
//
//  Created by Hate on 19/08/20.
//  Copyright © 2020 Angelica Can. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON


class PromocionesViewController: UIViewController {
    weak var delegateGoMenuTickets : GoMenuTickets?
    var itemsPrecios : [ItemPrecios] = [ItemPrecios]()
    var itemsPreciosOrder : [ItemPrecios] = [ItemPrecios]()
    var itemsPreciosSelect : [ItemProdProm] = [ItemProdProm]()
    var itemsProm : [ItemProdProm] = [ItemProdProm]()
    var itemHeaderSelect : [Itemslangs] = [Itemslangs]()
    var itemslangsPromotions : [Itemslangs] = [Itemslangs]()
    @IBOutlet var viewGradient: GradientView!
    var langListBenefits : [ItemsLangBenefit] = [ItemsLangBenefit]()
    @IBOutlet weak var constraintHomeX: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewImgBack: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var viewMenu: GradientView!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var nameCurrency: UILabel!
    @IBOutlet weak var imgIconChangeCurrency: UIImageView!
    @IBOutlet weak var contentCurrency: UIView!
    @IBOutlet weak var contentDrop: UIView!
    @IBOutlet weak var constraintDrop: NSLayoutConstraint!
    @IBOutlet weak var constraintHCollection: NSLayoutConstraint!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var goCarrito: UIView!
    @IBOutlet weak var poinrCS: UIView!
    @IBOutlet weak var promotionFrom: UILabel!
    
    var allotment = false
    
    var diaCarShop = ItemDiaCalendario()
    var listDiaCarShop = [ItemDiaCalendario]()
    var itemCarShoop = ItemCarShoop()
    var listCarshop = [ItemListCarshop]()
    
    var listItemCarShop = [ItemCarShoop]()
    var itemProdProm = [[ItemProdProm]]()
//    var itemCS = ItemCarShoop()
    
    var select = ""
    var buttomSelect = "park"
    var itemButtonSelectNil = false
    var typePopUp = ""
    var inAppSelect = ""
    var inAppPromotionCode = ""
    var inAppSelectNo = 0
    var idAction = ""
    var promos = [ItemProdProm]()
    let promotions = appDelegate.listlangsPromotions.filter({$0.uid == Constants.LANG.current && $0.status == true}).sorted(by: {$0.order < $1.order})
    var promFrom = ""
    
    let menu : DropDown = {
        let menu = DropDown()
        var imgCurrency = [String]()
        for itemCurrency in appDelegate.listCurrencies{
            
            menu.dataSource.append(itemCurrency.currency)
            imgCurrency.append("ic_\(itemCurrency.country ?? "ic_es")")
        }
        
        menu.cellNib = UINib(nibName: "DropDownTableViewCell", bundle: nil)
        menu.customCellConfiguration = {index, title, cell in
            guard let cell = cell as? DropDownTableViewCell else {
                return
            }
            cell.imgFlag.image = UIImage(named:  "Icons/\(imgCurrency[index])")
        }
        return menu
    }()
    
    @IBOutlet weak var collectionViewMenu: UICollectionView! {
        didSet{
            self.collectionViewMenu.register(UINib.init(nibName: "buttonMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellMenuPromociones")
            self.collectionViewMenu.register(UINib.init(nibName: "itemPromocionesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellPromosTienda")
        }
    }
    
    @IBOutlet weak var tblProm: UITableView!{
        didSet{
            tblProm.register(UINib(nibName: "itemProdPromTableViewCell", bundle: nil), forCellReuseIdentifier: "cellProduct")
            tblProm.register(UINib(nibName: "itemPromsTableViewCell", bundle: nil), forCellReuseIdentifier: "cellItemProms")
            tblProm.register(UINib(nibName: "itemsBenefitTableViewCell", bundle: nil), forCellReuseIdentifier: "cellBenefit")
            tblProm.register(UINib(nibName: "itemOpcionesPagoTableViewCell", bundle: nil), forCellReuseIdentifier: "cellOpcionesPago")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.goCarrito.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.someCarrito(_:))))
        poinrCS.isHidden = true
        print(appDelegate.idAction)
        //        if appDelegate.idAction != "" {
        //            self.idAction = appDelegate.idAction
        //            appDelegate.idAction
        //        }
        
        var status = appDelegate.listlangsPromotions.filter({$0.uid == Constants.LANG.current && $0.status == true})
        status = status.sorted(by: { $0.order < $1.order })
        for itemIndex in status.indices {
            if status[itemIndex].prod_code == appDelegate.idAction {
                self.inAppSelectNo = itemIndex
            }
        }
        
        self.constraintDrop.constant = 0
        
        menu.anchorView = contentDrop
        menu.backgroundColor = .white
        menu.selectRow(menu.dataSource.firstIndex(of: Constants.CURR.current) ?? 0)
        menu.selectionAction = { index, title in
            
            UserDefaults.standard.set(title, forKey: "UserCurrency")
            UserDefaults.standard.synchronize()
            Constants.CURR.current = title
            
            if appDelegate.optionsHome {
                
                AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: "HM_\(TagsID.Promotion.rawValue)", title: "\(Constants.CURR.current)_\(TagsContentAnalytics.Currency.rawValue)")
            }else{
                
                AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: "\(appDelegate.itemParkSelected.code ?? "")_\(TagsID.Promotion.rawValue)", title: "\(Constants.CURR.current)_\(TagsContentAnalytics.Currency.rawValue)")
            }
            
            self.configNavCurrency()
            self.tblProm.reloadData()
        }
        
        let floawLayout = UPCarouselFlowLayout()
        floawLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width * 0.92, height: 160.0)//height: UIScreen.main.bounds.height * 0.24)
        floawLayout.scrollDirection = .horizontal
        floawLayout.sideItemScale = 1
        floawLayout.sideItemAlpha = 1
        floawLayout.spacingMode = .fixed(spacing: 0.0)
        collectionViewMenu.collectionViewLayout = floawLayout
        
        self.configNavCurrency()
        self.tblProm.reloadData()
        
        constraintHomeX.constant = UIDevice().getHeightHomePromociones()
        constraintHCollection.constant = 175.0//UIScreen.main.bounds.height * 0.24
        
        self.lblTitle.text = "lbl_promotions".getNameLabel()
        self.promotionFrom.text = "lbl_best_promotions_shop".getNameLabel()//"Selecciona tu promoción y elige el parque que visitarás"
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        self.viewImgBack.addGestureRecognizer(tapRecognizer)
        
//        if !appDelegate.optionsHome {
//            self.viewImgBack.isHidden = true
//        }
        
        self.collectionViewMenu.delegate = self
        self.collectionViewMenu.dataSource = self
        self.tblProm.delegate = self
        self.tblProm.dataSource = self
        
        if appDelegate.itemParkSelected.code != ""{
            configBackColor(park : appDelegate.itemParkSelected)
        }
        
        configNavCurrency()
        datosPorPromocion()
        
    }
    
    func pointCarShop(){
        
            if appDelegate.listItemListCarshop.count > 0 {
                if (appDelegate.listItemListCarshop.first?.detail.count ?? 0) > 0 {
                    let itemsActivos = appDelegate.listItemListCarshop.first?.detail.filter({ $0.status == 1})
                    if itemsActivos?.count ?? 0 > 0 {
                        self.poinrCS.isHidden = false
                    }else{
                        self.poinrCS.isHidden = true
                    }
                }
            }
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
        
    }
    
    @objc func someCarrito(_ sender : UITapGestureRecognizer){
        let mainNC = AppStoryboard.Cotizador.instance.instantiateViewController(withIdentifier: "Cotizador")
        mainNC.modalPresentationStyle = .overFullScreen
        self.present(mainNC, animated: true, completion: nil)
    }
    
    func configNavCurrency(){
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.changeCurrency))
        self.contentCurrency.addGestureRecognizer(gesture)
        
        imgIconChangeCurrency.image = imgIconChangeCurrency.image?.withRenderingMode(.alwaysTemplate)
        imgIconChangeCurrency.tintColor = UIColor(red: 78/255, green: 117/255, blue: 163/255, alpha: 1.00)
//        contentCurrency.isHidden = true
    }
    
    

    @objc func changeCurrency(sender : UITapGestureRecognizer) {
//        self.constraintDrop.constant = 45
//        menu.show()
//        self.constraintDrop.constant = 0
        print("goMenuCUrrency")
        let mainNC = AppStoryboard.Tienda.instance.instantiateViewController(withIdentifier: "MenuCurrency") as! MenuCurrencyViewController
        mainNC.modalPresentationStyle = .overFullScreen
        mainNC.modalTransitionStyle = .crossDissolve
        mainNC.delegateChangeCurrencyShop = self
        self.present(mainNC, animated: true, completion: nil)
    }
    
    func configBackColor(park : ItemPark){
        lblTitle.text = park.name
        promotionFrom.text = "\("lbl_promotion_subtitle".getNameLabel()) \(park.name ?? "")"
        switch park.code.lowercased() {
        case "xc":
            viewGradient.firstColor = UIColor(red: 240/255, green: 255/255, blue: 218/255, alpha: 1.00)
            viewGradient.secondColor = UIColor.white
            gradientView.firstColor = UIColor(red: 240/255, green: 255/255, blue: 218/255, alpha: 1.00)
            gradientView.secondColor = UIColor.white
        case "xh":
            viewGradient.firstColor = UIColor(red: 216/255, green: 244/255, blue: 255/255, alpha: 1.00)
            viewGradient.secondColor = UIColor.white
            gradientView.firstColor = UIColor(red: 216/255, green: 244/255, blue: 255/255, alpha: 1.00)
            gradientView.secondColor = UIColor.white
        case "xp":
            viewGradient.firstColor = UIColor(red: 255/255, green: 231/255, blue: 214/255, alpha: 1.00)
            viewGradient.secondColor = UIColor.white
            gradientView.firstColor = UIColor(red: 255/255, green: 231/255, blue: 214/255, alpha: 1.00)
            gradientView.secondColor = UIColor.white
        case "xf":
            viewGradient.firstColor = UIColor(red: 255/255, green: 218/255, blue: 205/255, alpha: 1.00)
            viewGradient.secondColor = UIColor.white
            gradientView.firstColor = UIColor(red: 255/255, green: 218/255, blue: 205/255, alpha: 1.00)
            gradientView.secondColor = UIColor.white
        case "xo":
            viewGradient.firstColor = UIColor(red: 255/255, green: 221/255, blue: 253/255, alpha: 1.00)
            viewGradient.secondColor = UIColor.white
            gradientView.firstColor = UIColor(red: 255/255, green: 221/255, blue: 253/255, alpha: 1.00)
            gradientView.secondColor = UIColor.white
        case "xs":
            viewGradient.firstColor = UIColor(red: 255/255, green: 244/255, blue: 184/255, alpha: 1.00)
            viewGradient.secondColor = UIColor.white
            gradientView.firstColor = UIColor(red: 255/255, green: 244/255, blue: 184/255, alpha: 1.00)
            gradientView.secondColor = UIColor.white
        case "xv":
            viewGradient.firstColor = UIColor(red: 255/255, green: 219/255, blue: 218/255, alpha: 1.00)
            viewGradient.secondColor = UIColor.white
            gradientView.firstColor = UIColor(red: 255/255, green: 219/255, blue: 218/255, alpha: 1.00)
            gradientView.secondColor = UIColor.white
        case "xn":
            viewGradient.firstColor = UIColor(red: 221/255, green: 255/255, blue: 255/255, alpha: 1.00)
            viewGradient.secondColor = UIColor.white
            gradientView.firstColor = UIColor(red: 221/255, green: 255/255, blue: 255/255, alpha: 1.00)
            gradientView.secondColor = UIColor.white
        case "xi":
            viewGradient.firstColor = UIColor(red: 255/255, green: 196/255, blue: 196/255, alpha: 1.00)
            viewGradient.secondColor = UIColor.white
            gradientView.firstColor = UIColor(red: 255/255, green: 196/255, blue: 196/255, alpha: 1.00)
            gradientView.secondColor = UIColor.white
        default:
            viewGradient.firstColor = UIColor(red: 240/255, green: 255/255, blue: 218/255, alpha: 1.00)
            viewGradient.secondColor = UIColor.white
            gradientView.firstColor = UIColor(red: 240/255, green: 255/255, blue: 218/255, alpha: 1.00)
            gradientView.secondColor = UIColor.white
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.goShop = false
        
        pointCarShop()
        
        for itemIndex in itemsPrecios.indices {
            if itemsPrecios[itemIndex].uid == appDelegate.idAction {
                self.inAppSelectNo = itemIndex
            }
        }
        
        if inAppSelectNo != 0{
            DispatchQueue.main.async {
                if self.inAppSelectNo <= self.itemslangsPromotions.count{
                    let indexPath = IndexPath(item: self.inAppSelectNo, section: 0)
                    self.collectionViewMenu.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                }else{
                    let indexPath = IndexPath(item: 0, section: 0)
                    self.collectionViewMenu.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                }
            }
            
        }else{
            let indexPath = IndexPath(item: 0, section: 0)
            self.collectionViewMenu.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
        
        let aux = promFrom
//        if promFrom == "homePark" {
//            self.dismiss(animated: true, completion: nil)
//        }
        
        appDelegate.idAction = ""
        self.tblProm.reloadData()
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setPositionActivity(index : Int){
        
        if itemsPrecios.count > index{
//            let indexPath = IndexPath(item: index, section: 0)
//            self.collectionViewMenu.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            select = itemsPrecios[index].uid!
            buttomSelect = "park"
            let indexP = IndexPath(row: 0, section: 0)
            self.tblProm.scrollToRow(at: indexP, at: .top, animated: true)
            datosPorPromocion()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == collectionViewMenu) {
        let layout = self.collectionViewMenu.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        }
    }
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            print("page at centre = \(currentPage)")
            setPositionActivity(index: currentPage)
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionViewMenu.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    
    func datosPorPromocion(){
        itemsPreciosOrder.removeAll()
        itemsPrecios.removeAll()
        print(select)
        print(buttomSelect)
        let langHeaderItemProms = appDelegate.listlangsPromotions.filter({$0.uid == Constants.LANG.current && $0.status == true}).sorted(by: { $0.order < $1.order})
        itemslangsPromotions = langHeaderItemProms
//        for itemslangsProm in langHeaderItemProms{
//            if itemslangsPromotions.isEmpty {
//                itemslangsPromotions.append(itemslangsProm)
//            }else{
//                let itemP = itemslangsPromotions.filter({$0.prod_code == itemslangsProm.prod_code })
//                if itemP.count == 0 {
//                    itemslangsPromotions.append(itemslangsProm)
//                }
//            }
//        }
        let auxitemslangsPromotions = itemslangsPromotions
        let auxlistPrecios = appDelegate.listPrecios
        let auxItemParkSelected = appDelegate.itemParkSelected
        
        for ip in appDelegate.listPrecios{
            if appDelegate.itemParkSelected.code == ""{
                if ip.uid != "Regular"{
                    itemsPrecios.append(ip)
                }
            }else{
                if ip.uid != "Regular"{
                    let item = ip.productos.filter({$0.code_park == appDelegate.itemParkSelected.code!.lowercased()})
                    if !item.isEmpty {
                        let itemsPre : ItemPrecios = ItemPrecios()
                        itemsPre.uid = ip.uid
                        itemsPre.productos = item
                        itemsPrecios.append(itemsPre)
//                        select = itemsPrecios.first!.uid!
                    }
                }
                
            }
        }
        
        let listlangs = itemslangsPromotions.filter({$0.uid == Constants.LANG.current}).sorted(by: { $0.order < $1.order})
        
        for itemProm in listlangs{
            for itemPrecios in itemsPrecios{
                if itemProm.prod_code == itemPrecios.uid{
                    itemsPreciosOrder.append(itemPrecios)
                }
            }
        }
        itemsPrecios = itemsPreciosOrder

        
        if select == "" && itemsPrecios.count > 0{
            if inAppSelectNo != 0 {
//                let aux = itemslangsPromotions[inAppSelectNo].prod_code
                if self.inAppSelectNo <= self.itemslangsPromotions.count{
                    select = itemslangsPromotions[inAppSelectNo].prod_code
                }else{
                    select = itemsPrecios.first!.uid!
                }
            }else{
                select = itemsPrecios.first!.uid!
            }
            
        }
        
        itemHeaderSelect.removeAll()
        itemHeaderSelect = itemslangsPromotions.filter({$0.prod_code == select})
        langListBenefits.removeAll()
        langListBenefits = appDelegate.listlamgBenefit.filter({$0.uid == Constants.LANG.current && $0.status == true && $0.promotion == itemHeaderSelect.first?.key_promotion }).sorted(by: { $0.order < $1.order })
        let itemsPromSelect = itemsPrecios.filter({$0.uid == select})
        let itemButtonSelect = itemsPromSelect.first?.productos.filter({$0.distintivo == buttomSelect})
        if itemButtonSelect != nil && itemButtonSelect?.count != 0{
            itemsPreciosSelect = itemButtonSelect!.filter({$0.status_product == true}).sorted(by: { $0.product_order < $1.product_order })
        }else{
            if buttomSelect == "tour" || buttomSelect == "park" {
                print(select)
                print(buttomSelect)
                buttomSelect = "tour"
                datosPorPromocion()
            }
        }
        
        UIView.transition(with: tblProm,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { self.tblProm.reloadData() })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popUpHome" {
            if let vc = segue.destination as? PopUpHomeViewController{
                print(self.typePopUp)
                vc.typePopUP = self.typePopUp
                vc.itemsPreciosSelect = self.itemsPreciosSelect
                vc.itemProdProm = self.itemsProm
            }
        }
        if segue.identifier == "popUpPreBuy" {
            if let vc = segue.destination as? popUpPreBuyViewController{
                print(self.typePopUp)
                vc.itemsProm = self.itemsProm
                vc.itemsPreciosSelect = self.itemsPreciosSelect
                vc.delegatePreBuyProm = self
            }
        }
        
        if segue.identifier == "go3parks" {
            if let vc = segue.destination as? PopUp3ParksViewController{
                vc.promos = promos
            }
        }
        
        if segue.identifier == "goBuyProm"{
        if let detailBooking = segue.destination as? CotizadorViewController{
            let itemPromBuy = self.itemsProm
//            detailBooking.itemBuyProm = self.itemsProm
//            detailBooking.callingCode = "Promo"
//            detailBooking.delegateGoMenuTickets = self
//            let allParks = appDelegate.listAllParks.filter({$0.code.lowercased() == itemPromBuy.first?.code_park})
//            
//            if appDelegate.itemCuponActive.percent > 0 {
//                
//                detailBooking.titleWebView = "\(itemPromBuy.first!.code_promotion! ) - \(appDelegate.itemCuponActive.percent) %"
////                detailBooking.modalPresentationStyle = .fullScreen
//                
//            }else{
//                
//                detailBooking.titleWebView = "\(itemPromBuy.first!.code_promotion!) \(allParks.first!.name! )"
////                detailBooking.modalPresentationStyle = .fullScreen
//                
//            }
//            if appDelegate.itemParkSelected.code == "XV" {
////                detailBooking.typeItemBuyXV = self.typeItemBuyXV
//            }
//            
//            
//            let price = itemPromBuy.first?.adulto.filter({$0.key == Constants.CURR.current.lowercased()})
//            detailBooking.analytics_price = String(price?.first?.precio ?? 0.0)
            
        }
    }
    }
    
    func sendPopUpHome(typePopUp: String) {
        self.typePopUp = typePopUp
        performSegue(withIdentifier: "popUpHome", sender: nil)
    }
    
    
    func sendProm(itemProm: [ItemProdProm]) {
        if let prom = itemProm.first?.cupon_promotion {
            self.promos = itemProm
            if prom == "HSBCXC1" || prom == "SPRING2021" || prom == "SSANTA2021"{
                performSegue(withIdentifier: "go3parks", sender: nil)
            }else{
                self.typePopUp = "incluye"
                self.itemsProm = itemProm
                performSegue(withIdentifier: "popUpHome", sender: nil)
            }
        }else{
            self.typePopUp = "incluye"
            self.itemsProm = itemProm
            performSegue(withIdentifier: "popUpHome", sender: nil)
        }
        
    }
    
    func sendBuyProm(itemProm: [ItemProdProm]) {
        self.itemsProm = itemProm
        print(itemProm)
        performSegue(withIdentifier: "popUpPreBuy", sender: nil)
    }
    
    func addCar(itemProm: [ItemProdProm]) {
        
        if inCarShop(itemProm : itemProm) {
            let alert = UIAlertController(title: "En carrito", message: "Este parque ya lo tiene en su carrito, ¿desea agregarlo de nuevo?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertAction.Style.default, handler: { action in
                
                self.addCarContinue(itemProm: itemProm)

            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.addCarContinue(itemProm: itemProm)
        }
    }
    
    func inCarShop(itemProm: [ItemProdProm]) -> Bool {
        if (appDelegate.listItemListCarshop.first?.detail.filter({ $0.uid == itemProm.first?.uid}).count ?? 0) > 0 {
            return true
        }else{
            return false
        }
    }
    
    func addCarContinue(itemProm: [ItemProdProm]){
        if itemProm.first?.product_childs.count == 0 {
            addCarShopSencillo(itemProm: itemProm)
        }else{
            var listItemProdsProms = [ItemProdProm]()
            itemProm.first?.principal = true
//            itemProm.first?.code_promotion = "pack"
            listItemProdsProms.append(itemProm.first!)
            for productChilds in itemProm.first?.product_childs ?? [ItemProduct_childs]() {
                
                let itemProdProm = appDelegate.listProductsPromotions.filter({ $0.key_product == productChilds.value})
                let itemListProm = appDelegate.listPromotions.filter({$0.uid == itemProdProm.first?.key_promotion})
                
                let itemListPrecios = appDelegate.listPrecios.filter({ $0.uid == itemListProm.first?.code})
                let listItemProdProm = itemListPrecios.first?.productos.filter({ $0.key == productChilds.key}).first
                listItemProdProm?.principal = false
                listItemProdProm?.code_promotion = "pack"
                listItemProdsProms.append(listItemProdProm!)
            }
            addCarShopPacks(itemsProms: listItemProdsProms)
        }
    }
    
    
    
    func addCarShopPacks(itemsProms: [ItemProdProm]){
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        self.itemCarShoop.itemProdProm = itemsProms
        
        var listItemCS = [ItemCarShoop]()
        var listItemCSAllotment = [ItemCarShoop]()
        
        let itemsPromsPrincipal = itemsProms.filter({ $0.principal == true })
        let itemsPromsNoPrincipal = itemsProms.filter({ $0.principal == false })
        
        let itemCSPrincipal = ItemCarShoop()
        itemCSPrincipal.itemProdProm = itemsPromsPrincipal
        listItemCS.append(itemCSPrincipal)
        
        for itemProm in itemsPromsNoPrincipal {
            let date = Date()
            let calendario = Calendar.current
            
            let anio : Int = calendario.component(.year, from: date)
            let day : Int = calendario.component(.day, from: date)
            let mes : Int = calendario.component(.month, from: date)
            
            self.listItemCarShop.removeAll()
            self.itemProdProm.removeAll()
            
            var itemsProdProms = [ItemProdProm]()
            itemsProdProms = [itemProm]
            
            let itemCS = ItemCarShoop()
            itemCS.itemProdProm = itemsProdProms
            
            
            FirebaseBR.shared.getCalendarData(listDias: itemsProdProms, mes : mes, year : anio, day : day, completion: { (isSuccess, JSONData) in
                if isSuccess {
                    self.crearOnLine(mes : mes - 1, year : anio, dia: day, json : JSONData, principal: itemProm.principal ?? false)
                    if self.diaCarShop.disable == 0 {
                        itemCS.itemDiaCalendario = self.diaCarShop
                        self.diaCarShop = ItemDiaCalendario()
                        listItemCS.append(itemCS)
                        if listItemCS.count == itemsProms.count {
                            self.listDiaCarShop.removeAll()
                            FirebaseBR.shared.getPackData(listItemsCarShop: listItemCS, completion: { (isSuccess, listItemCSP) in
                                if isSuccess {
                                    print(listItemCS)
                                    for itemCS in listItemCSP.filter({$0.itemProdProm.first?.principal == false}) {
                                        
                                        FirebaseBR.shared.getAllotment(itemCarShoop : itemCS, completion: { (isSuccess, allotmentAvail) in
                                            if isSuccess {
                                                if allotmentAvail.activityAvail.status.lowercased() == "open"  && allotmentAvail.allotment{
                                                    listItemCSAllotment.append(itemCS)
                                                    let indexAllotmenItemPack = listItemCSP.index(where: { $0.itemProdProm.first?.uid == itemCS.itemProdProm.first?.uid })
                                                    listItemCSP[indexAllotmenItemPack ?? 0].productAllotment = allotmentAvail.allotment
                                                    if (listItemCS.count - 1) == listItemCSAllotment.count {
                                                        FirebaseBR.shared.updateListCarshopPacks(listItemCarShop : listItemCSP, completion: { listTickets, result   in
                                                            FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                                                self.listCarshop = itemsPickup
                                                                appDelegate.listItemListCarshop = itemsPickup
                                                                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                                                let alert = UIAlertController(title: "En carrito", message: "Se agrego a su carrito", preferredStyle: UIAlertController.Style.alert)
                                                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                                                self.present(alert, animated: true, completion: nil)
                                                            })
                                                        })
                                                    }
                                                }else{
                                                    listItemCSAllotment.append(itemCS)
                                                    if (listItemCS.count - 1) == listItemCSAllotment.count {
                                                        FirebaseBR.shared.updateListCarshopPacks(listItemCarShop : listItemCSP, completion: { listTickets, result   in
                                                            FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                                                self.listCarshop = itemsPickup
                                                                appDelegate.listItemListCarshop = itemsPickup
                                                                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                                                let alert = UIAlertController(title: "En carrito", message: "Se agrego a su carrito", preferredStyle: UIAlertController.Style.alert)
                                                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                                                self.present(alert, animated: true, completion: nil)
                                                            })
                                                        })
                                                    }
                                                }
                                            }
                                        })
                                        
                                        
//                                        FirebaseBR.shared.getRateKeyAllotment(itemCarShoop : itemCS, completion: { (isSuccess, allotment, rateKey, allowedCustomerConfigPax) in
//                                            if isSuccess && allotment == "allotment" {
//                                                listItemCSAllotment.append(itemCS)
//                                                let indexAllotmenItemPack = listItemCSP.index(where: { $0.itemProdProm.first?.uid == itemCS.itemProdProm.first?.uid })
//                                                listItemCSP[indexAllotmenItemPack ?? 0].productAllotment = true
//                                                if (listItemCS.count - 1) == listItemCSAllotment.count {
//                                                    FirebaseBR.shared.updateListCarshopPacks(listItemCarShop : listItemCSP, completion: { listTickets, result   in
//                                                        FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
//                                                            self.listCarshop = itemsPickup
//                                                            appDelegate.listItemListCarshop = itemsPickup
//                                                            LoadingView.shared.hideActivityIndicator(uiView: self.view)
//                                                            let alert = UIAlertController(title: "En carrito", message: "Se agrego a su carrito", preferredStyle: UIAlertController.Style.alert)
//                                                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
//                                                            self.present(alert, animated: true, completion: nil)
//                                                        })
//                                                    })
//                                                }
//                                            }else if isSuccess && allotment == "noAllotment"{
//                                                listItemCSAllotment.append(itemCS)
//                                                if (listItemCS.count - 1) == listItemCSAllotment.count {
//                                                    FirebaseBR.shared.updateListCarshopPacks(listItemCarShop : listItemCSP, completion: { listTickets, result   in
//                                                        FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
//                                                            self.listCarshop = itemsPickup
//                                                            appDelegate.listItemListCarshop = itemsPickup
//                                                            LoadingView.shared.hideActivityIndicator(uiView: self.view)
//                                                            let alert = UIAlertController(title: "En carrito", message: "Se agrego a su carrito", preferredStyle: UIAlertController.Style.alert)
//                                                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
//                                                            self.present(alert, animated: true, completion: nil)
//                                                        })
//                                                    })
//                                                }
//                                            }else{
//                                                LoadingView.shared.hideActivityIndicator(uiView: self.view)
//                                                let alert = UIAlertController(title: "Error", message: "Ocurrio un error inesperado, vuelva a intenralo mas tarde", preferredStyle: UIAlertController.Style.alert)
//                                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
//                                                self.present(alert, animated: true, completion: nil)
//                                            }
//
//                                        })
                                    }
                                }else{
                                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                    let alert = UIAlertController(title: "Error", message: "Error al agregarlo al carrito, intentelo más tarde", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertAction.Style.cancel, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            })
                        }
                    }else{
                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                        let alert = UIAlertController(title: "Error", message: "Error al agregarlo al carrito, intentelo más tarde", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertAction.Style.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }else{
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    let alert = UIAlertController(title: "Error", message: "Error al agregarlo al carrito, intentelo más tarde", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
//                    return
                }
            })
        }
        
    }
    
    func addCarShopSencillo(itemProm: [ItemProdProm]){
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        self.itemCarShoop.itemProdProm = itemProm
        
        let date = Date()
        let calendario = Calendar.current
        
        let anio : Int = calendario.component(.year, from: date)
        let day : Int = calendario.component(.day, from: date)
        let mes : Int = calendario.component(.month, from: date)
        
        self.listItemCarShop.removeAll()
        self.itemProdProm.removeAll()
        
        var itemsProdProms = [ItemProdProm]()
        itemsProdProms = itemProm
        itemsProdProms.first?.principal = true
        
        
        let itemCS = ItemCarShoop()
        itemCS.itemProdProm = itemsProdProms
        
        FirebaseBR.shared.getCalendarData(listDias: itemsProdProms, mes : mes, year : anio, day : day, completion: { (isSuccess, JSONData) in
            if isSuccess {
                self.crearOnLine(mes : mes - 1, year : anio, dia: day, json : JSONData, principal: itemsProdProms.first?.principal ?? false)
                if self.diaCarShop.disable == 0 {
                    itemCS.itemDiaCalendario = self.diaCarShop
                    self.diaCarShop = ItemDiaCalendario()
                    self.additemFBSencillo(itemCS : itemCS)
                }
            }else{
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                let alert = UIAlertController(title: "Error", message: "Ocurrio un error inesperado, vuelva a intenralo mas tarde", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func additemFBSencillo(itemCS : ItemCarShoop){
        FirebaseBR.shared.updateItemCarshopSencillo(itemCarShop : [itemCS], completion: { listTickets, result in
            FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                self.listCarshop = itemsPickup
                appDelegate.listItemListCarshop = itemsPickup
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                self.poinrCS.isHidden = false
                let alert = UIAlertController(title: "En carrito", message: "Se agrego a su carrito", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            })
        })
    }
    
    func addCarContinuex(itemProm: [ItemProdProm]){
        self.itemCarShoop.itemProdProm = itemProm
        let items = self.itemCarShoop.itemProdProm.first

        let date = Date()
        let calendario = Calendar.current

        let anio : Int = calendario.component(.year, from: date)
        let day : Int = calendario.component(.day, from: date)
        let mes : Int = calendario.component(.month, from: date)

        self.listItemCarShop.removeAll()
        self.itemProdProm.removeAll()

        if items!.product_childs != nil && items!.product_childs.count > 1{

            var itemsProdProms = [ItemProdProm]()
            itemsProdProms = itemProm
            itemsProdProms.first?.principal = true
            self.itemProdProm.append(itemsProdProms)

            for itemProductChilds in items!.product_childs {

                let filterAPP = appDelegate.listPrecios.filter({ $0.uid == "APP" })
                let filterProductos = filterAPP.first?.productos//.filter({ $0.idProducto == listProductsPromotions.first?.key_product })
                let producto = filterProductos?.filter({$0.code_product == itemProductChilds.key}) ?? [ItemProdProm]()
                producto.first?.principal = false
                self.itemProdProm.append(producto)

            }

        }else{
            var itemsProdProms = [ItemProdProm]()
            itemsProdProms = itemProm
            itemsProdProms.first?.principal = true
            self.itemProdProm.append(itemsProdProms)
        }

        for itemsProdProm in self.itemProdProm {
            LoadingView.shared.showActivityIndicator(uiView: self.view)
            let itemCS = ItemCarShoop()
            itemCS.itemProdProm = itemsProdProm

            FirebaseBR.shared.getCalendarData(listDias: itemsProdProm, mes : mes, year : anio, day : day, completion: { (isSuccess, JSONData) in
                if isSuccess {
                    self.crearOnLine(mes : mes - 1, year : anio, dia: day, json : JSONData, principal: itemsProdProm.first?.principal ?? false)
                    if self.diaCarShop.disable == 0 {
                        itemCS.itemDiaCalendario = self.diaCarShop
                        self.diaCarShop = ItemDiaCalendario()
                        FirebaseBR.shared.getPriceIKE(itemsCarShoop : itemCS ,completion: { (isSuccess, itemIKE) in
//                            if isSuccess {
                                itemCS.itemComplementos.seguroIKE = itemIKE
                                itemCS.itemComplementos.seguroIKE.status = true
                                self.listItemCarShop.append(itemCS)
                                if self.listItemCarShop.count == self.itemProdProm.count {
                                    self.listDiaCarShop.removeAll()
//                                    FirebaseBR.shared.updateListCarshop(listItemCarShop : self.listItemCarShop, completion: { listTickets, result   in
//                                        FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
//                                            LoadingView.shared.hideActivityIndicator(uiView: self.view)
//                                            self.listCarshop = itemsPickup
//                                            appDelegate.listItemListCarshop = itemsPickup
//                                            LoadingView.shared.hideActivityIndicator(uiView: self.view)
//                                        })
//                                    })
                                }
//                            }
                        })
                    }
                }else{
                    let alert = UIAlertController(title: "Error", message: "Ocurrio un error inesperado, vuelva a intenralo mas tarde", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    
    func crearOnLine(mes : Int, year : Int, dia : Int, json : JSON, principal : Bool){
        
        let Activities = json["Activities"].arrayValue
        let RateServices = Activities[0]["RateServices"].arrayValue
        let DailyRates = RateServices[0]["DailyRates"].arrayValue
        
        for itemDailyRates in DailyRates{
            
            if diaCarShop.disable != 0 {
                
                let itemDiaCalendario = ItemDiaCalendario()
                
                itemDiaCalendario.name = Activities[0]["Name"].stringValue
                itemDiaCalendario.code = Activities[0]["Code"].stringValue
                itemDiaCalendario.id = Activities[0]["Id"].intValue
                itemDiaCalendario.productKey = Activities[0]["ProductKey"].stringValue
                
                if json["Promotion"]["Applied"].exists(){
                    itemDiaCalendario.promotionApplied.status = json["Promotion"]["Applied"]["Status"].stringValue
                    itemDiaCalendario.promotionApplied.description = json["Promotion"]["Applied"]["Description"].stringValue
                    itemDiaCalendario.promotionApplied.message = json["Promotion"]["Applied"]["Message"].stringValue
                    
                    if json["Promotion"]["Applied"]["DetailStatus"].exists(){
                        itemDiaCalendario.promotionApplied.detailStatus.description = json["Promotion"]["Applied"]["DetailStatus"]["Description"].stringValue
                        itemDiaCalendario.promotionApplied.detailStatus.status = json["Promotion"]["Applied"]["DetailStatus"]["Status"].stringValue
                    }
                    
                }
                
                let data = itemDailyRates
                var avail = data["Avail"]["Status"].stringValue
                if data["Allotment"].exists() {
                    allotment = true
                    itemDiaCalendario.allotment.status = true
                    itemDiaCalendario.allotment.id = data["Allotment"]["Id"].intValue
                    itemDiaCalendario.allotment.total = data["Allotment"]["Total"].intValue
                    itemDiaCalendario.allotment.reserved = data["Allotment"]["Reserved"].intValue
                    itemDiaCalendario.allotment.sold = data["Allotment"]["Sold"].intValue
                    itemDiaCalendario.allotment.avail = data["Allotment"]["Avail"].intValue
                    if itemDiaCalendario.allotment.avail == 0 {
                        avail = "Close"
                    }
                }
                
                let dis = avail == "Close" ? 1 : 0
                itemDiaCalendario.disable = dis
                itemDiaCalendario.mes = mes
                itemDiaCalendario.diaNumero = 0
                itemDiaCalendario.year = 0
                itemDiaCalendario.descuento = data["Discount"]["Percent"].intValue
                
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "yyyy-MM-dd"
                let dateItem = dateFormatterGet.date(from: data["Day"].stringValue)
                let dt = dateFormatterPrint.string(from: dateItem ?? Date())
                itemDiaCalendario.date = dt
                
                var amount = data["NormalAdultAmount"].doubleValue
                var adult =  data["Adults"].doubleValue
                var children = data["Children"].doubleValue
                var normalAdults = data["NormalAdults"].doubleValue
                let normalChildren = data["NormalChildren"].doubleValue
                
                if data["Promotion"].exists() {
//                    amount = data["Promotion"]["Amount"].doubleValue
//                    normalAdults = amount
                    adult = data["Promotion"]["Adult"].doubleValue
                    if data["Promotion"]["Children"].doubleValue != 0 {
                        children = data["Promotion"]["Children"].doubleValue
                    }
                }
                
                itemDiaCalendario.normalAmount = amount//data["NormalAdultAmount"].doubleValue
                itemDiaCalendario.subtotalAdulto = adult//data["Adults"].doubleValue
                itemDiaCalendario.subtotalChildren = children//data["NormalChildren"].doubleValue
                itemDiaCalendario.ahorroAdulto = normalAdults - adult//data["NormalAdults"].doubleValue - data["Adults"].doubleValue
                itemDiaCalendario.ahorroChildren = normalChildren  - children//data["NormalChildren"].doubleValue - data["Children"].doubleValue
                itemDiaCalendario.transport = Activities[0]["Transport"].boolValue

                
                var arrItemRateServices = 0
                for itemRateServices in RateServices{
                    let itemRateKey = ItemRateKey()
                    itemRateKey.id = itemRateServices["Geographic"]["Id"].intValue
                    itemRateKey.nameGeographic = itemRateServices["Geographic"]["Name"].stringValue
                    itemRateKey.rateKey = itemRateServices["DailyRates"][arrItemRateServices]["RateKey"].stringValue
                    if itemRateServices["DailyRates"][arrItemRateServices]["Schedules"].exists(){
                        let schedulesHorarios = itemRateServices["DailyRates"][arrItemRateServices]["Schedules"].arrayValue
                        if schedulesHorarios.count > 0 {
                            for itemSchedule in schedulesHorarios {
                                let statusHorario = itemSchedule["Avail"]["Status"].stringValue
                                if statusHorario.lowercased() == "open"{
                                    let horarioPickup = HorarioPickup()
                                    horarioPickup.time = itemSchedule["Time"].stringValue
                                    horarioPickup.status = itemSchedule["Avail"]["Status"].stringValue
                                    horarioPickup.rateKey = itemSchedule["RateKey"].stringValue
                                    itemRateKey.horarioPickup.append(horarioPickup)
                                }
                            }
                        }
                    }
                    
                    itemDiaCalendario.rateKey.append(itemRateKey)
                    arrItemRateServices = arrItemRateServices + 1
                }
                
                itemDiaCalendario.family.id = Activities[0]["Family"]["Id"].intValue
                itemDiaCalendario.family.name = Activities[0]["Family"]["Name"].stringValue
                
                if itemDiaCalendario.disable == 0 {
                    
                    let existDateinList = listDiaCarShop.filter({ $0.date == itemDiaCalendario.date })
                    if existDateinList.isEmpty {
                        if !principal {
                            listDiaCarShop.append(itemDiaCalendario)
                        }
                        diaCarShop = itemDiaCalendario
                    }
                }
            }
        }
    }
    
    
    func sendPreBuyProm(itemProm: [ItemProdProm]) {
        let mainNC = AppStoryboard.Cotizador.instance.instantiateViewController(withIdentifier: "Cotizador") as! CotizadorViewController
        mainNC.modalPresentationStyle = .overFullScreen
        mainNC.itemProdProm = itemProm
        mainNC.vistaCotizador = true
        mainNC.from = "comprar"
        mainNC.compraProd = true
        self.present(mainNC, animated: true, completion: nil)
    }
    
    func sendPreBuyPromBook(){
        print("OK...")
    }
    
    func sendItemOpcProm(select : ItemsCatopcprom) {
        buttomSelect = select.identifier
        let itemSelect = appDelegate.listlangsPromotions.filter({$0.uid == Constants.LANG.current && $0.key_promotion == select.lang_Promo})
        self.select = itemSelect.first!.prod_code!
        datosPorPromocion()
    }
}

extension PromocionesViewController : GoMenuTickets {
    func goMenuTickets() {
        self.dismiss(animated: true) {
            self.delegateGoMenuTickets?.goMenuTickets()
        }
    }
}

extension PromocionesViewController : ChangeCurrencyShop{
    func changeCurrencyShop(codeCurrency : String) {
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        FirebaseDB.shared.getlistProductPrices(completion:{ (listProductPrices) in
            FirebaseDB.shared.getListPreciosXapi(completion:{ (ListPreciosXap) in
                self.datosPorPromocion()
                self.tblProm.reloadData()
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
            })
        })
    }
}


extension PromocionesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsPrecios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPromosTienda", for: indexPath as IndexPath) as! itemPromocionesCollectionViewCell
        cell.configPromotions(promotion: itemsPrecios[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if itemsPrecios.count > indexPath.row{

            self.collectionViewMenu.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)

            select = itemsPrecios[indexPath.row].uid!
            buttomSelect = "park"
                let indexPath = IndexPath(row: 0, section: 0)
                self.tblProm.scrollToRow(at: indexPath, at: .top, animated: true)

            datosPorPromocion()
        }
        
    }
    
}


extension PromocionesViewController: UITableViewDelegate, UITableViewDataSource, ManageUpdateOpcPromDelegate, ManageUpdatePromDelegate, ManageBuyPromDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if buttomSelect == "Benefits"{
            count = langListBenefits.count + 1
        }else if buttomSelect == "Payment_options"{
            count = 2
        }else{
            count = itemsPreciosSelect.count + 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            if itemButtonSelectNil == false{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellItemProms", for: indexPath) as! itemPromsTableViewCell
                cell.config(itemHeaderProm : itemHeaderSelect)
                cell.delegateOpcProm = self
                return cell
            }else{
                let cell = UITableViewCell()
                return cell
            }
            
        }else{
            if buttomSelect == "Benefits"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellBenefit", for: indexPath) as! itemsBenefitTableViewCell
                cell.config(itemBenefit : langListBenefits[indexPath.row - 1])
                return cell
            }else if buttomSelect == "Payment_options"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellOpcionesPago", for: indexPath) as! itemOpcionesPagoTableViewCell
                cell.config(itemPrecios : itemsPreciosSelect[indexPath.row - 1])
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellProduct", for: indexPath) as! itemProdPromTableViewCell
                cell.config(itemPrecios : itemsPreciosSelect[indexPath.row - 1])
                cell.delegateProm = self
                cell.delegateBuyProm = self
                cell.delegatePreBuyProm = self
                return cell
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    
}
