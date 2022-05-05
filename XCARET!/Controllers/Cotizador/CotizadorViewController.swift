//
//  CotizadorViewController.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 04/03/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON

class CotizadorViewController: UIViewController {

    @IBOutlet weak var viewImgBack: UIView!
    @IBOutlet weak var viewContentInfo: UIView!
    @IBOutlet weak var viewContentSubTotal: UIView!
    @IBOutlet weak var contraintContentSubTotal: NSLayoutConstraint!
    @IBOutlet weak var constraintCarritoX: NSLayoutConstraint!
    @IBOutlet weak var contentCurrency: UIView!
    @IBOutlet weak var constraintDrop: NSLayoutConstraint!
    @IBOutlet weak var contentDrop: UIView!
    @IBOutlet weak var titleCViewLbl: UILabel!
    @IBOutlet weak var tuAhorroLbl: UILabel!
    @IBOutlet weak var ahorroLbl: UILabel!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var seguirComprandoButton: UIButton!
    @IBOutlet weak var comprarAhoraButtom: UIButton!
    
    
    @IBOutlet weak var carShopTbl: UITableView!{
        didSet{
            carShopTbl.register(UINib(nibName: "CardCarShopTableViewCell", bundle: nil), forCellReuseIdentifier: "cellCardCarShop")
            carShopTbl.register(UINib(nibName: "CarShopEmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "carShopEmpty")
        }
    }
    
    var itemProdProm = [ItemProdProm]()
    var vistaCotizador : Bool = false
    var funcCerrarCotizador = false
    var validateCarshop : [ValidateCarshop] = [ValidateCarshop]()
    var itemDiaCalendario = ItemDiaCalendario()
    var itemVisitantes = ItemVisitantes()
    
    var itemCarShoop = ItemCarShoop()
    var listItemCarShop = [ItemCarShoop]()
    
    var diaCarShop = ItemDiaCalendario()
    
    var itemListCarshop = ItemListCarshop()
    var listCarshop = [ItemListCarshop]()
    var listitemCSCount = [ProductsCarShop]()
    var listitemCarShoopArr = [ItemCarShoop]()
    var listDiaCarShop = [ItemDiaCalendario]()
    var listitemAllotmen = [ProductsCarShop]()
    
    var editProd = false
    var compraProd = false
    var keyIdEdit = ""
    var keyProdEdit = ""
    var from = ""
    var statusCarShop = ""
    var prodPack = false
    
    var allotment = false
    
    let menu : DropDown = {
        let menu = DropDown()
        var imgCurrency = [String]()
        for itemCurrency in appDelegate.listCurrenct{
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tuAhorroLbl.text = "lbl_cart_save".getNameLabel()
        subtotalLbl.text = "lbl_cart_total".getNameLabel()
        seguirComprandoButton.setTitle("lbl_cart_add_new_product".getNameLabel(), for: .normal)
        comprarAhoraButtom.setTitle("lbl_cart_pay".getNameLabel(), for: .normal)
        
        contentCurrency.isHidden = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        self.viewImgBack.addGestureRecognizer(tapRecognizer)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.changeCurrency))
        self.contentCurrency.addGestureRecognizer(gesture)
        
        self.constraintDrop.constant = 0
        
        menu.anchorView = contentDrop
        menu.backgroundColor = .white
        menu.selectRow(menu.dataSource.firstIndex(of: Constants.CURR.current) ?? 0)
        menu.selectionAction = { index, title in
            
            UserDefaults.standard.set(title, forKey: "UserCurrency")
            UserDefaults.standard.synchronize()
            Constants.CURR.current = title
            self.configNavCurrency()
            
        }
    }
    
    @IBAction func seguirComprandoBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        cerrarCotizador()
    }
    
