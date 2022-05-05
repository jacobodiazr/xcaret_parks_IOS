//
//  AnimateBuyViewController.swift
//  XCARET!
//
//  Created by YEiK on 18/05/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import UIKit
import Lottie

class AnimateBuyViewController: UIViewController {
    weak var delegateFinalBuyStepReintentar : FinalBuyStepReintentar?
    weak var delegateFinalBuyStepGoTicket : FinalBuyStepGoTicket?
    var itemCarShoop : [ItemCarShoop] = [ItemCarShoop]()
    var buyItem: ItemCarshop = ItemCarshop()
    var allItems : ItemListCarshop = ItemListCarshop()
    var itemCompradorAllItems = ItemCarShoop()
    var idTicketsArray = [GetBookingTicket]()
    var listItemListCarshop : [ItemListCarshop] = [ItemListCarshop]()
    var arryTickets = [String]()
    @IBOutlet weak var viewBotones: UIView!
    var statusBuy = true
    var buyAll = false
    var buyItemCount = 0
    var buyItemPlus = 0
    var sizeSidthScreen : CGFloat = 0.0
    public typealias FinishedAnimationHandler = ((Bool) -> Void)
    public var finishedAnimationHandler: FinishedAnimationHandler?
    
    @IBOutlet weak var tableProductos: UITableView!
    
    
    enum ProgressKeyFrames: CGFloat {
        case start = 0
        case end = 60
        
        case successStart = 61
        case successEnd = 90
        
        case failStart = 91
        case failEnd = 120
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sizeSidthScreen = UIScreen.main.bounds.width
        
        listItemListCarshop = appDelegate.listItemListCarshop
        
        var firstItem : ItemCarshop = ItemCarshop()
        var firstitemCarShoop : [ItemCarShoop] = [ItemCarShoop]()
        
