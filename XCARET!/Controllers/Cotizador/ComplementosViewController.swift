//
//  ComplementosViewController.swift
//  XCARET!
//
//  Created by Yeik on 08/03/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit
import DropDown

class ComplementosViewController: UIViewController{
    
    weak var delegate: ManageCitizador?
    
    @IBOutlet weak var viewImgBack: UIView!
    @IBOutlet weak var viewContentInfo: UIView!
    @IBOutlet weak var viewContentSubTotal: UIView!
    @IBOutlet weak var constraintCarritoX: NSLayoutConstraint!
    @IBOutlet weak var contentCurrency: UIView!
    @IBOutlet weak var constraintDrop: NSLayoutConstraint!
    @IBOutlet weak var contentDrop: UIView!
    @IBOutlet weak var constraintTransportacion: NSLayoutConstraint!
    @IBOutlet weak var contraintFood: NSLayoutConstraint!
    
    @IBOutlet weak var agregaAEntradaLbl: UILabel!
    @IBOutlet weak var paxesLbl: UILabel!
    @IBOutlet weak var fechaLbl: UILabel!
    @IBOutlet weak var tuAhorroLbl: UILabel!
    @IBOutlet weak var ahorroLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var subtotalLbl: UILabel!
    
    @IBOutlet weak var alimentosSwitch: UISwitch!
    @IBOutlet weak var transportacionSwitch: UISwitch!
    @IBOutlet weak var fotosSwitch: UISwitch!
    
    @IBOutlet weak var addAlimentosBtn: UIButton!
    @IBOutlet weak var addFotosBtn: UIButton!
    @IBOutlet weak var addTransporte: UIButton!
    @IBOutlet weak var deleteTransporte: UIButton!
    @IBOutlet weak var constraintAddTrasporte: NSLayoutConstraint!
    @IBOutlet weak var contraintLblTransporte: NSLayoutConstraint!
    
    @IBOutlet weak var priceFotoLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var foodLbl: UILabel!
    @IBOutlet weak var checkAlimentos: UIView!
    @IBOutlet weak var fotosConstraintLbl: NSLayoutConstraint!
    @IBOutlet weak var siguienteBtn: UIButton!
    
    @IBOutlet weak var foodLabelE: UILabel!
    @IBOutlet weak var transporteLabelE: UILabel!
    @IBOutlet weak var photoLabelE: UILabel!
    
    
    @IBOutlet weak var titleLbl: UILabel!
    
    
    let mesesES = Constants.CALENDAR.mesesES
    let mesesEN = Constants.CALENDAR.mesesEN
    let diasES = Constants.CALENDAR.diasES
    let diasEN = Constants.CALENDAR.diasEN
    let diasMes = Constants.CALENDAR.diasMes
    
    var subtotalGrl = 0.0
    var ahorro = 0.0
    
    var adultos = 1
    var ninios = 0
    var infantes = 0
    
    var alimentos : Bool! = false
    var transporte : Bool! = false
    var fotos : Bool! = false
    var editPickUp : Bool! = false
    var prodPack = false
    
    var itemCarShoop = ItemCarShoop()
    var itemsLocations = [ItemLocations]()
    
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
        
        let aux = itemCarShoop
        let aux2 = itemsLocations
        
        titleLbl.text = "lbl_cart_adds_title".getNameLabel()
        agregaAEntradaLbl.text = "lbl_cart_adds_subtitle".getNameLabel()
        tuAhorroLbl.text = "lbl_cart_save".getNameLabel()
        subTotalLbl.text = "lbl_cart_total".getNameLabel()
        siguienteBtn.setTitle("lbl_cart_next".getNameLabel(), for: .normal)
        
        foodLabelE.text = "lbl_addons_food".getNameLabel()
        transporteLabelE.text = "lbl_addons_transport".getNameLabel()
        photoLabelE.text = "lbl_addons_photopass".getNameLabel()
        
        addAlimentosBtn.setTitle("lbl_add_plus_not_available".getNameLabel(), for: .normal)
        addFotosBtn.setTitle("lbl_add_plus_not_available".getNameLabel(), for: .normal)
        addTransporte.setTitle("lbl_add_plus_not_available".getNameLabel(), for: .normal)
        deleteTransporte.setTitle("lbl_add_plus_remove".getNameLabel(), for: .normal)
        
        contentCurrency.isHidden = true
        checkAlimentos.isHidden = true
        