    @objc func changeCurrency(sender : UITapGestureRecognizer) {
        self.constraintDrop.constant = 45
        menu.show()
        self.constraintDrop.constant = 0
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goCompra(_ sender: Any) {
        
        print("goTermsBooking")
        let mainNC = AppStoryboard.Promociones.instance.instantiateViewController(withIdentifier: "popUpPreBuyViewController") as! popUpPreBuyViewController
        mainNC.modalPresentationStyle = .overFullScreen
        mainNC.modalTransitionStyle = .crossDissolve
        mainNC.delegateGoBooking = self
        mainNC.buyAll = true
        self.present(mainNC, animated: true, completion: nil)
    }
    
    func goBookingAll(){
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        var itemsAllotmen = [ProductsCarShop]()
//        var itemsCheckoutParams : [String: Any] = [String: Any]()
//        for itemAllotmenSV in listitemAllotmen {
//            let itemprodpromSV = listitemCarShoopArr.filter({$0.keyItemEditCarShop == itemAllotmenSV.key})
//            let itemCheckoutParam: [String: Any] = [
//                  "itemID": "SKU_123",
//                  "itName": "jeggings"
//                ]
//            itemsCheckoutParams.add(itemCheckoutParam)
//            print("SV")
//        }
//        let aux = appDelegate.listItemListCarshop
//        let aux2 = appDelegate.listItemListCarshop.first?.detail.firstIndex(where: {$0.pro == true})
        
        for itemAllotmenSV in listitemAllotmen {
            let itemprodpromSV = listitemCarShoopArr.filter({$0.keyItemEditCarShop == itemAllotmenSV.key})
            
            if itemAllotmenSV.availabilityStatus {
                let quantity = (itemprodpromSV.first?.itemVisitantes.adulto ?? 0) + (itemprodpromSV.first?.itemVisitantes.ninio ?? 0)
                let rtSV = appDelegate.listItemListCarshop.first?.detail
                let rtproductSV = rtSV?.filter({$0.uid == itemprodpromSV.first?.itemProdProm.first?.uid }).first
                AnalyticsBR.shared.saveEventBeginCheckout(id: itemprodpromSV.first?.itemProdProm.first?.key ?? "",
                                                          name: itemprodpromSV.first?.itemProdProm.first?.descripcionEs.lowercased().capitalized ?? "",
                                                          quantity: quantity,
                                                          currency: Constants.CURR.current,
                                                          value: rtproductSV?.price ?? 0.0,
                                                          coupon: rtproductSV?.promotionName ?? "")
            }
            
        }
        
        
        for itemAllotmen in listitemAllotmen {
            if itemAllotmen.productAllotment {
                let itemprodprom = listitemCarShoopArr.filter({$0.keyItemEditCarShop == itemAllotmen.key})
                let rt = appDelegate.listItemListCarshop.first?.detail
                let rtproduct = rt?.filter({$0.uid == itemprodprom.first?.itemProdProm.first?.uid }).first
                let rtproductkey = rtproduct?.products.filter({ $0.key == itemprodprom.first?.keyItemEditCarShop }).first
                print(rtproductkey?.productApiRequest.activitiesRatekey ?? "")
                FirebaseBR.shared.getRateKeyAllotment(itemCarShoop : itemprodprom.first ?? ItemCarShoop(), rt: rtproductkey?.productApiRequest.activitiesRatekey ?? "", completion: { (isSuccess, allotment, rateKey, allowedCustomerConfigPax)  in
                    FirebaseBR.shared.getReservedAllotment(itemCarShoop : itemprodprom.first ?? ItemCarShoop(), rateKey : rateKey, time: "maximo", completion: { (isSuccess, prodAllotment) in
                        
                        itemsAllotmen.append(itemAllotmen)
                        let indexItem = self.listitemCarShoopArr.index(where: { $0.keyItemEditCarShop == itemAllotmen.key })
                        self.listitemCarShoopArr[indexItem ?? 0].allotment = prodAllotment
                        if self.listitemAllotmen.count == itemsAllotmen.count {
                            
                            for itemA in itemsAllotmen {
                                let rk = self.listitemCarShoopArr.filter({ $0.keyItemEditCarShop ==  itemA.key})
                                let idProd = appDelegate.listItemListCarshop.first?.detail.filter({ $0.uid == rk.first?.itemProdProm.first?.uid})
                                
                                FirebaseBR.shared.updateKeyCarShop(key: "productApiRequest/activitiesRateKey", value : rk.first?.allotment.rateKey ?? "", idDetail : idProd?.first?.key ?? "", idProduct : itemA.key ?? "", completion: { result in
                                    print("productApiRequest/activitiesRateKey:", rk.first?.allotment.rateKey ?? "")
                                    print(idProd?.first?.products.first?.key ?? "")
                                    print(itemA.key)
                                })
                            }

                            let mainNC = AppStoryboard.Compra.instance.instantiateViewController(withIdentifier: "TusDatos") as! TusDatosViewController
                            mainNC.modalPresentationStyle = .fullScreen
                            mainNC.itemCarShoop = self.listitemCarShoopArr
                            mainNC.allItems = appDelegate.listItemListCarshop.first ?? ItemListCarshop()
                            mainNC.buyAll = true
                            self.present(mainNC, animated: true, completion: nil)
                            LoadingView.shared.hideActivityIndicator(uiView: self.view)
                        }
                    })
                })
            }else{
                itemsAllotmen.append(itemAllotmen)
                if self.listitemAllotmen.count == itemsAllotmen.count {
                    let mainNC = AppStoryboard.Compra.instance.instantiateViewController(withIdentifier: "TusDatos") as! TusDatosViewController
                    mainNC.modalPresentationStyle = .fullScreen
                    mainNC.itemCarShoop = self.listitemCarShoopArr
                    mainNC.allItems = appDelegate.listItemListCarshop.first ?? ItemListCarshop()
                    mainNC.buyAll = true
                    self.present(mainNC, animated: true, completion: nil)
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        titleCViewLbl.text = "lbl_cart_title".getNameLabel()
        
        constraintCarritoX.constant = UIDevice().getHeightCarrito()
        
        self.viewContentSubTotal.dropShadow(color: UIColor.lightGray, opacity: 0.5, offSet: CGSize(width: -2, height: -3), radius:3, scale: true, corner: 0, backgroundColor: UIColor.white)
        
        if vistaCotizador {
            if !funcCerrarCotizador {
                
                self.fechaVisitas()
            }
        }else{
            
                if appDelegate.listItemListCarshop.count > 0 {
                    if !self.editProd && !self.compraProd {
                        
                        self.validacionesCarShop()
                    }
                }else{
                    print("EMPTY")
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    self.viewContentSubTotal.isHidden = true
                    self.contraintContentSubTotal.constant = 0
                    self.statusCarShop = "empty"
                    self.carShopTbl.delegate = self
                    self.carShopTbl.dataSource = self
                    self.carShopTbl.reloadData()
                }

            }
    }
    
    func validacionesCarShop(){
        let aux = appDelegate.listItemListCarshop
        print(aux)
        statusCarShop = ""
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        self.listitemCarShoopArr.removeAll()
        self.listitemCSCount.removeAll()
        self.listitemAllotmen.removeAll()

        for itemCarshop in (appDelegate.listItemListCarshop.first?.detail.filter({$0.status == 1}) ?? [ItemCarshop]()) {
            for itemProductsCarShop in itemCarshop.products{
                listitemCSCount.append(itemProductsCarShop)
            }
        }
        
        let auxlistitemCSCount = listitemCSCount
        print(auxlistitemCSCount)
        
        if listitemCSCount.count > 0 {
            
            viewContentSubTotal.isHidden = false
            contraintContentSubTotal.constant = 125
            let aux = appDelegate.listItemListCarshop
            for itemListCarshop in (appDelegate.listItemListCarshop.first?.detail.filter({$0.status == 1}) ?? [ItemCarshop]()) {
                let listitemCarShoop = ItemCarShoop()
                
                let promCodItems = appDelegate.listPrecios.filter({ $0.uid == itemListCarshop.promotionName})
                listitemCarShoop.itemProdProm = promCodItems.first?.productos.filter({ $0.idProducto == itemListCarshop.products.first?.productId }) ?? [ItemProdProm]()
                
                let keyProdEditCS = itemListCarshop.key ?? ""
                let keyIdEditCS = itemListCarshop.products.first?.key ?? ""
                
                listitemCarShoop.keyItemEditCarShop = keyIdEditCS//keyProdEditCS
                
                if itemListCarshop.products.count > 1 {
                    
                    var listItemProdsProms = [ItemProdProm]()
                    var listProductsCarShopValidate = [ProductsCarShop]()
                    let auxpromCodItems = promCodItems
                    print(auxpromCodItems)
                    
                    let itemPrincipal = ItemProdProm()
                    itemPrincipal.principal = true
                    itemPrincipal.cupon_promotion = promCodItems.first?.productos.first?.cupon_promotion
                    itemPrincipal.packageId = promCodItems.first?.productos.first?.packageId
                    itemPrincipal.descripcionEs = promCodItems.first?.productos.first?.descripcionEs
                    itemPrincipal.descripcionEn = promCodItems.first?.productos.first?.descripcionEn
                    itemPrincipal.code_promotion = promCodItems.first?.productos.first?.code_promotion
                    itemPrincipal.uid = promCodItems.first?.productos.first?.uid
                    
                    listItemProdsProms.append(itemPrincipal)
                    
                    for productChilds in promCodItems.first?.productos.first?.product_childs ?? [ItemProduct_childs]() {
                        
                        let itemProdProm = appDelegate.listProductsPromotions.filter({ $0.key_product == productChilds.value})
                        let itemListProm = appDelegate.listPromotions.filter({$0.uid == itemProdProm.first?.key_promotion})
                        
                        let itemListPrecios = appDelegate.listPrecios.filter({ $0.uid == itemListProm.first?.code})
                        let listItemProdProm = itemListPrecios.first?.productos.filter({ $0.key == productChilds.key}).first
                        listItemProdProm?.principal = false
                        listItemProdProm?.code_promotion = "pack"
                        listItemProdsProms.append(listItemProdProm!)
                    }
                    
                    var availabilityStatusPack = true
                    
                    for itemsListCarshopValidate in itemListCarshop.products {
                        if validateDate(date1 : itemsListCarshopValidate.productDate ?? "", dateToday: true) == "menor" {
                            FirebaseBR.shared.updateKeyCarShop(key: "availabilityStatus", value : false, idDetail : keyProdEditCS, idProduct : itemsListCarshopValidate.key, completion: { result in
                                availabilityStatusPack = false
                                listProductsCarShopValidate.append(itemsListCarshopValidate)
                                if itemListCarshop.products.count == listProductsCarShopValidate.count {
                                    if !availabilityStatusPack {
                                        for itemCSCount in self.listitemCSCount{
                                            self.listitemCarShoopArr.append(ItemCarShoop())
                                            if self.listitemCSCount.count == self.listitemCarShoopArr.count {
                                                FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                                    appDelegate.listItemListCarshop = itemsPickup
                                                    self.updateCurrency()
                                                    self.carShopTbl.delegate = self
                                                    self.carShopTbl.dataSource = self
                                                    self.carShopTbl.reloadData()
                                                    self.configPrice()
                                                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                                })
                                            }
                                        }
                                    }else{
                                        self.addCarShopPacks(itemsProms: listItemProdsProms, itemListCarshop : [itemListCarshop], keyProdEditCS: keyProdEditCS)
                                    }
                                }
                            })
                        }else if validateDate(date1 : itemsListCarshopValidate.productDate ?? "", dateToday: true) == "igual" {
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd'"
//                            formatter.locale = Locale(identifier: "en_US_POSIX")
                            guard let date = formatter.date(from: itemsListCarshopValidate.productDate ?? "") else {
                                return
                            }
                            
                            formatter.dateFormat = "yyyy"
                            let year = Int(formatter.string(from: date)) ?? 0
                            formatter.dateFormat = "MM"
                            let month = Int(formatter.string(from: date)) ?? 0
                            formatter.dateFormat = "dd"
                            let day = Int(formatter.string(from: date)) ?? 0
                            print(year, month, day)
                            
                            let itemProdsProms = listItemProdsProms.filter({ $0.idProducto == itemsListCarshopValidate.productId })
                            
                            FirebaseBR.shared.getCalendarData(listDias: itemProdsProms , reCotizacion : true, mes : month, year : year, day : day, itemProductsCarShop: itemListCarshop.products.first!, completion: { (isSuccess, JSONData) in
                                if isSuccess {
                                    let disableValidate = self.crearOnLine(mes : month - 1, year : year, dia: day, json : JSONData)
                                    if disableValidate.disable != 0 {
                                        FirebaseBR.shared.updateKeyCarShop(key: "availabilityStatus", value : false, idDetail : keyProdEditCS, idProduct : itemsListCarshopValidate.key, completion: { result in
                                            availabilityStatusPack = false
                                            listProductsCarShopValidate.append(itemsListCarshopValidate)
                                            if itemListCarshop.products.count == listProductsCarShopValidate.count {
                                                if !availabilityStatusPack {
                                                    for itemCSCount in self.listitemCSCount{
                                                        self.listitemCarShoopArr.append(ItemCarShoop())
                                                        if self.listitemCSCount.count == self.listitemCarShoopArr.count {
                                                            FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                                                appDelegate.listItemListCarshop = itemsPickup
                                                                self.updateCurrency()
                                                                self.carShopTbl.delegate = self
                                                                self.carShopTbl.dataSource = self
                                                                self.carShopTbl.reloadData()
                                                                self.configPrice()
                                                                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                                            })
                                                        }
                                                    }
                                                }else{
                                                    self.addCarShopPacks(itemsProms: listItemProdsProms, itemListCarshop : [itemListCarshop], keyProdEditCS: keyProdEditCS)
                                                }
                                            }
                                        })
                                    }else{
                                        listProductsCarShopValidate.append(itemsListCarshopValidate)
                                        if itemListCarshop.products.count == listProductsCarShopValidate.count {
                                            if !availabilityStatusPack {
                                                for itemCSCount in self.listitemCSCount{
                                                    self.listitemCarShoopArr.append(ItemCarShoop())
                                                    if self.listitemCSCount.count == self.listitemCarShoopArr.count {
                                                        FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                                            appDelegate.listItemListCarshop = itemsPickup
                                                            self.updateCurrency()
                                                            self.carShopTbl.delegate = self
                                                            self.carShopTbl.dataSource = self
                                                            self.carShopTbl.reloadData()
                                                            self.configPrice()
                                                            LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                                        })
                                                    }
                                                }
                                            }else{
                                                self.addCarShopPacks(itemsProms: listItemProdsProms, itemListCarshop : [itemListCarshop], keyProdEditCS: keyProdEditCS)
                                            }
                                            
                                        }
                                    }
                                }
                            })
                        }else{
                            print("Mayor")
                            if itemsListCarshopValidate.productAllotment {
                                listProductsCarShopValidate.append(itemsListCarshopValidate)
                                if itemListCarshop.products.count == listProductsCarShopValidate.count {
                                    if !availabilityStatusPack {
                                        for itemCSCount in self.listitemCSCount{
                                            self.listitemCarShoopArr.append(ItemCarShoop())
                                            if self.listitemCSCount.count == self.listitemCarShoopArr.count {
                                                FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                                    appDelegate.listItemListCarshop = itemsPickup
                                                    self.updateCurrency()
                                                    self.carShopTbl.delegate = self
                                                    self.carShopTbl.dataSource = self
                                                    self.carShopTbl.reloadData()
                                                    self.configPrice()
                                                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                                })
                                            }
                                        }
                                    }else{
                                        addCarShopPacks(itemsProms: listItemProdsProms, itemListCarshop : [itemListCarshop], keyProdEditCS: keyProdEditCS)
                                    }
                                }
                            }else{
                                listProductsCarShopValidate.append(itemsListCarshopValidate)
                                if itemListCarshop.products.count == listProductsCarShopValidate.count {
                                    if !availabilityStatusPack {
                                        for itemCSCount in self.listitemCSCount{
                                            self.listitemCarShoopArr.append(ItemCarShoop())
                                            if self.listitemCSCount.count == self.listitemCarShoopArr.count {
                                                FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                                    appDelegate.listItemListCarshop = itemsPickup
                                                    self.updateCurrency()
                                                    self.carShopTbl.delegate = self
                                                    self.carShopTbl.dataSource = self
                                                    self.carShopTbl.reloadData()
                                                    self.configPrice()
                                                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                                })
                                            }
                                        }
                                    }else{
                                        addCarShopPacks(itemsProms: listItemProdsProms, itemListCarshop : [itemListCarshop], keyProdEditCS: keyProdEditCS)
                                    }
                                }
                            }
                        }
                    }
                }else{
                    if validateDate(date1 : itemListCarshop.products.first?.productDate ?? "", dateToday: true) == "mayor" {
                        print("Mayor")
                        
                        listitemCarShoop.status = itemListCarshop.status
                        listitemCarShoop.productAllotment = itemListCarshop.products.first?.productAllotment
                        
                        listitemCarShoop.itemVisitantes.adulto = itemListCarshop.products.first?.productVisitor.productAdult
                        listitemCarShoop.itemVisitantes.ninio = itemListCarshop.products.first?.productVisitor.productChild
                        listitemCarShoop.itemVisitantes.infantes = itemListCarshop.products.first?.productVisitor.productInfant
                        
                        
                        listitemCarShoop.itemComplementos.transporte.nameLoc = itemListCarshop.products.first?.productApiRequest.transportCarShop.geographicName
                        listitemCarShoop.itemComplementos.transporte.id = itemListCarshop.products.first?.productApiRequest.transportCarShop.hotelId
                        listitemCarShoop.itemComplementos.transporte.pickUps.id = itemListCarshop.products.first?.productApiRequest.transportCarShop.hotelPickupId
                        listitemCarShoop.itemComplementos.transporte.name = itemListCarshop.products.first?.productApiRequest.transportCarShop.nameHotel
                        listitemCarShoop.itemComplementos.transporte.pickUps.time = itemListCarshop.products.first?.productApiRequest.transportCarShop.timePickup
                        listitemCarShoop.itemComplementos.transporte.time = itemListCarshop.products.first?.productApiRequest.transportCarShop.schedulePark
                        
                        let rateKeyCancel = itemListCarshop.products.first?.productApiRequest.activitiesRatekey ?? ""
                        
                        listitemCarShoop.dateOrder = itemListCarshop.products.first?.dateOrder
                        
                        let auxlistitemCarShoop = self.listitemCSCount
                        print(auxlistitemCarShoop)
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
//                        formatter.locale = Locale(identifier: "en_US_POSIX")
                        guard let date = formatter.date(from: itemListCarshop.products.first?.productDate ?? "") else {
                            return
                        }
                        
                        formatter.dateFormat = "yyyy"
                        let year = Int(formatter.string(from: date)) ?? 0
                        formatter.dateFormat = "MM"
                        let month = Int(formatter.string(from: date)) ?? 0
                        formatter.dateFormat = "dd"
                        let day = Int(formatter.string(from: date)) ?? 0
                        print(year, month, day)
                        
                        FirebaseBR.shared.getCalendarData(listDias: listitemCarShoop.itemProdProm , reCotizacion : true, mes : month, year : year, day : day, itemProductsCarShop: itemListCarshop.products.first!, completion: { (isSuccess, JSONData) in
                            if isSuccess {
                                listitemCarShoop.itemDiaCalendario = self.crearOnLine(mes : month - 1, year : year, dia: day, json : JSONData)
                                if listitemCarShoop.itemDiaCalendario.disable == 0 {
                                    FirebaseBR.shared.getPricePhotopass(itemsCarShoop : listitemCarShoop , completion: { (isSuccess, itemfotos) in
                                        listitemCarShoop.itemComplementos.fotos = itemfotos
                                        listitemCarShoop.itemComplementos.fotos.status = itemListCarshop.products.first?.productPhotopass
                                        FirebaseBR.shared.getPriceIKE(itemsCarShoop : listitemCarShoop ,completion: { (isSuccess, itemIKE) in
//                                            if isSuccess {
                                                listitemCarShoop.itemComplementos.seguroIKE = itemIKE
                                                listitemCarShoop.itemComplementos.seguroIKE.status = itemListCarshop.products.first?.productIke
                                                
                                            if listitemCarShoop.itemDiaCalendario.rateKey.count > 1 {
                                                let locName = itemListCarshop.products.first?.productApiRequest.transportCarShop.geographicName.lowercased()
                                                let itemMoutLoc = listitemCarShoop.itemDiaCalendario.rateKey.filter({ $0.nameGeographic.lowercased() == locName})
                                                
                                                listitemCarShoop.itemDiaCalendario.amount = itemMoutLoc.first?.amountLocation.amount
                                                listitemCarShoop.itemDiaCalendario.normalAmount = itemMoutLoc.first?.amountLocation.normalAmount
                                                listitemCarShoop.itemDiaCalendario.subtotalAdulto = itemMoutLoc.first?.amountLocation.subtotalAdulto
                                                listitemCarShoop.itemDiaCalendario.ahorroAdulto = itemMoutLoc.first?.amountLocation.ahorroAdulto
                                                listitemCarShoop.itemDiaCalendario.subtotalChildren = itemMoutLoc.first?.amountLocation.subtotalChildren
                                                listitemCarShoop.itemDiaCalendario.ahorroChildren = itemMoutLoc.first?.amountLocation.ahorroChildren
                                                
                                            }
                                                FirebaseBR.shared.updateItemCarshopSencillo(itemCarShop : [listitemCarShoop], editItem: keyProdEditCS, completion: { listTickets, result in
                                                    self.listitemCarShoopArr.append(listitemCarShoop)
                                                    if self.listitemCSCount.count == self.listitemCarShoopArr.count {
                                                        FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                                            let statusOpen = itemListCarshop.close
                                                            let itemDetail = appDelegate.listItemListCarshop.first?.detail
                                                            let itemIndex = itemDetail?.index(where: { $0.key == itemListCarshop.key })
                                                            self.listCarshop = itemsPickup
                                                            appDelegate.listItemListCarshop = itemsPickup
                                                            appDelegate.listItemListCarshop.first?.detail[itemIndex ?? 0].close = statusOpen
                                                            for itemsCancel in (appDelegate.listItemListCarshop.first?.detail.filter({$0.status == 1})) ?? [ItemCarshop]() {
                                                                for itemProdReserve in itemsCancel.products {
                                                                    if itemProdReserve.productAllotment {
                                                                        var mobile = false
                                                                        if itemsCancel.promotionId == "APP" {
                                                                            mobile = true
                                                                        }
                                                                        FirebaseBR.shared.getCancelAllotment(itemRateKey : rateKeyCancel, mobile: mobile, completion: { (isSuccess) in
                                                                            
                                                                            FirebaseBR.shared.getAllotment(itemCarShoop : listitemCarShoop, completion: { (isSuccess, allotmentAvail) in
                                                                                if isSuccess {
                                                                                    if allotmentAvail.activityAvail.status.lowercased() == "open" {
                                                                                        self.listitemAllotmen.append(itemProdReserve)
                                                                                        listitemCarShoop.itemDiaCalendario.allotmentAvail = allotmentAvail
                                                                                        if self.listitemCSCount.count == self.listitemAllotmen.count{
                                                                                            self.updateCurrency()
                                                                                            self.carShopTbl.delegate = self
                                                                                            self.carShopTbl.dataSource = self
                                                                                            self.carShopTbl.reloadData()
                                                                                            self.configPrice()
                                                                                            LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                                                                        }
                                                                                    }else{
                                                                                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                                                                    }
                                                                                }
                                                                                
                                                                            })
                                                                        })
                                                                    }else{
                                                                        self.listitemAllotmen.append(itemProdReserve)
                                                                        if self.listitemCSCount.count == self.listitemAllotmen.count {
                                                                            self.updateCurrency()
                                                                            self.carShopTbl.delegate = self
                                                                            self.carShopTbl.dataSource = self
                                                                            self.carShopTbl.reloadData()
                                                                            self.configPrice()
                                                                            LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        })
                                                    }
                                                })
//                                            }
                                        })
                                    })
                                }else{
                                    FirebaseBR.shared.updateKeyCarShop(key: "availabilityStatus", value : false, idDetail : keyProdEditCS, idProduct : keyIdEditCS, completion: { result in
                                        self.listitemCarShoopArr.append(listitemCarShoop)
                                        if self.listitemCSCount.count == self.listitemCarShoopArr.count {
                                            FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                                appDelegate.listItemListCarshop = itemsPickup
                                                self.updateCurrency()
                                                self.carShopTbl.delegate = self
                                                self.carShopTbl.dataSource = self
                                                self.carShopTbl.reloadData()
                                                self.configPrice()
                                                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                            })
                                        }
                                    })
                                }
                            }else{
                                let alert = UIAlertController(title: "Error", message: "Ocurrio un error inesperado, vuelva a intenralo mas tarde", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                print("Error")
                                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                self.viewContentSubTotal.isHidden = true
                                self.contraintContentSubTotal.constant = 0
                                self.statusCarShop = "error"
                                self.carShopTbl.delegate = self
                                self.carShopTbl.dataSource = self
                                self.carShopTbl.reloadData()
                            }
                        })
                    }else if validateDate(date1 : itemListCarshop.products.first?.productDate ?? "", dateToday: true) == "menor" {
                        
                        FirebaseBR.shared.updateKeyCarShop(key: "availabilityStatus", value : false, idDetail : keyProdEditCS, idProduct : keyIdEditCS, completion: { result in
                            self.listitemCarShoopArr.append(listitemCarShoop)
                            if self.listitemCSCount.count == self.listitemCarShoopArr.count {
                                FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                    appDelegate.listItemListCarshop = itemsPickup
                                    self.updateCurrency()
                                    self.carShopTbl.delegate = self
                                    self.carShopTbl.dataSource = self
                                    self.carShopTbl.reloadData()
                                    self.configPrice()
                                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                })
                            }
                        })
                        
                    }else{
                        
                        listitemCarShoop.status = itemListCarshop.status
                        listitemCarShoop.productAllotment = itemListCarshop.products.first?.productAllotment
                        
                        listitemCarShoop.itemVisitantes.adulto = itemListCarshop.products.first?.productVisitor.productAdult
                        listitemCarShoop.itemVisitantes.ninio = itemListCarshop.products.first?.productVisitor.productChild
                        listitemCarShoop.itemVisitantes.infantes = itemListCarshop.products.first?.productVisitor.productInfant
                        
                        
                        listitemCarShoop.itemComplementos.transporte.nameLoc = itemListCarshop.products.first?.productApiRequest.transportCarShop.geographicName
                        listitemCarShoop.itemComplementos.transporte.id = itemListCarshop.products.first?.productApiRequest.transportCarShop.hotelId
                        listitemCarShoop.itemComplementos.transporte.pickUps.id = itemListCarshop.products.first?.productApiRequest.transportCarShop.hotelPickupId
                        listitemCarShoop.itemComplementos.transporte.name = itemListCarshop.products.first?.productApiRequest.transportCarShop.nameHotel
                        listitemCarShoop.itemComplementos.transporte.pickUps.time = itemListCarshop.products.first?.productApiRequest.transportCarShop.timePickup
                        listitemCarShoop.itemComplementos.transporte.time = itemListCarshop.products.first?.productApiRequest.transportCarShop.schedulePark
//                        let rateKeyCancel = itemListCarshop.products.first?.productApiRequest.activitiesRatekey ?? ""
                        
                        print("Igual")
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'"
//                        formatter.locale = Locale(identifier: "en_US_POSIX")
                        guard let date = formatter.date(from: itemListCarshop.products.first?.productDate ?? "") else {
                            return
                        }
                        
                        formatter.dateFormat = "yyyy"
                        let year = Int(formatter.string(from: date)) ?? 0
                        formatter.dateFormat = "MM"
                        let month = Int(formatter.string(from: date)) ?? 0
                        formatter.dateFormat = "dd"
                        let day = Int(formatter.string(from: date)) ?? 0
                        print(year, month, day)
                        
                        FirebaseBR.shared.getCalendarData(listDias: listitemCarShoop.itemProdProm , reCotizacion : true, mes : month, year : year, day : day, itemProductsCarShop: itemListCarshop.products.first!, completion: { (isSuccess, JSONData) in
                            if isSuccess {
                                listitemCarShoop.itemDiaCalendario = self.crearOnLine(mes : month - 1, year : year, dia: day, json : JSONData)
                                let aux = listitemCarShoop.itemDiaCalendario
                                if listitemCarShoop.itemDiaCalendario.disable != 0 {
                                    FirebaseBR.shared.updateKeyCarShop(key: "availabilityStatus", value : false, idDetail : keyProdEditCS, idProduct : keyIdEditCS, completion: { result in
                                        self.listitemCarShoopArr.append(listitemCarShoop)
                                        if self.listitemCSCount.count == self.listitemCarShoopArr.count {
                                            FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                                appDelegate.listItemListCarshop = itemsPickup
                                                self.updateCurrency()
                                                self.carShopTbl.delegate = self
                                                self.carShopTbl.dataSource = self
                                                self.carShopTbl.reloadData()
                                                self.configPrice()
                                                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                            })
                                        }
                                    })
                                }else{
                                    FirebaseBR.shared.getPricePhotopass(itemsCarShoop : listitemCarShoop , completion: { (isSuccess, itemfotos) in
                                        listitemCarShoop.itemComplementos.fotos = itemfotos
                                        listitemCarShoop.itemComplementos.fotos.status = itemListCarshop.products.first?.productPhotopass
                                        
                                        FirebaseBR.shared.getPriceIKE(itemsCarShoop : listitemCarShoop ,completion: { (isSuccess, itemIKE) in
                                            if isSuccess {
                                                listitemCarShoop.itemComplementos.seguroIKE = itemIKE
                                                listitemCarShoop.itemComplementos.seguroIKE.status = itemListCarshop.products.first?.productIke
                                                listitemCarShoop.productAllotment = itemListCarshop.products.first?.productAllotment
                                                
                                                let rateKeyCancel = itemListCarshop.products.first?.productApiRequest.activitiesRatekey ?? ""
                                                
                                                
                                            if listitemCarShoop.itemDiaCalendario.rateKey.count > 1 {
                                                let locName = itemListCarshop.products.first?.productApiRequest.transportCarShop.geographicName.lowercased()
                                                let itemMoutLoc = listitemCarShoop.itemDiaCalendario.rateKey.filter({ $0.nameGeographic.lowercased() == locName})
                                                
                                                listitemCarShoop.itemDiaCalendario.amount = itemMoutLoc.first?.amountLocation.amount
                                                listitemCarShoop.itemDiaCalendario.normalAmount = itemMoutLoc.first?.amountLocation.normalAmount
                                                listitemCarShoop.itemDiaCalendario.subtotalAdulto = itemMoutLoc.first?.amountLocation.subtotalAdulto
                                                listitemCarShoop.itemDiaCalendario.ahorroAdulto = itemMoutLoc.first?.amountLocation.ahorroAdulto
                                                listitemCarShoop.itemDiaCalendario.subtotalChildren = itemMoutLoc.first?.amountLocation.subtotalChildren
                                                listitemCarShoop.itemDiaCalendario.ahorroChildren = itemMoutLoc.first?.amountLocation.ahorroChildren
                                                
                                            }
                                                self.listitemCarShoopArr.append(listitemCarShoop)
                                                FirebaseBR.shared.updateItemCarshopSencillo(itemCarShop : [listitemCarShoop], editItem: keyProdEditCS, completion: { listTickets, result in
                                                    if self.listitemCSCount.count == self.listitemCarShoopArr.count {
                                                       
                                                        FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                                            appDelegate.listItemListCarshop = itemsPickup
                                                            for itemsCancel in (appDelegate.listItemListCarshop.first?.detail.filter({$0.status == 1})) ?? [ItemCarshop]() {
                                                                for itemProdReserve in itemsCancel.products {
                                                                    if itemProdReserve.productAllotment {
                                                                        var mobile = false
                                                                        if itemsCancel.promotionId == "APP" {
                                                                            mobile = true
                                                                        }
                                                                        FirebaseBR.shared.getCancelAllotment(itemRateKey : rateKeyCancel, mobile: mobile, completion: { (isSuccess) in
                                                                            FirebaseBR.shared.getAllotment(itemCarShoop : listitemCarShoop, completion: { (isSuccess, allotmentAvail) in
                                                                                if isSuccess {
                                                                                    if allotmentAvail.activityAvail.status.lowercased() == "open" {
                                                                                        self.listitemAllotmen.append(itemProdReserve)
                                                                                        listitemCarShoop.itemDiaCalendario.allotmentAvail = allotmentAvail
                                                                                        if self.listitemCSCount.count == self.listitemAllotmen.count{
                                                                                            self.updateCurrency()
                                                                                            self.carShopTbl.delegate = self
                                                                                            self.carShopTbl.dataSource = self
                                                                                            self.carShopTbl.reloadData()
                                                                                            self.configPrice()
                                                                                            LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                                                                        }
                                                                                    }else{
                                                                                        
                                                                                    }
                                                                                }
                                                                                
                                                                            })
                                                                            
    //                                                                        FirebaseBR.shared.getRateKeyAllotment(itemCarShoop : listitemCarShoop, completion: { (isSuccess, allotment, rateKey, allowedCustomerConfigPax) in
    //                                                                            FirebaseBR.shared.getReservedAllotment(itemCarShoop : listitemCarShoop, rateKey : rateKey, completion: { (isSuccess, prodAllotment) in
    //                                                                                listitemCarShoop.allotment = prodAllotment
    //                                                                                self.listitemAllotmen.append(itemProdReserve)
    //                                                                                if self.listitemCSCount.count == self.listitemAllotmen.count{
    //                                                                                    self.updateCurrency()
    //                                                                                    self.carShopTbl.delegate = self
    //                                                                                    self.carShopTbl.dataSource = self
    //                                                                                    self.carShopTbl.reloadData()
    //                                                                                    self.configPrice()
    //                                                                                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
    //                                                                                }
    //                                                                            })
    //                                                                        })
                                                                            
                                                                            
                                                                            
                                                                            
                                                                            
                                                                        })
                                                                    }else{
                                                                        self.listitemAllotmen.append(itemProdReserve)
                                                                        if self.listitemCSCount.count == self.listitemAllotmen.count {
                                                                            self.updateCurrency()
                                                                            self.carShopTbl.delegate = self
                                                                            self.carShopTbl.dataSource = self
                                                                            self.carShopTbl.reloadData()
                                                                            self.configPrice()
                                                                            LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                    })
                                }
                            }
                        })
                        
                    }
                }
            }
        }else{
            print("EMPTY")
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
            viewContentSubTotal.isHidden = true
            contraintContentSubTotal.constant = 0
            statusCarShop = "empty"
            self.carShopTbl.delegate = self
            self.carShopTbl.dataSource = self
            self.carShopTbl.reloadData()
        }
    }
    
    
    func addCarShopPacks(itemsProms: [ItemProdProm], itemListCarshop : [ItemCarshop], keyProdEditCS : String ){
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        
        let auxItemCarShoop = self.itemCarShoop
        
        self.itemCarShoop.itemProdProm = itemsProms
        
        var listItemCS = [ItemCarShoop]()
        
        let itemsPromsPrincipal = itemsProms.filter({ $0.principal == true })
        let itemsPromsNoPrincipal = itemsProms.filter({ $0.principal == false })

        let itemCSPrincipal = ItemCarShoop()
        itemCSPrincipal.itemProdProm = itemsPromsPrincipal
        listItemCS.append(itemCSPrincipal)
        
        for itemProm in itemsPromsNoPrincipal {
            
            let iteminfoAdd = itemListCarshop.first?.products.filter({ $0.productId == itemProm.idProducto})
            
            self.listItemCarShop.removeAll()
            self.itemProdProm.removeAll()
            
            var itemsProdProms = [ItemProdProm]()
            itemsProdProms = [itemProm]
            
            let itemCS = ItemCarShoop()
            itemCS.keyItemEditCarShop = iteminfoAdd?.first?.key
            let rateKey = ItemRateKey()
            rateKey.rateKey = iteminfoAdd?.first?.productApiRequest.activitiesRatekey
            itemCS.itemDiaCalendario.rateKey = [rateKey]
            itemCS.itemVisitantes.adulto = iteminfoAdd?.first?.productVisitor.productAdult
            itemCS.itemVisitantes.ninio = iteminfoAdd?.first?.productVisitor.productChild
            itemCS.itemVisitantes.infantes = iteminfoAdd?.first?.productVisitor.productInfant
            itemCS.itemProdProm = itemsProdProms
            
            itemCS.productAllotment = iteminfoAdd?.first?.productAllotment
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'"
//            formatter.locale = Locale(identifier: "en_US_POSIX")
            guard let date = formatter.date(from: iteminfoAdd?.first?.productDate ?? "") else {
                return
            }
            
            formatter.dateFormat = "yyyy"
            let year = Int(formatter.string(from: date)) ?? 0
            formatter.dateFormat = "MM"
            let month = Int(formatter.string(from: date)) ?? 0
            formatter.dateFormat = "dd"
            let day = Int(formatter.string(from: date)) ?? 0
            print(year, month, day)
            
            FirebaseBR.shared.getCalendarData(listDias: itemsProdProms, reCotizacion : true, mes : month, year : year, day : day, completion: { (isSuccess, JSONData) in
                if isSuccess {
                    let itemDiaCalendarioPack = self.crearOnLine(mes : month - 1, year : year, dia: day, json : JSONData)
                    if itemDiaCalendarioPack.disable == 0 {
                        itemCS.itemDiaCalendario = itemDiaCalendarioPack
                        self.diaCarShop = ItemDiaCalendario()
                        FirebaseBR.shared.getPricePhotopass(itemsCarShoop : itemCS , completion: { (isSuccess, itemfotos) in
                            itemCS.itemComplementos.fotos = itemfotos
                            itemCS.itemComplementos.fotos.status = iteminfoAdd?.first?.productPhotopass
                            FirebaseBR.shared.getPriceIKE(itemsCarShoop : itemCS ,completion: { (isSuccess, itemIKE) in
                                itemCS.itemComplementos.seguroIKE = itemIKE
                                itemCS.itemComplementos.seguroIKE.status = iteminfoAdd?.first?.productIke
//                                listItemCS.append(itemCS)
                                if iteminfoAdd?.first?.productAllotment ?? false {
                                    let rateKeyCancel = iteminfoAdd?.first?.productApiRequest.activitiesRatekey
                                    FirebaseBR.shared.getCancelAllotment(itemRateKey : rateKeyCancel ?? "", mobile: true, completion: { (isSuccess) in
                                        FirebaseBR.shared.getAllotment(itemCarShoop : itemCS, completion: { (isSuccess, allotmentAvail) in
                                            if isSuccess {
                                                if allotmentAvail.activityAvail.status.lowercased() == "open" {
                                                    listItemCS.append(itemCS)
                                                    if listItemCS.count == itemsProms.count {
                                                        self.listDiaCarShop.removeAll()
                                                        FirebaseBR.shared.getPackData(listItemsCarShop: listItemCS, completion: { (isSuccess, listItemCSP) in
                                                            let auxListItemCSP = listItemCSP.filter({$0.itemProdProm.first?.principal == false})
                                                            for itemCSP in auxListItemCSP {
                                                                self.listitemCarShoopArr.append(itemCSP)
                                                            }
                                                            let aux = listItemCSP
                                                            FirebaseBR.shared.updateListCarshopPacks(listItemCarShop : listItemCSP, editId: keyProdEditCS, completion: { listTickets, result   in
                                                                if self.listitemCSCount.count == self.listitemCarShoopArr.count {
                                                                    FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                                                        self.listCarshop = itemsPickup
                                                                        appDelegate.listItemListCarshop = itemsPickup
                                                                        self.updateCurrency()
                                                                        self.carShopTbl.delegate = self
                                                                        self.carShopTbl.dataSource = self
                                                                        self.carShopTbl.reloadData()
                                                                        self.configPrice()
                                                                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                                                    })
                                                                }
                                                            })
                                                        })
                                                    }
                                                }else{
                                                    
                                                }
                                            }
                                        })
                                    })
                                }else{
                                    listItemCS.append(itemCS)
                                    if listItemCS.count == itemsProms.count {
                                        self.listDiaCarShop.removeAll()
                                        FirebaseBR.shared.getPackData(listItemsCarShop: listItemCS, completion: { (isSuccess, listItemCSP) in
                                            print(listItemCSP)
                                            let auxListItemCSP = listItemCSP.filter({$0.itemProdProm.first?.principal == false})
                                            for itemCSP in auxListItemCSP {
                                                self.listitemCarShoopArr.append(itemCSP)
                                            }
                                            let aux = listItemCSP
                                            
                                            FirebaseBR.shared.updateListCarshopPacks(listItemCarShop : listItemCSP, editId: keyProdEditCS, completion: { listTickets, result   in
                                                if self.listitemCSCount.count == self.listitemCarShoopArr.count {
                                                    let aux = self.listitemCSCount.count
                                                    let aux2 = self.listitemCarShoopArr.count
                                                    print(aux)
                                                    print(aux2)
                                                    FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                                        self.listCarshop = itemsPickup
                                                        appDelegate.listItemListCarshop = itemsPickup
                                                        self.updateCurrency()
                                                        self.carShopTbl.delegate = self
                                                        self.carShopTbl.dataSource = self
                                                        self.carShopTbl.reloadData()
                                                        self.configPrice()
                                                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                                                    })
                                                }
                                            })
                                        })
                                    }
                                }
                            })
                        })
                    }else{
                        print("Error")
                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                        self.viewContentSubTotal.isHidden = true
                        self.contraintContentSubTotal.constant = 0
                        self.statusCarShop = "error"
                        self.carShopTbl.delegate = self
                        self.carShopTbl.dataSource = self
                        self.carShopTbl.reloadData()
                    }
                }
            })
        }
        
    }
    
    
    
    func updateCurrency(){
        if Constants.CURR.current != appDelegate.listItemListCarshop.first?.currency {
            FirebaseBR.shared.updateKeyCarShop(key: "currency", value : Constants.CURR.current, completion: { result in
                print(result)
            })
        }
    }
    
    func crearOnLine(mes : Int, year : Int, dia : Int, json : JSON) -> ItemDiaCalendario {
        
        let Activities = json["Activities"].arrayValue
        let RateServices = Activities[0]["RateServices"].arrayValue
        let DailyRates = RateServices[0]["DailyRates"].arrayValue
        
        var returnDiaCalendario = ItemDiaCalendario()
        
        for itemDailyRates in DailyRates{
            
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
            itemDiaCalendario.diaNumero = dia
            itemDiaCalendario.year = year
            itemDiaCalendario.descuento = data["Discount"]["Percent"].intValue
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd"
            let dateItem = dateFormatterGet.date(from: data["Day"].stringValue)
            let dt = dateFormatterPrint.string(from: dateItem ?? Date())
            itemDiaCalendario.date = dt//data["Day"].stringValue
//            itemDiaCalendario.date = data["Day"].stringValue
            itemDiaCalendario.index = 0
            
            var amount = data["NormalAdultAmount"].doubleValue
            var adult =  data["Adults"].doubleValue
            var children = data["Children"].doubleValue
            var normalAdults = data["NormalAdults"].doubleValue
            let normalChildren = data["NormalChildren"].doubleValue
            
            if data["Promotion"].exists() {
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
                itemRateKey.rateKey = itemRateServices["DailyRates"][0]["RateKey"].stringValue
                
                
                
                if itemRateServices["DailyRates"][0]["Schedules"].exists(){
                    let schedulesHorarios = itemRateServices["DailyRates"][0]["Schedules"].arrayValue
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
                
                
                
                var amountL = itemRateServices["NormalAdultAmount"].doubleValue
                var adultL =  itemRateServices["AdultAmount"].doubleValue
                var childrenL = itemRateServices["ChildrenAmount"].doubleValue
                var normalAdultsL = itemRateServices["NormalAdultAmount"].doubleValue
                let normalChildrenL = itemRateServices["NormalChildrenAmount"].doubleValue
                
                if itemRateServices["Promotion"].exists() {
//                    amountL = itemRateServices["Promotion"]["Amount"].doubleValue
//                    normalAdultsL = amountL
                    adultL = itemRateServices["Promotion"]["Adult"].doubleValue
                    if itemRateServices["Promotion"]["Children"].doubleValue != 0 {
                        childrenL = itemRateServices["Promotion"]["Children"].doubleValue
                    }
                }
                
                itemRateKey.amountLocation.amount = amountL
                itemRateKey.amountLocation.normalAmount = amountL
                itemRateKey.amountLocation.subtotalAdulto = adultL
                itemRateKey.amountLocation.subtotalChildren = childrenL
                itemRateKey.amountLocation.ahorroAdulto = normalAdultsL - adultL
                itemRateKey.amountLocation.ahorroChildren = normalChildrenL - childrenL
                
                
                itemDiaCalendario.rateKey.append(itemRateKey)
                arrItemRateServices = arrItemRateServices + 1
            }
            
            itemDiaCalendario.family.id = Activities[0]["Family"]["Id"].intValue
            itemDiaCalendario.family.name = Activities[0]["Family"]["Name"].stringValue
            
            returnDiaCalendario = itemDiaCalendario
        }
        return returnDiaCalendario
    }

        
    func configPrice(){
        var subtotal = 0.0
        var ahorro = 0.0
        
        let itemsAvailabilityStatus = appDelegate.listItemListCarshop.first?.detail
        let itemsAvailabilityStatusAUX = appDelegate.listItemListCarshop
        
        let aux = appDelegate.listItemListCarshop
        
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
        
        if subtotal > 0 {
            comprarAhoraButtom.alpha = 1
            comprarAhoraButtom.isEnabled = true
        }else{
            comprarAhoraButtom.alpha = 0.5
            comprarAhoraButtom.isEnabled = false
        }
        
        self.subTotalLbl.text = subtotal.currencyFormat()
        self.ahorroLbl.text = ahorro.currencyFormat()
        
        FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
            appDelegate.listItemListCarshop = itemsPickup
        })
    }
    
    func updateTotalPrices(key : String, value : Double){
        FirebaseBR.shared.updateKeyCarShop(key: key, value : value, completion: { result in
            print(result)
        })
    }
    
    func configNavCurrency(){
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.changeCurrency))
        self.contentCurrency.addGestureRecognizer(gesture)
        
    }
    
    func validateDate(date1 : String, date2 : String = "", dateToday : Bool = false) -> String {
        
        let dateToday = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dt = formatter.string(from: dateToday)
        
        let di = date1
        
        if di < dt {
            print("Menor")
            return "menor"
        }else if di == dt{
            print("Igual")
            return "igual"
        }else{
            print("Mayor")
            return "mayor"
        }
        
    }
}

