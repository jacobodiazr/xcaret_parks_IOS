//
//  ItemTicketsPark.swift
//  XCARET!
//
//  Created by Angelica Can on 8/23/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import Foundation
import SwiftyJSON

open class ItemTicket{
    var uid : String
    var bookingReference: String!
    var barCode: String!
    var status: String!
    var enabled: Int!
    var purchaseDate: String!
    var registerDate: String!
    var dueDate: String!
    var totalAmount: String!
    var discount: String!
    var currency: String!
    var platform : String!
    var version : String!
    var contactName: String!
    var contactEmail: String!
    var salesChannel: String!
    var idCanalVenta : String!
    var listProducts : [ItemProduct]
    var allVisit: Bool!
    var promocion : ItemPromocion!
    
    init() {
        self.uid = ""
        self.bookingReference = ""
        self.barCode = ""
        self.status = ""
        self.enabled = 1
        self.purchaseDate = ""
        self.registerDate = ""
        self.dueDate = ""
        self.totalAmount = ""
        self.discount = ""
        self.currency = ""
        self.contactName = ""
        self.contactEmail = ""
        self.salesChannel = ""
        self.idCanalVenta = ""
        self.listProducts = [ItemProduct]()
        self.allVisit = true
        self.promocion = ItemPromocion()
    }
    
    init(key: String, dictionary : Dictionary<String, AnyObject>){
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.bookingReference = json["bookingReference"].stringValue
        self.barCode = json["barCode"].stringValue
        self.status = json["status"].stringValue
        self.enabled = json["enabled"].intValue
        self.purchaseDate = json["purchaseDate"].stringValue
        self.registerDate = json["registerDate"].stringValue
        self.dueDate = json["dueDate"].stringValue
        self.totalAmount = json["totalAmount"].stringValue
        self.discount = json["discount"].stringValue
        self.currency = json["currency"].stringValue
        self.contactName = json["contactName"].stringValue
        self.contactEmail = json["contactEmail"].stringValue
        self.salesChannel = json["salesChannel"].stringValue
        self.idCanalVenta = json["idCanalVenta"].stringValue
        self.allVisit = true
        self.listProducts = [ItemProduct]()
        self.promocion = ItemPromocion()
        
        let subJsonProm = json["Promocion"]
        if subJsonProm.count > 0 {
            let itemProm : ItemPromocion = ItemPromocion()
            itemProm.dsCodigoPromocion = subJsonProm["dsCodigoPromocion"].stringValue
            itemProm.dsNombrePromocion = subJsonProm["dsNombrePromocion"].stringValue
            itemProm.dsURLImagenCupon = subJsonProm["dsURLImagenCupon"].stringValue
            self.promocion = itemProm

        }
        
        for(key, subJson) in json["products"]{
            let itemProd : ItemProduct = ItemProduct()
            itemProd.uid = key
            itemProd.adults =  subJson["adults"].intValue
            itemProd.childrens =  subJson["childrens"].intValue
            itemProd.infants = subJson["infants"].intValue
            itemProd.visitDate = subJson["visitDate"].stringValue
            itemProd.dueDate = subJson["dueDate"].stringValue
            itemProd.feOperacion = subJson["feOperacion"].stringValue
            itemProd.paxes = subJson["paxes"].stringValue
            itemProd.productCode = subJson["productCode"].stringValue
            itemProd.productName = subJson["productName"].stringValue
            itemProd.hasPickup = subJson["hasPickup"].boolValue
            itemProd.hasAYB =  subJson["hasAYB"].boolValue
            itemProd.hasPhotopass =  subJson["hasPhotopass"].boolValue
            itemProd.timePickup = subJson["timePickup"].stringValue
            itemProd.locationPickup = subJson["locationPickup"].stringValue
            itemProd.un = subJson["un"].stringValue
            itemProd.familyProducto = subJson["familyProducto"].stringValue
            itemProd.orderSort = subJson["order"].intValue
            itemProd.listComponents = [ItemComponent]()
            
            for(key, subCompJson) in subJson["components"]{
                let itemComp : ItemComponent = ItemComponent()
                itemComp.uid = key
                itemComp.visitDate = subCompJson["visitDate"].stringValue
                itemComp.dueDate = subCompJson["dueDate"].stringValue
                itemComp.feOperacion = subCompJson["feOperacion"].stringValue
                itemComp.productCode = subCompJson["productCode"].stringValue
                itemComp.productName = subCompJson["productName"].stringValue
                itemComp.hasPickup = subCompJson["hasPickup"].boolValue
                itemComp.hasAYB =  subCompJson["hasAYB"].boolValue
                itemComp.hasPhotopass =  subCompJson["hasPhotopass"].boolValue
                itemComp.timePickup = subCompJson["timePickup"].stringValue
                itemComp.locationPickup = subCompJson["locationPickup"].stringValue
                itemComp.un = subCompJson["un"].stringValue
                itemComp.familyProducto = subCompJson["familyProducto"].stringValue
                itemProd.listComponents.append(itemComp)
            }
            listProducts.append(itemProd)
        }
    }
}


