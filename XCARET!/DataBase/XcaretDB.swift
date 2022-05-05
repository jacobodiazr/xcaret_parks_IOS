//
//  XcaretDB.swift
//  XCARET!
//
//  Created by Angelica Can on 11/12/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

open class XcaretDB{
    
    static let shared = XcaretDB()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var urlAPI : String {
        get {
            
            return self.appDelegate.enviromentProduction == TypeEnviroment.production
                ? "https://www.xperienciasxcaret.net/wapiotas/api/"
                : "https://www.xperienciasxcaret.net/wapiotas/api/"
        }
    }
    
    var apiKey : String {
        get {
            return self.appDelegate.enviromentProduction == TypeEnviroment.production
                ? "eWM2c0dUd2J0aHBWQ3BmVHRsTFBHWmt6RmpvOTlXNlhHbytmYkVxSXpOYlVOVXRDNlh3TG1PdC9KRWhmUzZkeg=="
                : "NG9WMnBzeXpOeUVlZEkvbjA3SlNqa2NuWlhVTENtR3FvR0ZGNWhydWdscFpYMkFQb1pLeXBDWUoxQ0dBSXJMTQ=="
        }
    }
    
    var urlSivex: String{
        get {
            let url = self.appDelegate.bookingConfig.sivex_url!
            return url//"http://prueba.xperienciasxcaret.net/inventoryservice/"//url!
        }
    }
    
    var sivexUser : String {
        get {
            let user = self.appDelegate.bookingConfig.sivex_user
            return user!
        }
    }
    
    var sivexPass : String {
        get {
            let user = self.appDelegate.bookingConfig.sivex_pass
            return user!
        }
    }
    
    var SFLogin : String {
        get {
            let urlSF = appDelegate.bookingConfig.profile_url
            return urlSF!
        }
    }
    
    var cognito_url : String {
        get {
            let cognito_url = appDelegate.bookingConfig.cognito_url
            return cognito_url!
        }
    }
    
    var urlProdCalendar : String {
        get {
//            return self.appDelegate.enviromentProduction == TypeEnviroment.production
//                ? "https://api-activities-pruebas.xperienciasxcaret.mx"
//                : "https://api-activities-pruebas.xperienciasxcaret.mx"
            let api_activities_url = appDelegate.bookingConfig.api_activities_url
            return api_activities_url!
        }
    }
    
    var urlBanksInfo : String {
        get {
//            return self.appDelegate.enviromentProduction == TypeEnviroment.production
//                ? "https://qa.apimop.xcaret.com"
//                : "https://qa.apimop.xcaret.com"
            let api_mop_url = appDelegate.bookingConfig.api_mop_url
            return api_mop_url!
        }
    }
    
    var urlBanksInfo2 : String {
        get {
            let api_mop_url = appDelegate.bookingConfig.bin_info_url
            return api_mop_url!
        }
    }
    
    
    var urlValidateCarShop : String {
        get {
            let api_mop_url = appDelegate.bookingConfig.api_carshop_url
            return api_mop_url!
        }
    }
    
    var urlBooking : String {
        get {
            if self.appDelegate.enviromentProduction == TypeEnviroment.production {
                return appDelegate.bookingConfig.sf_booking_engine!
            }else{
                return self.appDelegate.bookingXwitch ? appDelegate.bookingConfig.sf_booking_engine! : appDelegate.bookingConfig.api_mop_url!//"http://api-book-engine-prueba.xperienciasxcaret.mx"
            }
        }
    }
    
    func getVersionAppStore(url: String, completion: @escaping (String) -> ()){
        WebService.shared.execute(url: url, httpMethod: .get, params: nil) { (success, json) in
            if (success) {
                print(json)
                let result = json["results"].arrayValue
                var versionStore = ""
                for item in result {
                    if let dic = item.dictionary {
                        versionStore = dic["version"]!.stringValue
                        print(versionStore)
                    }
                }
                completion(versionStore)
            }else{
                completion("")
            }
        }
    }
    
    func getCountries(completion: @escaping ([Country]) -> ()){
        var countriesList : [Country] = [Country]()
        let wsName = self.urlAPI + "support/country"
        let headers = ["Accept": "application/json"]
        let requestType : Parameters = [
            "requestType" : "CountryRequest",
            "data" : [
                "ApiKey" : self.apiKey,
                "idIdioma" : Constants.LANG.current == "es" ? 1 : 2 
            ]
        ]
        
        WebService.shared.executeWith(url: wsName, httpMethod: .post, params: requestType, headers: headers) { (success, json) in
            if (success) {
                print(json)
                if json["data"].exists() {
                    let dataCountries = json["data"].arrayValue
                    for item in dataCountries {
                        let country = Country()
                        country.id = item["ID"].exists() ? item["ID"].int! : 0
                        country.name = item["Name"].exists() ? item["Name"].string! : ""
                        countriesList.append(country)
                    }
                }
                completion(countriesList)
            }
        }
    }
    
    
    
    
    