extension CotizadorViewController : ManageCitizador, GoBooking{
    
    func infoIKE(){
        print("InfoIKE")
        let mainNC = AppStoryboard.Cotizador.instance.instantiateViewController(withIdentifier: "infoIKE") as! InfoIKEViewController
        mainNC.modalPresentationStyle = .overFullScreen
        self.present(mainNC, animated: true, completion: nil)
    }
    
    
    func emptyError(type: String) {
        print(type)
        if statusCarShop == "empty" {
            self.dismiss(animated: true, completion: nil)
            appDelegate.goShop = true
            appDelegate.idAction = "promTicket"
        }else{
            validacionesCarShop()
        }
    }
    
    func closeItem(closeItem: Bool, item : ItemCarshop) {
        print(closeItem)
        let itemDetail = appDelegate.listItemListCarshop.first?.detail
        let itemIndex = itemDetail?.index(where: { $0.key == item.key })//!.indices.filter({ itemDetail![$0].key == item.key  }).endIndex
        appDelegate.listItemListCarshop.first?.detail[itemIndex ?? 0].close = closeItem
        self.carShopTbl.reloadData()
    }
    
    func AddIKE(prodAddIKE : ItemCarshop, status: Bool) {
        print("AddIKE")
        if prodAddIKE.products.count > 1 {
            var itemsCountItemCarshop = [ProductsCarShop]()
            print("ADDIKEPACK")
            for itemAddIke in prodAddIKE.products {
                print(itemAddIke.key)
                FirebaseBR.shared.updateKeyCarShop(key: "productIke", value : status, idDetail : prodAddIKE.key ?? "" , idProduct : itemAddIke.key, completion: { result in
                    if result {
                        itemsCountItemCarshop.append(itemAddIke)
                        if itemsCountItemCarshop.count == prodAddIKE.products.count {
                            FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                                self.listCarshop = itemsPickup
                                appDelegate.listItemListCarshop = itemsPickup
                                print(appDelegate.listItemListCarshop)
                                self.validacionesCarShop()
                            })
                        }
                    }
                    
                })
            }
        }else{
            FirebaseBR.shared.updateKeyCarShop(key: "productIke", value : status, idDetail : prodAddIKE.key, idProduct : prodAddIKE.products.first?.key ?? "", completion: { result in
                FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                    let statusOpen = prodAddIKE.close
                    let itemDetail = appDelegate.listItemListCarshop.first?.detail
                    let itemIndex = itemDetail?.index(where: { $0.key == prodAddIKE.key })
                    self.listCarshop = itemsPickup
                    appDelegate.listItemListCarshop = itemsPickup
                    appDelegate.listItemListCarshop.first?.detail[itemIndex ?? 0].close = statusOpen
                    self.validacionesCarShop()
                })
            })
        }
        
    }
    
    
    func editItem(editItem: ItemCarshop, IdItem : String) {
        editProd = true
        from = "edit"
        
        let prodEdit = editItem.products.filter({ $0.key == IdItem }).first
        keyProdEdit = prodEdit?.key ?? ""
        keyIdEdit = editItem.key
        
        if editItem.products.count > 1 {
            
            prodPack = true
            
            let itemproduct = editItem.products.filter({ $0.key == IdItem})
            
            var itemProd = ItemProdProm()
            
            for itemListPrecios in appDelegate.listPrecios {
                for itemListPrecioProd in itemListPrecios.productos{
                    if itemListPrecioProd.idProducto == itemproduct.first?.productId {
                        itemProd = itemListPrecioProd
                    }
                }
            }
            
            itemProdProm = [itemProd]
            print(itemProdProm)
        }else {
            prodPack = false
            let promCodItems = appDelegate.listPrecios.filter({ $0.uid == editItem.promotionName})
            itemProdProm = promCodItems.first?.productos.filter({ $0.idProducto == prodEdit?.productId }) ?? [ItemProdProm]()
        }
        
        let itemVisitantes : ItemVisitantes = ItemVisitantes()
        itemVisitantes.adulto = prodEdit?.productVisitor.productAdult//editItem.products.first?.productVisitor.productAdult
        itemVisitantes.ninio = prodEdit?.productVisitor.productChild//editItem.products.first?.productVisitor.productChild
        itemVisitantes.infantes = prodEdit?.productVisitor.productInfant//editItem.products.first?.productVisitor.productInfant
        
        itemCarShoop.itemVisitantes = itemVisitantes
        itemCarShoop.itemComplementos.alimentos = prodEdit?.productFood
        itemCarShoop.itemComplementos.seguroIKE.status = prodEdit?.productIke
        itemCarShoop.itemComplementos.fotos.status = prodEdit?.productPhotopass
//        if validateDate(date1 : editItem.products.first?.productDate ?? "", dateToday: true) == "mayor" {
          
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
//        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = formatter.date(from: prodEdit?.productDate ?? "") else {
            return
        }
            
            formatter.dateFormat = "yyyy"
            let year = Int(formatter.string(from: date)) ?? 0
            formatter.dateFormat = "MM"
            let month = Int(formatter.string(from: date)) ?? 0
            formatter.dateFormat = "dd"
            let day = Int(formatter.string(from: date)) ?? 0
            print(year, month, day)
            
            let itemDiaCalendario = ItemDiaCalendario()
            itemDiaCalendario.disable = 0
            itemDiaCalendario.diaNumero = day
            itemDiaCalendario.mes = month - 1
            itemDiaCalendario.year = year
            itemDiaCalendario.date = prodEdit?.productDate//editItem.products.first?.productDate
        
        if (prodEdit?.availabilityStatus)! {
            FirebaseBR.shared.getCalendarData(listDias: itemProdProm, reCotizacion : true, mes : month, year : year, day : day, completion: { (isSuccess, JSONData) in
                if isSuccess {
                    self.itemCarShoop.itemDiaCalendario = self.crearOnLine(mes : month - 1, year : year, dia: day, json : JSONData)
                    self.fechaVisitas()
                }
            })
        }else{
            self.fechaVisitas()
        }
            
