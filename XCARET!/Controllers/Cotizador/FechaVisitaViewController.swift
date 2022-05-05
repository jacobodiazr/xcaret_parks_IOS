//
//  FechaVisitaViewController.swift
//  XCARET!
//
//  Created by Yeik on 08/03/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON

class FechaVisitaViewController: UIViewController {
    
    weak var delegate: ManageCitizador?
    
    @IBOutlet weak var viewImgBack: UIView!
    @IBOutlet weak var viewContentInfo: UIView!
    @IBOutlet weak var viewContentSubTotal: UIView!
    @IBOutlet weak var constraintCarritoX: NSLayoutConstraint!
    @IBOutlet weak var contentCurrency: UIView!
    @IBOutlet weak var constraintDrop: NSLayoutConstraint!
    @IBOutlet weak var contentDrop: UIView!
    
    @IBOutlet weak var yearsCollection: UICollectionView!
    @IBOutlet weak var mesesCollection: UICollectionView!
    @IBOutlet weak var calendarioCollection: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var fechaLbl: UILabel!
    
    @IBOutlet weak var viewContentStack: UIView!
    
    @IBOutlet weak var tuAhorroLbl: UILabel!
    @IBOutlet weak var ahorroLbl: UILabel!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var subtotalCantidadLbl: UILabel!
    
    @IBOutlet weak var disponibilidadView: UIView!
    @IBOutlet weak var disponibilidadLbl: UILabel!
    @IBOutlet weak var disponibilidadConstraint: NSLayoutConstraint!
    @IBOutlet weak var diasConLbl: UILabel!
    
    @IBOutlet weak var siguienteBtn: UIButton!
    
    let mesesES = Constants.CALENDAR.mesesES
    let mesesEN = Constants.CALENDAR.mesesEN
    let diasES = Constants.CALENDAR.diasES
    let diasEN = Constants.CALENDAR.diasEN
    let diasMes = Constants.CALENDAR.diasMes
    
    let date = Date()
    let calendario = Calendar.current
    var anio = Int()
    var day = Int()
    var semana = Int()
    var mes = Int()
    
    var mesS = Int()
    var dayS = Int()
    var anioS = Int()
    
    var allotment = false
    var editProd = false
    
    var currentMes = String()
    var widthsize : CGFloat = 0.0
    var mesCreado = [ItemDiaCalendario]()
    var itemProdProm = [ItemProdProm]()
    var itemCarShoop = ItemCarShoop()
    var selectDiaCalendario = ItemDiaCalendario()
    var diaSeleccionado = ""
    
    var isSelect = ""
    var itemIsSelect = 0
    var moveToEndScroll = true
    var intentoCalendario = true
    var cambioSobreCalendario = false
    
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
        
        titleLbl.text = "lbl_cart_calendar_title".getNameLabel()
        diasConLbl.text = "lbl_cart_calendar_discount".getNameLabel()
        tuAhorroLbl.text = "lbl_cart_save".getNameLabel()
        subtotalLbl.text = "lbl_cart_total".getNameLabel()
        siguienteBtn.setTitle("lbl_cart_next".getNameLabel(), for: .normal)
        
