//
//  TiendaViewController.swift
//  XCARET!
//
//  Created by Jacobo Diaz on 17/02/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit
import DropDown

class TiendaViewController: UIViewController {

    @IBOutlet weak var viewImgBack: UIView!
    @IBOutlet weak var constraintGradient: NSLayoutConstraint!
    @IBOutlet weak var contentCurrency: UIView!
    @IBOutlet weak var constraintDrop: NSLayoutConstraint!
    @IBOutlet weak var contentDrop: UIView!
    @IBOutlet weak var goCarrito: UIView!
    @IBOutlet weak var poinrCS: UIView!
    @IBOutlet weak var titleShop: UILabel!
    
    @IBOutlet weak var tblProm: UITableView! {
        didSet{
            tblProm.register(UINib(nibName: "itemsPakTableViewCell", bundle: nil), forCellReuseIdentifier: "cellItemsPak")
            tblProm.register(UINib(nibName: "itemParksTableViewCell", bundle: nil), forCellReuseIdentifier: "itemParks")
            tblProm.register(UINib(nibName: "itemsTourTableViewCell", bundle: nil), forCellReuseIdentifier: "itemsTour")
            tblProm.register(UINib(nibName: "btnAllPromsTableViewCell", bundle: nil), forCellReuseIdentifier: "btnAllProms")
        }
    }
    var listShop = [ItemShop]()
    let items = appDelegate.listAllParks
    let menu : DropDown = {
        let menu = DropDown()
        var imgCurrency = [String]()
        let aux = appDelegate.listCurrencies
        for itemCurrency in appDelegate.listCurrencies{
            
            menu.dataSource.append(itemCurrency.currency)
            imgCurrency.append("flags/ic_\(itemCurrency.flag ?? "ic_es")")
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
        
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        
        
        titleShop.text = "lbl_store".getNameLabel()
        poinrCS.isHidden = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        self.viewImgBack.addGestureRecognizer(tapRecognizer)
        
        constraintGradient.constant = UIScreen.main.bounds.height / 4
        
        self.goCarrito.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.someCarrito(_:))))
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
            
            if appDelegate.optionsHome {
                
                AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: "HM_\(TagsID.Promotion.rawValue)", title: "\(Constants.CURR.current)_\(TagsContentAnalytics.Currency.rawValue)")
            }else{
                
                AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: "\(appDelegate.itemParkSelected.code ?? "")_\(TagsID.Promotion.rawValue)", title: "\(Constants.CURR.current)_\(TagsContentAnalytics.Currency.rawValue)")
            }
            
            self.configNavCurrency()
            self.tblProm.reloadData()
            
        }
        
        tblProm.delegate = self
        tblProm.dataSource = self
        
        loadInformation()
        

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
            
            }else{
                self.poinrCS.isHidden = true
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
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pointCarShop()
        self.tblProm.reloadData()
    }
    
    func loadInformation(){
        FirebaseBR.shared.getListInfoShop{ (listShop) in
                self.listShop = listShop
                self.tblProm.reloadData()
        }
    }
    
}

extension TiendaViewController : ChangeCurrencyShop, ChangeCurrencyShopBack{
    func changeCurrencyShopBack() {
        self.tblProm.reloadData()
    }
    
    func changeCurrencyShop(codeCurrency : String) {
        LoadingView.shared.showActivityIndicator(uiView: self.view)
        FirebaseDB.shared.getlistProductPrices(completion:{ (listProductPrices) in
            FirebaseDB.shared.getListPreciosXapi(completion:{ (ListPreciosXap) in
                FirebaseBR.shared.getListInfoShop{ (listShop) in
                    self.listShop = listShop
                    self.tblProm.reloadData()
                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                }
            })
        })
    }
    
}

extension TiendaViewController: UITableViewDelegate, UITableViewDataSource, GoToPromBar{
    
    func goToPromBar(item: Int) {
        
        if !CheckInternet.Connection() {
            UpAlertView(type: .error, message: "lbl_err_not_network".getNameLabel()).show {
                print("Error")
            }
        }else{
            AnalyticsBR.shared.saveEventContentsMainMenuCurrency(content: TagsContentAnalytics.MainNavigation.rawValue, title: TagsID.mainPromotions.rawValue)
            let mainNC = AppStoryboard.Promociones.instance.instantiateViewController(withIdentifier: "Prom") as! PromocionesViewController
            if appDelegate.itemParkSelected.p_type == "T"{
                mainNC.buttomSelect = "tour"
            }
            mainNC.modalPresentationStyle = .overFullScreen
            self.present(mainNC, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listShop.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listItemShop = listShop[indexPath.row]
        switch listItemShop.typeCell {
        case .cellPromotions:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellItemsPak", for: indexPath) as! itemsPakTableViewCell
//            cell.timerOff()
//            cell.timerOn()
//            cell.config()
            cell.delegate = self
            return cell
        case .cellParks:
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemParks", for: indexPath) as! itemParksTableViewCell
            cell.setInfoView(itemPark: listItemShop)
            cell.delegate = self
            return cell
        case .cellBtnAllPromotions:
            let cell = tableView.dequeueReusableCell(withIdentifier: "btnAllProms", for: indexPath) as! btnAllPromsTableViewCell
            cell.delegate = self
            return cell
        case .cellTours:
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemsTour", for: indexPath) as! itemsTourTableViewCell
            cell.backgroundColor = UIColor(red: 241/255, green: 243/255, blue: 252/255, alpha: 1.0)
            cell.setInfo(itemsShop: listItemShop)
            cell.delegate = self
            return cell
        case .cellPacks:
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemsTour", for: indexPath) as! itemsTourTableViewCell
            cell.backgroundColor = .clear
            cell.setInfo(itemsShop: listItemShop)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