open class ItemPromocion{
    var dsCodigoPromocion: String!
    var dsNombrePromocion: String!
    var dsURLImagenCupon: String!
    
    init() {
        self.dsCodigoPromocion = ""
        self.dsNombrePromocion = ""
        self.dsURLImagenCupon = ""
        
    }
}

open class ItemProduct {
    var uid: String
    var adults : Int
    var childrens : Int
    var infants : Int
    var visitDate: String!
    var dueDate: String!
    var feOperacion : String!
    var paxes : String!
    var productCode: String!
    var productName: String!
    var hasAYB: Bool!
    var hasPhotopass: Bool!
    var hasPickup: Bool!
    var timePickup: String!
    var locationPickup: String!
    var un : String!
    var familyProducto : String!
    var listComponents : [ItemComponent]!
    var headerTable : Bool!
    var orderSort : Int!
    var promocion : ItemPromocion!
    var detailComponent : Bool {
        get{
            if familyProducto.lowercased().contains("entradas") ||
                familyProducto.lowercased().contains("tours") {
                return true
            }else{
                return false
            }
        }
    }
    
    
    init() {
        self.uid = ""
        self.adults = 0
        self.childrens = 0
        self.infants = 0
        self.visitDate = ""
        self.dueDate = ""
        self.feOperacion = ""
        self.paxes = ""
        self.productCode = ""
        self.productName = ""
        self.hasPickup = false
        self.hasAYB = false
        self.hasPhotopass = false
        self.timePickup = ""
        self.locationPickup = ""
        self.un = ""
        self.familyProducto = ""
        self.headerTable = true
        self.orderSort = 1
        self.listComponents = [ItemComponent]()
        self.promocion = ItemPromocion()
    }
    
    init(key: String, dictionary : Dictionary<String, AnyObject>){
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.adults =  json["adults"].intValue
        self.childrens =  json["childrens"].intValue
        self.infants = json["infants"].intValue
        self.visitDate = json["visitDate"].stringValue
        self.dueDate = json["dueDate"].stringValue
        self.feOperacion = json["feOperacion"].stringValue
        self.paxes = json["paxes"].stringValue
        self.productCode = json["productCode"].stringValue
        self.productName = json["productName"].stringValue
        self.hasPickup = json["hasPickup"].boolValue
        self.hasAYB =  json["hasAYB"].boolValue
        self.hasPhotopass =  json["hasPhotopass"].boolValue
        self.timePickup = json["timePickup"].stringValue
        self.locationPickup = json["locationPickup"].stringValue
        self.orderSort = json["order"].intValue
        self.un = json["un"].stringValue
        self.familyProducto = json["familyProducto"].stringValue
        self.listComponents = [ItemComponent]()
        for(key, subCompJson) in json["components"]{
            let itemComp : ItemComponent = ItemComponent()
            itemComp.uid = key
            itemComp.visitDate = subCompJson["visitDate"].stringValue
            itemComp.dueDate = subCompJson["dueDate"].stringValue
            itemComp.feOperacion = subCompJson["feOperacion"].stringValue
            itemComp.productCode = subCompJson["productCode"].stringValue
            itemComp.productName = subCompJson["productName"].stringValue
            itemComp.hasPickup = subCompJson["hasPickup"].boolValue
            itemComp.hasAYB =  subCompJson["hasAYB"].boolValue
            itemComp.hasPhotopass =  subCompJson["hasPhotopass"].boolValue
            itemComp.timePickup = subCompJson["timePickup"].stringValue
            itemComp.locationPickup = subCompJson["locationPickup"].stringValue
            itemComp.un = subCompJson["un"].stringValue
            itemComp.familyProducto = subCompJson["familyProducto"].stringValue
            listComponents.append(itemComp)
        }
    }
    
}

