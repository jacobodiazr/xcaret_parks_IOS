//
//  ProtocolsParks.swift
//  XCARET!
//
//  Created by Angelica Can on 12/21/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import Foundation
import UIKit

protocol ManageControllersDelegate : class {
    func sendDetailActivity(activity: ItemActivity, idEvent: String)
    func sendDetailAdmission(admission: ItemAdmission)
}

protocol ManageControllersDelegateHome : class {
    func sendItemPark(itemPark: ItemPark)
}

protocol ManageUpdateOpcPromDelegate : class {
    func sendItemOpcProm(select : ItemsCatopcprom)
    func sendPopUpHome(typePopUp : String)
}

protocol ManageUpdatePromDelegate : class {
    func sendProm(itemProm : [ItemProdProm])
}

protocol ManageBuyPromDelegate : class {
    func sendBuyProm(itemProm : [ItemProdProm])
    func sendPreBuyProm(itemProm : [ItemProdProm])
    func sendPreBuyPromBook()
    func addCar(itemProm : [ItemProdProm])
}

protocol ManageButtonBuyProm : class {
    func sendPromBuy(itemProm : [ItemProdProm])
}

protocol ManageControllersDelegateXafety : class {
    func callWebXafety()
}

protocol ManageControllersDelegateXO : class {
    func sendDetailBasicActivity(activity: ItemEvents, idEvent: String)
}

protocol UpdateTableDelegate: class{
    func reloadTblView()
}

protocol ChangeHeightTableView: class {
    func changeHeightRow(newHeight: CGFloat)
}

protocol GoRouteMapDelegate : class {
    func goToMap(activity: ItemActivity)
}

protocol GoRouteServDelegate : class {
    func goToServ(service: ItemServicesLocation)
}

protocol GoDetailActDelegate: class {
    func gotoDetail(activity: ItemActivity)
}

protocol GoRoadDelegate : class {
    func goToRoadActivities(itemSelected: Int, listActivities: [ItemActivity])
}

protocol GoBookingXVDelegate: class{
    func goBookingXV(typeItemBuyXV: String)
}

protocol GoDetailComponent : class{
    func goComponent(sender: ButtonDetComponent)
}

protocol GoMenuTickets : class {
    func goMenuTickets()
}

protocol GoViewInAap : class {
    func goViewInAap(url: String)
}

protocol GoToPromBar : class {
    func goToPromBar(item: Int)
}

protocol TicketsGoToBuy : class {
    func ticketsGoToBuy()
}

protocol ManageCitizador : class {
    func cerrarCotizador()
    func fechaVisitas()
    func visitantes(item : ItemDiaCalendario)
    func complementos(itemVisitantes : ItemVisitantes, productAllotment : Bool, rateKey : String)
    func goCarrito(itemCarShoop: ItemCarShoop)
    func emptyError(type : String)
}

protocol ManageLocation : class{
    func itemLocation(itemLocation: ItemLocation)
}

protocol GoBooking: class{
    func goBooking(buyItem: ItemCarshop, dataCarShop : [ItemCarShoop])
    func goBookingAll()
    func goTermsBooking(buyItem : ItemCarshop, dataCarShop : [ItemCarShoop])
    func deleteItem(deleteItem : ItemCarshop)
    func editItem(editItem : ItemCarshop, IdItem : String)
    func closeItem(closeItem : Bool, item : ItemCarshop)
    func AddIKE(prodAddIKE : ItemCarshop, status: Bool)
    func infoIKE()
}

protocol GoBookingInfo: class{
    func editItemInfo(IdItem : String)
}

protocol DataFormBuy: class{
    func dataFormBuyTitle(title : String, itemTitle : ItemLangTitle)
    func dataFormBuyPais(pais : String, itemPais : ItemLangCountry)
    func dataFormBuyEstado(estado : String, itemEstado : ItemStates)
    
}

protocol InputDelegate: class{
    func focusIn(index: Int)
    func enterTextEvent(text: String, kind: InputType)
    func focusInNext(index: Int)
    func focusThePrevious(index: Int)
    func finalizeCapturing()
    func cancel()
}

protocol FinalBuyStepReintentar: class{
    func reintentar()
}

protocol FinalBuyStepGoTicket: class{
    func goTicket()
}

protocol ChangeCurrencyShop: class{
    func changeCurrencyShop(codeCurrency : String)
}

protocol ChangeCurrencyShopBack: class{
    func changeCurrencyShopBack()
}