        if buyAll {
            for item in allItems.detail {
                let availability = item.products.first?.availabilityStatus! ?? false
                if !availability {
                    let indexAllItems = self.allItems.detail.firstIndex(where: {$0.key == item.key}) ?? 0
                    self.allItems.detail.remove(at: indexAllItems)
                    let indexitemCarShoop = self.itemCarShoop.firstIndex(where: {$0.keyItemEditCarShop == item.products.first?.key}) ?? 0
                    self.itemCarShoop.remove(at: indexitemCarShoop)
                }
            }
//            let aux = allItems
//            let aux2 = itemCarShoop
            allItems.detail.first?.statusBuy.enProceso = true
            firstItem = allItems.detail.first ?? ItemCarshop()
            firstitemCarShoop = itemCarShoop.filter({$0.keyItemEditCarShop == allItems.detail.first?.products.first?.key})
        }else{
            buyItem.statusBuy.enProceso = true
            firstItem = buyItem
            firstitemCarShoop = itemCarShoop
        }
        self.buyItemCS(item: firstItem, itemCS: firstitemCarShoop)
        tableProductos.delegate = self
        tableProductos.dataSource = self
        tableProductos.reloadData()
    }
    
    
    
    
    private func buyItemCS(item : ItemCarshop, itemCS : [ItemCarShoop]){
        print(item)
        if buyAll {
            
            itemCS.first?.itemComprador = self.itemCompradorAllItems.itemComprador
            itemCS.first?.itemVisitanteCompra = self.itemCompradorAllItems.itemVisitanteCompra
            itemCS.first?.itemCreditCard = self.itemCompradorAllItems.itemCreditCard
            
            FirebaseBR.shared.validateCarShop(itemsCarShoop: itemCS, buyItem: item, completion: { (isSuccess, status) in
                if isSuccess {
                    if status.statusValidateCarShopAllotmen.holdStatusAllotment == "AllotmentAvail" && status.statusValidateCarShopAllotmen.statusApplied{
                        FirebaseBR.shared.buyItem(itemsCarShoop: itemCS, buyItem: item, completion: { (isSuccess, bookingTicket) in
                            
                            //eliminamos el reintento, si vuelve a fallar, la logica lo agregará de nuevo.
                            if let resIndex = appDelegate.listItemListCarshopReservation.firstIndex(where: {$0.keyItemCarshop == self.buyItem.key}) {
                                appDelegate.listItemListCarshopReservation.remove(at: resIndex)
                            }
                            
                            if isSuccess {
                                self.allItems.detail[self.buyItemCount].statusBuy.enProceso = false
                                self.allItems.detail[self.buyItemCount].statusBuy.idTicket = bookingTicket.dsSalesId
                                self.allItems.detail[self.buyItemCount].statusBuy.statusVenta = BookingStatusCard.init(rawValue: bookingTicket.status)!
                                self.allItems.detail[self.buyItemCount].statusBuy.id = bookingTicket.idProducto
                                self.idTicketsArray.append(bookingTicket)
                                let indexPath = IndexPath(item: self.buyItemCount, section: 0)
//                                self.arryTickets.append("AM13187")//QUITAR
//                                self.arryTickets.append("AM13186")
                                if BookingStatusCard.init(rawValue: bookingTicket.status) == .approved || BookingStatusCard.init(rawValue: bookingTicket.status) == .inProcess || BookingStatusCard.init(rawValue: bookingTicket.status) == .paymentPlan{
                                    let quantity = (itemCS.first?.itemVisitantes.adulto ?? 0) + (itemCS.first?.itemVisitantes.ninio ?? 0)
                                    AnalyticsBR.shared.saveEventPurchase(id: itemCS.first?.itemProdProm.first?.key ?? "",
                                                                         name: itemCS.first?.itemProdProm.first?.descripcionEs.lowercased().capitalized ?? "",
                                                                         quantity: quantity,
                                                                         currency: Constants.CURR.current,
                                                                         value: item.price,
                                                                         coupon: item.promotionName,
                                                                         transactionID: bookingTicket.salesId,
                                                                         paymentType: itemCS.first?.itemCreditCard.banks.cardTypes.first?.cardTypeName ?? "")
                                    
                                    FirebaseBR.shared.deleteListCarshop(listItemCarShop : item, completion: {result   in
                                        self.listItemListCarshop.first?.detail[indexPath.row].status = 0
                                    self.arryTickets.append(bookingTicket.dsSalesId)
                                        DispatchQueue.main.async {
                                        self.tableProductos.reloadRows(at: [indexPath], with: .none)
                                        }
                                    })
                                }else{
                                    let indexPathInProcess = IndexPath(item: self.buyItemCount, section: 0)
                                    self.allItems.detail[self.buyItemCount].statusBuy.statusVenta = .declined
                                    self.allItems.detail[self.buyItemCount].statusBuy.enProceso = false
//                                    self.buyItem.statusBuy.statusVenta = .declined
//                                    self.buyItem.statusBuy.enProceso = false
                                    if bookingTicket.salesId > 0 {
                                        let reservation = ItemCarshopReservation()
                                        reservation.keyItemCarshop = self.allItems.detail[self.buyItemCount].key
                                        reservation.salesId = bookingTicket.salesId
                                        reservation.dsSalesId = bookingTicket.dsSalesId
                                        reservation.dsSaleIdInsure = bookingTicket.dsSaleIdInsure
                                        reservation.saleIdInsure = bookingTicket.saleIdInsure
                                        appDelegate.listItemListCarshopReservation.append(reservation)
                                    }
                                    
                                    DispatchQueue.main.async {
                                    self.tableProductos.reloadRows(at: [indexPathInProcess], with: .fade)
                                    }
                                }
                                if self.allItems.detail.count == (self.buyItemCount + 1) {
                                    self.idTicketsArray.removeAll()
                                    self.buyItemCount = 0
                                    for idTicket in self.arryTickets {
                                        self.ticketsSendUserOnlySave(ticket: idTicket , email: self.itemCarShoop.first?.itemVisitanteCompra.emailValueTextF ?? "")
                                    }
                                    
                                    self.configButtons(items : self.allItems.detail)
                                    self.arryTickets.removeAll()
                                }else{
                                    self.buyItemCount = self.buyItemCount + 1
                                    
                                    self.allItems.detail[self.buyItemCount].statusBuy.enProceso = true
                                    
                                    let indexPathInProcess = IndexPath(item: self.buyItemCount, section: 0)
                                    DispatchQueue.main.async {
                                    self.tableProductos.reloadRows(at: [indexPathInProcess], with: .none)
                                    }
                                    let itemSig = self.allItems.detail[self.buyItemCount]
                                    let itemCarShoopSig = self.itemCarShoop.filter({$0.keyItemEditCarShop == itemSig.products.first?.key})
                                    self.buyItemCS(item: itemSig, itemCS: itemCarShoopSig)
                                }
            //
                            }else{
                                let indexPathInProcess = IndexPath(item: self.buyItemCount, section: 0)
                                self.allItems.detail[self.buyItemCount].statusBuy.statusVenta = .declined
                                self.allItems.detail[self.buyItemCount].statusBuy.enProceso = false
                                
                                DispatchQueue.main.async {
                                self.tableProductos.reloadRows(at: [indexPathInProcess], with: .fade)
                                }
                                if self.allItems.detail.count == (self.buyItemCount + 1) {
                                    self.idTicketsArray.removeAll()
                                    self.buyItemCount = 0
                                    for idTicket in self.arryTickets {
                                        self.ticketsSendUserOnlySave(ticket: idTicket , email: self.itemCarShoop.first?.itemVisitanteCompra.emailValueTextF ?? "")
                                    }
                                    
                                    self.configButtons(items : self.allItems.detail)
                                    self.arryTickets.removeAll()
                                }else{
                                    self.buyItemCount = self.buyItemCount + 1
                                    
                                    self.allItems.detail[self.buyItemCount].statusBuy.enProceso = true
                                    
                                    let indexPathInProcess = IndexPath(item: self.buyItemCount, section: 0)
                                    DispatchQueue.main.async {
                                    self.tableProductos.reloadRows(at: [indexPathInProcess], with: .none)
                                    }
                                    let itemSig = self.allItems.detail[self.buyItemCount]
                                    let itemCarShoopSig = self.itemCarShoop.filter({$0.keyItemEditCarShop == itemSig.products.first?.key})
                                    self.buyItemCS(item: itemSig, itemCS: itemCarShoopSig)
                                }
                            }
                        })
                    }else{
                        let indexPathInProcess = IndexPath(item: self.buyItemCount, section: 0)
                        self.allItems.detail[self.buyItemCount].statusBuy.statusVenta = .declined
                        self.allItems.detail[self.buyItemCount].statusBuy.enProceso = false
//                        self.buyItem.statusBuy.statusVenta = .declined
//                        self.buyItem.statusBuy.enProceso = false
                        
                        //fallo validate carshop, entonces borramos el reintento
                        if let resIndex = appDelegate.listItemListCarshopReservation.firstIndex(where: {$0.keyItemCarshop == self.buyItem.key}) {
                            appDelegate.listItemListCarshopReservation.remove(at: resIndex)
                        }
                        
                        DispatchQueue.main.async {
                        self.tableProductos.reloadRows(at: [indexPathInProcess], with: .fade)
                        }
                        if self.allItems.detail.count == (self.buyItemCount + 1) {
                            self.idTicketsArray.removeAll()
                            self.buyItemCount = 0
                            for idTicket in self.arryTickets {
                                self.ticketsSendUserOnlySave(ticket: idTicket , email: self.itemCarShoop.first?.itemVisitanteCompra.emailValueTextF ?? "")
                            }
                            
                            self.configButtons(items : self.allItems.detail)
                            self.arryTickets.removeAll()
                        }else{
                            self.buyItemCount = self.buyItemCount + 1
                            
                            self.allItems.detail[self.buyItemCount].statusBuy.enProceso = true
                            
                            let indexPathInProcess = IndexPath(item: self.buyItemCount, section: 0)
                            DispatchQueue.main.async {
                            self.tableProductos.reloadRows(at: [indexPathInProcess], with: .none)
                            }
                            let itemSig = self.allItems.detail[self.buyItemCount]
                            let itemCarShoopSig = self.itemCarShoop.filter({$0.keyItemEditCarShop == itemSig.products.first?.key})
                            self.buyItemCS(item: itemSig, itemCS: itemCarShoopSig)
                        }
                    }
                }else{
                    let indexPathInProcess = IndexPath(item: self.buyItemCount, section: 0)
                    self.allItems.detail[self.buyItemCount].statusBuy.statusVenta = .declined
                    self.allItems.detail[self.buyItemCount].statusBuy.enProceso = false
//                    self.buyItem.statusBuy.statusVenta = .declined
//                    self.buyItem.statusBuy.enProceso = false
                    
                    //fallo validate carshop, entonces borramos el reintento
                    if let resIndex = appDelegate.listItemListCarshopReservation.firstIndex(where: {$0.keyItemCarshop == self.buyItem.key}) {
                        appDelegate.listItemListCarshopReservation.remove(at: resIndex)
                    }
                    
                    DispatchQueue.main.async {
                    self.tableProductos.reloadRows(at: [indexPathInProcess], with: .fade)
                    }
                    
                    if self.allItems.detail.count == (self.buyItemCount + 1) {
                        self.idTicketsArray.removeAll()
                        self.buyItemCount = 0
                        for idTicket in self.arryTickets {
                            self.ticketsSendUserOnlySave(ticket: idTicket , email: self.itemCarShoop.first?.itemVisitanteCompra.emailValueTextF ?? "")
                        }
                        
                        self.configButtons(items : self.allItems.detail)
                        self.arryTickets.removeAll()
                    }else{
                        self.buyItemCount = self.buyItemCount + 1
                        
                        self.allItems.detail[self.buyItemCount].statusBuy.enProceso = true
                        
                        let indexPathInProcess = IndexPath(item: self.buyItemCount, section: 0)
                        DispatchQueue.main.async {
                        self.tableProductos.reloadRows(at: [indexPathInProcess], with: .none)
                        }
                        let itemSig = self.allItems.detail[self.buyItemCount]
                        let itemCarShoopSig = self.itemCarShoop.filter({$0.keyItemEditCarShop == itemSig.products.first?.key})
                        self.buyItemCS(item: itemSig, itemCS: itemCarShoopSig)
                    }
                }
            })
        }else{
            FirebaseBR.shared.validateCarShop(itemsCarShoop: itemCS, buyItem: item, completion: { (isSuccess, status) in
                print(isSuccess)
                if isSuccess {
                    if status.statusValidateCarShopAllotmen.holdStatusAllotment == "AllotmentAvail" && status.statusValidateCarShopAllotmen.statusApplied{
                        FirebaseBR.shared.buyItem(itemsCarShoop: itemCS, buyItem: item, completion: { (isSuccess, bookingTicket) in //.buyItem(itemsCarShoop : itemCarShoop, buyItem : buyItem, completion: { (isSuccess, banks) in
                            
                            //eliminamos el reintento, si vuelve a fallar, la logica lo agregará de nuevo.
                            if let resIndex = appDelegate.listItemListCarshopReservation.firstIndex(where: {$0.keyItemCarshop == self.buyItem.key}) {
                                appDelegate.listItemListCarshopReservation.remove(at: resIndex)
                            }
                            
                            if isSuccess &&  bookingTicket.salesId != 0{
                                self.buyItem.statusBuy.enProceso = false
                                self.buyItem.statusBuy.idTicket = bookingTicket.dsSalesId
                                self.buyItem.statusBuy.statusVenta = BookingStatusCard.init(rawValue: bookingTicket.status)!
                                self.buyItem.statusBuy.id = bookingTicket.idProducto
                                if BookingStatusCard.init(rawValue: bookingTicket.status) == .approved || BookingStatusCard.init(rawValue: bookingTicket.status) == .inProcess || BookingStatusCard.init(rawValue: bookingTicket.status) == .paymentPlan{
                                    let quantity = (itemCS.first?.itemVisitantes.adulto ?? 0) + (itemCS.first?.itemVisitantes.ninio ?? 0)
                                    AnalyticsBR.shared.saveEventPurchase(id: itemCS.first?.itemProdProm.first?.key ?? "",
                                                                         name: itemCS.first?.itemProdProm.first?.descripcionEs.lowercased().capitalized ?? "",
                                                                         quantity: quantity,
                                                                         currency: Constants.CURR.current,
                                                                         value: item.price,
                                                                         coupon: item.promotionName,
                                                                         transactionID: bookingTicket.salesId,
                                                                         paymentType: itemCS.first?.itemCreditCard.banks.cardTypes.first?.cardTypeName ?? "")
                                    self.ticketsSendUserOnlySave(ticket: bookingTicket.dsSalesId , email: self.itemCarShoop.first?.itemVisitanteCompra.emailValueTextF ?? "")
                                    FirebaseBR.shared.deleteListCarshop(listItemCarShop : item, completion: {result   in
                                        let indexProd = self.listItemListCarshop.first?.detail.firstIndex(where: {$0.key == item.key})
                                        self.listItemListCarshop.first?.detail[indexProd ?? 0].status = 0
                                        let indexPath = IndexPath(item: 0, section: 0)
                                        DispatchQueue.main.async {
                                        self.tableProductos.reloadRows(at: [indexPath], with: .fade)
                                        }
                                        self.configButtons(items : [self.buyItem])
                                    })
                                    
//                                    FirebaseBR.shared.updateKeyCarShop(key: "status", value : 0, idDetail : item.key, idProduct : "", completion: { result in
//                                        let indexProd = self.listItemListCarshop.first?.detail.firstIndex(where: {$0.key == item.key})
//                                        self.listItemListCarshop.first?.detail[indexProd ?? 0].status = 0
//                                        let indexPath = IndexPath(item: 0, section: 0)
//                                        self.tableProductos.reloadRows(at: [indexPath], with: .fade)
//                                        self.configButtons(items : [self.buyItem])
//                                    })
                                }else{
//                                    let indexPath = IndexPath(item: 0, section: 0)
//                                    self.tableProductos.reloadRows(at: [indexPath], with: .fade)
//                                    self.configButtons(items : [self.buyItem])
                                    
                                    let indexPath = IndexPath(item: 0, section: 0)
                                    self.buyItem.statusBuy.statusVenta = .declined
                                    self.buyItem.statusBuy.enProceso = false
                                    
                                    if bookingTicket.salesId > 0 {
                                        let reservation = ItemCarshopReservation()
                                        reservation.keyItemCarshop = self.buyItem.key
                                        reservation.salesId = bookingTicket.salesId
                                        reservation.dsSalesId = bookingTicket.dsSalesId
                                        reservation.dsSaleIdInsure = bookingTicket.dsSaleIdInsure
                                        reservation.saleIdInsure = bookingTicket.saleIdInsure
                                        appDelegate.listItemListCarshopReservation.append(reservation)
                                    }
                                    
                                    DispatchQueue.main.async {
                                    self.tableProductos.reloadRows(at: [indexPath], with: .fade)
                                    }
                                    self.configButtons(items : [self.buyItem])
                                }
                                
                            }else{
//                                let indexPath = IndexPath(item: 0, section: 0)
//                                self.tableProductos.reloadRows(at: [indexPath], with: .fade)
//                                self.configButtons(items : [self.buyItem])
                                let indexPath = IndexPath(item: 0, section: 0)
                                self.buyItem.statusBuy.statusVenta = .declined
                                self.buyItem.statusBuy.enProceso = false
                                DispatchQueue.main.async {
                                self.tableProductos.reloadRows(at: [indexPath], with: .fade)
                                }
                                self.configButtons(items : [self.buyItem])
                            }
                        })
                    }else{
                        let indexPath = IndexPath(item: 0, section: 0)
                        self.buyItem.statusBuy.statusVenta = .errorCarShop
                        self.buyItem.statusBuy.enProceso = false
                        
                        //eliminamos por fallo de carshop
                        if let resIndex = appDelegate.listItemListCarshopReservation.firstIndex(where: {$0.keyItemCarshop == self.buyItem.key}) {
                            appDelegate.listItemListCarshopReservation.remove(at: resIndex)
                        }
                        
                        DispatchQueue.main.async {
                        self.tableProductos.reloadRows(at: [indexPath], with: .fade)
                        }
                        self.configButtons(items : [self.buyItem])
                    }
                }else{
                    self.buyItem.statusBuy.enProceso = false
                    self.buyItem.statusBuy.statusVenta = .errorCarShop
                    
                    //eliminamos por fallo de carshop
                    if let resIndex = appDelegate.listItemListCarshopReservation.firstIndex(where: {$0.keyItemCarshop == self.buyItem.key}) {
                        appDelegate.listItemListCarshopReservation.remove(at: resIndex)
                    }
                    
                    let aux = self.buyItem
                    let indexPath = IndexPath(item: 0, section: 0)
                    DispatchQueue.main.async {
                    self.tableProductos.reloadRows(at: [indexPath], with: .fade)
                    }
                    self.configButtons(items : [self.buyItem])
                }
            })
        }
    }
    
