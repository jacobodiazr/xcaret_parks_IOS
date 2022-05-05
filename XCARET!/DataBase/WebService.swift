
import Alamofire
import SwiftyJSON
import Foundation

class WebService {
    
    static let shared = WebService()
    
    func execute(url: String, httpMethod: HTTPMethod, params: Parameters?, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()) {
        Alamofire.request(url, method: httpMethod, parameters: params)
            .validate()
            .responseJSON { (response) in
                
                switch response.result {
                case .success:
                    
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
    }
    
    func execute(url: String, httpMethod: HTTPMethod, params: Parameters?, user: String, pass: String, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()) {
        Alamofire.request(url, method: httpMethod, parameters: params)
            .validate()
            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                
                switch response.result {
                case .success:
                    
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
    }
    
    func executeWith(request: URLRequestConvertible,  completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()) {
        Alamofire.request(request)
            .validate()
            .responseJSON { (response) in
                
                switch response.result {
                case .success:
                    
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
            }
    }
    
    
    func executeWith(url: String, params: AnyObject, token: String, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        let jsonBody = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        if let json = json {
            print(json)
        }
        
        //Configuramos el urlRequest
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
        
    }
    
    func executeWith(url: String, params: AnyObject, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        let jsonBody = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        if let json = json {
            print(json)
        }
        
        //Configuramos el urlRequest
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
        
    }
    
    func executeWithSF(url: String, params: AnyObject ,user: String, pass: String, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        let jsonBody = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        
        if let json = json {
            print(json)
        }
        
        let credentialData = "\(user):\(pass)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        let base64Credentials = credentialData.base64EncodedString()
        let headers = [
                    "Authorization": "Basic \(base64Credentials)",
                    "Accept": "application/json",
                    "Content-Type": "application/json" ]
        
        //Configuramos el urlRequest
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        request.allHTTPHeaderFields = headers
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
//            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
        
    }
    
    func executeWithAuthSF(url: String, token: String, user : UserApp, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        let headers = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        var firstname = user.firstname != "" ? user.firstname : user.name
        var lastname = user.lastname != "" ? user.lastname : user.name
        
        let principalNameEmail = user.email.components(separatedBy: "@")
        
        firstname = firstname != "" ? firstname : principalNameEmail[0]
        lastname = lastname != "" ? lastname : principalNameEmail[0]
        
        let lenjuage = Constants.LANG.current == "es" ? "Español" : "Inglés"
        
        let body: [String : Any] = [
            "Contact": [
                "FirstName": firstname,
                "LastName": lastname,
                "Email": user.email,
                "Phone": user.phone,
                "Como_se_entero_de_nosotros__c": "Aplicación Parques",
                "Lenguaje__c" : lenjuage
                ],
            "ContactDeveloperName": "Ex_Visitante"
        ]
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        
                if let json = json {
                    print(json)
                }
        //Configuramos el urlRequest
        let urlprofile = "\(url)createpaxprofilerq"
        let urlRequest = URL(string: urlprofile)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonBody
        request.allHTTPHeaderFields = headers
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
//            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    print(response.result.isSuccess)
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(response.result.error as Any)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
        
    }
    
    func executeCheckUser(url: String, token: String, user : UserApp, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        let headers = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let urlCheck = "\(url)getpaxprofilerq?Email=\(user.email)"
        let urlRequest = URL(string: urlCheck)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.allHTTPHeaderFields = headers
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
            //            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    print(response.result.isSuccess)
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        completion(true, json)
                    } else {
                        completion(false, JSON.null)
                    }
                case .failure(let error):
                    print(response.result.error as Any)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
            }
    }
    
    
    func executeWithPack(url: String, listItemsCarShop : [ItemCarShoop], completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        var itemsCarShopPromoCode = ""
        var itineraryId = ""
        var itemsCarShopPackageId = 0
        var arrayOptionId : [[String : Any]] = [[String : Any]]()
        var optionId : [String : Any] = [String : Any]()
        
        for itemsCarShop in listItemsCarShop {
            
            if (itemsCarShop.itemProdProm.first?.principal ?? false) {
                itemsCarShopPromoCode = itemsCarShop.itemProdProm.first?.cupon_promotion ?? ""
                itemsCarShopPackageId = itemsCarShop.itemProdProm.first?.packageId ?? 0
            }
            
            if !(itemsCarShop.itemProdProm.first?.principal ?? false) {
                if itineraryId == "" {
                    itineraryId = itemsCarShop.itemDiaCalendario.productKey ?? ""
                }else{
                    itineraryId = "\(itineraryId)|\(itemsCarShop.itemDiaCalendario.productKey ?? "")"
                }
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let dateFormatterPrint = DateFormatter()
                let locat = Constants.LANG.current == "es" ? "es_MX" : "en_US"
                dateFormatterPrint.locale = Locale(identifier: locat)
                dateFormatterPrint.dateFormat = "yyyy-MM-dd"
                let dateItem = dateFormatterGet.date(from: itemsCarShop.itemDiaCalendario.date)
                
                optionId = [
                    "OptionId" : itemsCarShop.itemDiaCalendario.rateKey.first?.rateKey ?? "",
                    "Date" : dateFormatterPrint.string(from: dateItem ?? Date()),
                    "Guests" : [
                        "Adults" : itemsCarShop.itemVisitantes.adulto,
                        "Children" : itemsCarShop.itemVisitantes.ninio,
                        "Infants" : itemsCarShop.itemVisitantes.infantes
                    ]
                ]
                arrayOptionId.append(optionId)
            }
        }
        
        
        
        let body: [String : Any] = [
            "Header":[
                "Channel": appDelegate.channelBuy,
                "ClientId": 0,
                "Language": Constants.LANG.current,
                "Currency": Constants.CURR.current.uppercased(),
                "Country": "mex",
//                "Mobile": true
            ],
            "PromoCode" : itemsCarShopPromoCode,//"HSBCXC1",
            "Package" : [
            "PackageId" : itemsCarShopPackageId,//1925,
            "ItineraryId" : itineraryId,//"Mjk1OjE6WENFUEw=|MzA2OjI6WFBFVEk=|MTU3NjoxMDpYT0VD",
                "Options" : arrayOptionId
            ]
        ]
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        
                if let json = json {
                    print(json)
                }
        //Configuramos el urlRequest
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
//        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonBody
        request.allHTTPHeaderFields = headers
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
//            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    print(response.result.isSuccess)
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(response.result.error as Any)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
        
    }
    
    
    func executeWithCalendar(url: String, prod: ItemProdProm, reCotizacion : Bool = false, mes : Int, year : Int, day : Int, itemProductsCarShop : ProductsCarShop = ProductsCarShop(), completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]

        let diasMes = Constants.CALENDAR.diasMes
//        let date = Date()
//        let calendario = Calendar.current
//        var mesSiguiente = calendario.component(.month, from: date)
        
        
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(year: year, month: mes, day: day, hour: 0, minute: 0, second: 0)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es")
        formatter.dateFormat = "yyyy-MM-dd"
        let fechaHoy = formatter.string(from: calendar.date(from: components)!)
        
        let calendarSiguiente = Calendar(identifier: .gregorian)
        let componentsSiguiente = DateComponents(year: year, month: mes, day: diasMes[mes - 1], hour: 0, minute: 0, second: 0)
        let formatterSiguiente = DateFormatter()
        formatterSiguiente.locale = Locale(identifier: "es")
        formatterSiguiente.dateFormat = "yyyy-MM-dd"
        var fechaSiguiente = formatterSiguiente.string(from: calendarSiguiente.date(from: componentsSiguiente)!)
        
        var promocode = ""
        if prod.cupon_promotion != nil {
            promocode = prod.cupon_promotion
        }
        
        var adults = 1
        var children = 1
        var infants = 1
        
        if reCotizacion {
            fechaSiguiente = fechaHoy
            adults = itemProductsCarShop.productVisitor.productAdult
            children = itemProductsCarShop.productVisitor.productChild
            infants = itemProductsCarShop.productVisitor.productInfant
        }
        
        var mobile = false
        let channel = appDelegate.channelBuy
        if prod.code_promotion == "APP" {
            mobile = true
        }
        
        let current = appDelegate.listCurrencies.filter({ $0.currency == Constants.CURR.current})
        appDelegate.currencyShop = current.first?.country ?? "MEX"
        
        let body: [String : Any] = [
            "Header":[
                "Channel": channel,
                "ClientId": 0,
                "Language": Constants.LANG.current,
                "Currency": Constants.CURR.current.uppercased(),
                "Country": appDelegate.currencyShop,
                "Mobile": mobile
            ],
            "PromoCode": promocode,
            "Traveler": [
                "Dates": [
                    "From": fechaHoy,
                    "To": fechaSiguiente
                ],
                "Guests": [
                    "Adults" : adults,
                    "Children" : children,
                    "Infants" : infants
                ]
            ],
            "Filter": [
                "Activities": [prod.idProducto]
            ],
        ]
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        
                if let json = json {
                    print(json)
                }
        //Configuramos el urlRequest
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
//        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonBody
        request.allHTTPHeaderFields = headers
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
//            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    print(response.result.isSuccess)
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(response.result.error as Any)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
        
    }
    
    
    func executeWithRateKeyAllotment(url: String, itemCarShoop : ItemCarShoop, rt : String = "", completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        var mobile = false
        let channel = appDelegate.channelBuy
        if itemCarShoop.itemProdProm.first?.code_promotion == "APP" {
            mobile = true
        }
        
        var ratekey = itemCarShoop.itemDiaCalendario.rateKey.first?.rateKey ?? ""
        if rt != "" {
            ratekey = rt
        }
        
        let body: [String : Any] = [
            "Header":[
                "Channel": channel,
                "ClientId": 0,
                "Language": Constants.LANG.current,
                "Currency": Constants.CURR.current.uppercased(),
                "Country": appDelegate.currencyShop,
                "Mobile": mobile
            ],
            "PromoCode": itemCarShoop.itemProdProm.first?.cupon_promotion ?? "",
            "Activity": [
                "RateKey": ratekey,//itemCarShoop.itemDiaCalendario.rateKey.first?.rateKey ?? "",
                "Date": itemCarShoop.itemDiaCalendario.date,//"2021-09-14",
                "Guests": [
                    "Adults": itemCarShoop.itemVisitantes.adulto,
                    "Children": itemCarShoop.itemVisitantes.ninio,
                    "Infants" : itemCarShoop.itemVisitantes.infantes
                ]
            ]
        ]
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        
                if let json = json {
                    print(json)
                }
        //Configuramos el urlRequest
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
//        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonBody
        request.allHTTPHeaderFields = headers
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
//            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    print(response.result.isSuccess)
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(response.result.error as Any)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
        
    }
    
    
    
    func executeWithCancelAllotment(url: String, itemRateKey : String, mobile : Bool, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let mobile = mobile
        let channel = appDelegate.channelBuy
        
        let body: [String : Any] = [
            "Header":[
                "Channel": channel,
                "ClientId": 0,
                "Language": Constants.LANG.current,
                "Currency": Constants.CURR.current.uppercased(),
                "Country": appDelegate.currencyShop,
                "Mobile": mobile
            ],
            "Activity": [
                "RateKey": itemRateKey,
                "UseRFC": false,
                "TimeToLive": 0
            ]
        ]
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        
                if let json = json {
                    print(json)
                }
        //Configuramos el urlRequest
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
//        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonBody
        request.allHTTPHeaderFields = headers
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
//            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    print(response.result.isSuccess)
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(response.result.error as Any)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
        
    }
    
    
    func executeWithReservedAllotment(url: String, itemCarShoop : ItemCarShoop, rateKey : String, time : String = "minimo", completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        
        var mobile = false
        let channel = appDelegate.channelBuy
        if itemCarShoop.itemProdProm.first?.code_promotion == "APP" {
            mobile = true
        }
        
        var timeToLive = 5
        if time == "minimo" {
            timeToLive = appDelegate.timeToLiveMinimo
        }else if time == "maximo" {
            timeToLive = appDelegate.timeToLiveMaximo
        }
        
        
        let body: [String : Any] = [
            "Header":[
                "Channel": channel,
                "ClientId": 0,
                "Language": Constants.LANG.current,
                "Currency": Constants.CURR.current.uppercased(),
                "Country": appDelegate.currencyShop,
                "Mobile": mobile
            ],
            "PromoCode": itemCarShoop.itemProdProm.first?.cupon_promotion ?? "",
            "Activity": [
                "RateKey": rateKey,
                "UseRFC": false,
                "TimeToLive": 1800//timeToLive
            ]
        ]
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        
                if let json = json {
                    print(json)
                }
        //Configuramos el urlRequest
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
//        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonBody
        request.allHTTPHeaderFields = headers
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
//            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    print(response.result.isSuccess)
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(response.result.error as Any)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
        
    }
    
    func executeWithBanksInfo(url: String, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        
        let headers = [
            "Token": appDelegate.bookingConfig.api_mop_token!,//"ABh7a67GciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.987ayYuAiOjE1NjIxNzI4MDE88ui7lzcyI6Imh0dHBzOi8vYXBpc2l2ZXgueGIHnj870LmNvb998yiLCJhdWQiOiJodHRwczovL2FwaXNpdmV4LnhjYXJldC5jb20vIn0.nbARppP5UEW6f6Uife4ClyT-mS5ouaKedCcLOIn",//appDelegate.paramSettings.api_mop_token,
            "Username": appDelegate.bookingConfig.api_mop_user!,//"app",//appDelegate.paramSettings.api_mop_user,
            "Password": appDelegate.bookingConfig.api_mop_pass!//"3AZn8=df?x4jr<r3O(U+t=u^"//appDelegate.paramSettings.api_mop_pass
        ]
        
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
//            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    print(response.result.isSuccess)
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(response.result.error as Any)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
    }
    
    func executeWithGetInfoBuy(url: String, itemsCarShoop : [ItemCarShoop], buyItem : ItemCarshop, itemLocations : [ItemLocations] = [ItemLocations](), completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        
        let ISOCountry: String = itemsCarShoop.first?.itemComprador.ladaValuetextF.iso ?? ""
        var activities : Dictionary = [String : Any]()
        var visitors : Dictionary = [String : Any]()
        var cards : Dictionary = [String : Any]()
        var buyer : Dictionary = [String : Any]()
        var address : Dictionary = [String : Any]()
        var telephone : Dictionary = [String : Any]()
        var traveler : Dictionary = [String : Any]()
        var services : Dictionary = [String : Any]()
        var addons : Dictionary = [String : Any]()
        var packages : Dictionary = [String : Any]()//Foto
        var pickup : Dictionary = [String : Any]()
        var reservation: Dictionary = [String : Any]()
//        let ISO2Country: String = itemsCarShoop.itemComprador.ladaValuetextF.iso2
//        let date: String = "\(String(itemsCarShoop.itemDiaCalendario.year))-\(itemsCarShoop.itemDiaCalendario.mes + 1)-\(String(itemsCarShoop.itemDiaCalendario.diaNumero))"
        
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        visitors = [
            "namePrefix" : itemsCarShoop.first?.itemVisitanteCompra.titleValueTextF.value ?? "",//"Mrs.",
            "firstName": itemsCarShoop.first?.itemVisitanteCompra.nameValueTextF ?? "",
            "lastName": itemsCarShoop.first?.itemVisitanteCompra.apellidoValueTextF ?? "",
            "secondLastName": "",
            "fullName": "\(itemsCarShoop.first?.itemVisitanteCompra.nameValueTextF ?? "") \(itemsCarShoop.first?.itemVisitanteCompra.apellidoValueTextF ?? "")",//"TEST APP",
            "email": itemsCarShoop.first?.itemVisitanteCompra.emailValueTextF ?? "",//"test-accept@xcaret.com",
            "clientType" : 1,
            "telephone": [
                "telephoneClass": 1,
                "number": itemsCarShoop.first?.itemVisitanteCompra.telefonoValueTextF ?? ""//"5536568972"
            ],
            "address": [
                "city": itemsCarShoop.first?.itemVisitanteCompra.ciudadvalueTextF ?? "",//"CANCUN",
                "street": "",
                "countryId": itemsCarShoop.first?.itemVisitanteCompra.paisValueTextF.id ?? "",//484,
                "stateId": itemsCarShoop.first?.itemVisitanteCompra.estadoValueTextF.id ?? "",//Qroo - 260,
                "postalCode": Int(itemsCarShoop.first?.itemVisitanteCompra.cpValueTextF ?? "0") ?? 0
            ]
        ]
        
//        var rateKeyAllotmen = itemsCarShoop.first?.itemDiaCalendario.rateKey.first?.rateKey
//        if buyItem.products.first?.productAllotment ?? false{
//            rateKeyAllotmen = itemsCarShoop.first?.allotment.rateKey ?? ""
//            if rateKeyAllotmen == "" {
//                rateKeyAllotmen = itemsCarShoop.first?.itemDiaCalendario.rateKey.first?.rateKey
//            }
//        }
        
        var rateKeyAllotmen = buyItem.products.first?.productApiRequest.activitiesRatekey
        
        if buyItem.products.first?.productTransport ?? false {
            print("Transporte true")
            
            let nameGeographic = itemsCarShoop.first?.itemComplementos.transporte.nameLoc.lowercased()
            let schedulePark = itemsCarShoop.first?.itemComplementos.transporte.time
            
            let locatiomHours = itemsCarShoop.first?.itemDiaCalendario.rateKey.filter({$0.nameGeographic.lowercased() == nameGeographic})
            let locationRK = locatiomHours?.first?.horarioPickup.filter({ $0.time == schedulePark })
            rateKeyAllotmen = locationRK?.first?.rateKey ?? ""
            
//            let locationsName = itemLocations.filter({$0.name == itemsCarShoop.first?.itemComplementos.transporte.nameLoc})
//            for itemlocationsName in locationsName {
//                let locationsID = itemlocationsName.itemLocation.filter({ $0.id == itemsCarShoop.first?.itemComplementos.transporte.id })
////                let locationspickupID = locationsID?.first?.pickUps.id
//                if locationsID.first?.pickUps.id == itemsCarShoop.first?.itemComplementos.transporte.pickUps.id {
//                    let srateKeyAllotmen = itemlocationsName.time
//                    let locatiomHours = itemsCarShoop.first?.itemDiaCalendario.rateKey.filter({$0.nameGeographic == itemlocationsName.name})
//                    let locationRK = locatiomHours?.first?.horarioPickup.filter({ $0.time == itemlocationsName.time })
//                    rateKeyAllotmen = locationRK?.first?.rateKey ?? ""
//                    print(srateKeyAllotmen)
//                }
//            }
        }
        
        if rateKeyAllotmen == "" {
            rateKeyAllotmen = buyItem.products.first?.productApiRequest.activitiesRatekey
        }
        
        
        activities = [
            "rateKey" : rateKeyAllotmen ?? "",//itemsCarShoop.first?.allotment.rateKey ?? "",//buyItem.products.first?.productApiRequest.activitiesRatekey ?? "",
            "amount": buyItem.discountPrice,
            "visitors" : [visitors]
        ]
        
        
        if buyItem.products.first?.productTransport ?? false {
            pickup = [
                "idHotelPickup": itemsCarShoop.first?.itemComplementos.transporte.pickUps.id ?? 0,//756811768,
                "hrPickup": itemsCarShoop.first?.itemComplementos.transporte.pickUps.time ?? "",//"07:15:00",
                "idHotel": itemsCarShoop.first?.itemComplementos.transporte.id ?? 0//337
            ]
            let pickupInServices = [
                "pickup": pickup
            ]
            activities.add(pickupInServices)
        }
        
        address = [
            "city": itemsCarShoop.first?.itemComprador.ciudadvalueTextF ?? "",//"CANCUN",
            "countryId": itemsCarShoop.first?.itemComprador.paisValueTextF.id ?? 0,//484,
            "stateId": itemsCarShoop.first?.itemComprador.estadoValueTextF.id ?? 0,//260,
            "postalCode": Int(itemsCarShoop.first?.itemComprador.cpValueTextF ?? "0") ?? 0,//77513,
            "street": ""
        ]
        
        telephone = [
            "telephoneClass": 1,
            "number": itemsCarShoop.first?.itemComprador.telefonoValueTextF ?? "",//"5536568972"
        ]
        
        buyer = [
            "fullName": "\(itemsCarShoop.first?.itemComprador.nameValueTextF ?? "") \(itemsCarShoop.first?.itemComprador.apellidoValueTextF ?? "")",//"TEST APP",
            "clientType" : 0,
            "namePrefix" : "",
            "secondlastName": "",
            "lastName": itemsCarShoop.first?.itemComprador.apellidoValueTextF ?? "",
            "firstName": itemsCarShoop.first?.itemComprador.nameValueTextF ?? "",
            "email": itemsCarShoop.first?.itemComprador.emailValueTextF ?? "",//"test-accept@xcaret.com",
            "address": address,
            "telephone" : telephone
        ]

        var cvv = itemsCarShoop.first?.itemCreditCard.creditCard.cvv ?? ""
        var cardNumber = itemsCarShoop.first?.itemCreditCard.creditCard.cardNumber ?? ""
        var month = itemsCarShoop.first?.itemCreditCard.creditCard.expirationDateMonth
        var year = itemsCarShoop.first?.itemCreditCard.creditCard.expirationDateYear
        
        if appDelegate.bookingXwitch {
            cvv = Encriptation.shared.encript(encript: itemsCarShoop.first?.itemCreditCard.creditCard.cvv ?? "") ?? ""
            cardNumber = Encriptation.shared.encript(encript: itemsCarShoop.first?.itemCreditCard.creditCard.cardNumber ?? "") ?? ""
            month = Encriptation.shared.encript(encript: itemsCarShoop.first?.itemCreditCard.creditCard.expirationDateMonth ?? "")
            year = Encriptation.shared.encript(encript: itemsCarShoop.first?.itemCreditCard.creditCard.expirationDateYear ?? "")
        }
        
        var mesessi = 1
        if itemsCarShoop.first?.itemCreditCard.bank.status ?? false {
            let msiOrder = itemsCarShoop.first?.itemCreditCard.bank.bankInstallments.sorted(by: { $0.installments < $1.installments })
            let indexMsi = itemsCarShoop.first?.itemCreditCard.bank.bankInstallmentsIndexSelect ?? 0
            mesessi = msiOrder?[indexMsi].installments ?? 1
        }
        
        cards = [
            "bankCharge":[
                "name": itemsCarShoop.first?.itemCreditCard.banks.banks.first?.bankName ?? "",//"HSBC",
                "id": itemsCarShoop.first?.itemCreditCard.banks.banks.first?.idBank ?? 0//8
            ],
            "paymentMethod": [
                "id": itemsCarShoop.first?.itemCreditCard.banks.banks.first?.idBank ?? 0,//8,
                "name": itemsCarShoop.first?.itemCreditCard.banks.banks.first?.bankName ?? ""//"HSBC"
            ],
            "cvv" : cvv,
            "msi" : mesessi,
            "transactionId": "",
            "buyer": buyer,
            "amount": buyItem.discountPrice,
            "cardNumber": cardNumber,
            "expireDate": [
                "month": month,
                "year": year
            ]
        ]
        
        traveler = [
            "namePrefix" : "",
            "firstName": itemsCarShoop.first?.itemVisitanteCompra.nameValueTextF ?? "",
            "lastName": itemsCarShoop.first?.itemVisitanteCompra.apellidoValueTextF ?? "",
            "fullName": "\(itemsCarShoop.first?.itemVisitanteCompra.nameValueTextF ?? "") \(itemsCarShoop.first?.itemVisitanteCompra.apellidoValueTextF ?? "")",//"TEST APP",
            "secondLastName": "",
            "email": itemsCarShoop.first?.itemVisitanteCompra.emailValueTextF ?? "",//"test-accept@xcaret.com",
            "clientType" : 1,
            "address": [
                "city": itemsCarShoop.first?.itemVisitanteCompra.ciudadvalueTextF ?? "",//"CANCUN",
                "street": "",
                "countryId": itemsCarShoop.first?.itemVisitanteCompra.paisValueTextF.id ?? 0,//484,
                "stateId": itemsCarShoop.first?.itemVisitanteCompra.estadoValueTextF.id ?? 0,//260,
                "postalCode": Int(itemsCarShoop.first?.itemVisitanteCompra.cpValueTextF ?? "0") ?? 0//77513
            ],
            "telephone": [
                "telephoneClass": 1,
                "number": itemsCarShoop.first?.itemVisitanteCompra.telefonoValueTextF ?? ""//"5536568972"
            ]
        ]
        
        if let res = buyItem.reservation {
            reservation = [
                "dsSalesId": res.dsSalesId,
                "salesId": res.salesId
            ]
            
            if res.saleIdInsure > 0 && !res.dsSaleIdInsure.isEmpty {
                reservation["dsSaleIdInsure"] = res.dsSaleIdInsure
                reservation["saleIdInsure"] = res.saleIdInsure
            }
        }
        
        services = [
            "activities" : [
                activities
            ],
        ]
        
        if (itemsCarShoop.first?.itemComplementos.seguroIKE.status ?? false) { //?? false &&  itemsCarShoop.first?.itemComplementos.fotos.status ?? false{
            addons = [
                "rateKey" : buyItem.products.first?.productApiRequest.addons_Ratekey ?? "",
                "amount" : buyItem.products.first?.productApiRequest.assistanceCarShop.amount ?? 0.0,
                "visitors" : [visitors]
            ]
            let addonsInServices = [
                "addons": [
                    addons,
                ],
            ]
            services.add(addonsInServices)
        }
        
        if (itemsCarShoop.first?.itemComplementos.fotos.status ?? false) { //?? false &&  itemsCarShoop.first?.itemComplementos.fotos.status ?? false{
            packages = [
//                "rateKey" : buyItem.products.first?.productApiRequest.photopassCarShop.optionId ?? "",
                "options": [
                    [
                        "optionId": buyItem.products.first?.productApiRequest.photopassCarShop.optionId ?? ""
                    ]
                ],
                "amount" : buyItem.products.first?.productApiRequest.photopassCarShop.amount ?? 0.0, 
                "visitors" : [visitors],
                "packageId": buyItem.products.first?.productApiRequest.photopassCarShop.packageId ?? 0,
                "itineraryId": buyItem.products.first?.productApiRequest.photopassCarShop.itineraryId ?? ""
            ]
            let photoInServices = [
                "packages": [
                    packages,
                ],
            ]
            services.add(photoInServices)
        }
        
        var mobile = false
        var promCode = buyItem.promotionId
        let channel = appDelegate.channelBuy
        if itemsCarShoop.first?.itemProdProm.first?.code_promotion == "APP" {
            mobile = true
            promCode = ""
        }
        for interface in WiFiAddress.enumerate() {
            print("\(interface.name):  \(interface.ip)")
        }
        
        var ipAddress = WiFiAddress.enumerate().filter({ $0.name == "en0"})
        if ipAddress.count == 0 {
            ipAddress = WiFiAddress.enumerate().filter({ $0.name == "pdp_ip0"})
        }

        var body: [String : Any] = [
            
            "header": [
                "language": Constants.LANG.current,
                "browserCookie": "",
                "ip": ipAddress.first?.ip ?? "127.0.0.1",
                "currency": Constants.CURR.current.uppercased(), //"MXN",
                "deviceTransactionId" : "876a34ad-a3bb-4c48-aeaa-60f6e2b9009d",
                "currencyId" : 2,
                "clientId": 0,
                "os" : "iOS",
                "app": "PARK",
                "browser" : "Dispositivo",
                "mobile": mobile,
                "country": appDelegate.currencyShop,
                "channel": channel,
                "appVersion": "\(Tools.shared.version() ?? "")(\(Tools.shared.build() ?? ""))",
                "osVersion" : "\(UIDevice.current.systemVersion)",
                "deviceModel": "\(UIDevice().type.rawValue)"
            ],
            "services": services,
            "device": [
                "id": 1,
                "name": "Mobile"
            ],
            "payments": [ 
                "cards": [
                    cards
                    ]
                ],
            "traveler" : traveler,
            "promotionCode": promCode ?? "",//buyItem.promotionId,//"INAPAM",
            "discount" : buyItem.saving,//0,
            "total" : buyItem.discountPrice//7136.49
        ]
        
        if let _ = buyItem.reservation {
            body["reservation"] = reservation
        }
        
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        
        if let json = json {
            print(json)
        }
        //Configuramos el urlRequest
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
        //        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonBody
        request.allHTTPHeaderFields = headers
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
            //            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    print(response.result.isSuccess)
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        print(json)
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(response.result.error as Any)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
            }
        
    }
    