//            FirebaseBR.shared.getCalendarData(listDias: itemProdProm, reCotizacion : true, mes : month, year : year, day : day, completion: { (isSuccess, JSONData) in
//                if isSuccess {
//                    self.itemCarShoop.itemDiaCalendario = self.crearOnLine(mes : month - 1, year : year, dia: day, json : JSONData)
//                    self.itemCarShoop.itemDiaCalendario =
//                    self.fechaVisitas()
//                }
//            })
//        }else if validateDate(date1 : editItem.products.first?.productDate ?? "", dateToday: true) == "menor"{
//            fechaVisitas()
//
//        }else{
//
//            fechaVisitas()
//        }
        
    }
    
    
    func deleteItem(deleteItem : ItemCarshop) {
        let id = listitemCarShoopArr.filter({ $0.keyItemEditCarShop ==  deleteItem.products.first?.key})
        let quantity = (deleteItem.products.first?.productVisitor.productAdult ?? 0) + (deleteItem.products.first?.productVisitor.productChild ?? 0)
        AnalyticsBR.shared.saveEventRemoveFromCart(id: id.first?.itemProdProm.first?.code_product ?? "", name: id.first?.itemProdProm.first?.descripcionEs?.lowercased().capitalized ?? "" , quantity: quantity, currency: Constants.CURR.current, value: deleteItem.price)
        
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        FirebaseBR.shared.deleteListCarshop(listItemCarShop : deleteItem, completion: {result in
            FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                self.listCarshop = itemsPickup
                appDelegate.listItemListCarshop = itemsPickup
                if itemsPickup.first?.detail.count == 0 {
                    self.viewContentSubTotal.isHidden = true
                    self.contraintContentSubTotal.constant = 0
                    self.statusCarShop = "empty"
                }
                self.configPrice()
                self.carShopTbl.reloadData()
            })
        })
    }
    
    
    func goTermsBooking(buyItem: ItemCarshop, dataCarShop : [ItemCarShoop]) {
        print("goTermsBooking")
        let mainNC = AppStoryboard.Promociones.instance.instantiateViewController(withIdentifier: "popUpPreBuyViewController") as! popUpPreBuyViewController
        mainNC.modalPresentationStyle = .overFullScreen
        mainNC.modalTransitionStyle = .crossDissolve
        mainNC.delegateGoBooking = self
        mainNC.buyItem = buyItem
        mainNC.dataCarShop = dataCarShop
        self.present(mainNC, animated: true, completion: nil)
    }
    
    func goBooking(buyItem: ItemCarshop, dataCarShop : [ItemCarShoop]) {
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        let quantity = (dataCarShop.first?.itemVisitantes.adulto ?? 0) + (dataCarShop.first?.itemVisitantes.ninio ?? 0)
        AnalyticsBR.shared.saveEventBeginCheckout(id: dataCarShop.first?.itemProdProm.first?.key ?? "",
                                                  name: dataCarShop.first?.itemProdProm.first?.descripcionEs.lowercased().capitalized ?? "",
                                                  quantity: quantity,
                                                  currency: Constants.CURR.current,
                                                  value: buyItem.price,
                                                  coupon: buyItem.promotionName)
        if buyItem.products.first?.productAllotment ?? false {
            let rt = buyItem.products.filter({ $0.key == dataCarShop.first?.keyItemEditCarShop})
            let rkey = rt.first?.productApiRequest.activitiesRatekey ?? ""
            FirebaseBR.shared.getRateKeyAllotment(itemCarShoop : dataCarShop.first ?? ItemCarShoop(), rt : rkey, completion: { (isSuccess, allotment, rateKey, allowedCustomerConfigPax) in
                FirebaseBR.shared.getReservedAllotment(itemCarShoop : dataCarShop.first ?? ItemCarShoop(), rateKey : rateKey, time: "maximo", completion: { (isSuccess, prodAllotment) in
                    FirebaseBR.shared.updateKeyCarShop(key: "productApiRequest/activitiesRateKey", value : prodAllotment.rateKey, idDetail : buyItem.key, idProduct : buyItem.products.first?.key ?? "", completion: { result in
                        dataCarShop.first?.allotment = prodAllotment
                        let mainNC = AppStoryboard.Compra.instance.instantiateViewController(withIdentifier: "TusDatos") as! TusDatosViewController
                        mainNC.modalPresentationStyle = .fullScreen
                        mainNC.itemCarShoop = dataCarShop
                        mainNC.buyItem = buyItem
                        mainNC.buyAll = false
                        self.present(mainNC, animated: true, completion: nil)
                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    })
                })
            })
        }else{
            let mainNC = AppStoryboard.Compra.instance.instantiateViewController(withIdentifier: "TusDatos") as! TusDatosViewController
            mainNC.modalPresentationStyle = .fullScreen
            mainNC.itemCarShoop = dataCarShop
            mainNC.buyItem = buyItem
            mainNC.buyAll = false
            self.present(mainNC, animated: true, completion: nil)
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
        }
    }
    
    
    func goCarrito(itemCarShoop: ItemCarShoop) {
        
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        if !prodPack {
            itemCarShoop.itemProdProm.first?.principal = true
            itemCarShoop.keyItemEditCarShop = keyProdEdit
            FirebaseBR.shared.updateItemCarshopSencillo(itemCarShop : [itemCarShoop], editItem: keyIdEdit, completion: { listTickets, result in
                if result {
                    FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                        let statusOpen = !self.editProd
                        let itemDetail = appDelegate.listItemListCarshop.first?.detail
                        let itemIndex = itemDetail?.index(where: { $0.key == itemCarShoop.keyItemEditCarShop })//!.indices.filter({ itemDetail![$0].key == item.key  }).endIndex
                        self.listCarshop = itemsPickup
                        appDelegate.listItemListCarshop = itemsPickup
                        appDelegate.listItemListCarshop.first?.detail[itemIndex ?? 0].close = statusOpen
                        let aux = appDelegate.listItemListCarshop
                        
                        self.editProd = false
                        self.compraProd = false
                        self.validacionesCarShop()
                        //                    self.carShopTbl.reloadData()
                    })
                }
            })
        }else{
            itemCarShoop.itemProdProm.first?.principal = false
            itemCarShoop.keyItemEditCarShop = keyProdEdit
            FirebaseBR.shared.updateListCarshopPacks(listItemCarShop : [itemCarShoop], editId: keyIdEdit, completion: { listTickets, result   in
//                if result {
                    FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
                        //                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                        self.listCarshop = itemsPickup
                        appDelegate.listItemListCarshop = itemsPickup
                        self.editProd = false
                        self.compraProd = false
                        self.validacionesCarShop()
                        //                    self.carShopTbl.reloadData()
                    })
//                }
            })
        }
