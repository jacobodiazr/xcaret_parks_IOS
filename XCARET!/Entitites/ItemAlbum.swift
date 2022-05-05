//
//  ItemAlbum.swift
//  XCARET!
//
//  Created by Angelica Can on 4/10/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import Foundation
import SwiftyJSON


open class ItemAlbum {
    var code: String!
    var isBook : Bool
    var isValid : Bool!
    var dateRegister : String!
    var totalPurchase : Int!
    var totalUnlock : Int!
    var listAlbumesDet : [ItemAlbumDetail]!
    var visitDate : String!
    var expiresDate: String!
    var totalRest : Int! {
        get {
            return totalPurchase - totalUnlock
        }
    }
    
    var statusAlbum: TypeAlbumStatus! {
        get {
            var resultStatus : TypeAlbumStatus = .valid
            let daysVisited = self.getDaysVisited()
            let daysExpired = self.getDaysExpired()
            if ((self.visitDate != nil && !self.visitDate.isEmpty)
                    && (self.expiresDate != nil && !self.expiresDate.isEmpty)) {
                if daysExpired < 0 {
                    resultStatus = .expired
                }else if daysExpired >= 0 && daysExpired <= 15{
                    resultStatus = .commigExpired
                }else if daysVisited >= 0 && daysVisited <= 4{
                    resultStatus = .recentAdd
                }
            }else{
                resultStatus = .expired
            }
            
            return resultStatus //self.code == "XSK3NSFGFXJA" ? .commigExpired : .recentAdd
        }
    }

    init() {
        self.code = ""
        self.isBook = false
        self.dateRegister = ""
        self.totalPurchase = 0
        self.totalUnlock = 0
        self.listAlbumesDet = [ItemAlbumDetail]()
        self.visitDate = ""
        self.expiresDate = ""
        self.isValid = false
    }
    
    init(key: String, dictionary : Dictionary<String, AnyObject>){
        let json = SwiftyJSON.JSON(dictionary)
        self.code = key 
        self.isBook = json["book"].boolValue
        self.dateRegister = json["dateRegister"].stringValue
        self.expiresDate = json["expiresDate"].stringValue
        self.visitDate = json["visitDate"].stringValue
        self.totalPurchase = json["totalPurchase"].intValue
        self.totalUnlock = json["totalUnlock"].intValue
        self.isValid = json["isValid"].boolValue
        self.listAlbumesDet = [ItemAlbumDetail]()
        for(key, subJson) in json["albumsList"]{
            let itemDet : ItemAlbumDetail = ItemAlbumDetail()
            itemDet.uid = key
            itemDet.parkId = subJson["parkID"].intValue
            itemDet.totalMedia = subJson["totalMedia"].intValue
            itemDet.unlock = subJson["unlock"].boolValue
            itemDet.visitDate = subJson["visitDate"].stringValue
            self.listAlbumesDet.append(itemDet)
            self.listAlbumesDet = self.listAlbumesDet.sorted(by: { (id1, id2) -> Bool in
                return id1.parkId < id2.parkId
            })
        }
        
    }
    
    init(dictionary : Dictionary<String, AnyObject>){
        let json = SwiftyJSON.JSON(dictionary)
        self.code = json["code"].stringValue
        self.isBook = json["book"].boolValue
        self.dateRegister = json["visitDate"].stringValue
        self.totalPurchase = json["totalPurchase"].intValue
        self.totalUnlock = json["totalUnlock"].intValue
        self.listAlbumesDet = [ItemAlbumDetail]()
        for(key, subJson) in json["albumsList"]{
            let itemDet : ItemAlbumDetail = ItemAlbumDetail()
            itemDet.uid = key
            itemDet.parkId = subJson["parkID"].intValue
            itemDet.totalMedia = subJson["totalMedia"].intValue
            itemDet.unlock = subJson["unlock"].boolValue
            itemDet.visitDate = subJson["visitDate"].stringValue
            self.listAlbumesDet.append(itemDet)
            self.listAlbumesDet = self.listAlbumesDet.sorted(by: { (id1, id2) -> Bool in
                return id1.parkId < id2.parkId
            })
        }
    }
    
    func getDaysExpired() -> Int{
        //Validamos cuantos dias que visitó el parque
        var daysResult = 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if (self.expiresDate != nil && !self.expiresDate.isEmpty){
            let dateExpired = dateFormatter.date(from: self.expiresDate)
            let diffs = Calendar.current.dateComponents([.day], from: Date(), to: dateExpired!)
            daysResult = diffs.day ?? 0
        }
        return daysResult
    }
    
    func getDaysVisited() -> Int{
        //Validamos cuantos dias que visitó el parque
        var daysResult = 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if (self.visitDate != nil && !self.visitDate.isEmpty) {
            let dateVisited = dateFormatter.date(from: self.visitDate)
            let diffs = Calendar.current.dateComponents([.day], from: dateVisited!, to: Date())
            daysResult = diffs.day ?? 0
        }
        return daysResult
    }
    
    func getDaysAvailable() -> Int{
        var daysResult = 0
        //Validamos cuantos dias que visitó el parque
        if ((self.visitDate != nil && !self.visitDate.isEmpty)
                && (self.expiresDate != nil && !self.expiresDate.isEmpty)) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" //"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let dateVisited = dateFormatter.date(from: self.visitDate)
            
            let dateFormatterExp = DateFormatter()
            dateFormatterExp.dateFormat = "yyyy-MM-dd" //"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatterExp.locale = Locale(identifier: "en_US_POSIX")
            let dateExpired = dateFormatter.date(from: self.expiresDate)
            
            let diffs = Calendar.current.dateComponents([.day], from: dateVisited!, to: dateExpired!)
            daysResult = diffs.day ?? 0
        }
        
        
        return daysResult
    }
}

open class ItemAlbumDetail {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var uid: String!
    var parkId: Int!
    var visitDate : String!
    var totalMedia : Int!
    var unlock: Bool!
    var status: Bool!
    
    init() {
        self.uid = ""
        self.parkId = 0
        self.visitDate = ""
        self.totalMedia = 0
        self.unlock = true
        self.status = false
    }
    
    init(key: String, dictionary : Dictionary<String, AnyObject>){
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.parkId = json["parkID"].intValue
        self.visitDate = json["visitDate"].stringValue
        self.totalMedia = json["totalMedia"].intValue
        self.unlock = json["unlock"].boolValue
        self.status = json["Status"].boolValue
    }
    
    var getNameByParkId : String {
        get {
            print("Park code: \(self.parkId ?? 0)")
            if let park = appDelegate.listAllParksEnabled.first(where: {$0.photoCode == self.parkId!}){
                return park.name
            }else{
                return ""
            }
        }
    }
}

open class ItemPhoto {
    var mediaID : Int!
    var thumb : String!
    var mink : String!
    var mini : String!
    var orig : String!
    var isSelected : Bool!
    
    init(){
        self.mediaID = 0
        self.thumb = ""
        self.mink = ""
        self.mini = ""
        self.orig = ""
        self.isSelected = false
    }
}