    func configButtons(items : [ItemCarshop]){
        if buyAll {
            let aux = items
            print(aux)
            
            let successItems = items.filter({ $0.statusBuy.statusVenta ==  BookingStatusCard.init(rawValue: 2) || $0.statusBuy.statusVenta == BookingStatusCard.init(rawValue: 5) || $0.statusBuy.statusVenta == BookingStatusCard.init(rawValue: 6)})
            let errorItems = items.filter({ $0.statusBuy.statusVenta !=  BookingStatusCard.init(rawValue: 2) && $0.statusBuy.statusVenta != BookingStatusCard.init(rawValue: 5) && $0.statusBuy.statusVenta != BookingStatusCard.init(rawValue: 6)})

            if successItems.count > 0 && errorItems.count > 0 {
                let button3 = UIButton(frame: CGRect(x: 15, y: 10, width: (sizeSidthScreen/2) - 22.5, height: 40))
                button3.backgroundColor = .clear
                button3.borderWidth = 1
                button3.borderColor = .white
                button3.cornerRadius = 10
                button3.setTitle("lbl_buy_try_again".getNameLabel(), for: .normal)
                button3.addTarget(self, action: #selector(reintentarGoDC), for: .touchUpInside)
                self.viewBotones.addSubview(button3)

                let button4 = UIButton(frame: CGRect(x: (sizeSidthScreen/2) + 7.5, y: 10, width: (sizeSidthScreen/2) - 22.5, height: 40))
                button4.backgroundColor = .clear
                button4.borderWidth = 1
                button4.borderColor = .white
                button4.cornerRadius = 10
                button4.setTitle("lbl_buy_try_go_tickets".getNameLabel(), for: .normal)
                button4.addTarget(self, action: #selector(irATickets), for: .touchUpInside)
                self.viewBotones.addSubview(button4)

            }else if successItems.count > 0 && errorItems.count == 0 {
                let button = UIButton(frame: CGRect(x: 15, y: 10, width: sizeSidthScreen - 30, height: 40))
                button.backgroundColor = .clear
                button.borderWidth = 1
                button.borderColor = .white
                button.cornerRadius = 10
                button.setTitle("lbl_buy_try_go_tickets".getNameLabel(), for: .normal)
                button.addTarget(self, action: #selector(irATickets), for: .touchUpInside)
                self.viewBotones.addSubview(button)
            }else if successItems.count == 0 && errorItems.count > 0 {
                let button2 = UIButton(frame: CGRect(x: 15, y: 10, width: sizeSidthScreen - 30, height: 40))
                button2.backgroundColor = .clear
                button2.borderWidth = 1
                button2.borderColor = .white
                button2.cornerRadius = 10
                button2.setTitle("lbl_buy_try_again".getNameLabel(), for: .normal)
                button2.addTarget(self, action: #selector(reintentarGoDC), for: .touchUpInside)
                self.viewBotones.addSubview(button2)
            }

        }else{
            let itemCS = items.first
            if BookingStatusCard.init(rawValue: itemCS?.statusBuy.statusVenta.rawValue ?? 9999) == .approved || BookingStatusCard.init(rawValue: itemCS?.statusBuy.statusVenta.rawValue ?? 9999) == .inProcess || BookingStatusCard.init(rawValue: itemCS?.statusBuy.statusVenta.rawValue ?? 9999) == .paymentPlan{
                let button = UIButton(frame: CGRect(x: 15, y: 10, width: sizeSidthScreen - 30, height: 40))
                button.backgroundColor = .clear
                button.borderWidth = 1
                button.borderColor = .white
                button.cornerRadius = 10
                button.setTitle("lbl_buy_try_go_tickets".getNameLabel(), for: .normal)
                button.addTarget(self, action: #selector(irATickets), for: .touchUpInside)
                self.viewBotones.addSubview(button)
            }else{

                let button2 = UIButton(frame: CGRect(x: 15, y: 10, width: sizeSidthScreen - 30, height: 40))
                button2.backgroundColor = .clear
                button2.borderWidth = 1
                button2.borderColor = .white
                button2.cornerRadius = 10
                button2.setTitle("lbl_buy_try_again".getNameLabel(), for: .normal)
                button2.addTarget(self, action: #selector(reintentarGoDC), for: .touchUpInside)
                self.viewBotones.addSubview(button2)
            }
        }
    }
    
    @objc func irATickets(sender: UIButton!) {
        appDelegate.goTicketsBuy = true
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func reintentarGoDC(sender: UIButton!) {
        for itemReintentar in allItems.detail {
            if itemReintentar.statusBuy.statusVenta != BookingStatusCard.init(rawValue: 2) || itemReintentar.statusBuy.statusVenta != BookingStatusCard.init(rawValue: 5) || itemReintentar.statusBuy.statusVenta != BookingStatusCard.init(rawValue: 6) {
                let indexReintentar = allItems.detail.index(where: { $0.statusBuy.idTicket == itemReintentar.statusBuy.idTicket })
                allItems.detail[indexReintentar ?? 0].statusBuy = StatusBuy()
            }
        }
        self.delegateFinalBuyStepReintentar?.reintentar()
        self.dismiss(animated: true)

    }
    
    func ticketsSendUserOnlySave(ticket: String, email: String){
        FirebaseDB.shared.saveTicket(cupon: ticket) { (success) in
            if success {
                print("Se guardó cupon \(ticket)")
            }
        }
    }
    
    
    func ticketsSendUser(ticket: String, email: String){
        
        FirebaseBR.shared.updateTicket(listTicketsUpdate: [ItemTicket()], ticket: ticket, email: email , completion: { listTickets, result   in
            if result == "success"{
            }
        })
    }
    
    func loadTickets(){
        FirebaseBR.shared.getTickets { (ticketListFB) in
                let ticketsList = appDelegate.listTickets
                if ticketsList.count > 0 {
                    FirebaseBR.shared.updateTickets(listTicketsUpdate: ticketListFB, completion: { (listTickets) in
                    })
                }else{
//                    LoadingView.shared.hideActivityIndicator(uiView: self.view)
                    
                }
        }
    }
}

extension AnimateBuyViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if buyAll {
            return allItems.detail.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let aux = indexPath
            let cell = tableProductos.dequeueReusableCell(withIdentifier: "cellItem", for: indexPath) as! ItemBuyTableViewCell
            if buyAll {
                cell.configLottie(itemCarshop : allItems.detail[indexPath.row], status: "play")
            }else{
                cell.configLottie(itemCarshop : buyItem, status: "play")
            }
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