    func executeValidateCarShop(url: String, itemsCarShoop : [ItemCarShoop], buyItem : ItemCarshop, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        
        var activities : Dictionary = [String : Any]()
        var services : Dictionary = [String : Any]()
        var addons : Dictionary = [String : Any]()
        var packages : Dictionary = [String : Any]()//Foto
        var pickup : Dictionary = [String : Any]()
        var arrayOptionId : [[String : Any]] = [[String : Any]]()
//        let ISO2Country: String = itemsCarShoop.itemComprador.ladaValuetextF.iso2
//        let date: String = "\(String(itemsCarShoop.itemDiaCalendario.year))-\(itemsCarShoop.itemDiaCalendario.mes + 1)-\(String(itemsCarShoop.itemDiaCalendario.diaNumero))"
        var itemPackages : Dictionary = [String : Any]()
        
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        
        if buyItem.products.count == 1 {
            
            //ACTIVIDAD
            var rateKeyAllotmen = itemsCarShoop.first?.itemDiaCalendario.rateKey.first?.rateKey
            if buyItem.products.first?.productAllotment ?? false{
                rateKeyAllotmen = itemsCarShoop.first?.allotment.rateKey ?? ""
            }
            
            if rateKeyAllotmen == "" {
                rateKeyAllotmen = itemsCarShoop.first?.itemDiaCalendario.rateKey.first?.rateKey
            }
            
            activities = [
                "RateKey" : rateKeyAllotmen ?? ""// itemsCarShoop.first?.allotment.rateKey ?? ""//buyItem.products.first?.productApiRequest.activitiesRatekey ?? "",
            ]
            
            if buyItem.products.first?.productTransport ?? false {
                pickup = [
                    "IdHotelPickup": itemsCarShoop.first?.itemComplementos.transporte.pickUps.id ?? 0,//756811768,
                    "HrPickup": itemsCarShoop.first?.itemComplementos.transporte.pickUps.time ?? "",//"07:15:00",
                    "IdHotel": itemsCarShoop.first?.itemComplementos.transporte.id ?? 0//337
                ]
                let pickupInServices = [
                    "Pickup": pickup
                ]
                activities.add(pickupInServices)
            }
            
            let addActivities = [
                "Activities" : [activities]
            ]
            services.add(addActivities)
            
            //IKE
            if (itemsCarShoop.first?.itemComplementos.seguroIKE.status ?? false) {
                addons = [
                    "RateKey" : buyItem.products.first?.productApiRequest.addons_Ratekey ?? "",
                ]
                
                let addAddon = [
                    "Addons": [
                        addons,
                    ],
                ]
                services.add(addAddon)
            }
            
            //PHOTO
            if (itemsCarShoop.first?.itemComplementos.fotos.status ?? false) {
                packages = [
                    "options": [
                        [
                            "optionId": buyItem.products.first?.productApiRequest.photopassCarShop.optionId ?? ""
                        ]
                    ],
                    "amount" : buyItem.products.first?.productApiRequest.photopassCarShop.amount ?? 0.0,
                    "packageId": buyItem.products.first?.productApiRequest.photopassCarShop.packageId ?? 0,
                    "itineraryId": buyItem.products.first?.productApiRequest.photopassCarShop.itineraryId ?? ""
                ]
                
                let photoInServices = [
                    "packages": [
                        packages,
                    ],
                ]
                services.add(photoInServices)
            }
            
        }
        
//        var rateKeyAllotmen = itemsCarShoop.first?.itemDiaCalendario.rateKey.first?.rateKey
//        if buyItem.products.first?.productAllotment ?? false{
//            rateKeyAllotmen = itemsCarShoop.first?.allotment.rateKey ?? ""
//        }
//
//        if buyItem.products.count == 1 {
//            activities = [
//                "RateKey" : rateKeyAllotmen ?? ""// itemsCarShoop.first?.allotment.rateKey ?? ""//buyItem.products.first?.productApiRequest.activitiesRatekey ?? "",
//            ]
//
//            if buyItem.products.first?.productTransport ?? false {
//                pickup = [
//                    "idHotelPickup": itemsCarShoop.first?.itemComplementos.transporte.pickUps.id ?? 0,//756811768,
//                    "hrPickup": itemsCarShoop.first?.itemComplementos.transporte.pickUps.time ?? "",//"07:15:00",
//                    "idHotel": itemsCarShoop.first?.itemComplementos.transporte.id ?? 0//337
//                ]
//                let pickupInServices = [
//                    "pickup": pickup
//                ]
//                activities.add(pickupInServices)
//            }
//        }else{
//
//        }
//
//
//        var itineraryId = ""
//        for itemProd in itemsCarShoop{
//            itineraryId = "\(itineraryId)|\(itemProd.itemDiaCalendario.productKey ?? "")"
//            print(itineraryId)
//
//        let optionid = [
//            "OptionId" : itemProd.itemDiaCalendario.rateKey.first?.rateKey,
//            ]
//
//            arrayOptionId.append(optionid)
//        }
//
//        itineraryId.remove(at: itineraryId.startIndex)
//
//        if buyItem.products.count == 1 {
//            services = [
//                "Activities" : [
//                    activities
//                ],
//            ]
//        }else{
//
//            services = [
//                "Packages" : [[
//                    "PackageId": 1925,
//                    "ItineraryId": itineraryId,
//                    "Options": arrayOptionId
//                ]],
//            ]
//        }
//
//
//
//        if (itemsCarShoop.first?.itemComplementos.seguroIKE.status ?? false) { //?? false &&  itemsCarShoop.first?.itemComplementos.fotos.status ?? false{
//            addons = [
//                "rateKey" : buyItem.products.first?.productApiRequest.addons_Ratekey ?? "",
//                "amount" : buyItem.products.first?.productApiRequest.assistanceCarShop.amount ?? 0.0,
//            ]
//
//            let addonsInServices = [
//                "addons": [
//                    addons,
//                ],
//            ]
//            services.add(addonsInServices)
//        }
//
//
//        if buyItem.products.count == 1 {
//            if (itemsCarShoop.first?.itemComplementos.fotos.status ?? false) {
//                packages = [
//                    "options": [
//                        [
//                            "optionId": buyItem.products.first?.productApiRequest.photopassCarShop.optionId ?? ""
//                        ]
//                    ],
//                    "amount" : buyItem.products.first?.productApiRequest.photopassCarShop.amount ?? 0.0,
//                    "packageId": buyItem.products.first?.productApiRequest.photopassCarShop.packageId ?? 0,
//                    "itineraryId": buyItem.products.first?.productApiRequest.photopassCarShop.itineraryId ?? ""
//                ]
//
//                let photoInServices = [
//                    "packages": [
//                        packages,
//                    ],
//                ]
//                services.add(photoInServices)
//            }
//        }
        
        var mobile = false
        let channel = appDelegate.channelBuy
        if itemsCarShoop.first?.itemProdProm.first?.code_promotion == "APP" {
            mobile = true
        }
//-CARSHOP CAMBIO
        let body: [String : Any] = [
            
            "Header": [
                "Channel":channel,
                "ClientId":0,
                "Country":appDelegate.currencyShop,
                "Language": Constants.LANG.current,
                "Currency": Constants.CURR.current.uppercased(),
                "Mobile":mobile
            ],
            "Services": services,
            "AdditionalInformation": [
                "Payments":[ [
                    "BankId": Int(itemsCarShoop.first?.itemCreditCard.itemCardInfo.idBanco ?? "0") ?? 0,//8
                    "PaymentMethodId": Int(itemsCarShoop.first?.itemCreditCard.itemCardInfo.paymentMethodCode ?? "0") ?? 0//7
                ]],
                "Device": [
                  "Id": 1,
                  "Name": "Mobile"
                ]
            ],
            "PromoCode": buyItem.promotionId
        ]
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        
        if let json = json {
            print(json)
        }
        //Configuramos el urlRequest
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
        //        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonBody
        request.allHTTPHeaderFields = headers
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
            //            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    print(response.result.isSuccess)
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        print(json)
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(response.result.error as Any)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
            }
        
    }
    
    
    
    func executeWithCardInfo(url: String, bin: String, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        
        let headers = [
            "Token": appDelegate.bookingConfig.api_mop_token!,//"ABh7a67GciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.987ayYuAiOjE1NjIxNzI4MDE88ui7lzcyI6Imh0dHBzOi8vYXBpc2l2ZXgueGIHnj870LmNvb998yiLCJhdWQiOiJodHRwczovL2FwaXNpdmV4LnhjYXJldC5jb20vIn0.nbARppP5UEW6f6Uife4ClyT-mS5ouaKedCcLOIn",//appDelegate.paramSettings.api_mop_token,
            "Username": appDelegate.bookingConfig.api_mop_user!,//"app",//appDelegate.paramSettings.api_mop_user,
            "Password": appDelegate.bookingConfig.api_mop_pass!,//"3AZn8=df?x4jr<r3O(U+t=u^",//appDelegate.paramSettings.api_mop_pass
            "bin": bin
        ]
        
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    print(response.result.isSuccess)
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(response.result.error as Any)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
    }
    
    
    func executeWithCardInfo2(url: String, bin: String, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        
        let headers = [
            "Token": appDelegate.bookingConfig.api_mop_token!,//"ABh7a67GciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.987ayYuAiOjE1NjIxNzI4MDE88ui7lzcyI6Imh0dHBzOi8vYXBpc2l2ZXgueGIHnj870LmNvb998yiLCJhdWQiOiJodHRwczovL2FwaXNpdmV4LnhjYXJldC5jb20vIn0.nbARppP5UEW6f6Uife4ClyT-mS5ouaKedCcLOIn",//appDelegate.paramSettings.api_mop_token,
            "Username": appDelegate.bookingConfig.api_mop_user!,//"app",//appDelegate.paramSettings.api_mop_user,
            "Password": appDelegate.bookingConfig.api_mop_pass!,//"3AZn8=df?x4jr<r3O(U+t=u^",//appDelegate.paramSettings.api_mop_pass
//            "bin": bin
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let body: [String : Any] = [
            "BinNumber": Int(bin) ?? 0
        ]
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        
        if let json = json {
            print(json)
        }
        
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
        request.httpBody = jsonBody
        request.allHTTPHeaderFields = headers
        
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    print(response.result.isSuccess)
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(response.result.error as Any)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
    }
    
    
    func executeWithLocations(url: String, rateKey : String, app : Bool, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        
        
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let body: [String : Any] = [
            "Header":[
            "Channel": appDelegate.channelBuy,
            "ClientId": 0,
            "Language": Constants.LANG.current,
            "Currency": Constants.CURR.current.uppercased(),
            "Country": appDelegate.currencyShop,
            "Mobile": app
            ],
            "Activity":
                  [
                    "RateKey": rateKey
                  ]
        ]
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        
                if let json = json {
                    print(json)
                }
        //Configuramos el urlRequest
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
//        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonBody
        request.allHTTPHeaderFields = headers
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
//            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    print(response.result.isSuccess)
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(response.result.error as Any)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
        
    }
    
    
    func executeWithPricePhotopass(url: String, itemsCarShoop : ItemCarShoop, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        
        let parkId = appDelegate.listAllParks.filter({ $0.uid == itemsCarShoop.itemProdProm.first?.key_park})
        let componentsId = parkId.first?.componentId
        let itemDia = itemsCarShoop.itemDiaCalendario
        let itemVisitante = itemsCarShoop.itemVisitantes

        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(year: itemDia.year, month: itemDia.mes + 1, day: itemDia.diaNumero, hour: 0, minute: 0, second: 0)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es")
        formatter.dateFormat = "yyyy-MM-dd"
        let fechaHoy = formatter.string(from: calendar.date(from: components)!)
        
        
        var mobile = false
        let channel = appDelegate.channelBuy
        if itemsCarShoop.itemProdProm.first?.code_promotion == "APP" {
            mobile = true
        }
        
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let body: [String : Any] = [
            "Header":[
                "Channel": appDelegate.channelBuy,
                "ClientId": 0,
                "Language": Constants.LANG.current,
                "Currency": Constants.CURR.current.uppercased(),
                "Country": appDelegate.currencyShop,
                "Mobile": mobile
            ],
            "Filters": [
                "Packages": [1806],
                "Components": [componentsId],
                "Location": 0
            ],
            "Traveler": [
                "Dates": [
                    "From": fechaHoy,
                    "To": fechaHoy
                ],
                "Guests": [
                    "Adults" : itemVisitante.adulto,
                    "Children" : itemVisitante.ninio,
                    "Infants" : 0
                ]
            ]
        ]
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        
                if let json = json {
                    print(json)
                }
        //Configuramos el urlRequest
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
//        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonBody
        request.allHTTPHeaderFields = headers
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
//            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    print(response.result.isSuccess)
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(response.result.error as Any)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
        
    }
    
    
    func executeWithPriceIKE(url: String, itemsCarShoop : ItemCarShoop, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]

        let itemDia = itemsCarShoop.itemDiaCalendario
        
        var mobile = false
        let channel = appDelegate.channelBuy
        if itemsCarShoop.itemProdProm.first?.code_promotion == "APP" {
            mobile = true
        }
        
        let body: [String : Any] = [
            "Header":[
                "Channel": appDelegate.channelBuy,
                "ClientId": 0,
                "Language": Constants.LANG.current,
                "Currency": Constants.CURR.current.uppercased(),
                "Country": appDelegate.currencyShop,
                "Mobile": mobile
            ],
            "Activity":
                [
                    "RateKey": itemDia.rateKey.first?.rateKey,
                    "Guests": [
                        "Adults" : itemsCarShoop.itemVisitantes.adulto,
                        "Children" : itemsCarShoop.itemVisitantes.ninio,
                        "Infants" : 0
                    ]
                ],
            
        ]
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        
                if let json = json {
                    print(json)
                }
        //Configuramos el urlRequest
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
//        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonBody
        request.allHTTPHeaderFields = headers
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
//            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    print(response.result.isSuccess)
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(response.result.error as Any)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
    }
    
    
    
    func executeWith(url: String, params: AnyObject ,user: String, pass: String, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        let jsonBody = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        
        if let json = json {
            print(json)
        }
        
        //Configuramos el urlRequest
        let urlRequest = URL(string: url)
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
            .authenticate(user: user, password: pass)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
        }
        
    }
    
    func executeWith(url: String, httpMethod: HTTPMethod, params: Parameters?, headers: [String: String], completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()) {
        let encoding = URLEncoding.httpBody
         Alamofire.request(url, method: httpMethod, parameters: params, encoding: encoding, headers: headers)
            .validate(statusCode: 200..<600)
            .responseJSON(completionHandler: { (response) in
         
                switch response.result {
                case .success:
                    
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false, JSON.null)
                }
                
         })
    }
    
    func execute(url: String, params: AnyObject, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()) {
        
            let jsonBody = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
            if let json = json {
                print(json)
            }
            
            //Configuramos el urlRequest
            let urlRequest = URL(string: url)
            var request = URLRequest(url: urlRequest!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Basic dWFwcG1vYmlsZTplWHBBcHAyMDE5", forHTTPHeaderField: "Authorization")
//            request.setValue("Basic dWFwcG1vYmlsZWdleDplWHBBcHAyMDE5", forHTTPHeaderField: "Authorization")
            request.httpBody = jsonBody
            
        
            Alamofire.request(request)
                .validate(statusCode: 200..<600)
                .responseJSON { (response) in
                    switch response.result {
                    case .success:
                        
                        if response.result.value != nil {
                            let json = JSON(response.result.value!)
                            
                            completion(true, json)
                        }
                        else {
                            completion(false, JSON.null)
                        }
                        
                    case .failure(let error):
                        print(error)
                        completion(false, JSON.null)
                    }
            }
    }
    
   
    
}