        paxesLbl.isHidden = true
        fechaLbl.isHidden = true
        
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
        
//        alimentosSwitch.isEnabled = false
//        alimentosSwitch.alpha = 0.5
//        transportacionSwitch.isEnabled = false
//        transportacionSwitch.alpha = 0.5
        
        
//        alimentosSwitch.addTarget(self, action: #selector(alimentosSwitchChanged), for: UIControl.Event.valueChanged)
//        transportacionSwitch.addTarget(self, action: #selector(transportacionSwitchChanged), for: UIControl.Event.valueChanged)
//        fotosSwitch.addTarget(self, action: #selector(fotosSwitchChanged), for: UIControl.Event.valueChanged)
        
        
        
        deleteTransporte.isHidden = true
        getData()
    }
    
    func getData(){
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        FirebaseBR.shared.getPricePhotopass(itemsCarShoop : self.itemCarShoop , completion: { (isSuccess, itemfotos) in
            let statusPhoto = self.itemCarShoop.itemComplementos.fotos.status
            self.itemCarShoop.itemComplementos.fotos = itemfotos
            self.itemCarShoop.itemComplementos.fotos.status = statusPhoto
            FirebaseBR.shared.getPriceIKE(itemsCarShoop : self.itemCarShoop , completion: { (isSuccess, itemIKE) in
                if isSuccess {
                    let statusIke = self.itemCarShoop.itemComplementos.seguroIKE.status
                    self.itemCarShoop.itemComplementos.seguroIKE = itemIKE
                    self.itemCarShoop.itemComplementos.seguroIKE.status = statusIke
                }
                let aux = self.itemCarShoop.itemComplementos.transporte
                if self.itemCarShoop.itemDiaCalendario.rateKey.count > 1{
                    FirebaseBR.shared.getLocations(itemsCarShoop : self.itemCarShoop , completion: { (isSuccess, itemLocations) in
                        self.itemsLocations = itemLocations
                        var locationOk = false
                        for locationsOk in self.itemsLocations {
                            if locationsOk.itemLocation.count > 0 {
                                locationOk = true
                            }
                        }
                        self.configVista()
                        if locationOk {
                            if self.itemCarShoop.itemComplementos.transporte.id == 0 {
                                self.performSegue(withIdentifier: "popUpMap", sender: nil)
                            }else{
                                self.itemLocation(itemLocation: self.itemCarShoop.itemComplementos.transporte)
                            }
                            
                        }else{
                            let alert = UIAlertController(title: "Alerta", message: "Sin pickups", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }else{
                    self.configVista()
                }
            })
        })
    }
    
    
    func configVista(){
        self.adultos = itemCarShoop.itemVisitantes.adulto
        self.ninios = itemCarShoop.itemVisitantes.ninio
        self.infantes = itemCarShoop.itemVisitantes.infantes
        
        self.fechaLbl.text = "\(Constants.LANG.current == "es" ? mesesES[itemCarShoop.itemDiaCalendario.mes].prefix(3) : mesesEN[itemCarShoop.itemDiaCalendario.mes].prefix(3)) \(String(describing: itemCarShoop.itemDiaCalendario.diaNumero!)), \(String(describing: itemCarShoop.itemDiaCalendario.year!))"
        
        var addPriceFotoSub = 0.0
        var addPriceFotoAhorro = 0.0
        if self.itemCarShoop.itemComplementos.fotos.status {
            addPriceFotoSub = self.itemCarShoop.itemComplementos.fotos.amount
            addPriceFotoAhorro = self.itemCarShoop.itemComplementos.fotos.normalAmount - self.itemCarShoop.itemComplementos.fotos.amount
        }
        
        let subtotal = ((Double(itemCarShoop.itemVisitantes.adulto) * itemCarShoop.itemDiaCalendario.subtotalAdulto) + (Double(itemCarShoop.itemVisitantes.ninio) * itemCarShoop.itemDiaCalendario.subtotalChildren))
        let ahorro = ((Double(itemCarShoop.itemVisitantes.adulto) * itemCarShoop.itemDiaCalendario.ahorroAdulto) + (Double(itemCarShoop.itemVisitantes.ninio) * itemCarShoop.itemDiaCalendario.ahorroChildren))
        
        subtotalGrl = (subtotal + addPriceFotoSub)
        self.subtotalLbl.text = (subtotal + addPriceFotoSub).currencyFormat()
        self.ahorroLbl.text = (ahorro + addPriceFotoAhorro).currencyFormat()
        
        configLabelsPaxes()
        if prodPack {
            configAddonsPack()
        }else{
            configAddons()
        }
        
    }
    
    func configAddonsPack() {
        let aux = itemCarShoop
        print(aux)
        let food = itemCarShoop.itemProdProm.first?.food == 0 ? false : true
        let transport = itemCarShoop.itemProdProm.first?.transportation == 0 ? false : true
        
        if food {
            checkAlimentos.isHidden = false
            addAlimentosBtn.isHidden = true
            foodLbl.text = "lbl_add_plus_included".getNameLabel()
            self.itemCarShoop.itemComplementos.alimentos = true
        }else{
            foodLbl.isHidden = true
            contraintFood.constant = 0
        }
        
        if transport {
            addTransporte.isEnabled = true
            addTransporte.borderWidth = 1
            addTransporte.borderColor = .systemBlue
            addTransporte.tintColor = .systemBlue
            addTransporte.setTitleColor( .systemBlue, for: .normal)
            addTransporte.setTitle("lbl_add_plus_edit".getNameLabel(), for: .normal)
            transporte = true
            editPickUp = true
        }else{
            locationLbl.isHidden = true
            constraintTransportacion.constant = 0
        }
        
        
        fotos = itemCarShoop.itemComplementos.fotos.status
        if itemCarShoop.itemComplementos.fotos.status {
            addFotosBtn.isEnabled = true
            addFotosBtn.borderWidth = 1
            addFotosBtn.borderColor = .systemRed
            addFotosBtn.tintColor = .systemRed
            addFotosBtn.setTitleColor( .systemRed, for: .normal)
            addFotosBtn.setTitle("lbl_add_plus_remove".getNameLabel(), for: .normal)
        }else{
            addFotosBtn.isEnabled = true
            addFotosBtn.borderWidth = 1
            addFotosBtn.borderColor = .systemBlue
            addFotosBtn.tintColor = .systemBlue
            addFotosBtn.setTitleColor( .systemBlue, for: .normal)
            addFotosBtn.setTitle("lbl_add_plus_add".getNameLabel(), for: .normal)
        }
        
        
        
        LoadingView.shared.hideActivityIndicator(uiView: self.view)
        paxesLbl.isHidden = false
        fechaLbl.isHidden = false
    }
    
    func configAddons(){
        let aux = itemCarShoop
        constraintTransportacion.constant = -10
        contraintFood.constant = -10
        let dataAddons = appDelegate.listPrecios.filter({ $0.uid == itemCarShoop.itemProdProm.first?.code_promotion})
        let addonsCTD = dataAddons.first?.productos.filter({ $0.key_park ==  itemCarShoop.itemProdProm.first?.key_park})
        
        let food = itemCarShoop.itemProdProm.first?.food == 0 ? false : true
        let transport = itemCarShoop.itemProdProm.first?.transportation == 0 ? false : true
        
        
        if (addonsCTD?.count ?? 0) > 1 {
            if food {
                if (addonsCTD?.filter({ $0.food == 0 }).count ?? 0) > 0 {
                    addAlimentosBtn.isEnabled = true
                    addAlimentosBtn.borderWidth = 1
                    addAlimentosBtn.borderColor = .systemRed
                    addAlimentosBtn.tintColor = .systemRed
                    addAlimentosBtn.setTitleColor( .systemRed, for: .normal)
                    addAlimentosBtn.setTitle("lbl_add_plus_remove".getNameLabel(), for: .normal)
                    foodLbl.text = "lbl_add_plus_included".getNameLabel()
                    alimentos = true
                }else{
                    checkAlimentos.isHidden = false
                    addAlimentosBtn.isHidden = true
                    foodLbl.text = "lbl_add_plus_included".getNameLabel()
                    self.itemCarShoop.itemComplementos.alimentos = true
                }
            }else{
                if (addonsCTD?.filter({ $0.food == 1 }).count ?? 0) > 0{
                    addAlimentosBtn.isEnabled = true
                    addAlimentosBtn.borderWidth = 1
                    addAlimentosBtn.borderColor = .systemBlue
                    addAlimentosBtn.tintColor = .systemBlue
                    addAlimentosBtn.setTitleColor( .systemBlue, for: .normal)
                    addAlimentosBtn.setTitle("lbl_add_plus_add".getNameLabel(), for: .normal)
                    foodLbl.text = "lbl_add_plus_add_him".getNameLabel()
                    alimentos = false
                }else{
                    contraintFood.constant = 0
                }
            }
        }else if (addonsCTD?.count ?? 0) == 1{
            if food {
                checkAlimentos.isHidden = false
                addAlimentosBtn.isHidden = true
                foodLbl.text = "lbl_add_plus_included".getNameLabel()
                self.itemCarShoop.itemComplementos.alimentos = true
            }
        }
        
        
        constraintAddTrasporte.constant = 0
        deleteTransporte.isHidden = true
        if (addonsCTD?.count ?? 0) > 1 {
            if transport {
                if (addonsCTD?.filter({ $0.transportation == 0 }).count ?? 0) > 0 {
                    addTransporte.isEnabled = true
                    addTransporte.borderWidth = 0
//                    addTransporte.borderColor = .systemBlue
                    addTransporte.tintColor = .systemBlue
                    addTransporte.setTitleColor( .systemBlue, for: .normal)
                    addTransporte.setTitle("lbl_add_plus_edit".getNameLabel(), for: .normal)
                    constraintAddTrasporte.constant = -18
                    deleteTransporte.isHidden = false
                    transporte = true
                    editPickUp = true
                }else{
                    addTransporte.isEnabled = true
                    addTransporte.borderWidth = 0
//                    addTransporte.borderColor = .systemBlue
                    addTransporte.tintColor = .systemBlue
                    addTransporte.setTitleColor( .systemBlue, for: .normal)
                    addTransporte.setTitle("lbl_add_plus_edit".getNameLabel(), for: .normal)
                    transporte = true
                    editPickUp = true
                }
            }else{
                
//                let addonsCTDaux = addonsCTD.filter({ $0.transportation == 1 && $0.extra_day == 0 })
//                print(addonsCTDaux)
                
                let itemValidationDay = addonsCTD?.filter({ $0.transportation == 1 && $0.extra_day == 0})
                
                if itemValidationDay?.count ?? 0 > 0 {
                    
//                    let auxitemCarShoop = itemCarShoop
//                    let auxitemsLocations = itemsLocations
//
//                    let itemValidationDay = addonsCTD?.filter({ $0.transportation == 1 && $0.extra_day == 0})
                    
                    FirebaseBR.shared.getCalendarData(listDias: itemValidationDay ?? [ItemProdProm](), reCotizacion : true, mes : itemCarShoop.itemDiaCalendario.mes + 1, year : itemCarShoop.itemDiaCalendario.year, day : itemCarShoop.itemDiaCalendario.diaNumero, completion: { (isSuccess, JSONData) in
                        if isSuccess {
                            let Activities = JSONData["Activities"].arrayValue
                            let RateServices = Activities[0]["RateServices"].arrayValue
                            let status = RateServices[0]["Avail"]["Status"].stringValue
                            let dis = status.lowercased() == "close" ? false : true
                            if dis {
                                self.addTransporte.isEnabled = true
                                self.addTransporte.borderWidth = 1
                                self.addTransporte.borderColor = .systemBlue
                                self.addTransporte.tintColor = .systemBlue
                                self.addTransporte.setTitleColor( .systemBlue, for: .normal)
                                self.addTransporte.setTitle("lbl_add_plus_add".getNameLabel(), for: .normal)
                                self.locationLbl.text = "lbl_add_plus_add_him".getNameLabel()
                                self.transporte = false
                                self.editPickUp = false
                            }else{
                                self.contraintLblTransporte.constant = 0
                            }
                            
                        }
                    })
                }
            }
        }else if (addonsCTD?.count ?? 0) == 1{
            if transport {
                addTransporte.isEnabled = true
//                addTransporte.borderWidth = 1
//                addTransporte.borderColor = .systemBlue
                addTransporte.tintColor = .systemBlue
                addTransporte.setTitleColor( .systemBlue, for: .normal)
                addTransporte.setTitle("lbl_add_plus_edit".getNameLabel(), for: .normal)
                transporte = true
                editPickUp = true
            }
        }
        
        fotos = itemCarShoop.itemComplementos.fotos.status
        if itemCarShoop.itemComplementos.fotos.status {
            addFotosBtn.isEnabled = true
            addFotosBtn.borderWidth = 1
            addFotosBtn.borderColor = .systemRed
            addFotosBtn.tintColor = .systemRed
            addFotosBtn.setTitleColor( .systemRed, for: .normal)
            addFotosBtn.setTitle("lbl_add_plus_remove".getNameLabel(), for: .normal)
        }else{
            if itemCarShoop.itemComplementos.fotos.individual != nil {
                self.priceFotoLbl.text = "\("lbl_add_plus_per_person".getNameLabel()) \(itemCarShoop.itemComplementos.fotos.individual.currencyFormat())"
//                self.priceFotoLbl.text = "\(itemCarShoop.itemComplementos.fotos.individual.currencyFormat())"
                addFotosBtn.isEnabled = true
                addFotosBtn.borderWidth = 1
                addFotosBtn.borderColor = .systemBlue
                addFotosBtn.tintColor = .systemBlue
                addFotosBtn.setTitleColor( .systemBlue, for: .normal)
                addFotosBtn.setTitle("lbl_add_plus_add".getNameLabel(), for: .normal)
            }else{
                fotosConstraintLbl.constant = 0
            }
            
        }
        
        LoadingView.shared.hideActivityIndicator(uiView: self.view)
        paxesLbl.isHidden = false
        fechaLbl.isHidden = false
    }

    @IBAction func transporteDeleteSwitchChanged(_ sender: Any) {
        print("Delete Transport")
        self.itemCarShoop.itemComplementos.transporte = ItemLocation()
        if transporte {
            print("Transport ok")
            transporte = !transporte
        }else{
            print("Transport no")
            transporte = !transporte
        }
        
        realodData(itemcambio : "Transporte")
    }
    
    @IBAction func alimentosSwitchChanged(_ sender: Any) {
        
        print("Alimentos")
        if alimentos {
            print("Alimentos ok")
            addAlimentosBtn.isEnabled = true
            addAlimentosBtn.borderWidth = 1
            addAlimentosBtn.borderColor = .systemBlue
            addAlimentosBtn.tintColor = .systemBlue
            addAlimentosBtn.setTitleColor( .systemBlue, for: .normal)
            addAlimentosBtn.setTitle("lbl_add_plus_add".getNameLabel(), for: .normal)
            alimentos = !alimentos
        }else{
            print("Alimentos no")
            addAlimentosBtn.isEnabled = true
            addAlimentosBtn.borderWidth = 1
            addAlimentosBtn.borderColor = .systemRed
            addAlimentosBtn.tintColor = .systemRed
            addAlimentosBtn.setTitleColor( .systemRed, for: .normal)
            addAlimentosBtn.setTitle("lbl_add_plus_remove".getNameLabel(), for: .normal)
            alimentos = !alimentos
        }
        
//        self.itemCarShoop.itemComplementos.alimentos = alimentos
        realodData(itemcambio : "Alimentos")
    }
    
    
    func realodData(itemcambio : String){
        
        let dataAddons = appDelegate.listPrecios.filter({ $0.uid == itemCarShoop.itemProdProm.first?.code_promotion})
        let addonsCTD = dataAddons.first?.productos.filter({ $0.key_park ==  itemCarShoop.itemProdProm.first?.key_park})
        let filterFood = alimentos ? 1 : 0
        let filterTrasp = transporte ? 1 : 0
        var addons = [ItemProdProm]()
        
        if itemcambio == "Alimentos" {
            
            addons = (addonsCTD?.filter({ $0.food == filterFood }))!
            
            if addons.count > 1 {
                let addonsTwo = addonsCTD?.filter({ $0.food == filterFood && $0.transportation == filterTrasp }) ?? [ItemProdProm]()
                if addonsTwo.count > 0 {
                    addons = addonsTwo
                }
            }
            //                if let addonsTwo = addonsCTD?.filter({ $0.food == filterFood && $0.transportation == filterTrasp }){
        }
        
        
        if itemcambio == "Transporte" {
            addons = (addonsCTD?.filter({ $0.transportation == filterTrasp }))!
            var addonsTwo = [ItemProdProm]()
            if addons.count > 1 {
                if addonsCTD?.first?.code_park == "xc"{
                    addonsTwo = addonsCTD?.filter({ $0.food == filterFood && $0.transportation == filterTrasp }) ?? [ItemProdProm]()
                }else{
                    addonsTwo = addonsCTD?.filter({ $0.transportation == filterTrasp && $0.extra_day == 0 }) ?? [ItemProdProm]()//addons
                }
                addons = addonsTwo
            }
        }
        
        
        recotizador(itemProdProm : addons)
    }
    
    func recotizador(itemProdProm : [ItemProdProm]){
        let sendData = self.itemCarShoop
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        FirebaseBR.shared.getCalendarData(listDias: itemProdProm, reCotizacion: true , mes : sendData.itemDiaCalendario.mes + 1, year : sendData.itemDiaCalendario.year, day : sendData.itemDiaCalendario.diaNumero, completion: { (isSuccess, JSONData) in
            if isSuccess {
                let itemDiaCalendario = ItemDiaCalendario()
                
                let Activities = JSONData["Activities"].arrayValue
                let RateServices = Activities[0]["RateServices"].arrayValue
//                let rateServicesCount = RateServices.count
                let DailyRates = RateServices[0]["DailyRates"].arrayValue
                
                    let data = DailyRates[0]
                    
                    var avail = data["Avail"]["Status"].stringValue
                    if data["Allotment"].exists() {
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
                    itemDiaCalendario.mes = sendData.itemDiaCalendario.mes
                    itemDiaCalendario.diaNumero = sendData.itemDiaCalendario.diaNumero
                    itemDiaCalendario.year = sendData.itemDiaCalendario.year
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
//                        amount = data["Promotion"]["Amount"].doubleValue
//                        normalAdults = amount
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
//                else{
//                        itemDiaCalendario.normalAmount = amount//data["NormalAdultAmount"].doubleValue
//                        itemDiaCalendario.subtotalAdulto = adult//data["Adults"].doubleValue
//                        itemDiaCalendario.subtotalChildren = children//data["NormalChildren"].doubleValue
//                        itemDiaCalendario.ahorroAdulto = normalAdults//data["NormalAdults"].doubleValue - data["Adults"].doubleValue
//                        itemDiaCalendario.ahorroChildren = normalChildren//data["NormalChildren"].doubleValue - data["Children"].doubleValue
//                    }
                    
                    
                    itemDiaCalendario.transport = Activities[0]["Transport"].boolValue
                    
                
                for itemRateServices in RateServices{
                    let itemRateKey = ItemRateKey()
                    itemRateKey.id = itemRateServices["Geographic"]["Id"].intValue
                    itemRateKey.nameGeographic = itemRateServices["Geographic"]["Name"].stringValue
                    itemRateKey.rateKey = itemRateServices["DailyRates"][0]["RateKey"].stringValue
                    
                    
                    var amountL = itemRateServices["NormalAmount"].doubleValue
                    var adultL =  itemRateServices["NormalAdultAmount"].doubleValue
                    var childrenL = itemRateServices["ChildrenAmount"].doubleValue
                    var normalAdultsL = itemRateServices["AdultAmount"].doubleValue
                    let normalChildrenL = itemRateServices["NormalChildrenAmount"].doubleValue
                    
                    if itemRateServices["Promotion"].exists() {
//                        amountL = itemRateServices["Promotion"]["Amount"].doubleValue
//                        normalAdultsL = amountL
                        adultL = itemRateServices["Promotion"]["Adult"].doubleValue
                        if itemRateServices["Promotion"]["Children"].doubleValue != 0 {
                            childrenL = itemRateServices["Promotion"]["Children"].doubleValue
                        }
                    }
                    
                    itemRateKey.amountLocation.amount = amountL
                    itemRateKey.amountLocation.normalAmount = amountL
                    itemRateKey.amountLocation.subtotalAdulto = adultL
                    itemRateKey.amountLocation.subtotalChildren = childrenL
                    itemRateKey.amountLocation.ahorroAdulto = normalAdultsL
                    itemRateKey.amountLocation.ahorroChildren = normalChildrenL
                    
                    
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
                    
                    itemDiaCalendario.rateKey.append(itemRateKey)
                }
                    
                itemDiaCalendario.index = sendData.itemDiaCalendario.index
                self.itemCarShoop.itemDiaCalendario = itemDiaCalendario
                self.itemCarShoop.itemProdProm = itemProdProm
                self.getData()
//                LoadingView.shared.hideActivityIndicator(uiView: self.view)
            }else{
                print("no ok")
                LoadingView.shared.hideActivityIndicator(uiView: self.view)
            }
        })
    }
    
    @IBAction func transportacionSwitchChanged(_ sender: Any) {
        print("addTransporte")
//        if transporte {
//            addTransporte.isEnabled = true
//            addTransporte.borderWidth = 1
//            addTransporte.borderColor = .systemBlue
//            addTransporte.tintColor = .systemBlue
//            addTransporte.setTitleColor( .systemBlue, for: .normal)
//            addTransporte.setTitle("Editar", for: .normal)
//            transporte = !transporte
//        realodData(itemcambio : "Transporte")
//        self.performSegue(withIdentifier: "popUpMap", sender: nil)
//        }else{
//            addTransporte.isEnabled = true
//            addTransporte.borderWidth = 1
//            addTransporte.borderColor = .systemRed
//            addTransporte.tintColor = .systemRed
//            addTransporte.setTitleColor( .systemRed, for: .normal)
//            addTransporte.setTitle("Eliminar", for: .normal)
//            transporte = !transporte
//        }
        
//        print("Delete Transport")
        if editPickUp {
            self.performSegue(withIdentifier: "popUpMap", sender: nil)
        }else{
            if transporte {
                print("Transport ok")
                transporte = !transporte
            }else{
                print("Transport no")
                transporte = !transporte
            }
            
            realodData(itemcambio : "Transporte")
        }
        
    }
    
//    @objc func fotosSwitchChanged(mySwitch: UISwitch) {
//        let value = mySwitch.isOn
//        self.fotos = value
//        print(value)
//        // Do something
//    }
    
    @IBAction func fotosSwitchChanged(_ sender: Any) {
        
        if fotos {
            addFotosBtn.isEnabled = true
            addFotosBtn.borderWidth = 1
            addFotosBtn.borderColor = .systemBlue
            addFotosBtn.tintColor = .systemBlue
            addFotosBtn.setTitleColor( .systemBlue, for: .normal)
            addFotosBtn.setTitle("lbl_add_plus_add".getNameLabel(), for: .normal)
            fotos = !fotos
        }else{
            addFotosBtn.isEnabled = true
            addFotosBtn.borderWidth = 1
            addFotosBtn.borderColor = .systemRed
            addFotosBtn.tintColor = .systemRed
            addFotosBtn.setTitleColor( .systemRed, for: .normal)
            addFotosBtn.setTitle("lbl_add_plus_remove".getNameLabel(), for: .normal)
            fotos = !fotos
        }
        self.itemCarShoop.itemComplementos.fotos.status = fotos
        configVista()
    }
    
    @objc func changeCurrency(sender : UITapGestureRecognizer) {
        self.constraintDrop.constant = 45
        menu.show()
        self.constraintDrop.constant = 0
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
        self.delegate?.visitantes(item : itemCarShoop.itemDiaCalendario)
    }
      
    @IBAction func goCarrito(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        let itemComplementos = ItemComplementos()
//        itemComplementos.alimentos = self.alimentos
//        itemComplementos.transporte = self.transporte
//        itemComplementos.fotos = self.fotos
        let quantity = itemCarShoop.itemVisitantes.adulto + itemCarShoop.itemVisitantes.ninio
        AnalyticsBR.shared.saveEventAddToCart(id: itemCarShoop.itemProdProm.first?.code_product ?? "", name: itemCarShoop.itemProdProm.first?.descripcionEs.lowercased().capitalized ?? "", quantity: quantity, currency: Constants.CURR.current, value: subtotalGrl)
        self.delegate?.goCarrito(itemCarShoop: self.itemCarShoop)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        constraintCarritoX.constant = UIDevice().getHeightCarrito()
        self.viewContentSubTotal.dropShadow(color: UIColor.lightGray, opacity: 0.5, offSet: CGSize(width: -2, height: -3), radius:3, scale: true, corner: 0, backgroundColor: UIColor.white)
        
    }
    
    func configNavCurrency(){
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.changeCurrency))
        self.contentCurrency.addGestureRecognizer(gesture)
    }
    
    func configLabelsPaxes(){
        
        let labelpaxesAdultos = adultos > 1 ? "\(adultos) \(Constants.LANG.current == "es" ? "Adultos" : "Adults")" : "\(adultos) \(Constants.LANG.current == "es" ? "Adulto" : "Adult")"
        var labelpaxesninios = ""
        var labelpaxesInfantes = ""
        
        if (infantes > 0 && ninios > 0) || (adultos > 0 && infantes > 0){
            labelpaxesInfantes = " - \(infantes) \(Constants.LANG.current == "es" ? "Infante" : "Infant")"
            if infantes > 1 {
                labelpaxesInfantes = " - \(infantes) \(Constants.LANG.current == "es" ? "Infantes" : "Infants")"
            }
        }else if infantes > 1 {
            labelpaxesInfantes = "\(infantes) \(Constants.LANG.current == "es" ? "Infantes" : "Infants")"
        }
        
        if ninios > 0 && adultos > 0 {
            labelpaxesninios = " - \(ninios) \(Constants.LANG.current == "es" ? "Niño" : "Child")"
            if ninios > 1 {
                labelpaxesninios = " - \(ninios) \(Constants.LANG.current == "es" ? "Niños" : "Children")"
            }
        }else if ninios > 1 {
            labelpaxesninios = "\(ninios) \(Constants.LANG.current == "es" ? "Niños" : "Children")"
        }
        UIView.transition(with: self.view, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.paxesLbl.text = "\(labelpaxesAdultos)\(labelpaxesninios)\(labelpaxesInfantes)"
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popUpMap" {
            if let vc = segue.destination as? MapTrasportacionViewController{
                vc.itemCarShoop = itemCarShoop
                vc.itemsLocations = self.itemsLocations
                vc.delegateLocation = self
            }
        }
    }
   
}

extension ComplementosViewController: ManageLocation {
    func itemLocation(itemLocation: ItemLocation){
        self.itemCarShoop.itemComplementos.transporte = itemLocation
        let amountLocation = itemCarShoop.itemDiaCalendario.rateKey.filter({ $0.nameGeographic.lowercased() == itemLocation.nameLoc.lowercased() })
        
        let strNameLocation = itemLocation.name.lowercased()
        self.locationLbl.text = "\(String(itemLocation.nameLoc)) - \(strNameLocation.capitalized)"
        
        
        
        self.adultos = itemCarShoop.itemVisitantes.adulto
        self.ninios = itemCarShoop.itemVisitantes.ninio
        self.infantes = itemCarShoop.itemVisitantes.infantes
        
        self.fechaLbl.text = "\(Constants.LANG.current == "es" ? mesesES[itemCarShoop.itemDiaCalendario.mes].prefix(3) : mesesEN[itemCarShoop.itemDiaCalendario.mes].prefix(3)) \(String(describing: itemCarShoop.itemDiaCalendario.diaNumero!)), \(String(describing: itemCarShoop.itemDiaCalendario.year!))"
        
        var addPriceFotoSub = 0.0
        var addPriceFotoAhorro = 0.0
        if self.itemCarShoop.itemComplementos.fotos.status {
            addPriceFotoSub = self.itemCarShoop.itemComplementos.fotos.amount
            addPriceFotoAhorro =  self.itemCarShoop.itemComplementos.fotos.amount - self.itemCarShoop.itemComplementos.fotos.normalAmount
        }
        
        itemCarShoop.itemDiaCalendario.amount = amountLocation.first?.amountLocation.amount
        itemCarShoop.itemDiaCalendario.normalAmount = amountLocation.first?.amountLocation.normalAmount
        itemCarShoop.itemDiaCalendario.subtotalAdulto = amountLocation.first?.amountLocation.subtotalAdulto
        itemCarShoop.itemDiaCalendario.ahorroAdulto = Double(amountLocation.first?.amountLocation.subtotalAdulto ?? 0) - Double(amountLocation.first?.amountLocation.ahorroAdulto ?? 0)
        itemCarShoop.itemDiaCalendario.subtotalChildren = amountLocation.first?.amountLocation.subtotalChildren
        itemCarShoop.itemDiaCalendario.ahorroChildren = Double(amountLocation.first?.amountLocation.subtotalChildren ?? 0) - Double(amountLocation.first?.amountLocation.ahorroChildren ?? 0)
//
        let subtotal = ((Double(itemCarShoop.itemVisitantes.adulto) * itemCarShoop.itemDiaCalendario.subtotalAdulto) + (Double(itemCarShoop.itemVisitantes.ninio) * itemCarShoop.itemDiaCalendario.subtotalChildren))
        let ahorro = ((Double(itemCarShoop.itemVisitantes.adulto) * itemCarShoop.itemDiaCalendario.ahorroAdulto) + (Double(itemCarShoop.itemVisitantes.ninio) * itemCarShoop.itemDiaCalendario.ahorroChildren))
        
        subtotalGrl = (subtotal + addPriceFotoSub)
        self.subtotalLbl.text = (subtotal + addPriceFotoSub).currencyFormat()
        self.ahorroLbl.text = (ahorro + addPriceFotoAhorro).currencyFormat()
    }
}
