//
//  PhotoDB.swift
//  XCARET!
//
//  Created by Angelica Can on 4/10/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

open class PhotoDB{
    static let shared = PhotoDB()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    var urlAPI : String {
//        get {
//            let url = self.appDelegate.bookingConfig.photo_url
//            return url!
//        }
//    }
    var urlAPINew : String {
        get {
            let url = self.appDelegate.bookingConfig.photo_api_url
            return url!
        }
    }
    
    var passwordAPI : String {
        get {
            let url = self.appDelegate.bookingConfig.photo_password
            return url!
        }
    }
    
    var userAPI : String {
        get {
            let url = self.appDelegate.bookingConfig.photo_user
            return url!
        }
    }
    
    var tokenAPI : String {
        get{
            let token = AppUserDefaults.value(forKey: .TokenPhotoAPI, fallBackValue: 0).stringValue
            return token
        }set {
            AppUserDefaults.save(value: newValue, forKey: .TokenPhotoAPI)
        }
    }
    
    var tokenIat : Double {
        get{
            let iat = AppUserDefaults.value(forKey: .TokenIat, fallBackValue: 0).doubleValue
            return iat
        }set{
            AppUserDefaults.save(value: newValue, forKey: .TokenIat)
        }
    }
    var tokenExp : Double {
        get{
            let exp = AppUserDefaults.value(forKey: .TokenExp, fallBackValue: 0).doubleValue
            return exp
        }set{
            AppUserDefaults.save(value: newValue, forKey: .TokenExp)
        }
    }
    
    func validateToken(completion: @escaping (Bool) ->()){
        var getToken : Bool = false
        
        //Validamos Que exista valor en el token
        if tokenExp > 0 {
            let startDate = Date()
            let dateExp = Date(timeIntervalSince1970: (tokenExp / 1000.0))
            print("hoy: \(startDate) - exp: \(dateExp)")
            
            if startDate > dateExp{
                getToken = true
            }
        }else{
            getToken = true
        }
        
        if getToken {
            self.getTokenPhotopass { (successToken) in
                completion(successToken)
            }
        }else{
            completion(true)
        }
    }
    
    
    
    func validateCode(code:String, completion: @escaping (Bool, ItemAlbum) ->()){
        var isValid : Bool = false
        let itemAlbum : ItemAlbum = ItemAlbum()
        let wsName = self.urlAPINew + "sale/GetCode"
        let parameters : [String : Any] = [
            "JoinedCode" : "\(code)"
        ]
        print(wsName)
        self.validateToken { (success) in
            APIRequest.shared.execute(url: wsName, token: self.tokenAPI, params: parameters as AnyObject) { (success, json) in
                if (success){
                    print(json)
                    isValid = json["IsValid"].boolValue
                    itemAlbum.isValid = json["IsValid"].boolValue
                    itemAlbum.isBook = json["IsBook"].boolValue
                    if isValid {
                        itemAlbum.visitDate = json["VisitDate"].stringValue
                        itemAlbum.expiresDate = json["ExpiresDate"].stringValue
                        if itemAlbum.isBook{
                            itemAlbum.totalPurchase = json["AvailableParks"].intValue
                        }
                        itemAlbum.code = code
                    }
                }
                completion(isValid, itemAlbum)
            }
        }
    }
    
    func getSelectedParks(code: String, completion: @escaping ([Int])-> ()){
        var parksSelected : [Int] = [Int]()
        let wsName = self.urlAPINew + "sale/GetSelectedParks"
        let parameters : [String : Any] = [
            "JoinedCode" : "\(code)"
        ]
        print(wsName)
        self.validateToken { (success) in
            APIRequest.shared.execute(url: wsName, token: self.tokenAPI, params: parameters as AnyObject) { (success, json) in
                if (success){
                    let dataParksSelected = json.arrayValue
                    for item in dataParksSelected {
                        let parkId = item["ParkID"].intValue
                        parksSelected.append(parkId)
                    }
                }
                completion(parksSelected)
            }
        }
    }
    
    func getAlbums(code:String, isBook : Bool, selectedList: [Int], completion: @escaping ([ItemAlbumDetail]) ->()){
        var listAlbum : [ItemAlbumDetail] = [ItemAlbumDetail]()
        let listParksNotAvailable : [Int] = self.getListParksNotAvalialable()
        let wsName = self.urlAPINew + "media/GetAlbum​"
        let parameters : [String : Any] = [
            "JoinedCode" : "\(code)"
        ]
        print(wsName)
        self.validateToken { (success) in
            APIRequest.shared.execute(url: wsName, token: self.tokenAPI, params: parameters as AnyObject) { (success, json) in
                if (success){
                    let dataAlbums = json.arrayValue
                    for item in dataAlbums {
                        var parkNotAvailable = false
                        let itemDetail : ItemAlbumDetail = ItemAlbumDetail()
                        itemDetail.visitDate = item["VisitDate"].stringValue
                        itemDetail.parkId = item["ParkID"].intValue
                        itemDetail.totalMedia = item["TotalMedia"].intValue
                        itemDetail.status = item["Status"].boolValue
                        if isBook {
                            //Si es HXMX (8) o es HXAR(11)
                            if itemDetail.parkId != 8 && itemDetail.parkId != 11 {
                                itemDetail.unlock = selectedList.contains(itemDetail.parkId) ? true : false
                            }
                        }
                        
                        //Si tenemos parques no disponibles
                        if listParksNotAvailable.count > 0 {
                            for park in listParksNotAvailable {
                                if itemDetail.parkId == park {
                                    parkNotAvailable = true
                                    break
                                }
                            }
                            if parkNotAvailable == false{
                                listAlbum.append(itemDetail)
                            }
                            
                        }else{
                            listAlbum.append(itemDetail)
                        }
                    }
                }
                completion(listAlbum)
            }
        }
    }
    
    
    func getListParksNotAvalialable() -> [Int]{
        let parksIDNotAvailable : String = appDelegate.bookingConfig.photo_parkID
        var listParks : [Int] = []
        if !parksIDNotAvailable.isEmpty{
            let arrayParks = parksIDNotAvailable.components(separatedBy: ",")
            for park in arrayParks{
                let myPark = Int(park) ?? 0
                if myPark > 0 {
                    listParks.append(myPark)
                }
            }
        }
        return listParks
    }
    
    func getPhotosReloaded(code: String, parkId: Int, current: Int = 0, completion: @escaping ([ItemPhoto], Int, Int) -> ()){
        var listPhotos : [ItemPhoto] = [ItemPhoto]()
        let wsName = self.urlAPINew + "media/GetPhotos"
        var currentPage : Int = current
        var totalPages : Int = 0
        
        let parameters : [String : Any] = [
            "JoinedCode" : code,
            "ParkID" : parkId,
            "Page" : current,
            "OrderBy" : 1,
            "PhotosPerPage" : 200
        ]
        
        print("WS - \(wsName)")
        print("parameters : \(parameters)")
        
        self.validateToken { (success) in
            print(success)
            APIRequest.shared.execute(url: wsName, token: self.tokenAPI, params: parameters as AnyObject) { (success, json) in
                if success{
                    if json["TotalPages"].exists() {
                        totalPages = json["TotalPages"].intValue
                        currentPage = json["CurrentPage"].intValue
                        if json["Photos"].exists(){
                            let dataPhotos = json["Photos"].arrayValue
                            for item in dataPhotos {
                                let itemPhoto : ItemPhoto = ItemPhoto()
                                itemPhoto.mediaID = item["MediaID"].intValue
                                itemPhoto.mini = item["Mini"].stringValue
                                itemPhoto.mink = item["Mink"].stringValue
                                itemPhoto.thumb = item["Thumb"].stringValue
                                itemPhoto.orig = item["Orig"].stringValue
                                listPhotos.append(itemPhoto)
                            }
                            completion(listPhotos, totalPages, currentPage)
                        }
                    }else{
                        completion(listPhotos, 0, 0)
                    }
                }
            }
        }
    }
    
    func saveAlbumUnlock(code: String, parkId: Int, completion: @escaping (Bool)->()){
        let wsName = self.urlAPINew + "sale/AddVisitPark"
        let parameters : [String : Any] = [
            "JoinedCode" : code,
            "ParkID" : parkId
        ]
        print(wsName)
        self.validateToken { (success) in
            APIRequest.shared.execute(url: wsName, token: self.tokenAPI, params: parameters as AnyObject) { (success, json) in
                if success{
                    print(json)
                    if json["Status"].exists(){
                        let status = json["Status"].boolValue
                        let totalParks = json["TotalParks"].intValue
                        completion(status)
                    }else{
                        completion(false)
                    }
                }else{
                    completion(false)
                }
            }
        }
    }
    
    func getTokenPhotopass(completion: @escaping(Bool)->()){
        let wsName = self.urlAPINew + "auth/Login"
        let parameters : [String: Any] = [
            "Username" : self.userAPI,
            "Password" : self.passwordAPI
        ]
        
        WebService.shared.executeWith(url: wsName, params: parameters as AnyObject) { (success, json) in
            if success{
                print(json)
                if json["token"].exists(){
                    print("token API: \(json["token"].stringValue)")
                    self.tokenAPI = json["token"].stringValue
                    self.tokenExp = json["exp"].doubleValue
                    self.tokenIat = json["iat"].doubleValue
                    completion(true)
                }else{
                    completion(false)
                }
            }else{
                completion(false)
            }
        }
        
    }
    
    func sendUrl(email: String, photoCode: String, completion: @escaping(Bool) -> ()){
        let wsName = self.urlAPINew + "media/SendUrlCode"
        //let wsName = "https://api.xcaret.photos/dev/" + "media/SendUrlCode"
        let parameters : [String: Any] = [
            "JoinedCode": photoCode,
            "VisitorEmail": email,
            "Shipping": true,
            "Lang": Constants.LANG.current.uppercased()
        ]
        self.validateToken { success in
            APIRequest.shared.execute(url: wsName, token: self.tokenAPI, params: parameters as AnyObject) { success, json in
                if success {
                    if json["Status"].exists() {
                        completion(json["Status"].boolValue)
                    } else {
                        completion(false)
                    }
                }else {
                    completion(false)
                }
            }
        }
    }
}