//        FirebaseBR.shared.updateListCarshop(listItemCarShop : [self.itemCarShoop], editId: keyIdEdit, completion: { listTickets, result   in
//            FirebaseDB.shared.getListCarShop (completion : {(itemsPickup) in
//                LoadingView.shared.hideActivityIndicator(uiView: self.view)
//                self.listCarshop = itemsPickup
//                appDelegate.listItemListCarshop = itemsPickup
//                self.carShopTbl.reloadData()
//            })
//
//        })
    }
    
    func complementos(itemVisitantes : ItemVisitantes, productAllotment : Bool, rateKey : String) {
        itemCarShoop.itemVisitantes = itemVisitantes
        itemCarShoop.productAllotment = productAllotment
//        itemCarShoop.itemDiaCalendario.rateKey.first?.rateKey = rateKey
        self.itemVisitantes = itemVisitantes
        self.vistaCotizador = false
        let mainNC = AppStoryboard.Cotizador.instance.instantiateViewController(withIdentifier: "Complementos") as! ComplementosViewController
        mainNC.modalPresentationStyle = .overFullScreen
        mainNC.itemCarShoop = itemCarShoop
        mainNC.prodPack = prodPack
        mainNC.delegate = self
        self.present(mainNC, animated: true, completion: nil)
    }
    
    func fechaVisitas() {
        let mainNC = AppStoryboard.Cotizador.instance.instantiateViewController(withIdentifier: "FechaVisita") as! FechaVisitaViewController
        mainNC.modalPresentationStyle = .overFullScreen
        mainNC.delegate = self
        itemCarShoop.itemProdProm = itemProdProm
        mainNC.itemProdProm = itemProdProm
        mainNC.itemCarShoop = itemCarShoop
        mainNC.editProd = editProd
        self.present(mainNC, animated: true, completion: nil)
    }
    
    func cerrarCotizador() {
        if from == "edit"{
            self.funcCerrarCotizador = true
        }else if from == "comprar" {
            self.funcCerrarCotizador = true
            self.dismiss(animated: true, completion: nil)
        }else if from == "homePark"{
            self.funcCerrarCotizador = true
            self.dismiss(animated: true, completion: nil)
        }else {
            self.funcCerrarCotizador = true
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func visitantes(item : ItemDiaCalendario) {
//        self.vistaCotizador = false
        self.itemDiaCalendario = item
        itemCarShoop.itemDiaCalendario = item
        let mainNC = AppStoryboard.Cotizador.instance.instantiateViewController(withIdentifier: "Visitantes") as! VisitantesViewController
        mainNC.modalPresentationStyle = .overFullScreen
        mainNC.itemCarShoop = itemCarShoop
        mainNC.delegate = self
        self.present(mainNC, animated: true, completion: nil)
    }
}

extension CotizadorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if statusCarShop == "empty" || statusCarShop == "error" {
            return 1
        }else{
            let listItemListCarshopCount = appDelegate.listItemListCarshop.first?.detail.filter({$0.status == 1})
            return listItemListCarshopCount?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if statusCarShop == "empty" || statusCarShop == "error" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "carShopEmpty", for: indexPath) as! CarShopEmptyTableViewCell
            cell.configMensaje(type: statusCarShop)
            cell.delegate = self
            return cell
        }else{
            var listItemListCarshopCount = appDelegate.listItemListCarshop.first?.detail.filter({$0.status == 1})
            listItemListCarshopCount = listItemListCarshopCount?.sorted(by: { $0.products.first?.dateOrder ?? "" > $1.products.first?.dateOrder ?? "" })
            let item = listItemListCarshopCount?[indexPath.row] ?? ItemCarshop()
            var itemCarShopProd = [ItemCarShoop]()
            
            for itemCarShoopProduct in item.products{
                itemCarShopProd.append(contentsOf: self.listitemCarShoopArr.filter({ $0.keyItemEditCarShop == itemCarShoopProduct.key}))
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCardCarShop", for: indexPath) as! CardCarShopTableViewCell
            cell.configCard(item : item, itemCarShop: itemCarShopProd)
            cell.delegateGoBooking = self
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = appDelegate.listItemCarShoop[indexPath.row]
//    }
    
    
}