open class ItemComponent {
    var uid: String
    var adults : Int
    var childrens : Int
    var infants : Int
    var visitDate: String!
    var dueDate: String!
    var feOperacion : String!
    var productCode: String!
    var productName: String!
    var hasAYB: Bool!
    var hasPhotopass: Bool!
    var hasPickup: Bool!
    var timePickup: String!
    var locationPickup: String!
    var un : String!
    var familyProducto : String!
    var detailComponent : Bool
    var itemPromotion : ItemPromocion!
    
    init() {
        self.uid = ""
        self.adults = 0
        self.childrens = 0
        self.infants = 0
        self.visitDate = ""
        self.dueDate = ""
        self.feOperacion = ""
        self.productCode = ""
        self.productName = ""
        self.hasPickup = false
        self.hasAYB = false
        self.hasPhotopass = false
        self.timePickup = ""
        self.locationPickup = ""
        self.un = ""
        self.familyProducto = ""
        self.detailComponent = true
        self.itemPromotion = ItemPromocion()
    }
    
    init(key: String, dictionary : Dictionary<String, AnyObject>){
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.visitDate = json["visitDate"].stringValue
        self.dueDate = json["dueDate"].stringValue
        self.feOperacion = json["feOperacion"].stringValue
        self.productCode = json["productCode"].stringValue
        self.productName = json["productName"].stringValue
        self.hasPickup = json["hasPickup"].boolValue
        self.hasAYB =  json["hasAYB"].boolValue
        self.hasPhotopass =  json["hasPhotopass"].boolValue
        self.timePickup = json["timePickup"].stringValue
        self.locationPickup = json["locationPickup"].stringValue
        self.un = json["un"].stringValue
        self.familyProducto = json["familyProducto"].stringValue
        self.adults = 0
        self.childrens = 0
        self.infants = 0
        self.detailComponent = true
        //Añadimos Promo si tiene
        if json["Promocion"].exists(){
            let jsonPromotion = json["Promocion"]
            self.itemPromotion.dsCodigoPromocion = jsonPromotion["dsCodigoPromocion"].stringValue
            self.itemPromotion.dsNombrePromocion = jsonPromotion["dsNombrePromocion"].stringValue
            self.itemPromotion.dsURLImagenCupon = jsonPromotion["dsURLImagenCupon"].stringValue
        }else{
            self.itemPromotion = ItemPromocion()
        }
    }
}

open class ItemDetInfoTicket{
    var title: String!
    var desc : String!
    var typeInfo: String!
    
    init() {
        self.title = ""
        self.desc = ""
        self.typeInfo = "DEF" // PROMO // INFO
    }
    
    init(_title: String, _desc: String, _typeIfo: String) {
        self.title = _title
        self.desc = _desc
        self.typeInfo = _typeIfo
    }
}

open class ItemProductAyB{
    var uid: String!
    var code: String!
    var description : String!
    var status : Bool!
    
    init(key: String, dictionary : Dictionary<String, AnyObject>){
    let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.code = json["code"].stringValue
        self.description = json["description"].stringValue
        self.status = json["status"].boolValue
    }
}