        let auxitemProdProm = itemProdProm
        let auxitemCarShoop = itemCarShoop
        let auxeditProd = editProd
        
        
        contentCurrency.isHidden = true
        disponibilidadView.isHidden = true
        disponibilidadLbl.isHidden = true
        disponibilidadConstraint.constant = 5
        configInit()
        crearDiasSemana()
        
    }
    
    func configInit(){
        
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
        
        let yearFL = UPCarouselFlowLayout()
        yearFL.itemSize = CGSize(width: 90.0, height: 52.0)
        yearFL.scrollDirection = .horizontal
        yearFL.sideItemScale = 0.8
        yearFL.sideItemAlpha = 0.5
        yearFL.spacingMode = .fixed(spacing: 0.0)
        yearsCollection.collectionViewLayout = yearFL
        
        let mesFL = UPCarouselFlowLayout()
        mesFL.itemSize = CGSize(width: 155.0, height: 52.0)
        mesFL.scrollDirection = .horizontal
        mesFL.sideItemScale = 0.8
        mesFL.sideItemAlpha = 0.5
        mesFL.spacingMode = .fixed(spacing: 0.0)
        mesesCollection.collectionViewLayout = mesFL
        
        let dateToday = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "GMT-5")
        formatter.locale = Locale(identifier: "es")
        let resultDateToday = formatter.string(from: dateToday)
        let dateformatter = formatter.date(from: resultDateToday)
        
        
        formatter.dateFormat = "yyyy"
        anio = Int(formatter.string(from: dateformatter ?? Date())) ?? 0//calendario.component(.year, from: date)
        formatter.dateFormat = "dd"
        day = Int(formatter.string(from: dateformatter ?? Date())) ?? 0//calendario.component(.day, from: date)
        semana = calendario.component(.weekday, from: date)
        formatter.dateFormat = "MM"
        mes = Int(formatter.string(from: dateformatter ?? Date())) ?? 0//calendario.component(.month, from: date)
        mesS = mes
        dayS = day
        anioS = anio
        
        yearsCollection.isHidden = true
        mesesCollection.isHidden = true
        fechaLbl.isHidden = true
        viewContentStack.isHidden = true
        
        
        if itemCarShoop.itemDiaCalendario.date != "" {
            self.selectDiaCalendario = itemCarShoop.itemDiaCalendario
            if mesS != (itemCarShoop.itemDiaCalendario.mes + 1) || itemCarShoop.itemDiaCalendario.year != anioS{
                dayS = 1
            }
            mesS = itemCarShoop.itemDiaCalendario.mes + 1
            anioS = itemCarShoop.itemDiaCalendario.year
            changeCalendar(year : anioS, mes : mesS, dia : dayS)
        }else {
            
            changeCalendar(year : anioS, mes : mesS, dia : dayS)
//            changeCalendar(year : 2021, mes : 12, dia : 31)
        }
        
    }
    
    func crearDiasSemana(){
        
        let stackView = UIStackView(frame: CGRect(x: 0, y:0, width: viewContentStack.bounds.width, height: viewContentStack.bounds.height))
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = .fillEqually
        
        let diasLetra = Constants.LANG.current == "es" ? diasES : diasEN
        for diaLeta in diasLetra {
            let letra = diaLeta.prefix(1)
            print(letra)
            
            let item : UIView = {
                let cell = UIView()
                
                widthsize = (UIScreen.main.bounds.width - 30) / 7
                
                let labelday = UILabel()
                labelday.text = String(letra)
                labelday.textAlignment = .center
                labelday.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
                labelday.textColor = UIColor(red: 140/255, green: 157/255, blue: 175/255, alpha: 0.8)
                labelday.frame = CGRect(x:0,y:0,width: widthsize,height:labelday.intrinsicContentSize.height)
                
                viewContentStack.addSubview(stackView)
                cell.addSubview(labelday)
                
                return cell
            }()
            
            stackView.addArrangedSubview(item)
        }
    }
    
    func crearMes(mes : Int, year : Int, day : Int, inicio : Int){
        mesCreado.removeAll()
        if mes < self.mes && year <= self.anio{
            self.crearMesAnterior(mes : mes, inicio : inicio)
            self.calendarioCollection.reloadData()
            LoadingView.shared.hideActivityIndicator(uiView: self.view)
        }else{
            LoadingView.shared.showActivityIndicator(uiView: self.view)
            FirebaseBR.shared.getCalendarData(listDias: itemProdProm, mes : mes, year : year, day : day, completion: { (isSuccess, JSONData) in
                if isSuccess {
                    UIView.transition(with: self.view, duration: 0.1, options: .transitionCrossDissolve, animations: {
                        self.yearsCollection.isHidden = false
                        self.mesesCollection.isHidden = false
                        self.fechaLbl.isHidden = false
                        self.viewContentStack.isHidden = false
                    })
                    self.crearOnLine(mes : mes - 1, year : year, dia: day, inicio : inicio, json : JSONData)
                    let diaDisponible = self.mesCreado.filter({ $0.disable == 0 })
                    if !diaDisponible.isEmpty {
                        self.calendarioCollection.reloadData()
                        self.collectionConfig()
                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    }else{
                        if self.cambioSobreCalendario {
//                            self.intentoCalendario = true
                            self.calendarioCollection.reloadData()
                            self.collectionConfig()
                            LoadingView.shared.hideActivityIndicator(uiView: self.view)
                        }else{
                            if self.intentoCalendario {
                                self.intentoCalendario = false
                                var mesSiguiente = mes + 1
                                var yearSiguinte = year
                                var diaMesSiguiente = 1
                                if mesSiguiente > 12 {
                                    mesSiguiente = 1
                                    diaMesSiguiente = 1
                                    yearSiguinte = year + 1
                                }
                                if let weekday = self.getDayOfWeek("\(yearSiguinte)-\(mesSiguiente)-\(01)") {
                                    print(weekday)
                                    let inicioDia = weekday - 1
                                    
                                    self.mesS = mesSiguiente
                                    self.anioS = yearSiguinte
                                    self.crearMes(mes : mesSiguiente, year : yearSiguinte, day : diaMesSiguiente, inicio : inicioDia)
                        //            calendarioCollection.reloadData()
                                } else {
                                    print("bad input")
                                }
                            }else{
                                self.intentoCalendario = true
                                self.calendarioCollection.reloadData()
                                self.collectionConfig()
                                LoadingView.shared.hideActivityIndicator(uiView: self.view)
                            }
                        }
                    }
                    
                }else{
//                    let alert = UIAlertController(title: "Error", message: "Ocurrio un error inesperado, vuelva a intenralo mas tarde", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.cerrarCotizador()
                        LoadingView.shared.hideActivityIndicator(uiView: self.view)
                        let mainNC = AppStoryboard.AlertDefault.instance.instantiateViewController(withIdentifier: "AlertDefault") as! AlertDefaultViewController
                        mainNC.modalPresentationStyle = .overFullScreen
                        mainNC.modalTransitionStyle = .crossDissolve
                        mainNC.configAlert(type: .disconnectionAPI, heightC: 250, texto: "lbl_dialog_card_api_error".getNameLabel())
                        self.present(mainNC, animated: true, completion: nil)
                            
                }
            })
        }
    }
    
    func configSelect(itemSelect : ItemDiaCalendario, index : Int = 0){
        let indexPath = IndexPath(item: index , section: 0)
        DispatchQueue.main.async {
            self.calendarioCollection.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
        if itemSelect.index != -1 {
            self.selectDiaCalendario = mesCreado[index]
            self.diaSeleccionado = mesCreado[index].date
            self.ahorroLbl.text = mesCreado[index].ahorroAdulto.currencyFormat()
            self.subtotalCantidadLbl.text = mesCreado[index].subtotalAdulto.currencyFormat()
            
            UIView.transition(with: self.view, duration: 0.1, options: .transitionCrossDissolve, animations: {
                self.fechaLbl.text = "\(Constants.LANG.current == "es" ? self.mesesES[self.selectDiaCalendario.mes].prefix(3) : self.mesesEN[self.selectDiaCalendario.mes].prefix(3)) \(String(describing: self.selectDiaCalendario.diaNumero!)), \(String(describing: self.selectDiaCalendario.year!))"
                if self.allotment {
                    self.disponibilidadLbl.text = "Lugares disponibles: \(String(itemSelect.allotment.avail))"
                }
            })
        }
        
    }
    
    func crearMesAnterior(mes : Int, inicio : Int){
        
        var diaS = 1
        
        for item in 1...42 {
            let itemDiaCalendario = ItemDiaCalendario()
            if item <= inicio {
                if (mes - 1) == 0 {
                    itemDiaCalendario.disable = 2
                    mesCreado.append(itemDiaCalendario)
                }else{
                    itemDiaCalendario.diaNumero =  diasMes[mes - 2] - (inicio - item)
                    mesCreado.append(itemDiaCalendario)
                }
            }else if item > inicio && item <= diasMes[mes - 1] + inicio {
                itemDiaCalendario.mes = mes
                itemDiaCalendario.diaNumero = item - inicio
                    mesCreado.append(itemDiaCalendario)
            }else {
                if mes == 11 {
                    itemDiaCalendario.disable = 2
                    mesCreado.append(itemDiaCalendario)
                }else{
                    itemDiaCalendario.diaNumero = diaS
                    mesCreado.append(itemDiaCalendario)
                    diaS = diaS + 1
                }
            }
        }
        
    }
    
    func crearOnLine(mes : Int, year : Int, dia : Int, inicio : Int, json : JSON){
        
        let aux = itemProdProm
        let aux2 = editProd
        
        let Activities = json["Activities"].arrayValue
        let RateServices = Activities[0]["RateServices"].arrayValue
        let rateServicesCount = RateServices.count
        let DailyRates = RateServices[0]["DailyRates"].arrayValue
        
        let dailyRatesCount = DailyRates.count
        var diaS = 1
        
        for item in 1...42{
            
            let itemDiaCalendario = ItemDiaCalendario()
            
            if item <= inicio {
                if mes == 0 {
                    itemDiaCalendario.disable = 2
                    mesCreado.append(itemDiaCalendario)
                }else{
                    itemDiaCalendario.diaNumero =  diasMes[mes - 1] - (inicio - item)
                    mesCreado.append(itemDiaCalendario)
                }
            }else if item > inicio && item <= diasMes[mes] + inicio {
                
                if (item - inicio) < dia {
                    
                    itemDiaCalendario.mes = mes
                    itemDiaCalendario.diaNumero = item - inicio
                    itemDiaCalendario.year = anio
                    mesCreado.append(itemDiaCalendario)
                }else{
                    let itemCountDays = (item - (inicio + dia))
                    if dailyRatesCount >= itemCountDays{
                        let data = DailyRates[itemCountDays]
                        
                        if json["Promotion"]["Applied"].exists(){
                            itemDiaCalendario.promotionApplied.status = json["Promotion"]["Applied"]["Status"].stringValue
                            itemDiaCalendario.promotionApplied.description = json["Promotion"]["Applied"]["Description"].stringValue
                            itemDiaCalendario.promotionApplied.message = json["Promotion"]["Applied"]["Message"].stringValue
                            
                            if json["Promotion"]["Applied"]["DetailStatus"].exists(){
                                itemDiaCalendario.promotionApplied.detailStatus.description = json["Promotion"]["Applied"]["DetailStatus"]["Description"].stringValue
                                itemDiaCalendario.promotionApplied.detailStatus.status = json["Promotion"]["Applied"]["DetailStatus"]["Status"].stringValue
                            }
                            
                        }
            
                        
                        var avail = data["Avail"]["Status"].stringValue
                        if data["Allotment"].exists() {
                            allotment = true
                            disponibilidadView.isHidden = false
                            disponibilidadLbl.isHidden = false
                            disponibilidadConstraint.constant = 30
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
                        itemDiaCalendario.diaNumero = item - inicio
                        itemDiaCalendario.year = anioS
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
//                        data["NormalAdultAmount"].doubleValue - data["Promotion"]["Amount"].doubleValue
                        
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
                        itemDiaCalendario.ahorroChildren = normalChildren - children//data["NormalChildren"].doubleValue - data["Children"].doubleValue
                        
                        itemDiaCalendario.transport = Activities[0]["Transport"].boolValue
                        
                        
//                        for itemRateServices in RateServices{
//                            let itemRateKey = ItemRateKey()
//                            itemRateKey.id = itemRateServices["Geographic"]["Id"].intValue
//                            itemRateKey.nameGeographic = itemRateServices["Geographic"]["Name"].stringValue
//                            itemRateKey.rateKey = itemRateServices["DailyRates"][itemCountDays]["RateKey"].stringValue
//                            itemDiaCalendario.rateKey.append(itemRateKey)
//                        }
                        
                        for itemRateServices in RateServices{
                            let itemRateKey = ItemRateKey()
                            itemRateKey.id = itemRateServices["Geographic"]["Id"].intValue
                            itemRateKey.nameGeographic = itemRateServices["Geographic"]["Name"].stringValue
                            itemRateKey.rateKey = itemRateServices["DailyRates"][itemCountDays]["RateKey"].stringValue

                            
                            var amountL = itemRateServices["NormalAdultAmount"].doubleValue
                            var adultL =  itemRateServices["AdultAmount"].doubleValue
                            var childrenL = itemRateServices["ChildrenAmount"].doubleValue
                            var normalAdultsL = itemRateServices["NormalAdultAmount"].doubleValue
                            let normalChildrenL = itemRateServices["NormalChildrenAmount"].doubleValue
                            
//                            var taxAmount = 0.0
                            if itemRateServices["Promotion"].exists() {
//                                amountL = itemRateServices["Promotion"]["Amount"].doubleValue
//                                normalAdultsL = amountL
                                adultL = itemRateServices["Promotion"]["Adult"].doubleValue
                                if itemRateServices["Promotion"]["Children"].doubleValue != 0 {
                                    childrenL = itemRateServices["Promotion"]["Children"].doubleValue
                                }
                                
//                                taxAmount = itemRateServices["Promotion"]["Tax"]["Amount"].doubleValue
                            }
                            
                            itemRateKey.amountLocation.amount = amountL
                            itemRateKey.amountLocation.normalAmount = amountL
                            itemRateKey.amountLocation.subtotalAdulto = adultL
                            itemRateKey.amountLocation.subtotalChildren = childrenL
                            itemRateKey.amountLocation.ahorroAdulto = normalAdultsL - adultL
//                            if taxAmount > 0 {
//                                itemRateKey.amountLocation.ahorroAdulto = taxAmount
//                            }
                            itemRateKey.amountLocation.ahorroChildren = normalChildrenL - childrenL
                            
                            
                            if itemRateServices["DailyRates"][itemCountDays]["Schedules"].exists(){
                                let schedulesHorarios = itemRateServices["DailyRates"][itemCountDays]["Schedules"].arrayValue
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
                        
                        
                        
                        itemDiaCalendario.family.id = Activities[0]["Family"]["Id"].intValue
                        itemDiaCalendario.family.name = Activities[0]["Family"]["Name"].stringValue
                        
                        itemDiaCalendario.index = item - 1
                        
                        mesCreado.append(itemDiaCalendario)
                    }
                    
                }
            }else{
                if mes == 11 {
                    itemDiaCalendario.disable = 2
                    mesCreado.append(itemDiaCalendario)
                }else{
                    itemDiaCalendario.diaNumero = diaS
                    mesCreado.append(itemDiaCalendario)
                    diaS = diaS + 1
                }
            }
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == yearsCollection) {
            let layout = self.yearsCollection.collectionViewLayout as! UPCarouselFlowLayout
            let pageSizeYear = (layout.scrollDirection == .horizontal) ? self.pageSizeYear.width : self.pageSizeYear.height
            let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
            currentPageYears = Int(floor((offset - pageSizeYear / 2) / pageSizeYear) + 1)
        }else if scrollView == mesesCollection{
            let layout = self.mesesCollection.collectionViewLayout as! UPCarouselFlowLayout
            let pageSizeMes = (layout.scrollDirection == .horizontal) ? self.pageSizeMes.width : self.pageSizeMes.height
            let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
            currentPageMes = Int(floor((offset - pageSizeMes / 2) / pageSizeMes) + 1)
        }
    }
    
    fileprivate var currentPageYears: Int = 0 {
        didSet {
            
            cambioSobreCalendario = true
            
            anioS = anio + currentPageYears
            
            var dia = day
            if mes != mesS || anio != anioS{
                if anio != anioS {
                    dia = 1
                }
            }
            if anioS > anio {mesS = 1}else{mesS = mes}
            changeCalendar(year: anioS, mes: mesS, dia: dia)
            
        }
    }
    
    fileprivate var currentPageMes: Int = 0 {
        didSet {
            
            cambioSobreCalendario = true
            
            mesS = currentPageMes + 1
            
            var dia = day
            if mes != mesS || anio != anioS{
                dia = 1
            }
            
            changeCalendar(year: anioS, mes: mesS, dia: dia)
        }
    }
    
    func changeCalendar (year : Int, mes : Int, dia : Int = 01) {
        
        if let weekday = getDayOfWeek("\(year)-\(mes)-\(01)") {
            print(weekday)
            let inicioDia = weekday - 1
            crearMes(mes: mes, year: year, day: dia, inicio : inicioDia)
//            calendarioCollection.reloadData()
        } else {
            print("bad input")
        }
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    fileprivate var pageSizeYear: CGSize {
        let layout = self.yearsCollection.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    fileprivate var pageSizeMes: CGSize {
        let layout = self.mesesCollection.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    @objc func changeCurrency(sender : UITapGestureRecognizer) {
        self.constraintDrop.constant = 45
        menu.show()
        self.constraintDrop.constant = 0
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
        self.delegate?.cerrarCotizador()
    }
    
    @IBAction func sendVisitantes(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.visitantes(item : selectDiaCalendario)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionConfig()
    }
    
    func collectionConfig(){
        constraintCarritoX.constant = UIDevice().getHeightCarrito()
        self.viewContentSubTotal.dropShadow(color: UIColor.lightGray, opacity: 0.5, offSet: CGSize(width: -2, height: -3), radius:3, scale: true, corner: 0, backgroundColor: UIColor.white)
        
        let indexPathMes = IndexPath(item: mesS - 1, section: 0)
        DispatchQueue.main.async {
            self.mesesCollection.selectItem(at: indexPathMes, animated: true, scrollPosition: .centeredHorizontally)
        }
        var index = 0
        for item in 0...9{
            if anioS == (anio + item) {
                index = item
            }
        }
        let indexPathAnio = IndexPath(item: index, section: 0)
        DispatchQueue.main.async {
            self.yearsCollection.selectItem(at: indexPathAnio, animated: true, scrollPosition: .centeredHorizontally)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        print(self.isFirstSelect)
//        if self.isFirstSelect {
//            mesSeleccionado = self.mestDayOfWeek
//            self.changeCalendar(year : self.anio, mes : self.mestDayOfWeek + 1)
//        }
    }
    
    
    func configNavCurrency(){
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.changeCurrency))
        self.contentCurrency.addGestureRecognizer(gesture)
        
    }
    
    func esBisiesto(anio : Int) -> Bool {
        return (anio % 4 == 0 && anio % 100 != 0) || anio % 400 == 0
    }

}


extension FechaVisitaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == yearsCollection {
            count = 10
        }else if collectionView == mesesCollection{
            count = mesesES.count
        }else if collectionView == calendarioCollection{
            count = mesCreado.count
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == yearsCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Years", for: indexPath) as! YearCollectionViewCell
            cell.yearLabel.text = String(anio + indexPath.row)
            return cell
        }else if collectionView == mesesCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Mes", for: indexPath) as! MesCollectionViewCell
            cell.mesLbl.text = Constants.LANG.current == "es" ? mesesES[indexPath.row] : mesesEN[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "diaCalendario", for: indexPath) as! DataCalendarioCollectionViewCell
            cell.configDia(item: mesCreado[indexPath.row])
            let mesConfig = mesCreado[indexPath.row]
            if mesConfig.disable != 0 {
                cell.isUserInteractionEnabled = false
            }else{
                cell.isUserInteractionEnabled = true
            }
            if  mesConfig.disable == 0 && selectDiaCalendario.date == "" {
                self.selectDiaCalendario = mesCreado[indexPath.row]
                configSelect(itemSelect: selectDiaCalendario, index : indexPath.row)
            }else if mesConfig.disable == 0 && mesConfig.date == selectDiaCalendario.date {
                configSelect(itemSelect: selectDiaCalendario, index : indexPath.row)
            }
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == calendarioCollection{
            let mesConfig = mesCreado[indexPath.row]
            if mesConfig.disable == 0 {
                print(mesConfig.date)
                self.selectDiaCalendario = mesCreado[indexPath.row]
                configSelect(itemSelect: selectDiaCalendario, index: indexPath.row)
            }
        }else if collectionView == yearsCollection {
            DispatchQueue.main.async {
                self.yearsCollection.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
            anioS = anio + indexPath.row
            
            var dia = day
            if mes != mesS || anio != anioS{
                dia = 1
            }
            if anioS > anio {mesS = 1}else{mesS = mes}
            changeCalendar(year: anioS, mes: mesS, dia: dia)
            
        }else if collectionView == mesesCollection{
            let indexPathMes = IndexPath(item: indexPath.row, section: 0)
            DispatchQueue.main.async {
                self.mesesCollection.selectItem(at: indexPathMes, animated: true, scrollPosition: .centeredHorizontally)
                self.mesS = indexPath.row + 1
                
                var dia = self.day
                if self.mes != self.mesS || self.anio != self.anioS{
                    dia = 1
                }
                
                self.changeCalendar(year: self.anioS, mes: self.mesS, dia: dia)
            }
        }
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == yearsCollection {
            return CGSize(width: 90.0, height: 52.0)
        }else if collectionView == mesesCollection{
            return CGSize(width: 155.0, height: 52.0)
        }else{
            return CGSize(width: (UIScreen.main.bounds.width - 40) / 7 , height: (calendarioCollection.bounds.height) / 6)
        }
    }
    
    
}
