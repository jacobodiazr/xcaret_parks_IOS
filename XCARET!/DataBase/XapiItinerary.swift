//
//  XapiItinerary.swift
//  XCARET!
//
//  Created by Angelica Can on 08/10/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

open class XapiItinerary{
    static let shared = XapiItinerary()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var url_itinerary : String {
        get {
            let user = self.appDelegate.bookingConfig.api_itinerary_url
            return user!
        }
    }
    
    func getItineraryByCode(listTickets: [ItemTicket], completion: @escaping ([ItemTicket] , Bool) -> ()){
        var listTicketsSivex : [ItemTicket] = [ItemTicket]()
        let group = DispatchGroup() // create a group.
        for ticket in listTickets{
            //Iniciamos dispatch group
            group.enter()
            let wsName = "\(self.url_itinerary)Reservations/by-referencecode/en/MXN/\(ticket.barCode!)/false/false/1"
            //let wsName = "https://xapis-eks.xcaret.com/itinerary/Reservations/by-referencecode/en/MXN/PW1360529/false/false"
            var itemTicket = ItemTicket()
            
            //Llenamos el objeto de tickets a enviar
            var json = [String]()
            print(wsName)
            WebService.shared.execute(url: wsName, httpMethod: .get, params: nil) { completed, JSONResponse in
                if completed {
                    print(JSONResponse)
                    itemTicket = self.loadTicketItinerary(jResponse: JSONResponse, uidTicket: ticket.uid)
                    listTicketsSivex.append(itemTicket)
                }else{
                    print("No trajo el ticket \(String(describing: ticket.barCode))")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if listTicketsSivex.count > 0 {
                completion(listTicketsSivex, true)
            }else{
                completion(listTicketsSivex, false)
            }
        }
    }
    
    func loadTicketItinerary(jResponse: JSON, uidTicket: String) -> ItemTicket{
        let itemTicket = ItemTicket()
        var havePhotopass : Bool = false
        
        //Obtenemos los datos del ticket
        let json = jResponse
        itemTicket.uid = uidTicket
        itemTicket.barCode = json["ReservationNumber"].stringValue
        itemTicket.purchaseDate = json["SaleDate"].stringValue
        itemTicket.bookingReference = json["SaleId"].stringValue
        itemTicket.totalAmount = json["Amount"].stringValue
        itemTicket.purchaseDate = json["SaleDate"].stringValue
        if json["Traveler"].exists(){
            itemTicket.contactName = json["Traveler"]["FullName"].stringValue
            itemTicket.contactEmail = json["Traveler"]["Contac"]["Email"].stringValue
        }
        
        if json["Channel"].exists(){
            itemTicket.salesChannel = json["Channel"]["Name"].stringValue
        }
        
        if json["Status"].exists() {
            itemTicket.status = json["Status"]["Reservation"].stringValue
        }
        
        if json["Channel"].exists(){
            itemTicket.salesChannel = json["Channel"]["Name"].stringValue
            itemTicket.idCanalVenta = json["Channel"]["Id"].stringValue
        }
        // Verificamos si existe activides es un ticket de App o web
        if json["Services"]["Activities"].exists(){
            let jListActivities = json["Services"]["Activities"].arrayValue
            for jActivity in jListActivities {
                var itemNewProduct = ItemProduct()
                itemNewProduct = self.loadObjectItinerary(jActivity: jActivity, family: "entradas")
                //Asignamos los productos al ticket
                itemTicket.listProducts.append(itemNewProduct)
            }
            
            //Vamos por Photopass
            if json["Services"]["Packages"].exists(){
                havePhotopass = true
                let jListActivities = json["Services"]["Packages"].arrayValue
                for jActivity in jListActivities {
                    var itemNewProduct = ItemProduct()
                    itemNewProduct = self.loadObjectItinerary(jActivity: jActivity, family: "fotos")
                    //Asignamos los productos al ticket
                    itemTicket.listProducts.append(itemNewProduct)
                }
            }
            
            if json["Services"]["Insurances"].exists(){
                let jListActivities = json["Services"]["Insurances"].arrayValue
                for jActivity in jListActivities {
                    var itemNewProduct = ItemProduct()
                    itemNewProduct = self.loadObjectItinerary(jActivity: jActivity, family: "seguro")
                    //Asignamos los productos al ticket
                    itemTicket.listProducts.append(itemNewProduct)
                }
            }
            
        }else{
            if json["Services"]["Packages"].exists(){
                havePhotopass = true
                let jListActivities = json["Services"]["Packages"].arrayValue
                for jActivity in jListActivities {
                    var itemNewProduct = ItemProduct()
                    itemNewProduct = self.loadObjectItinerary(jActivity: jActivity, family: "fotos")
                    //Asignamos los productos al ticket
                    itemTicket.listProducts.append(itemNewProduct)
                }
            }
        }
        
        
        if havePhotopass {
            itemTicket.listProducts = self.hasPhotoPass(prodList: itemTicket.listProducts)
        }
        return itemTicket
    }
    
    func loadObjectItinerary(jActivity: JSON, family: String) -> ItemProduct{
        var codeUn = 0
        var codePark: ParkId = .newPark
        
        let itemNewProduct = ItemProduct()
        let claveProducto = jActivity["ProductCode"].stringValue
        itemNewProduct.productCode = claveProducto
        itemNewProduct.familyProducto = family
        itemNewProduct.productName = jActivity["ProductName"].stringValue
        itemNewProduct.visitDate = jActivity["VisitDate"].stringValue
        //PEDIENTE HABILITAR AYB
        if family == "entradas" || family == "tours" {
            itemNewProduct.hasAYB = self.hasAyB(dsClave: claveProducto)
            if jActivity["UnitBusines"].exists(){
                codeUn = jActivity["UnitBusines"]["Id"].intValue
            }
        }else if family == "fotos"{
            if jActivity["Details"].exists(){
                for(key, subJson) in jActivity["Details"]{
                    codeUn = subJson["UnitBusines"]["Id"].intValue
                }
            }
        }

        if let codePark: ParkId = ParkId.init(initString: codeUn){
            itemNewProduct.un = codePark.rawValue
        }
        
        if jActivity["Pax"].exists(){
            itemNewProduct.adults = jActivity["Pax"]["Adults"].intValue
            itemNewProduct.childrens = jActivity["Pax"]["Children"].intValue
            itemNewProduct.infants = jActivity["Pax"]["Infant"].intValue
        }
        
        if jActivity["Operated"].exists(){
            itemNewProduct.feOperacion =  jActivity["Operated"]["Date"].stringValue
        }
        
        if jActivity["PickUp"].exists(){
            itemNewProduct.hasPickup = true
            itemNewProduct.timePickup = jActivity["PickUp"]["Time"].stringValue
            itemNewProduct.locationPickup = jActivity["PickUp"]["Hotel"]["Name"].stringValue
        }

        if jActivity["Promotion"].exists(){
            let itemPromotion = ItemPromocion()
            itemPromotion.dsCodigoPromocion = jActivity["Promotion"]["Code"].stringValue
            itemPromotion.dsNombrePromocion = jActivity["Promotion"]["Description"].stringValue
            itemPromotion.dsURLImagenCupon = jActivity["Promotion"]["UrlAdditionalBenefit"].stringValue
            itemNewProduct.promocion = itemPromotion
        }
        return itemNewProduct
    }
    
    func hasAyB(dsClave: String) -> Bool{
        var haveAyB = false
        _ = self.appDelegate.listCodeAyB.filter { (itemCode) -> Bool in
            if itemCode.code.contains(dsClave.trimmingCharacters(in: .whitespacesAndNewlines)){
                print("Si tiene comida Clave : \(dsClave)")
                haveAyB = true
                return true
            }else{
                print("No tiene comida Clave : \(dsClave)")
                return false
            }
        }
        return haveAyB
    }
    
    
    func hasPhotoPass(prodList: [ItemProduct])-> [ItemProduct] {
        for itemProd in prodList{
            if itemProd.familyProducto == "fotos"{
                prodList.filter({$0.un == itemProd.un && $0.familyProducto != "fotos"}).first?.hasPhotopass = true
            }
        }
        
        return prodList
    }
}