    func getTicketsSivex2(listTickets: [ItemTicket]?, completion: @escaping ([ItemTicket], Bool) -> ()){
        
        let wsName = self.urlSivex + "mobapp/ventas"
        var listTicketsSivex : [ItemTicket] = [ItemTicket]()
        //Llenamos el objeto de tickets a enviar
        var json = [String]()
        for item in listTickets! {
            if !json.contains(item.barCode){
                json.append(item.barCode)
            }
        }
        //let jsonData = try? JSONSerialization.data(withJSONObject: json)
        //print(jsonData)
//        json.append("PW2003165")
        print(wsName)
        
//        let headers = ["Accept": "application/json", "Authorization": "Basic dWFwcG1vYmlsZTplWHBBcHAyMDE5"]
        print(self.sivexUser + " --- " + self.sivexPass)
        
        WebService.shared.execute(url: wsName, params: json as AnyObject) { (success, json) in
            if (success) {
                print(json)
                if json["Ventas"].exists() {
                    let dataTickets = json["Ventas"].arrayValue
                    for item in dataTickets {
                        let itemTicket = ItemTicket()
                        var itemPhotoPass = ItemProduct()
                        
                        itemTicket.barCode = item["dsClaveVenta"].stringValue
                        itemTicket.purchaseDate = item["feVenta"].stringValue
                        itemTicket.registerDate = item["feAlta"].stringValue
                        itemTicket.currency = item["moneda"].stringValue
                        itemTicket.totalAmount = item["mnMontoTotal"].stringValue
                        itemTicket.discount = item["mnDescuento"].stringValue
                        itemTicket.bookingReference = item["idVenta"].stringValue
                        itemTicket.status = item["dsEstatusVenta"].stringValue
                        itemTicket.dueDate = item["feCaducidad"].stringValue
                        itemTicket.totalAmount = item["mnMontoTotal"].stringValue
                        itemTicket.discount = item["mnDescuento"].stringValue
                        itemTicket.currency = item["moneda"].stringValue
                        itemTicket.salesChannel = item["dsCanalVenta"].stringValue
                        itemTicket.listProducts = [ItemProduct]()
                        //Obtenemos datos de contacto
                        if item["contacto"].exists(){
                            let dataContact = item["contacto"].dictionary
                            itemTicket.contactName = dataContact!["dsNombre"]?.stringValue
                            itemTicket.contactEmail = dataContact!["dsCorreoElectronico"]?.stringValue
                        }
                        
                        //Obtenemos los productos
                        if item["productos"].exists(){
                            let dataProducts = item["productos"].arrayValue
                            var listProducts = [ItemProduct]()
                            for itemProd in dataProducts {
                                //Instancia de un productos
                                let itemNewProduct = ItemProduct()
                                
                                //Llenamos los datos
                                let claveProducto = itemProd["dsClave"].stringValue
                                let familyProducto = itemProd["familyProducto"].stringValue.lowercased()
                                itemNewProduct.productCode = claveProducto
                                itemNewProduct.familyProducto = familyProducto
                                itemNewProduct.hasAYB = self.hasAyB(dsClave: claveProducto)
                                
                                //Obtenemos los tipos de cliente
                                let dataClients = itemProd["tipoCliente"].arrayValue
                                for itemClient in dataClients {
                                    let typeClient = itemClient["dsTipoCliente"].stringValue
                                    let pax = itemClient["noPax"].intValue
                                    if typeClient == "Adulto"{
                                        itemNewProduct.adults = pax
                                    }else if typeClient == "Menor" {
                                        itemNewProduct.childrens = pax
                                    } else if typeClient == "Infante"{
                                        itemNewProduct.infants = pax
                                    }
                                }
                                
                                //Obtenemos la info de producto
                                itemNewProduct.visitDate = itemProd["feVisita"].stringValue
                                itemNewProduct.dueDate =  itemProd["feVisitaLimite"].stringValue
                                itemNewProduct.feOperacion =  itemProd["feOperacion"].stringValue
                                itemNewProduct.paxes = itemProd["Paxes"].string
                                itemNewProduct.productName = itemProd["dsProducto"].stringValue
                                itemNewProduct.un = itemProd["dsClaveUnidadNegocio"].stringValue
                                //Informacion de traslado
                                itemNewProduct.hasPickup = itemProd["cnPickup"].boolValue
                                itemNewProduct.timePickup = itemProd["hrPickup"].stringValue
                                itemNewProduct.locationPickup = itemProd["dsNombreHotel"].stringValue
                                
                                //Recorremos la lista de componentes
                                if itemProd["componentes"].exists(){
                                    let dataComponents = itemProd["componentes"].arrayValue
                                    var listComponents = [ItemComponent]()
                                    for itemComponent in dataComponents {
                                        let itemNewComponent = ItemComponent()
                                        itemNewComponent.visitDate = itemComponent["feVisita"].stringValue
                                        itemNewComponent.dueDate = itemComponent["feVisitaLimite"].stringValue
                                        itemNewComponent.feOperacion = itemComponent["feOperacion"].stringValue
                                        itemNewComponent.productCode = itemComponent["dsClave"].stringValue
                                        itemNewComponent.productName = itemComponent["dsProducto"].stringValue
                                        itemNewComponent.hasPickup = itemComponent["cnPickup"].boolValue
                                        //itemNewComponent.hasAYB = itemComponent["familyProducto"].boolValue
                                        itemNewComponent.hasPhotopass = itemComponent[""].boolValue
                                        itemNewComponent.timePickup = itemComponent["hrPickup"].stringValue
                                        itemNewComponent.locationPickup = itemComponent["dsNombreHotel"].stringValue
                                        itemNewComponent.un = itemComponent["dsClaveUnidadNegocio"].stringValue
                                        itemNewComponent.familyProducto = itemComponent["familyProducto"].stringValue
                                        
                                        let claveComponente = itemComponent["dsClave"].stringValue
                                        itemNewComponent.hasAYB = self.hasAyB(dsClave: claveComponente)
                                        listComponents.append(itemNewComponent)
                                    }
                                    if listComponents.count > 0 {
                                        itemNewProduct.listComponents = listComponents
                                    }
                                }
                                
                                //Buscamos si tiene photopass
                                if familyProducto.contains("fotos" ){
                                    itemPhotoPass = itemNewProduct
                                }
                                
                                listProducts.append(itemNewProduct)
                            }
                            
                            listProducts = self.hasPhotoPass(productPhoto: itemPhotoPass, prodList: listProducts)
                            //Asignamos la lista de productos
                            itemTicket.listProducts = listProducts
                        }
                        
                        //asignamos el ticketuid
                        if let uidItem = listTickets!.first(where: {$0.barCode == itemTicket.barCode}){
                            itemTicket.uid = uidItem.uid
                            listTicketsSivex.append(itemTicket)
                        }
                        
                    }
                    completion(listTicketsSivex, true)
                }else{
                    completion(listTicketsSivex, false)
                }
            }
        }
    }
    
    
    
    
    
    
    func getTicketsSivex(listTickets: [ItemTicket]?, ticket: String = "", completion: @escaping ([ItemTicket], Bool) -> ()){
//        https://prueba.xperienciasxcaret.net/xcaretapp/mobapp/ventas
        let wsName = self.urlSivex + "mobapp/ventas"
        var listTicketsSivex : [ItemTicket] = [ItemTicket]()
        //Llenamos el objeto de tickets a enviar
        var json = [String]()
        if ticket != ""{
            json.append(ticket)
        }else{
            for item in listTickets! {
                if !json.contains(item.barCode){
                    json.append(item.barCode)
                }
            }
        }
        
        
        //let jsonData = try? JSONSerialization.data(withJSONObject: json)
        //print(jsonData)
        print(wsName)
        print(self.sivexUser + " --- " + self.sivexPass)
        WebService.shared.executeWith(url: wsName, params: json as AnyObject, user: self.sivexUser, pass: self.sivexPass) { (success, json) in
            if (success) {
                print(json)
                if json["Ventas"].exists() {
                    
                    let dataTickets = json["Ventas"].arrayValue
                    for item in dataTickets {
                        let itemTicket = ItemTicket()
                        var itemPhotoPass = ItemProduct()
                        var promocion = ItemProduct()
                        
                        itemTicket.barCode = item["dsClaveVenta"].stringValue
                        itemTicket.purchaseDate = item["feVenta"].stringValue
                        itemTicket.registerDate = item["feAlta"].stringValue
                        itemTicket.currency = item["moneda"].stringValue
                        itemTicket.totalAmount = item["mnMontoTotal"].stringValue
                        itemTicket.discount = item["mnDescuento"].stringValue
                        itemTicket.bookingReference = item["idVenta"].stringValue
                        itemTicket.status = item["dsEstatusVenta"].stringValue
                        itemTicket.dueDate = item["feCaducidad"].stringValue
                        itemTicket.salesChannel = item["dsCanalVenta"].stringValue
                        itemTicket.idCanalVenta = item["idCanalVenta"].stringValue
                        itemTicket.listProducts = [ItemProduct]()
                        
                        
                        //Obtenemos datos de contacto
                        if item["contacto"].exists(){
                            let dataContact = item["contacto"].dictionary
                            itemTicket.contactName = dataContact!["dsNombre"]?.stringValue
                            itemTicket.contactEmail = dataContact!["dsCorreoElectronico"]?.stringValue
                        }
                        
                        //Obtenemos los productos
                        if item["productos"].exists(){
                            let dataProducts = item["productos"].arrayValue
                            var listProducts = [ItemProduct]()
                            
                            for itemProd in dataProducts {
                                //Instancia de un productos
                                let itemNewProduct = ItemProduct()
                                
                                //Llenamos los datos
                                let claveProducto = itemProd["dsClave"].stringValue
                                let familyProducto = itemProd["familyProducto"].stringValue.lowercased()
                                itemNewProduct.productCode = claveProducto
                                itemNewProduct.familyProducto = familyProducto
                                itemNewProduct.hasAYB = self.hasAyB(dsClave: claveProducto)
                                
                                //Obtenemos los tipos de cliente
                                let dataClients = itemProd["tipoCliente"].arrayValue
                                for itemClient in dataClients {
                                    let typeClient = itemClient["dsTipoCliente"].stringValue
                                    let pax = itemClient["noPax"].intValue
                                    if typeClient == "Adulto"{
                                        itemNewProduct.adults = pax
                                    }else if typeClient == "Menor" {
                                        itemNewProduct.childrens = pax
                                    } else if typeClient == "Infante"{
                                        itemNewProduct.infants = pax
                                    }
                                }
                                
                                //Obtenemos la info de producto
                                itemNewProduct.visitDate = itemProd["feVisita"].stringValue
                                itemNewProduct.dueDate =  itemProd["feVisitaLimite"].stringValue
                                itemNewProduct.feOperacion =  itemProd["feOperacion"].stringValue
                                itemNewProduct.paxes = itemProd["Paxes"].string
                                itemNewProduct.productName = itemProd["dsProducto"].stringValue
                                itemNewProduct.un = itemProd["dsClaveUnidadNegocio"].stringValue
                                //Informacion de traslado
                                itemNewProduct.hasPickup = itemProd["cnPickup"].boolValue
                                itemNewProduct.timePickup = itemProd["hrPickup"].stringValue
                                itemNewProduct.locationPickup = itemProd["dsNombreHotel"].stringValue
                                
                                if itemProd["Promocion"].exists(){
                                    let dataPromocion = itemProd["Promocion"]
                                    let listPromocion = ItemPromocion()
                                    
                                    listPromocion.dsCodigoPromocion = dataPromocion["dsCodigoPromocion"].stringValue
                                    listPromocion.dsNombrePromocion = dataPromocion["dsNombrePromocion"].stringValue
                                    listPromocion.dsURLImagenCupon = dataPromocion["dsURLImagenCupon"].stringValue
                                    
                                    itemNewProduct.promocion = listPromocion
                                    
                                }
                                
                                //Recorremos la lista de componentes
                                if itemProd["componentes"].exists(){
                                    let dataComponents = itemProd["componentes"].arrayValue
                                    var listComponents = [ItemComponent]()
                                    for itemComponent in dataComponents {
                                        let itemNewComponent = ItemComponent()
                                        itemNewComponent.visitDate = itemComponent["feVisita"].stringValue
                                        itemNewComponent.dueDate = itemComponent["feVisitaLimite"].stringValue
                                        itemNewComponent.feOperacion = itemComponent["feOperacion"].stringValue
                                        itemNewComponent.productCode = itemComponent["dsClave"].stringValue
                                        itemNewComponent.productName = itemComponent["dsProducto"].stringValue
                                        itemNewComponent.hasPickup = itemComponent["cnPickup"].boolValue
                                        //itemNewComponent.hasAYB = itemComponent["familyProducto"].boolValue
                                        itemNewComponent.hasPhotopass = itemComponent[""].boolValue
                                        itemNewComponent.timePickup = itemComponent["hrPickup"].stringValue
                                        itemNewComponent.locationPickup = itemComponent["dsNombreHotel"].stringValue
                                        itemNewComponent.un = itemComponent["dsClaveUnidadNegocio"].stringValue
                                        itemNewComponent.familyProducto = itemComponent["familyProducto"].stringValue
                                        
                                        if itemComponent["Promocion"].exists(){
                                            let dataPromocion = itemProd["Promocion"]
                                            itemNewComponent.itemPromotion.dsCodigoPromocion = dataPromocion["dsCodigoPromocion"].stringValue
                                            itemNewComponent.itemPromotion.dsNombrePromocion = dataPromocion["dsNombrePromocion"].stringValue
                                            itemNewComponent.itemPromotion.dsURLImagenCupon = dataPromocion["dsURLImagenCupon"].stringValue
                                        }
                                        
                                        let claveComponente = itemComponent["dsClave"].stringValue
                                        itemNewComponent.hasAYB = self.hasAyB(dsClave: claveComponente)
                                        listComponents.append(itemNewComponent)
                                    }
                                    if listComponents.count > 0 {
                                        itemNewProduct.listComponents = listComponents
                                    }
                                }
                                
                                //Buscamos si tiene photopass
                                if familyProducto.contains("fotos" ){
                                    itemPhotoPass = itemNewProduct
                                }
                                
                                listProducts.append(itemNewProduct)
                            }
                            
                            listProducts = self.hasPhotoPass(productPhoto: itemPhotoPass, prodList: listProducts)
                            //Asignamos la lista de productos
                            itemTicket.listProducts = listProducts
                        }
                        
                        //asignamos el ticketuid
                        if let uidItem = listTickets!.first(where: {$0.barCode == itemTicket.barCode}){
                            itemTicket.uid = uidItem.uid
                            listTicketsSivex.append(itemTicket)
                        }else{
                            if ticket != ""{
//                                itemTicket.uid = "-\(AppUserDefaults.value(forKey: .UserUID, fallBackValue: "").stringValue)-\(itemTicket.barCode ?? "")"
                                listTicketsSivex.append(itemTicket)
                            }
                        }
                    }
                    completion(listTicketsSivex, true)
                }else{
                    completion(listTicketsSivex, false)
                }
            }
        }
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
    
    func getTokenSF(user: UserApp, completion: @escaping (Bool, String)-> ()){
        var token = ""
        let wsName = "\(cognito_url)validateuser"
        let user = "gex_appsDev"
        let pass = "VQztpnH@l9Oa"
        let json : [String : Any] = [
            "Username" : "cognitouserapp@xcaret.com",
            "Password" : "DsV4iQ@yCYjKNZ!"
        ]
        
        print(wsName)
        print(json)
        WebService.shared.executeWithSF(url: wsName, params: json as AnyObject, user: user, pass: pass) { (success, json) in
            if (success){
                token = json["TOKEN"].stringValue
                let dataUser = user
                print(token)
                print(dataUser)
            }else{
                token = ""
            }
            completion(success, token)
        }
    }
    
    func authSF(user: UserApp, token: String, completion: @escaping (Bool)-> ()){
        let wsName = self.SFLogin
        let token = token
        print(wsName)
        print(token)
        WebService.shared.executeWithAuthSF(url: wsName, token: token, user : user) { (success, json) in
            if (success){
                if json["message"].stringValue != "" && json["MESSAGE"].stringValue != "" {
                    print(json["message"].stringValue)
                    print(json["MESSAGE"].stringValue)
                    completion(false)
                }else{
                    completion(true)
                }
            }else{
                print(json)
                completion(false)
            }
            
        }
    }
    
    func getdataCalendar(producto: ItemProdProm, reCotizacion : Bool = false, mes : Int, year : Int, day : Int, itemProductsCarShop : ProductsCarShop = ProductsCarShop(), completion: @escaping (Bool, JSON)-> ()){
        let XAPPICalendar = "\(self.urlProdCalendar)Avail/list"
        print(XAPPICalendar)
        
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            WebService.shared.executeWithCalendar(url: XAPPICalendar,  prod: producto, reCotizacion : reCotizacion, mes : mes, year : year, day : day, itemProductsCarShop : itemProductsCarShop) { (success, json) in
                group.leave()
                if (success){
                    
                    print(json)
                    
                    if json["message"].stringValue != "" || json["MESSAGE"].stringValue != "" || json["Message"].stringValue != ""{
                        print(json["message"].stringValue)
                        print(json["MESSAGE"].stringValue)
                        print(json["Message"].stringValue)
                        completion(false, json)
                    }else{
                        completion(true, json)
                    }
                }else{
                    print(json)
                    completion(false, json)
                }
            }
            group.wait()
        }
        
    }
    
    
    func getRateKeyAllotment(itemCarShoop : ItemCarShoop, rt : String , completion: @escaping (Bool, String, String, AllowedCustomerConfigPax)-> ()){
        let XAPPICalendar = "\(self.urlProdCalendar)Avail/activity-by-ratekey"
        print(XAPPICalendar)
        
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            WebService.shared.executeWithRateKeyAllotment(url: XAPPICalendar, itemCarShoop : itemCarShoop, rt : rt) { (success, json) in
                group.leave()
                if (success){
                    
                    print(json)
                    
                    if json["message"].stringValue != "" || json["MESSAGE"].stringValue != "" || json["Message"].stringValue != ""{
                        print(json["message"].stringValue)
                        print(json["MESSAGE"].stringValue)
                        print(json["Message"].stringValue)
                        completion(false, "error", "", AllowedCustomerConfigPax())
                    }else{
                        
                        let allotmentAvail = AllotmentAvail()
                        let allowedCustomerConfigPax = AllowedCustomerConfigPax()
                        var activityAvail = ActivityAvail()
                        var rateKey = ""
                        
                        if json["Activity"]["Avail"].exists() {
                            allotmentAvail.activityAvail.message = json["Activity"]["Avail"]["Message"].stringValue
                            allotmentAvail.activityAvail.status = json["Activity"]["Avail"]["Status"].stringValue
                            allotmentAvail.activityAvail.description = json["Activity"]["Avail"]["Description"].stringValue
                        }
                        
                        if json["Activity"]["AllowedCustomer"].exists() {
                            
                            allotmentAvail.allowedCustomerConfigPax.children = json["Activity"]["AllowedCustomer"]["Children"].boolValue
                            allotmentAvail.allowedCustomerConfigPax.adults = json["Activity"]["AllowedCustomer"]["Adults"].boolValue
                            allotmentAvail.allowedCustomerConfigPax.individual = json["Activity"]["AllowedCustomer"]["Individual"].boolValue
                            allotmentAvail.allowedCustomerConfigPax.infants = json["Activity"]["AllowedCustomer"]["Infants"].boolValue
                            
                        }
                        
                        if json["Activity"]["RateServices"][0]["DailyRates"][0]["Allotment"].exists() {
                            rateKey = json["Activity"]["RateServices"][0]["DailyRates"][0]["RateKey"].stringValue
                            completion(true, "allotment", rateKey, allowedCustomerConfigPax)
                        }else if json["Activity"]["RateServices"][0]["DailyRates"][0]["Schedules"].exists(){
                            rateKey = json["Activity"]["RateServices"][0]["DailyRates"][0]["RateKey"].stringValue
                            completion(true, "allotment", rateKey, allowedCustomerConfigPax)
                        }else if json["Activity"]["RateServices"][0]["DailyRates"][0]["RateKey"].exists(){
                            rateKey = json["Activity"]["RateServices"][0]["DailyRates"][0]["RateKey"].stringValue
                            completion(true, "allotment", rateKey, allowedCustomerConfigPax)
                        }else{
                            completion(true, "noAllotment", "", AllowedCustomerConfigPax())
                        }
                    }
                }else{
                    print(json)
                    completion(false, "error", "", AllowedCustomerConfigPax())
                }
            }
            group.wait()
        }
        
    }
    
    
    func getAllotment(itemCarShoop : ItemCarShoop, completion: @escaping (Bool, AllotmentAvail)-> ()){
        let XAPPICalendar = "\(self.urlProdCalendar)Avail/activity-by-ratekey"
        print(XAPPICalendar)
        
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            WebService.shared.executeWithRateKeyAllotment(url: XAPPICalendar, itemCarShoop : itemCarShoop) { (success, json) in
                group.leave()
                if (success){
                    
                    print(json)
                    
                    if json["message"].stringValue != "" || json["MESSAGE"].stringValue != "" || json["Message"].stringValue != ""{
                        print(json["message"].stringValue)
                        print(json["MESSAGE"].stringValue)
                        print(json["Message"].stringValue)
                        completion(false, AllotmentAvail())
                    }else{
                        
                        let allotmentAvail = AllotmentAvail()
                        
//                        if json["Activity"]["Avail"].exists() {
//                            allotmentAvail.activityAvail.message = json["Activity"]["Avail"]["Message"].stringValue
//                            allotmentAvail.activityAvail.status = json["Activity"]["Avail"]["Status"].stringValue
//                            allotmentAvail.activityAvail.description = json["Activity"]["Avail"]["Description"].stringValue
//                        }
                        
                        if json["Activity"]["RateServices"][0]["DailyRates"][0]["Avail"].exists() {
                            allotmentAvail.activityAvail.message = json["Activity"]["RateServices"][0]["DailyRates"][0]["Avail"]["Message"].stringValue
                            allotmentAvail.activityAvail.status = json["Activity"]["RateServices"][0]["DailyRates"][0]["Avail"]["Status"].stringValue
                            allotmentAvail.activityAvail.description = json["Activity"]["RateServices"][0]["DailyRates"][0]["Avail"]["Description"].stringValue
                        }else{
                            if json["Activity"]["Avail"].exists() {
                                allotmentAvail.activityAvail.message = json["Activity"]["Avail"]["Message"].stringValue
                                allotmentAvail.activityAvail.status = json["Activity"]["Avail"]["Status"].stringValue
                                allotmentAvail.activityAvail.description = json["Activity"]["Avail"]["Description"].stringValue
                            }
                        }
                        
                        if json["Activity"]["AllowedCustomer"].exists() {
                            
                            allotmentAvail.allowedCustomerConfigPax.children = json["Activity"]["AllowedCustomer"]["Children"].boolValue
                            allotmentAvail.allowedCustomerConfigPax.adults = json["Activity"]["AllowedCustomer"]["Adults"].boolValue
                            allotmentAvail.allowedCustomerConfigPax.individual = json["Activity"]["AllowedCustomer"]["Individual"].boolValue
                            allotmentAvail.allowedCustomerConfigPax.infants = json["Activity"]["AllowedCustomer"]["Infants"].boolValue
                            
                        }
                        
                        if json["Activity"]["RateServices"][0]["DailyRates"][0]["Allotment"].exists() {
                            allotmentAvail.rateKey = json["Activity"]["RateServices"][0]["DailyRates"][0]["RateKey"].stringValue
                            allotmentAvail.allotment = true
                            completion(true, allotmentAvail)
                        }else{
                            allotmentAvail.allotment = false
                            completion(true, allotmentAvail)
                        }
                    }
                }else{
                    print(json)
                    completion(false, AllotmentAvail())
                }
            }
            group.wait()
        }
        
    }
    
    
    func getCancelAllotment(itemRateKey : String, mobile : Bool, completion: @escaping (Bool)-> ()){
        let XAPPICalendar = "\(self.urlProdCalendar)hold/cancel"
        print(XAPPICalendar)
        
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            WebService.shared.executeWithCancelAllotment(url: XAPPICalendar, itemRateKey : itemRateKey, mobile : mobile) { (success, json) in
                group.leave()
                if (success){
                    print(json)
                    if json["Status"].exists() {
                        let prodAllotment = ProdAllotment()
                        prodAllotment.id = json["Id"].intValue
                        prodAllotment.rateKey = json["RateKey"].stringValue
                        prodAllotment.status = json["Status"].stringValue
                        completion(true)
                    }else if json["StatusCode"].exists(){
                        completion(true)
                    }
                }else{
                    print(json)
                    completion(false)
                }
            }
            group.wait()
        }
        
    }
    func getReservedAllotment(itemCarShoop : ItemCarShoop, rateKey : String, time : String = "minimo", completion: @escaping (Bool, ProdAllotment)-> ()){
        let XAPPICalendar = "\(self.urlProdCalendar)hold/reserve"
        print(XAPPICalendar)
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            WebService.shared.executeWithReservedAllotment(url: XAPPICalendar, itemCarShoop : itemCarShoop, rateKey: rateKey, time : time) { (success, json) in
                group.leave()
                if (success){
                    print(json)
                    if json["Status"].exists() {
                        let status = json["Status"].stringValue
                        let prodAllotment = ProdAllotment()
                        prodAllotment.id = json["Id"].intValue
                        prodAllotment.rateKey = json["RateKey"].stringValue
                        prodAllotment.status = json["Status"].stringValue
                        completion(true, prodAllotment)
                    }else if json["StatusCode"].exists(){
                        completion(true, ProdAllotment())
                    }
                }else{
                    print(json)
                    completion(false, ProdAllotment())
                }
            }
            group.wait()
        }
        
    }
    
    func getdataPack(listItemsCarShop :  [ItemCarShoop] , completion: @escaping (Bool, [ItemCarShoop])-> ()){
        let XAPPIPack = "\(self.urlProdCalendar)PackageAvail/package-details"
        print(XAPPIPack)
        
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            WebService.shared.executeWithPack(url: XAPPIPack, listItemsCarShop : listItemsCarShop) { (success, json) in
                group.leave()
                if (success){
                    
                    print(json)
                    
                    if json["message"].stringValue != "" || json["MESSAGE"].stringValue != "" || json["Message"].stringValue != ""{
                        print(json["message"].stringValue)
                        print(json["MESSAGE"].stringValue)
                        print(json["Message"].stringValue)
                        completion(false, [ItemCarShoop]())
                    }else{
                        let aux = listItemsCarShop
                        print(aux)
                        var listItemCS = [ItemCarShoop]()
                        if json["Itinerary"].exists(){
                            
                            let itinerary = json["Itinerary"]
                            
                            let count = itinerary["Components"]["Count"].intValue
                            print(count)
                            
                            for itemItinerary in json["Itinerary"]["Components"]["Components"].arrayValue {
                                let id = itemItinerary["Id"].intValue
                                for itemsCarShop in listItemsCarShop {
                                    var itemCS = ItemCarShoop()
                                    
                                    if itemsCarShop.itemProdProm.first?.idProducto == id {
                                        print(itemItinerary)
                                        let Id = itemItinerary["Id"].intValue
                                        print(Id)
                                        itemCS = itemsCarShop
                                        listItemCS.append(itemCS)
                                    }
                                }
                            }
                            
                            if let itemsCarShopPrincipal = listItemsCarShop.filter({ $0.itemProdProm.first?.principal == true}).first {
                                var itemCSPrincipal = ItemCarShoop()
                                
                                itemsCarShopPrincipal.itemDiaCalendario.amount = itinerary["Amount"].doubleValue
                                itemsCarShopPrincipal.itemDiaCalendario.normalAmount = itinerary["NormalAmount"].doubleValue
                                itemsCarShopPrincipal.itemDiaCalendario.subtotalAdulto = itinerary["AdultAmount"].doubleValue
                                itemsCarShopPrincipal.itemDiaCalendario.ahorroAdulto = itinerary["NormalAdultAmount"].doubleValue - itinerary["AdultAmount"].doubleValue
                                itemsCarShopPrincipal.itemDiaCalendario.subtotalChildren = itinerary["ChildrenAmount"].doubleValue
                                itemsCarShopPrincipal.itemDiaCalendario.ahorroChildren = itinerary["NormalChildrenAmount"].doubleValue - itinerary["ChildrenAmount"].doubleValue
                                
                                itemsCarShopPrincipal.itemProdProm.first?.descripcionEn = itemsCarShopPrincipal.itemProdProm.first?.code_promotion
                                itemsCarShopPrincipal.itemProdProm.first?.descripcionEs = itemsCarShopPrincipal.itemProdProm.first?.code_promotion
                                itemCSPrincipal = itemsCarShopPrincipal
                                listItemCS.append(itemCSPrincipal)
                            }
                        }
                        let aux2 = listItemCS
                        print(aux2)
                        completion(true, listItemCS)
                    }
                }else{
                    print(json)
                    completion(false, [ItemCarShoop]())
                }
            }
            group.wait()
        }
        
    }
    
    
    func getBanksInfo(itemsCarShoop : ItemCarShoop, completion: @escaping (Bool, Banks)-> ()) {
        let ISO3Country: String = itemsCarShoop.itemComprador.ladaValuetextF.iso
        let ISO2Country: String = itemsCarShoop.itemComprador.ladaValuetextF.iso2
        let date: String = "\(String(itemsCarShoop.itemDiaCalendario.year))-\(itemsCarShoop.itemDiaCalendario.mes + 1)-\(String(itemsCarShoop.itemDiaCalendario.diaNumero))"
        let cantidad = itemsCarShoop.itemDiaCalendario.subtotalAdulto
        
        
        let dateToday = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "GMT-5")
        formatter.locale = Locale(identifier: "es")
        let resultDateToday = formatter.string(from: dateToday)
        
        
        let XAPPIBanksInfo = "\(self.urlBanksInfo)api/Payment/banks/\(Constants.CURR.current)/\(appDelegate.bookingConfig.channel_id!)/\(resultDateToday)/\(date)/\(cantidad ?? 0.0)?ISO3Country=\(ISO3Country)&ISO2Country=\(ISO2Country)"
        
        WebService.shared.executeWithBanksInfo(url: XAPPIBanksInfo) { (success, json) in
            if (success){
                
                print(json)
                
                if json["message"].stringValue != "" || json["MESSAGE"].stringValue != "" || json["Message"].stringValue != ""{
                    print(json["message"].stringValue)
                    print(json["MESSAGE"].stringValue)
                    print(json["Message"].stringValue)
                    completion(false, Banks())
                }else{
                    let banks = Banks()
                    
                    if json["cardTypes"].exists(){
                        for itemCardTypes in json["cardTypes"].arrayValue {
                            let cardType = CardType()
                            
                            cardType.idCardType = itemCardTypes["idCardType"].intValue
                            cardType.cardTypeCode = itemCardTypes["cardTypeCode"].stringValue
                            cardType.cardTypeName = itemCardTypes["cardTypeName"].stringValue
                            cardType.cardTypeURLLogo = itemCardTypes["cardTypeUrlLogo"].stringValue
                            banks.cardTypes.append(cardType)
                        }
                    }
                    
                    if json["banks"].exists(){
                        for itemBank in json["banks"].arrayValue {
                            let bank = Bank()
                            
                            bank.idBank = itemBank["idBank"].intValue
                            bank.bankCode = itemBank["bankCode"].stringValue
                            bank.bankName = itemBank["bankName"].stringValue
                            let bankInstallments = itemBank["bankInstallments"].arrayValue
                            for itembankInstallments in bankInstallments {
                                let bankInstallments = BankInstallment()
                                bankInstallments.installmentCode = InstallmentCode(rawValue: itembankInstallments["installmentCode"].stringValue)! //?? InstallmentCode.the1P
                                bankInstallments.installmentName = InstallmentName(rawValue: itembankInstallments["installmentName"].stringValue)! //?? InstallmentName.the1SoloPago
                                bankInstallments.installments = itembankInstallments["installments"].intValue
                                bankInstallments.commissionAmount = itembankInstallments["commissionAmount"].doubleValue
                                bankInstallments.commissionPercentage = itembankInstallments["commissionPercentage"].doubleValue
                                bankInstallments.minimiumAmount = itembankInstallments["minimiumAmount"].doubleValue
                                bank.bankInstallments.append(bankInstallments)
                            }
                            bank.idSivex = itemBank["idSivex"].intValue
                            banks.banks.append(bank)
                        }
                    }
                    completion(true, banks)
                }
            }else{
                print(json)
                completion(false, Banks())
            }
            
        }
        
    }
    
    
    func getInfoBuy(itemsCarShoop : [ItemCarShoop], buyItem : ItemCarshop, itemLocations : [ItemLocations] = [ItemLocations](), completion: @escaping (Bool, GetBookingTicket)-> ()) {
        var XAPPIBanksInfo = ""
        if self.appDelegate.bookingXwitch {
            XAPPIBanksInfo = "\(self.urlBooking)api/Booking/SetBooking"
        }else{
            XAPPIBanksInfo = "\(self.urlBooking)BookingService/Booking"
        }
        
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            WebService.shared.executeWithGetInfoBuy(url: XAPPIBanksInfo, itemsCarShoop : itemsCarShoop, buyItem : buyItem, itemLocations : itemLocations) { (success, json) in
                group.leave()
                if (success){
                    
                    print(json)
                    
                    if json["message"].stringValue != "" || json["MESSAGE"].stringValue != "" || json["Message"].stringValue != ""{
                        print(json["message"].stringValue)
                        print(json["MESSAGE"].stringValue)
                        print(json["Message"].stringValue)
                        completion(false, GetBookingTicket())
                    }else{
                        let getBookingTicket = GetBookingTicket()
                        
                        getBookingTicket.idProducto = buyItem.products.first?.key
                        getBookingTicket.salesId = json["salesId"].intValue
                        getBookingTicket.dsSalesId = json["dsSalesId"].stringValue
                        getBookingTicket.dsSaleIdInsure = json["dsSaleIdInsure"].stringValue
                        getBookingTicket.saleIdInsure = json["saleIdInsure"].intValue
                        
                        if json["services"]["activities"].exists(){
                            let services = json["services"]["activities"][0]
                            getBookingTicket.productId = services["productId"].intValue
                            getBookingTicket.status = json["payments"]["cards"][0]["status"].intValue//services["status"].intValue
                        }
                        
                        if json["payments"].exists(){
                            let payments = json["payments"]
                            let cards = payments["cards"][0]
                            if cards["error"].exists() {
                                getBookingTicket.id = cards["error"]["id"].intValue
                                getBookingTicket.message = cards["error"]["message"].stringValue
                            }
                        }
                        
                        if json["payments"]["cards"][0]["comments"].exists(){
                            getBookingTicket.comments = json["payments"]["cards"][0]["comments"].stringValue
                        }
                           
                        completion(true, getBookingTicket)
                    }
                }else{
                    print(json)
                    completion(false, GetBookingTicket())
                }
                
            }
            group.wait()
        }
    }
    

    func getValidateCarShop(itemsCarShoop : [ItemCarShoop], buyItem : ItemCarshop, completion: @escaping (Bool, StatusValidateCarShop)-> ()) {
        let XAPPIBanksInfo = "\(self.urlValidateCarShop)ValidateCarShop/validate-carshop"
        
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            WebService.shared.executeValidateCarShop(url: XAPPIBanksInfo, itemsCarShoop : itemsCarShoop, buyItem : buyItem) { (success, json) in
                group.leave()
                if (success){
                    print(json)
                    var successResponse = false
                    let statusValidateCarShop = StatusValidateCarShop()
                        if json["Activities"].exists() {
                        statusValidateCarShop.simple = true
                        let statusAllotment = json["Activities"]["Activities"][0]["Status"]["HoldStatusAllotment"].stringValue
                        statusValidateCarShop.statusValidateCarShopAllotmen.holdStatusAllotment = statusAllotment
                        if json["Activities"]["Promotion"].exists() {
                            if json["Activities"]["Promotion"]["Url"].exists() {
                                statusValidateCarShop.statusValidateCarShopAllotmen.statusPromotion = true
                            }
                            let statusApplied = json["Activities"]["Promotion"]["Applied"]["Status"].stringValue
                            statusValidateCarShop.statusValidateCarShopAllotmen.statusApplied = statusApplied.lowercased() == "notapplied" ? false : true
                        }else{
                            statusValidateCarShop.statusValidateCarShopAllotmen.statusApplied = true
                        }
                        successResponse = true
                        print(statusAllotment)
                    }else if json["Packages"].exists(){
                        let statusAllotment = json["Packages"]["Packages"][0]["Status"]["HoldStatusAllotment"].stringValue
                        statusValidateCarShop.statusValidateCarShopAllotmen.holdStatusAllotment = statusAllotment
                        print(statusAllotment)
                        successResponse = true
                    }
                    completion(successResponse, statusValidateCarShop)
                }else{
                    print(json)
                    completion(false, StatusValidateCarShop())
                }
            }
            group.wait()
        }
    }
    
    
    func getCardInfo(bin : String, completion: @escaping (Bool, ItemCardInfo)-> ()) {
        
        let XAPPICardInfo = "\(self.urlBanksInfo)api/Payment/BinInfo"
        
        WebService.shared.executeWithCardInfo(url: XAPPICardInfo, bin: bin) { (success, json) in
            if (success){
                
                print(json)
                
                if json["message"].stringValue != "" || json["MESSAGE"].stringValue != "" || json["Message"].stringValue != ""{
                    print(json["message"].stringValue)
                    print(json["MESSAGE"].stringValue)
                    print(json["Message"].stringValue)
                    completion(false, ItemCardInfo())
                }else{
                    
                    let cardInfo = ItemCardInfo()
                    if json["idBanco"].exists() {
                        
                        cardInfo.isoCountry = json["isoCountry"].stringValue
                        cardInfo.brand = json["brand"].stringValue
                        cardInfo.bank = json["bank"].stringValue
                        cardInfo.idBanco = String(json["idBanco"].intValue)
                        cardInfo.bin = json["bin"].stringValue
                        cardInfo.info = json["info"].stringValue
                        cardInfo.level = json["level"].stringValue
                        cardInfo.phone = json["phone"].stringValue
                        cardInfo.paymentMethodName = json["paymentMethodName"].stringValue
                        cardInfo.paymentMethodCode = json["paymentMethodCode"].stringValue
                        cardInfo.cardTypeName = json["cardTypeName"].stringValue
                        cardInfo.type = json["type"].stringValue
                        cardInfo.country2_Iso = json["country2_Iso"].stringValue
                        cardInfo.country3_Iso = json["country3_Iso"].stringValue
                        cardInfo.www = json["www"].stringValue
                        cardInfo.cardTypeCode = json["cardTypeCode"].stringValue
                    
                    }
                    
                    completion(true, cardInfo)
                }
            }else{
                print(json)
                completion(false, ItemCardInfo())
            }
            
        }
        
    }

    func getCardInfo2(bin : String, completion: @escaping (Bool, ItemCardInfo, String)-> ()) {
        
        let XAPPICardInfo = "\(self.urlBanksInfo2)BinSettings/info"//api/Payment/BinInfo"
        
        WebService.shared.executeWithCardInfo2(url: XAPPICardInfo, bin: bin) { (success, json) in
            if (success){
                
                print(json)
                
                if json["message"].stringValue != "" || json["MESSAGE"].stringValue != "" || json["Message"].stringValue != ""{
                    print(json["message"].stringValue)
                    print(json["MESSAGE"].stringValue)
                    print(json["Message"].stringValue)
                    completion(false, ItemCardInfo(), json["StatusCode"].stringValue)
                }else{
                    
                    let cardInfo = ItemCardInfo()
                    if json["IdBank"].exists() {
                        
                        cardInfo.isoCountry = json["IsoCountry"].stringValue
                        cardInfo.brand = json["Brand"].stringValue
                        cardInfo.bank = json["Bank"].stringValue
                        cardInfo.idBanco = String(json["IdBank"].intValue)
                        cardInfo.bin = json["Bin"].stringValue
                        cardInfo.info = json["Info"].stringValue
                        cardInfo.level = json["Level"].stringValue
                        cardInfo.phone = json["Phone"].stringValue
                        cardInfo.paymentMethodName = json["PaymentMethodName"].stringValue
                        cardInfo.paymentMethodCode = json["PaymentMethodCode"].stringValue
                        cardInfo.cardTypeName = json["CardTypeName"].stringValue
                        cardInfo.type = json["Type"].stringValue
                        cardInfo.country_iso = json["Country_iso"].stringValue
                        cardInfo.country2_Iso = json["Country2_iso"].stringValue
                        cardInfo.country3_Iso = json["Country3_iso"].stringValue
                        cardInfo.www = json["Www"].stringValue
                        cardInfo.cardTypeCode = json["CardTypeCode"].stringValue
                    
                    }
                    
                    completion(true, cardInfo, "200")
                }
            }else{
                print(json)
                completion(false, ItemCardInfo(), "")
            }
            
        }
        
    }
    
    func getDataLocations(itemsCarShoop : ItemCarShoop, completion: @escaping (Bool, [ItemLocations]) -> ()){
        let XAPPICalendar = "\(self.urlProdCalendar)Avail/activity-by-ratekey"
        print(XAPPICalendar)
        var totalItems = 0
        for itemsCount in itemsCarShoop.itemDiaCalendario.rateKey {
            totalItems = totalItems + itemsCount.horarioPickup.count
        }
        var listItemsLocations = [ItemLocations]()
        let appProd = itemsCarShoop.itemProdProm.first?.code_promotion == "APP" ? true : false
        let group = DispatchGroup()
        var totalPages = 0
        DispatchQueue.global(qos: .userInitiated).async {
            for itemKeyrate in itemsCarShoop.itemDiaCalendario.rateKey {
                if itemKeyrate.horarioPickup.count > 0 {
                    for listItemKeyrate in itemKeyrate.horarioPickup {
                        group.enter()
                        WebService.shared.executeWithLocations(url: XAPPICalendar, rateKey: listItemKeyrate.rateKey, app: appProd) { (success, json) in
                            group.leave()
                            totalPages = totalPages + 1
                            if (success){
                                
                                print(json)
                                
                                if json["Activity"].exists() {
                                    let itemLocations = ItemLocations()
                                    //
                                    print("JSONData")
                                    
                                    let Activities = json["Activity"]
                                    let RateServices = Activities["RateServices"].arrayValue
                                    let Geographic = RateServices[0]["Geographic"]
                                    itemLocations.date = listItemKeyrate.time
                                    itemLocations.id = Geographic["Id"].intValue
                                    itemLocations.name = Geographic["Name"].stringValue
                                    let DailyRates = RateServices[0]["DailyRates"].arrayValue
                                    var PickUps = DailyRates[0]["PickUps"]
                                    var pickUpsCount = PickUps.count
                                    if DailyRates[0]["Schedules"].exists() && pickUpsCount == 0{
                                        PickUps = DailyRates[0]["Schedules"][0]["PickUps"]//DailyRates[0]["PickUps"]
                                    }
                                    if DailyRates[0]["Schedules"].exists() {
                                        itemLocations.time = DailyRates[0]["Schedules"][0]["Time"].stringValue
                                        let aux = DailyRates[0]["Schedules"][0]["Time"].stringValue
                                    }
                                    pickUpsCount = PickUps.count
                                    if pickUpsCount > 0 {
                                        for index in 0...pickUpsCount - 1 {
                                            let itemLocation = ItemLocation()
                                            let pickUps = PickUps[index]
                                            itemLocation.idLoc = Geographic["Id"].intValue
                                            itemLocation.nameLoc = Geographic["Name"].stringValue
                                            itemLocation.id = pickUps["Id"].intValue
                                            itemLocation.name = pickUps["Name"].stringValue
                                            itemLocation.time = listItemKeyrate.time
                                            let location = pickUps["Location"]
                                            itemLocation.location.latitude = location["Latitude"].doubleValue
                                            itemLocation.location.longitude = location["Longitude"].doubleValue
                                            let pu = pickUps["PickUps"][0]
                                            itemLocation.pickUps.id = pu["Id"].intValue
                                            itemLocation.pickUps.time = pu["Time"].stringValue
                                            
                                            itemLocations.itemLocation.append(itemLocation)
                                            
                                        }
                                    }
                                    listItemsLocations.append(itemLocations)
                                }else{
                                    print("no ok")
                                }
                                
                                if totalPages == totalItems {//itemsCarShoop.itemDiaCalendario.rateKey.count {
                                    
                                    let listPickup = listItemsLocations//self.appDelegate.listPickup
                                    let listGeographicPickup = self.appDelegate.listGeographicPickup
                                    let item = ItemLocations()
                                    item.id = 4
                                    item.name = "Otro"
                                    for GeographicPickup in listGeographicPickup {
                                        
                                        for itemsLocations in listItemsLocations {
                                            let location = itemsLocations.itemLocation.filter({ String($0.id) == GeographicPickup.hotelId})
                                            if location.count > 0{
                                                item.itemLocation.append(location.first ?? ItemLocation())
                                            }
                                        }
                                        
                                    }
                                    
                                    listItemsLocations.append(item)
                                    completion(true, listItemsLocations)
                                }
                                
                            }else{
                                print(json)
                                completion(false, listItemsLocations)
                            }
                        }
                        group.wait()
                    }
                }else{
                    group.enter()
                    WebService.shared.executeWithLocations(url: XAPPICalendar, rateKey: itemKeyrate.rateKey, app: appProd) { (success, json) in
                        group.leave()
//                        totalPages = totalPages + 1
                        if (success){

                            print(json)

                            if json["Activity"].exists() {
                                let itemLocations = ItemLocations()
                                //
                                print("JSONData")

                                let Activities = json["Activity"]
                                let RateServices = Activities["RateServices"].arrayValue
                                let Geographic = RateServices[0]["Geographic"]
//                                itemLocations.date = listItemKeyrate.time
                                itemLocations.id = Geographic["Id"].intValue
                                itemLocations.name = Geographic["Name"].stringValue
                                let DailyRates = RateServices[0]["DailyRates"].arrayValue
                                var PickUps = DailyRates[0]["PickUps"]
                                var pickUpsCount = PickUps.count
                                if DailyRates[0]["Schedules"].exists() && pickUpsCount == 0{
                                    PickUps = DailyRates[0]["Schedules"][0]["PickUps"]//DailyRates[0]["PickUps"]
                                }
                                if pickUpsCount > 0 {
                                    for index in 0...pickUpsCount - 1 {
                                        let itemLocation = ItemLocation()
                                        let pickUps = PickUps[index]
                                        itemLocation.idLoc = Geographic["Id"].intValue
                                        itemLocation.nameLoc = Geographic["Name"].stringValue
                                        itemLocation.id = pickUps["Id"].intValue
                                        itemLocation.name = pickUps["Name"].stringValue
                                        let location = pickUps["Location"]
                                        itemLocation.location.latitude = location["Latitude"].doubleValue
                                        itemLocation.location.longitude = location["Longitude"].doubleValue
                                        let pu = pickUps["PickUps"][0]
                                        itemLocation.pickUps.id = pu["Id"].intValue
                                        itemLocation.pickUps.time = pu["Time"].stringValue
                                        
                                        itemLocations.itemLocation.append(itemLocation)
                                    }
                                }
                                listItemsLocations.append(itemLocations)
                            }else{
                                print("no ok")
                            }

                            if listItemsLocations.count == itemsCarShoop.itemDiaCalendario.rateKey.count{
                                let listPickup = self.appDelegate.listPickup
                                let listGeographicPickup = self.appDelegate.listGeographicPickup
                                let item = ItemLocations()
                                item.id = 4
                                item.name = "Otro"
                                for GeographicPickup in listGeographicPickup {
                                    let geographic = listPickup.filter({ $0.id == GeographicPickup.key_pickup})
                                    let itemsLocations = listItemsLocations.filter({ String($0.id) == geographic.first?.geographicId }).first

                                    let itemlocation = itemsLocations?.itemLocation.filter({ String($0.id) == GeographicPickup.hotelId}).first

                                    if itemlocation != nil {item.itemLocation.append(itemlocation!)}

                                }
                                listItemsLocations.append(item)
                                completion(true, listItemsLocations)
                            }
                        }else{
                            print(json)
                            completion(false, listItemsLocations)
                        }
                    }
                    group.wait()
                }
                
                
            }
        }
        
    }
    

    func getDataPricePhotopass(itemsCarShoop : ItemCarShoop, completion: @escaping (Bool, Itemfotos) -> ()){
        let XAPPICalendar = "\(self.urlProdCalendar)PackageAvail/list"
        print(XAPPICalendar)
        WebService.shared.executeWithPricePhotopass(url: XAPPICalendar, itemsCarShoop: itemsCarShoop) { (success, json) in
            let itemfotos = Itemfotos()
            if (success){
                print(json)
                if json["Packages"].exists() {
                    let packages = json["Packages"].arrayValue
                    let itineraries = packages[0]["Itineraries"].arrayValue
                    let components = packages[0]["Options"]["Components"].arrayValue
                    
                    itemfotos.itineraries.packageId = packages[0]["Id"].intValue
                    itemfotos.packageName = packages[0]["Name"].stringValue
                    itemfotos.itineraries.itineraryId = itineraries[0]["Id"].stringValue
                    
                    
                    itemfotos.id = components[0]["Id"].intValue
                    itemfotos.productKey = components[0]["ProductKey"].stringValue
                    itemfotos.name = components[0]["Name"].stringValue
                    itemfotos.code = components[0]["Code"].stringValue
                    itemfotos.packageDiscount = components[0]["PackageDiscount"].doubleValue
                    itemfotos.descuento = components[0]["NormalAmount"].doubleValue - components[0]["Amount"].doubleValue
                    
                    let dailyRates = components[0]["RateServices"][0]["DailyRates"].arrayValue
                    
                    itemfotos.normalAmount = dailyRates[0]["NormalAmount"].doubleValue
                    itemfotos.amount = dailyRates[0]["Amount"].doubleValue
                    itemfotos.normalAdults = dailyRates[0]["NormalAdults"].doubleValue
                    itemfotos.adults = dailyRates[0]["Adults"].doubleValue
                    itemfotos.normalChildren = dailyRates[0]["NormalChildren"].doubleValue
                    itemfotos.children = dailyRates[0]["NormalInfant"].doubleValue
                    itemfotos.normalInfant = dailyRates[0]["NormalInfant"].doubleValue
                    itemfotos.infant = dailyRates[0]["Infant"].doubleValue
                    itemfotos.normalIndividual = dailyRates[0]["NormalIndividual"].doubleValue
                    itemfotos.individual = dailyRates[0]["Individual"].doubleValue
                    itemfotos.rateKey = dailyRates[0]["RateKey"].stringValue//components[0]["RateServices"][0]["DailyRates"][0]["RateKey"].stringValue
                    
                    completion(true, itemfotos)
                }else{
                    completion(false, itemfotos)
                }
                
            }else{
                print(json)
                completion(false, itemfotos)
            }
        }
    }
    
    
    func getDataPriceIKE(itemsCarShoop : ItemCarShoop, completion: @escaping (Bool, ItemIKE) -> ()){
        let XAPPICalendar = "\(self.urlProdCalendar)Addons/addons-by-activity"
        print(XAPPICalendar)
        
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            WebService.shared.executeWithPriceIKE(url: XAPPICalendar, itemsCarShoop: itemsCarShoop) { (success, json) in
                group.leave()
                let itemIKE = ItemIKE()
                if (success){
                    
                    print(json)
                    
                    if json["Addons"].exists() {
                        let addons = json["Addons"].arrayValue
                        itemIKE.id = addons[0]["Id"].intValue
                        itemIKE.productKey = addons[0]["ProductKey"].stringValue
                        itemIKE.name = addons[0]["Name"].stringValue
                        itemIKE.code = addons[0]["Code"].stringValue
                        
                        let rateServices = addons[0]["RateServices"].arrayValue
                        
                        itemIKE.amount = rateServices[0]["Amount"].doubleValue
                        itemIKE.normalAmount = rateServices[0]["NormalAmount"].doubleValue
                        
                        itemIKE.normalAdultAmount = rateServices[0]["NormalAdultAmount"].doubleValue
                        itemIKE.adultAmount = rateServices[0]["AdultAmount"].doubleValue
                        itemIKE.normalChildrenAmount = rateServices[0]["NormalChildrenAmount"].doubleValue
                        itemIKE.childrenAmount = rateServices[0]["ChildrenAmount"].doubleValue
                        itemIKE.normalInfantAmount = rateServices[0]["NormalInfantAmount"].doubleValue
                        itemIKE.infantAmount = rateServices[0]["InfantAmount"].doubleValue
                        itemIKE.normalIndividualAmount = rateServices[0]["NormalIndividualAmount"].doubleValue
                        itemIKE.individualAmount = rateServices[0]["individualAmount"].doubleValue
                        
                        itemIKE.locationname = rateServices[0]["Location"]["Name"].stringValue
                        
                        itemIKE.rateKey = rateServices[0]["DailyRates"][0]["RateKey"].stringValue
                        
                        completion(true, itemIKE)
                    }else{
                        completion(true, itemIKE)
                    }
                    
                }else{
                    print(json)
                    completion(false, itemIKE)
                }
            }
            group.wait()
        }
    }
    
    func checkUser(user: UserApp, token: String, completion: @escaping (Bool)-> ()){
            let wsName = self.SFLogin
            let token = token
            print(wsName)
            print(token)
            WebService.shared.executeCheckUser(url: wsName, token: token, user : user) { (success, json) in
                if success{
                    if json["COUNT"].exists(){
                        if Int(json["COUNT"].stringValue) ?? 0 > 0 {
                            completion(true)
                        }else{
                            completion(false)
                        }
                    }else{
                        completion(false)
                    }
                }else{
                    completion(false)
                }
            }
        }
    
    func hasPhotoPass(productPhoto: ItemProduct, prodList: [ItemProduct])-> [ItemProduct] {
        for itemComponent in productPhoto.listComponents{
            for itemProd in prodList{
                if (itemProd.un == itemComponent.un && itemProd.visitDate == itemComponent.visitDate){
                    itemProd.hasPhotopass = true
                }
                for itemProdComp in itemProd.listComponents{
                    if (itemProdComp.un == itemComponent.un && itemProdComp.visitDate == itemComponent.visitDate){
                        itemProdComp.hasPhotopass = true
                    }
                }
            }
        }
        
        return prodList
    }
}
