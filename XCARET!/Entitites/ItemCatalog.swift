//
//  File.swift
//  XCARET!
//
//  Created by Angelica Can on 12/5/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import Foundation
import SwiftyJSON
import GoogleMaps

let appDelegate = UIApplication.shared.delegate as! AppDelegate

open class ItemFavorite {
    var uid : String!
    var f_keyPark : String
    
    init(uid: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = uid
        //Verificamos si existe, lo asignamos
        //Si no, es un fav de XC
        if json["key_park"].exists(){
            self.f_keyPark = json["key_park"].stringValue
        }else{
            if let park = appDelegate.listAllParksEnabled.first(where: { $0.code == "XC"}){
                self.f_keyPark = park.uid
            }else{
                self.f_keyPark = ""
            }
        }
    }
    
    init(uid: String) {
        self.uid = uid
        self.f_keyPark = ""
    }
    
    init() {
        self.uid = ""
        self.f_keyPark = ""
    }
}

open class ItemSubFilter {
    var name: String!
    var sf_icon : String!
    var sf_code : String!
    
    init(name: String, sf_code: String, sf_icon: String) {
        self.name = name
        self.sf_code = sf_code
        self.sf_icon = sf_icon
    }
}

open class ItemFilterMap {
    var uid: String!
    var f_code: String!
    var f_icon: String!
    var f_order: Int!
    var f_type: String!
    var typeEntity : TypeEntity!
    var langs: [ItemLanguage]!
    var subFilter : [ItemSubFilter]!
    var f_keyPark : String!
    
    var getDetail: ItemLanguage {
        get {
            if let item = langs.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLanguage()
            }
        }
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.f_code = json["f_code"].stringValue
        self.f_icon = json["f_icon"].stringValue
        self.f_type = json["f_type"].stringValue
        self.f_order = json["f_order"].intValue
        self.f_keyPark = json["key_park"].stringValue
        
        //Vamos por los nombres por idioma
        self.langs = [ItemLanguage]()
        for(key, subJson) in json["langs"] {
            let itemLang : ItemLanguage = ItemLanguage()
            itemLang.isoLang = key
            itemLang.name = subJson["name"].stringValue
            langs.append(itemLang)
        }
    }
}

open class ItemMenu{
    var name: String!
    var code: String!
    var icon: String!
    var separatorHidden : Bool //Si se oculta el separador
    var submenu: [ItemSubmenu]!
    init() {
        self.name = ""
        self.code = ""
        self.icon = ""
        self.separatorHidden = false
        self.submenu = [ItemSubmenu]()
    }
    
    init(name : String, code: String, icon: String, separatorHidden: Bool = false, listSubmenu: [ItemSubmenu]) {
        self.name = name
        self.code = code
        self.icon = icon
        self.separatorHidden = separatorHidden
        self.submenu = listSubmenu
    }
}
open class ItemSubmenu{
    var name: String!
    var code: String!
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
}

open class ItemHome {
    var name: String!
    var subTitle : String!
    var description : String!
    var isMap : Bool!
    var listActivities : [ItemActivity]
    var listAdmissions : [ItemAdmission]
    var listEvents : [ItemEvents]
    var listXOStaticData : [ItemXOStaticData]
    var listXNStaticData : [ItemXNStaticData]
    var listAwards : [ItemAward]
    var parksHome : [ItemPark]
    var itemPark :  ItemPark
    var heightCV: CGFloat = 0.0
    var sizeCell : CGSize = CGSize(width: 150, height: 170)
    var typeCell : TypeCell
    var lineisHide: Bool
    var idEventFB : String!
    
    init(name: String, subTitle: String, description: String, isMap: Bool, listActivities: [ItemActivity] = [ItemActivity](), listEvents: [ItemEvents] = [ItemEvents](), heightCV: CGFloat, typeCell: TypeCell, sizeCell: CGSize, lineisHide : Bool, listAdmissions : [ItemAdmission] = [ItemAdmission](), listXOStaticData : [ItemXOStaticData] = [ItemXOStaticData](), listXNStaticData : [ItemXNStaticData] = [ItemXNStaticData](), listAwards : [ItemAward] = [ItemAward](), itemPark : ItemPark = ItemPark(), parkHome : [ItemPark] = [ItemPark]()) {
        self.name = name
        self.description = description
        self.isMap = isMap
        self.listActivities = listActivities
        self.heightCV = heightCV
        self.typeCell = typeCell
        self.sizeCell = sizeCell
        self.lineisHide = lineisHide
        self.listAdmissions = listAdmissions
        self.listEvents = listEvents
        self.listXOStaticData = listXOStaticData
        self.listXNStaticData = listXNStaticData
        self.listAwards = listAwards
        self.itemPark = itemPark
        self.parksHome = parkHome
    }
    
    init() {
        self.name = ""
        self.subTitle = ""
        self.isMap = false
        self.description = ""
        self.listActivities = [ItemActivity]()
        self.heightCV = 0.0
        self.typeCell = .cellActivity
        self.sizeCell = CGSize(width: 150, height: 170)
        self.lineisHide = false
        self.idEventFB = "NA"
        self.listAdmissions = [ItemAdmission]()
        self.listEvents = [ItemEvents]()
        self.listXOStaticData = [ItemXOStaticData]()
        self.listXNStaticData = [ItemXNStaticData]()
        self.listAwards = [ItemAward]()
        self.itemPark = ItemPark()
        self.parksHome = [itemPark]
    }
}

open class ItemShop {
    var name: String!
    var subTitle : String!
    var description : String!
    var parkPref : [ItemPark]
    var park : [ItemPark]
    var promotion : [Itemslangs]
    var tours : [ItemPark]
    var packs : [ItemPark]
    var heightCV: CGFloat = 0.0
    var sizeCell : CGSize = CGSize(width: 150, height: 170)
    var typeCell : TypeCellShop
    
    
    var isMap : Bool!
    var listActivities : [ItemActivity]
    var listAdmissions : [ItemAdmission]
    var listEvents : [ItemEvents]
    var listXOStaticData : [ItemXOStaticData]
    var listXNStaticData : [ItemXNStaticData]
    var listAwards : [ItemAward]
    var parksHome : [ItemPark]
    var itemPark :  ItemPark
    var lineisHide: Bool
    var idEventFB : String!
    
    init(name: String,
         subTitle: String,
         description: String,
         parkPref : [ItemPark] = [ItemPark](),
         park : [ItemPark] = [ItemPark](),
         promotion : [Itemslangs] = [Itemslangs](),
         tours : [ItemPark] = [ItemPark](),
         packs : [ItemPark] = [ItemPark](),
         heightCV: CGFloat,
         sizeCell: CGSize,
         typeCell: TypeCellShop,
         isMap: Bool, listActivities: [ItemActivity] = [ItemActivity](), listEvents: [ItemEvents] = [ItemEvents](), lineisHide : Bool, listAdmissions : [ItemAdmission] = [ItemAdmission](), listXOStaticData : [ItemXOStaticData] = [ItemXOStaticData](), listXNStaticData : [ItemXNStaticData] = [ItemXNStaticData](), listAwards : [ItemAward] = [ItemAward](), itemPark : ItemPark = ItemPark(), parkHome : [ItemPark] = [ItemPark]()) {
        self.name = name
        self.description = description
        self.parkPref = parkPref
        self.park = park
        self.promotion = promotion
        self.tours = tours
        self.packs = packs
        self.heightCV = heightCV
        self.typeCell = typeCell
        self.sizeCell = sizeCell
        
        self.isMap = isMap
        self.listActivities = listActivities
        self.lineisHide = lineisHide
        self.listAdmissions = listAdmissions
        self.listEvents = listEvents
        self.listXOStaticData = listXOStaticData
        self.listXNStaticData = listXNStaticData
        self.listAwards = listAwards
        self.itemPark = itemPark
        self.parksHome = parkHome
    }
    
    init() {
        self.name = ""
        self.subTitle = ""
        self.description = ""
        self.parkPref = [ItemPark]()
        self.park = [ItemPark]()
        self.promotion = [Itemslangs]()
        self.tours = [ItemPark]()
        self.packs = [ItemPark]()
        self.heightCV = 0.0
        self.typeCell = .cellPromotions
        self.sizeCell = CGSize(width: 150, height: 170)
        
        self.isMap = false
        self.listActivities = [ItemActivity]()
        self.lineisHide = false
        self.idEventFB = "NA"
        self.listAdmissions = [ItemAdmission]()
        self.listEvents = [ItemEvents]()
        self.listXOStaticData = [ItemXOStaticData]()
        self.listXNStaticData = [ItemXNStaticData]()
        self.listAwards = [ItemAward]()
        self.itemPark = ItemPark()
        self.parksHome = [itemPark]
    }
}

open class ItemSchedule {
    var uid : String!
    var s_duration: String!
    var s_time:String!
    var s_key_activity: String!
    var s_key_season: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.s_duration = json["s_duration"].stringValue
        if Tools.shared.isFormatHours24() {
            self.s_time = json["s_time24"].stringValue
        }else{
            self.s_time = json["s_time12"].stringValue
        }
        self.s_key_season = json["s_season"].stringValue
        self.s_key_activity = json["s_key_activity"].stringValue
    }
}

open class ItemNote {
    var icon: String!
    var name: String!
    var valueNote : String!
    
    init(_icon: String, _name: String, _valueNote: String) {
        self.icon = _icon
        self.name = _name
        self.valueNote = _valueNote
    }
}

open class ItemAward {
    var uid : String!
    var keyPark : String!
    var icon : String!
    var order : Int!
    var status : Bool!
    var langs : [ItemLanguage]!
    var detail: ItemLanguage {
        get {
            if let item = langs.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLanguage()
            }
        }
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.icon = json["icon"].stringValue
        self.keyPark = json["key_park"].stringValue
        self.order = json["order"].intValue
        self.status = json["status"].intValue == 1 ? true : false
        self.langs = [ItemLanguage]()
        for(key, subJson) in json["langs"] {
            let itemLang : ItemLanguage = ItemLanguage()
            itemLang.isoLang = key
            itemLang.name = subJson["name"].stringValue
            langs.append(itemLang)
        }
    }
}

open class ItemPark {
    var uid : String!
    var contact_phone : String!
    var image : String!
    var name : String!
    var score : Int!
    var code : String!
    var photoCode : Int!
    var p_type : String! //P = Parque, H = Hotel, T = Tour
    var product_name : String!
    var listAwards : [ItemAward]!
    var sivex_code: String!
    var order : Int
    var status : Bool
    var version_ios : String
    var bookingParams : String!
    var buy_status : Bool
    var home_preference : Bool
    var componentId : Int!
    var detail : ItemLangPark {
        get {
            if let item = langs.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLangPark()
            }
        }
    }
    
    var langs : [ItemLangPark]!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let listAllAwards = appDelegate.listAllAwards
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.contact_phone = json["contact_phone"].stringValue
        self.image = json["image"].stringValue
        self.name = json["name"].stringValue
        self.score = json["score"].intValue
        self.code = json["code"].stringValue.uppercased()
        self.photoCode = json["photo_code"].intValue
        self.p_type = json["type"].stringValue
        self.product_name = json["product_name"].stringValue
        self.sivex_code =  json["sivex_code"].stringValue
        self.order =  json["order"].intValue
        self.status = json["p_status"].boolValue
        self.version_ios = json["version_ios"].stringValue
        self.buy_status = json["buy_status"].boolValue
        self.home_preference = json["home_preference"].boolValue
        self.bookingParams = ""
        self.componentId = json["componentId"].intValue
        self.listAwards = [ItemAward]()
        if listAllAwards.count > 0 {
            self.listAwards = listAllAwards.filter({$0.keyPark == self.uid}).sorted(by: { (aw0, aw1) -> Bool in
                return aw0.order < aw1.order
            })
        }
        
        self.langs = [ItemLangPark]()
        for(key, subJson) in json["langs"] {
            let itemLang : ItemLangPark = ItemLangPark()
            itemLang.isoLang = key
            itemLang.description = subJson["description"].stringValue
            itemLang.include = subJson["include"].stringValue
            itemLang.recomendations = subJson["recomendations"].stringValue
            itemLang.slogan = subJson["slogan"].stringValue
            itemLang.address = subJson["address"].stringValue
            itemLang.p_schelude = subJson["p_schedule"].stringValue
            langs.append(itemLang)
        }
    }
    
    init() {
        self.uid = ""
        self.code = ""
        self.contact_phone = ""
        self.image = ""
        self.name = ""
        self.score = 0
        self.langs = [ItemLangPark]()
        self.product_name = ""
        self.sivex_code = ""
        self.order = 0
        self.status = false
        self.version_ios = "4.0"
        self.bookingParams = ""
        self.buy_status = false
        self.home_preference = false
        self.componentId = 0
    }
    
}

open class ItemSubcategory {
    var uid : String!
    var key_category : String
    var scat_code : String!
    var scat_colorHex : String!
    var scat_icon: String!
    var scat_image : String!
    var langs : [ItemLanguage]!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.key_category = json["key_category"].stringValue
        self.scat_code = json["scat_code"].stringValue
        self.scat_icon = json["scat_icon"].stringValue
        self.scat_image = json["scat_image"].stringValue
        self.scat_colorHex = json["scat_colorHex"].stringValue
        self.langs = [ItemLanguage]()
        for(key, subJson) in json["langs"] {
            let itemLang : ItemLanguage = ItemLanguage()
            itemLang.isoLang = key
            itemLang.name = subJson["name"].stringValue
            langs.append(itemLang)
        }
    }
    
    init() {
        self.uid = ""
        self.key_category = ""
        self.scat_colorHex = ""
        self.scat_icon = ""
        self.scat_image = ""
        self.scat_code = ""
        self.langs = [ItemLanguage]()
    }
    
    
}

open class ItemCategory {
    
    var uid: String!
    var cat_colorHex: String!
    var cat_icon: String!
    var cat_image: String!
    var cat_type: String!
    var cat_code: String!
    var langs : [ItemLanguage]!
    
    var getDetail: ItemLanguage {
        get {
            if let item = langs.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLanguage()
            }
        }
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.cat_colorHex = json["cat_colorHex"].stringValue
        self.cat_icon = json["cat_icon"].stringValue
        self.cat_image = json["cat_image"].stringValue
        self.cat_type = json["cat_type"].stringValue
        self.cat_code = json["cat_code"].stringValue
        self.langs = [ItemLanguage]()
        for(key, subJson) in json["langs"] {
            let itemLang : ItemLanguage = ItemLanguage()
            itemLang.isoLang = key
            itemLang.name = subJson["name"].stringValue
            langs.append(itemLang)
        }
    }
    
    init() {
        self.uid = ""
        self.cat_colorHex = ""
        self.cat_icon = ""
        self.cat_image = ""
        self.cat_type = ""
        self.cat_code = ""
        self.langs = [ItemLanguage]()
    }
}

open class ItemRestiction {
    var uid : String!
    var res_colorHex  : String!
    var res_icon  : String!
    var langs : [ItemLanguage]!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.res_colorHex = json["res_colorHex"].stringValue
        self.res_icon = json["res_icon"].stringValue
        self.langs = [ItemLanguage]()
        for(key, subJson) in json["langs"] {
            let itemLang : ItemLanguage = ItemLanguage()
            itemLang.isoLang = key
            itemLang.name = subJson["name"].stringValue
            langs.append(itemLang)
        }
    }
    
    
}

open class ItemRoute {
    var uid: String!
    var r_colorHex: String!
    var r_icon: String!
    var r_code: String!
    var r_keyPark: String!
    var langs: [ItemLanguage]!
    
    var getName : ItemLanguage {
        get {
            if let item = langs.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLanguage()
            }
        }
    }
    
    var getColorPoint : UIColor {
        get {
            var colorPin = UIColor()
            switch self.r_code {
            case "BLUE":
                colorPin = Constants.COLORS.MARKER_MAP.route_blue
            case "RED":
                colorPin = Constants.COLORS.MARKER_MAP.route_red
            case "BRICK":
                colorPin = Constants.COLORS.MARKER_MAP.route_brick
            case "WHITE":
                colorPin = Constants.COLORS.MARKER_MAP.route_white
            case "BLACK":
                colorPin = Constants.COLORS.MARKER_MAP.route_black
            case "GREEN":
                colorPin = Constants.COLORS.MARKER_MAP.route_green
            default:
                colorPin = Constants.COLORS.MARKER_MAP.activity
            }
            return colorPin
        }
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.r_colorHex = json["r_colorHex"].stringValue
        self.r_icon = json["r_icon"].stringValue
        self.r_code = json["r_code"].stringValue
        self.r_keyPark = json["key_park"].stringValue
        self.langs = [ItemLanguage]()
        for(key, subJson) in json["langs"] {
            let itemLang : ItemLanguage = ItemLanguage()
            itemLang.isoLang = key
            itemLang.name = subJson["name"].stringValue
            itemLang.color = subJson["color"].stringValue
            langs.append(itemLang)
        }
    }
    
    init() {
        self.uid = ""
        self.r_colorHex = ""
        self.r_icon = ""
        self.r_code = ""
        self.r_keyPark = ""
        self.langs = [ItemLanguage]()
    }
}


open class ItemSeason {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var uid: String!
    var sea_end : String
    var sea_start : String
    var name : String
    
    init(sufijo: String = "", key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.sea_end = json["sea_end"].stringValue
        self.sea_start = json["sea_start"].stringValue
        self.name = json["name"].stringValue
        self.validateHighSeason()
    }
    
    func validateHighSeason(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let dateNow = Date().string(format: "dd/MM/yyyy")
        let year = Date().string(format: "yyyy")
        let actual = formatter.date(from: dateNow)
        
        let inicial = formatter.date(from: "\(self.sea_start)/\(year)")
        let final = formatter.date(from: "\(self.sea_end)/\(year)")
        
        if actual!.isBetween(inicial!, and: final!) {
            if self.name == "H"{
                appDelegate.isHightSeason = true
            }
            
            if self.name == "DF"{
                appDelegate.isFunctionDouble = true
            }
        }
    }
}

open class ItemService {
    var uid: String!
    var key_category: String!
    var serv_colorHex: String!
    var serv_icon: String!
    var serv_code: String!
    var serv_keyPark: String!
    var langs: [ItemLanguage]!
    
    var getDetail : ItemLanguage {
        get {
            if let item = langs.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLanguage()
            }
        }
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.key_category = json["key_category"].stringValue
        self.serv_colorHex = json["serv_colorHex"].stringValue
        self.serv_icon = json["serv_icon"].stringValue
        self.serv_code = json["serv_code"].stringValue
        self.serv_keyPark = json["key_park"].stringValue
        
        self.langs = [ItemLanguage]()
        for(key, subJson) in json["langs"] {
            let itemLang : ItemLanguage = ItemLanguage()
            itemLang.isoLang = key
            itemLang.name = subJson["name"].stringValue
            langs.append(itemLang)
        }
    }
    
    init(){
        self.uid = ""
        self.serv_colorHex = ""
        self.serv_icon = ""
        self.serv_code = ""
        self.langs = [ItemLanguage]()
    }
}

open class ItemTag {
    var uid: String!
    var scat_colorHex: String!
    var scat_icon: String!
    var scat_code: String!
    var langs: [ItemLanguage]!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.scat_colorHex = json["scat_colorHex"].stringValue
        self.scat_icon = json["scat_icon"].stringValue
        self.scat_code = json["scat_code"].stringValue
        
        self.langs = [ItemLanguage]()
        for(key, subJson) in json["langs"] {
            let itemLang : ItemLanguage = ItemLanguage()
            itemLang.isoLang = key
            itemLang.name = subJson["name"].stringValue
            langs.append(itemLang)
        }
    }
}

open class ItemLegal {
    var code: String
    var details: [ItemLangLegal]
    var getInfo : ItemLangLegal {
        get {
            if let item = details.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLangLegal()
            }
        }
    }
    
    init() {
        self.code = ""
        self.details = [ItemLangLegal]()
    }
    
    init(dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.code = json["code"].stringValue
        self.details = [ItemLangLegal]()
        for(key, subJson) in json["langs"] {
            let item : ItemLangLegal = ItemLangLegal()
            item.title = subJson["title"].stringValue
            item.desc = subJson["text"].stringValue
            item.isoLang = key
            details.append(item)
        }
    }
}

open class ItemTagByActivity {
    var uid : String
    var key_activity : String!
    var key_tag : String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.key_activity = json["key_activity"].stringValue
        self.key_tag = json["key_tag"].stringValue
    }
    
    init() {
        self.uid = ""
        self.key_activity = ""
        self.key_tag = ""
    }
}

open class ItemRestrictionsByActivity {
    var uid : String
    var key_activity : String!
    var key_restriction : String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.key_activity = json["key_activity"].stringValue
        self.key_restriction = json["key_restriction"].stringValue
    }
}


open class ItemSubcategoryByActivity {
    var uid : String!
    var key_activity : String!
    var key_subcategory : String!
    init(key: String, dictionary : Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.key_activity = json["key_activity"].stringValue
        self.key_subcategory = json["key_subcategory"].stringValue
    }
}

open class ItemCategoryByActivity {
    var uid : String!
    var key_activity : String!
    var key_category : String!
    init(key: String, dictionary : Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.key_activity = json["key_activity"].stringValue
        self.key_category = json["key_category"].stringValue
    }
}

open class ItemServicesLocation {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var uid: String!
    var s_latitude: String!
    var s_longitude: String!
    var s_schedule12: String!
    var s_schedule24: String!
    var s_photo: String!
    var category : ItemCategory!
    var route : ItemRoute!
    var service : ItemService!
    var langs : [ItemLanguage]!
    var s_keyPark : String!
    var getDetail : ItemLanguage {
        get {
            if let item = langs.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLanguage()
            }
        }
    }
    
    var doubleLatitude: Double {
        get {
            return Double(self.s_latitude)!
        }
    }
    
    var doubleLongitude: Double{
        get {
            return Double(self.s_longitude)!
        }
    }
    
    func getLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.doubleLatitude, longitude: self.doubleLongitude)
    }
    
    init(){
        self.uid = ""
        self.s_latitude = ""
        self.s_longitude = ""
        self.s_schedule12 = ""
        self.s_schedule24 = ""
        self.s_photo = ""
        self.s_keyPark = ""
        self.category = ItemCategory()
        self.route = ItemRoute()
        self.service = ItemService()
        self.langs = [ItemLanguage]()
    }
    
    init(key: String, dictionary : Dictionary<String, AnyObject>) {
        let allCategories = appDelegate.listAllCategories
        let allRoutes = appDelegate.listAllRoutes
        let allServices = appDelegate.listAllServices
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.s_latitude = json["s_latitude"].stringValue
        self.s_longitude = json["s_longitude"].stringValue
        self.s_schedule12 = json["s_schedule12"].stringValue
        self.s_schedule24 = json["s_schedule24"].stringValue
        self.s_photo = json["s_photo"].stringValue
        self.s_keyPark = json["s_key_park"].stringValue
        //Vamos por la categoria
        let s_key_category = json["s_key_category"].stringValue
        category = ItemCategory()
        if !s_key_category.isEmpty{
            if let itemCategory : ItemCategory = allCategories.first(where: {$0.uid == s_key_category}){
                category = itemCategory
            }
        }
        
        //Vamos por la ruta
        let s_key_rout = json["s_key_rout"].stringValue
        route = ItemRoute()
        if !s_key_rout.isEmpty{
            if let itemRoute : ItemRoute = allRoutes.first(where: {$0.uid == s_key_rout}){
                route = itemRoute
            }
        }
        
        //Vamos por el servicio
        let s_key_service = json["s_key_service"].stringValue
        service = ItemService()
        if !s_key_service.isEmpty{
            if let itemService : ItemService = allServices.first(where: {$0.uid == s_key_service}){
                service = itemService
            }
        }
        
        //Vamos por los nombres
        self.langs = [ItemLanguage]()
        for(key, subJson) in json["langs"] {
            let itemLang : ItemLanguage = ItemLanguage()
            itemLang.isoLang = key
            itemLang.name = subJson["name"].stringValue
            langs.append(itemLang)
        }
    }
}

open class ItemActivity {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var uid: String!
    var act_image: String!
    var act_longitude: String!
    var act_latitude: String!
    var act_maxDeepMTS: String!
    var act_maxDeepFTS: String!
    var act_maxHeigthMTS: String!
    var act_maxHeigthFTS: String!
    var act_minAge: String!
    var act_capacity: String!
    var act_number: Int!
    var act_aditionalCost : Bool!
    var act_children : Bool!
    var act_handicapped : Bool!
    var act_new : Bool!
    var act_extra : Bool = false
    var act_status : Bool = false
    var act_tagsSearch : String!
    var act_duration: String!
    var act_keyPark : String!
    var act_order: Int!
    
    var details : ItemLangDetail {
        get {
            if let item = langs.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLangDetail()
            }
        }
    }
    
    var nameES : String {
        get {
            if let item = langs.first(where: {$0.isoLang == "es"}){
                return item.name
            }else{
                return ""
            }
        }
    }
    
    var numberMap : String {
        get {
            return String(self.act_number)
        }
    }
    
    var getSubcategory : ItemLanguage {
        get {
            if let item = subcategory.langs.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLanguage()
            }
        }
    }
    
    var getCategory : ItemLanguage {
        get {
            if let item = category.langs.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLanguage()
            }
        }
    }
    
    var getRestrictions : String {
        get {
            var restrictions = ""
            var indexList = 1
            for item in listRestrictions {
                if let rest = item.langs.first(where: {$0.isoLang == Constants.LANG.current}){
                    restrictions.append(contentsOf: "\u{2022} \(rest.name)\(indexList == listRestrictions.count ? "\n\n" : "\n")")
                    indexList += 1
                }
            }
            return restrictions
        }
    }
    

    var getRoute : ItemLanguage {
        get{
            if let item = route.langs.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLanguage()
            }
        }
    }
    
    var doubleLatitude: Double {
        get {
            return Double(self.act_latitude) ?? 0.0
        }
    }
    
    var doubleLongitude: Double{
        get {
            return Double(self.act_longitude) ?? 0.0
        }
    }
    
    var langs: [ItemLangDetail]!
    var listRestrictions: [ItemRestiction]!
    var listSchedules: [ItemSchedule]!
    var listTags: [ItemTag]!
    var listNotes : [ItemNote]!
    var gallery : [ItemPicture]!
    var category : ItemCategory!
    var subcategory : ItemSubcategory!
    var route : ItemRoute!
    
    init() {
        self.langs = [ItemLangDetail]()
        self.uid = ""
        self.act_image = ""
        self.act_longitude = ""
        self.act_latitude = ""
        self.act_maxDeepFTS = ""
        self.act_maxDeepMTS = ""
        self.act_maxHeigthFTS = ""
        self.act_maxHeigthMTS = ""
        self.act_minAge = ""
        self.act_capacity = ""
        self.act_number = 0
        self.act_children = false
        self.act_aditionalCost = false
        self.act_handicapped = false
        self.act_new = false
        self.act_status = false
        self.act_tagsSearch = ""
        self.act_keyPark = ""
        self.langs = [ItemLangDetail]()
        self.category = ItemCategory()
        self.route = ItemRoute()
        self.listRestrictions = [ItemRestiction]()
        self.listSchedules = [ItemSchedule]()
        self.listTags = [ItemTag]()
        self.listNotes = [ItemNote]()
        self.gallery = [ItemPicture]()
        self.act_order = 0
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        
        let allRestrictions = appDelegate.listAllRestrictions
        let allCategories = appDelegate.listAllCategories
        let allRestByAct = appDelegate.listAllRestByActivity
        let allCateByAct = appDelegate.listAllCateByActivity
        let allSchedule = appDelegate.listAllSchedules
        let allScheduleDF = appDelegate.listAllSchedulesDF
        let allTags = appDelegate.listAllTags
        let allTagsByAct = appDelegate.listAllTagsByActivity
        let allRoutes = appDelegate.listAllRoutes
        let allSubcategories = appDelegate.listAllSubcategories
        let allSubByAct = appDelegate.listAllSubCatByActivity
        let allPictures = appDelegate.listPictures
        let allGallery = appDelegate.listGallery
        
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.act_image = json["act_image"].stringValue
        self.act_longitude = json["act_longitude"].stringValue
        self.act_latitude = json["act_latitude"].stringValue
        self.act_maxDeepMTS = json["act_maxDeepMTS"].stringValue
        self.act_maxDeepFTS = json["act_maxDeepFTS"].stringValue
        self.act_maxHeigthMTS = json["act_maxHeigthMTS"].stringValue
        self.act_maxHeigthFTS = json["act_maxHeigthFTS"].stringValue
        self.act_minAge = json["act_minAge"].stringValue
        self.act_capacity = json["act_capacity"].stringValue
        self.act_number = json["act_number"].intValue
        self.act_aditionalCost = json["act_aditionalCost"].intValue == 1 ? true : false
        self.act_children = json["act_children"].intValue == 1 ? true : false
        self.act_handicapped = json["act_handicapped"].intValue == 1 ? true : false
        self.act_new = json["act_new"].intValue == 1 ? true : false
        self.act_status = json["act_status"].intValue == 1 ? true : false
        self.act_keyPark = json["key_park"].stringValue
        self.act_order = json["act_order"].intValue
        
        //Vamos por el detalle
        self.langs = [ItemLangDetail]()
        for(key, subJson) in json["langs"] {
            let itemLang : ItemLangDetail = ItemLangDetail()
            itemLang.isoLang = key
            itemLang.name = subJson["name"].stringValue
            itemLang.description = subJson["description"].stringValue
            itemLang.include = subJson["include"].stringValue
            itemLang.warning = subJson["warning"].stringValue
            langs.append(itemLang)
        }
        
        //Vamos por las notas
        self.listNotes = [ItemNote]()
        if !self.act_capacity.isEmpty {
            listNotes.append(ItemNote(_icon: "Icons/svg/ic_personas", _name: "lbl_note_persons".getNameLabel()/*"lbNotePersons".localized()*/, _valueNote: "max \(self.act_capacity!)"))
        }
        if !self.act_minAge.isEmpty {
            listNotes.append(ItemNote(_icon: "Icons/svg/ic_ninos_edad", _name: "lbl_note_years_old".getNameLabel()/*"lblNoteYearsOld".localized()*/, _valueNote: "+ \(self.act_minAge!)"))
        }
        if !self.act_maxDeepFTS.isEmpty && !self.act_maxDeepMTS.isEmpty{
            let maxDeep = Constants.LANG.current == "es" ? "\(self.act_maxDeepMTS!)" : "\(self.act_maxDeepFTS!) fts"
            listNotes.append(ItemNote(_icon: "Icons/svg/ic_profundidad", _name: "lbl_note_deep".getNameLabel()/*"lblNoteDeep".localized()*/, _valueNote: maxDeep ))
        }
        if !self.act_maxHeigthFTS.isEmpty && !self.act_maxHeigthMTS.isEmpty{
            let maxHeight = Constants.LANG.current == "es" ? "+ \(self.act_maxHeigthMTS!)" : "+ \(self.act_maxHeigthFTS!) fts"
            listNotes.append(ItemNote(_icon: "Icons/svg/ic_altura", _name: "lbl_note_height".getNameLabel()/*"lblNoteHeight".localized()*/, _valueNote: maxHeight ))
        }
        
        //Vamos por la ruta
        self.route = ItemRoute()
        let key_route = json["act_rout"].stringValue
        if let route : ItemRoute = allRoutes.first(where: {$0.uid == key_route }){
            self.route = route
        }
        
        //Vamos por la categoria
        self.category = ItemCategory()
        if let category : ItemCategoryByActivity = allCateByAct.first(where: {$0.key_activity == key}){
            if !category.key_category.isEmpty{
                if let itemCategory = allCategories.first(where: {$0.uid == category.key_category}){
                    self.category = itemCategory
                    if itemCategory.cat_code.contains("AEXT"){
                        self.act_extra = true
                    }
                }
            }
        }
        
        //Vamos por la subcategoria
        self.subcategory = ItemSubcategory()
        if let subcategory : ItemSubcategoryByActivity = allSubByAct.first(where: {$0.key_activity == key}){
            if !subcategory.key_subcategory.isEmpty{
                if let itemSubcategory = allSubcategories.first(where: { $0.uid == subcategory.key_subcategory}){
                    self.subcategory = itemSubcategory
                }
            }
        }
        
        //Vamos por las restricciones
        //Inicializamos las restricciones
        self.listRestrictions = [ItemRestiction]()
        //Vamos por las restricciones de la actividad
        let restricByActivity = allRestByAct.filter({$0.key_activity == key})
        for item in restricByActivity {
            if let itemRestriction = allRestrictions.first(where: {$0.uid == item.key_restriction}){
                listRestrictions.append(itemRestriction)
            }
        }
        
        //Vamos por los horarios
        self.listSchedules = [ItemSchedule]()
        
        if appDelegate.isHightSeason{
            listSchedules = allSchedule.filter({$0.s_key_activity == key && $0.s_key_season == "H"}).sorted { (sch0, sch1) -> Bool in
                return sch0.s_time < sch1.s_time
            }
        }else{
            listSchedules = allSchedule.filter({$0.s_key_activity == key && $0.s_key_season != "H"}).sorted { (sch0, sch1) -> Bool in
                return sch0.s_time < sch1.s_time
            }
        }
        
        if appDelegate.isFunctionDouble{
            let listDF = allScheduleDF.filter({$0.s_key_activity == key}).sorted { (sch0, sch1) -> Bool in
                return sch0.s_time < sch1.s_time
            }
            if listDF.count > 0 {
                print("Doble funcion \(self.details.name)")
                listSchedules = listDF
            }
        }
        //Recorremos para guardar las diferentes duraciones
        self.act_duration = ""
        for schedule in listSchedules {
            if !schedule.s_duration.isEmpty{
                if !self.act_duration.contains(schedule.s_duration!){
                    self.act_duration = " \(schedule.s_duration ?? ""),"
                }
            }
        }
        
        //Vamos por los tags
        self.listTags = [ItemTag]()
        self.act_tagsSearch = ""
        //Vamos por los tags de la actividad
        let tagsByActivity = allTagsByAct.filter({ $0.key_activity == key})
        for item in tagsByActivity {
            if let itemTag = allTags.first(where: {$0.uid == item.key_tag}){
                for lang in itemTag.langs{
                    act_tagsSearch = act_tagsSearch + "\(lang.name) "
                }
                listTags.append(itemTag)
            }
        }
        
        //Vamos por la galería
        self.gallery = [ItemPicture]()
        let galleries = allGallery.filter({$0.key_activity == key})
        for picture in galleries {
            if let itemPicture = allPictures.first(where: {$0.uid == picture.key_picture}){
                self.gallery.append(itemPicture)
            }
        }
    }
    
    func getLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.doubleLatitude, longitude: self.doubleLongitude)
    }
}


open class ItemMapInfo {
    var uid : String!
    var latitude : Double!
    var longitude : Double!
    var defaultZoom : Float!
    var imgOverlay : String!
    var limitA_lat : Double!
    var limitA_long : Double!
    var limitB_lat : Double!
    var limitB_long : Double!
    var maxZoom : Float!
    var minZoom : Float!
    var overNE_lat : Double!
    var overNE_long : Double!
    var overSW_lat : Double!
    var overSW_long : Double!
    var m_keyPark : String!
    var radiusLimit : Double!
    
    var style : String {
        get{
            let keyCode = appDelegate.itemParkSelected.code!
            return MapInfoByPark().getStyle(keycode: keyCode)
        }
    }
    
    init() {
        uid = ""
        latitude = 0.0
        longitude = 0.0
        defaultZoom = 18
        imgOverlay = ""
        limitA_lat = 0.0
        limitA_long = 0.0
        limitB_lat = 0.0
        limitB_long = 0.0
        maxZoom = 19
        minZoom = 17
        overNE_lat = 0.0
        overNE_long = 0.0
        overSW_lat = 0.0
        overSW_long = 0.0
        m_keyPark = ""
        radiusLimit = 0.0
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        uid = key
        latitude = json["latitude"].doubleValue
        longitude = json["longitude"].doubleValue
        defaultZoom = json["defaultZoom"].floatValue
        imgOverlay = json["imgOverlay"].stringValue
        limitA_lat = json["bound1_lat"].doubleValue
        limitA_long = json["bound1_long"].doubleValue
        limitB_lat = json["bound2_lat"].doubleValue
        limitB_long = json["bound2_long"].doubleValue
        maxZoom = json["maxZoom"].floatValue
        minZoom = json["minZoom"].floatValue
        overNE_lat = json["overlay1_lat"].doubleValue
        overNE_long = json["overlay1_long"].doubleValue
        overSW_lat = json["overlay2_lat"].doubleValue
        overSW_long = json["overlay2_long"].doubleValue
        m_keyPark = json["key_park"].stringValue
        radiusLimit = json["radiusLimit"].doubleValue
    }
}

open class ItemDirectory{
    var name : String!
    var type : TypeDirectory
    var dataInfo : String
    var dataSend : String
    
    init(name: String, type : TypeDirectory = .phone, dataInfo : String, dataSend: String) {
        self.name = name
        self.type = type
        self.dataInfo = dataInfo
        self.dataSend = dataSend
    }
    
    init() {
        self.name = ""
        self.type = .phone
        self.dataInfo = ""
        self.dataSend = ""
    }
}

open class ItemContact {
    var uid: String!
    var email: String!
    var tel_english : String!
    var tel_spanish : String!
    var tel_usacan : String!
    
    init(){
        self.uid = ""
        self.tel_usacan = ""
        self.tel_english = ""
        self.tel_spanish = ""
        self.email = ""
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.tel_spanish = json["tel_spanish"].stringValue
        self.tel_english = json["tel_english"].stringValue
        self.tel_usacan = json["tel_usacan"].stringValue
        self.email = json["email"].stringValue
    }
}

open class ItemInfoHotel{
    var title : String!
    var subtitle: String!
    var typeCellHotel : TypeCellHotel
    var heighView : CGSize!
    var listDetailImages : [ItemDetailImages]!
    
    init() {
        self.title = ""
        self.subtitle = ""
        self.heighView = CGSize(width: 120, height: 120)
        self.typeCellHotel = .cellRooms
        self.listDetailImages = [ItemDetailImages]()
    }
}

open class ItemDetailImages{
    var name : String!
    var urlImage : String!
    
    init(name: String, urlImage: String) {
        self.name = name
        self.urlImage = urlImage
    }
    
    init() {
        self.name = ""
        self.urlImage = ""
    }
}

open class ItemCupon {
    var uid : String!
    var code : String!
    var description : String!
    var insidePark : Bool!
    var status : Bool
    var percent : Int
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.code = json["code"].stringValue
        self.description = json["description"].stringValue
        self.insidePark = json["insidePark"].intValue == 1 ? true : false
        self.status = json["status"].intValue == 1 ? true : false
        self.percent = json["percent"].intValue
    }
    
    init() {
        self.uid = ""
        self.code = ""
        self.description = ""
        self.insidePark = false
        self.status = false
        self.percent = 0
    }
}

open class ItemSection {
    var type: String!
    var totalElements : Int!
    var uid : String!
    
    init(type: String, totalElements: Int, uid: String = "") {
        self.type = type
        self.totalElements = totalElements
        self.uid = uid
    }
    
    init() {
        self.type = ""
        self.totalElements = 0
        self.uid = ""
    }
}


//open class ItemSectionHome {
//    var type: String!
//    var totalElements : Int!
//    var uid : String!
//    
//    init(type: String, totalElements: Int, uid: String) {
//        self.type = type
//        self.totalElements = totalElements
//        self.uid = uid
//    }
//    
//    init() {
//        self.type = ""
//        self.totalElements = 0
//        self.uid = ""
//    }
//}

open class ItemPicture {
    var uid : String!
    var photo : String!
    var langs : [ItemLangPicture]!
    
    var getDetail : ItemLangPicture {
        get {
            if let item = langs.first(where: { $0.isoLang == Constants.LANG.current }){
                    return item
            }else{
                return ItemLangPicture()
            }
        }
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.photo = json["photo"].stringValue
        
        self.langs = [ItemLangPicture]()
        for(key, subJson) in json["langs"]{
            let itemLang : ItemLangPicture = ItemLangPicture()
            itemLang.isoLang = key
            itemLang.name = subJson["name"].stringValue
            langs.append(itemLang)
        }
    }
}

open class ItemGallery {
    var uid: String!
    var key_activity: String!
    var key_picture: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.key_activity = json["key_activity"].stringValue
        self.key_picture = json["key_picture"].stringValue
    }
}

open class ItemNetworkParam {
    var uid: String!
    var params: String!
    var key_park : String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.params = json["params"].stringValue
        self.key_park = json["park_code"].stringValue
    }
}

open class ItemBookingConfig {
//    let uid: String
    let params : String!
    var dymanics : [String]!
    let url : String!
    let final_url : String!
    let sivex_url : String!
    let sivex_pass : String!
    let sivex_user: String!
    let step_one : String!
    let step_two : String!
    let wallet : Bool!
    let photo_url : String!
    let datamap_ios : String!
    let cognito_url : String!
    let profile_url : String!
    let photo_api_url : String!
    let photo_password: String!
    let photo_user: String!
    let photo_parkID: String!
    let url_ferries: String!
    let url_ferries_en: String!
    let api_activities_url: String!//N
    let api_carshop_url: String!
    let api_itinerary_url: String!//N //Sin usar
    let api_mop_pass: String!//N
    let api_mop_token: String!//N
    let api_mop_url : String!//N
    let bin_info_url : String!
    let api_mop_user : String!//N
    let channel_id : String!//N
    let password : String!//N //Sin usar
    let public_key_rsa : String!//N
    let sf_booking_engine : String!//N
    let user : String!//N //Sin usar
    
    init(dictionary: Dictionary<String, Any>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.url = json["url"]["value"].stringValue
        self.params = json["params"]["value"].stringValue
        self.final_url = json["final_url"]["value"].stringValue
        self.sivex_url = json["sivex_url"]["value"].stringValue
        self.sivex_pass = json["password"]["value"].stringValue
        self.sivex_user = json["user"]["value"].stringValue
        self.step_one = json["step_one"]["value"].stringValue
        self.step_two = json["step_two"]["value"].stringValue
        self.wallet = json["wallet"]["value"].boolValue
        self.photo_url = json["photo_url"]["value"].stringValue
        self.datamap_ios = json["datamap_ios"]["value"].stringValue
        self.cognito_url = json["cognito_url"]["value"].stringValue
        self.profile_url = json["profile_url"]["value"].stringValue
        
        /*Campos Generados para AWS API Photopass*/
        self.photo_api_url = json["photo_api_url"]["value"].stringValue
        self.photo_user = json["photo_user"]["value"].stringValue
        self.photo_password = json["photo_password"]["value"].stringValue
        self.photo_parkID = json["photo_parksID"]["value"].stringValue
        
        self.url_ferries = json["url_ferries"]["value"].stringValue//"https://www.xailing.com.com/es/ferry-isla-mujeres/"
        self.url_ferries_en = json["url_ferries_en"]["value"].stringValue
        
        self.api_activities_url = json["api_activities_url"]["value"].stringValue
        self.api_carshop_url = json["api_carshop_url"]["value"].stringValue
        self.api_itinerary_url = json["api_itinerary_url"]["value"].stringValue
        self.api_mop_pass = json["api_mop_pass"]["value"].stringValue
        self.api_mop_token = json["api_mop_token"]["value"].stringValue
        self.api_mop_url = json["api_mop_url"]["value"].stringValue
        self.api_mop_user = json["api_mop_user"]["value"].stringValue
        self.channel_id = json["channel_id"]["value"].stringValue
        appDelegate.channelBuy = Int(json["channel_id"]["value"].stringValue) ?? 0
        self.password = json["password"]["value"].stringValue
        self.public_key_rsa = json["public_key_rsa"]["value"].stringValue
        self.sf_booking_engine = json["sf_booking_engine"]["value"].stringValue
        self.user = json["user"]["value"].stringValue
        self.bin_info_url = json["bin_info_url"]["value"].stringValue
        
        //Obtengo los params dinamicos
        let dynamic = json["dynamic"]["value"].stringValue
        let tokens = dynamic.components(separatedBy: "|")
        self.dymanics = [String]()
        for item in tokens {
            print ("param \(item)")
            self.dymanics.append(item)
        }
    }
}

open class ItemAdmissionActivities{
    let uid: String
    let key_activity: String!
    let key_admission: String!
    let order: Int!
    let status: Int!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.key_activity = json["key_activity"].stringValue
        self.key_admission = json["key_admission"].stringValue
        self.order = json["order"].intValue
        self.status = json["status"].intValue
    }
}

open class ItemAdmission{
    let uid: String
    let ad_buy: Int!
    let ad_code: String!
    let ad_image: String!
    let ad_order: Int!
    var ad_primary_HEX: String!
    var ad_primary_RGB: String!
    var ad_secundary_HEX: String!
    var ad_secundary_RGB: String!
    let ad_status: Int!
    let key_park: String!
    
    let listAdmissionsActivities: [ItemAdmissionActivities]!
    var langs: [ItemLanguageAdmission]!
    
    var getDetail: ItemLanguageAdmission {
        get {
            if let item = langs.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLanguageAdmission()
            }
        }
    }
    
    var getDestiations : [ItemDestination]{
        get{
            let list = appDelegate.listDestByAdmission.filter({$0.key_admission == self.uid}).sorted(by: { (aw0, aw1) -> Bool in
                return aw0.name < aw1.name
            })
            return list
        }
    }
    
    init (){
        self.uid = ""
        self.ad_buy = 0
        self.ad_code = ""
        self.ad_image = ""
        self.ad_order = 1
        self.ad_primary_HEX = "#ffffff"
        self.ad_primary_RGB = "1|1|1"
        self.ad_secundary_HEX = "#ffffff"
        self.ad_secundary_RGB = "1|1|1"
        self.ad_status = 0
        self.key_park = ""
        self.listAdmissionsActivities = [ItemAdmissionActivities]()
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.ad_buy = json["ad_buy"].intValue
        self.ad_code = json["ad_code"].stringValue
        self.ad_image = json["ad_image"].stringValue
        self.ad_order = json["ad_order"].intValue
        self.ad_primary_HEX = json["ad_primary_HEX"].stringValue
        self.ad_primary_RGB = json["ad_primary_RGB"].stringValue
        self.ad_secundary_HEX = json["ad_secundary_HEX"].stringValue
        self.ad_secundary_RGB = json["ad_secundary_RGB"].stringValue
        self.ad_status = json["ad_status"].intValue
        self.key_park = json["key_park"].stringValue
        self.listAdmissionsActivities = appDelegate.listAdmissionsActivities.filter({$0.key_admission == key})
        
        self.langs = [ItemLanguageAdmission]()
        for(key, subJson) in json["lang"] {
            let itemLang : ItemLanguageAdmission = ItemLanguageAdmission()
            itemLang.isoLang = key
            itemLang.description = subJson["description"].stringValue
            itemLang.name = subJson["name"].stringValue
            itemLang.days = subJson["days"].stringValue
            itemLang.longDescription = subJson["longDescription"].stringValue
            itemLang.slogan = subJson["slogan"].stringValue
            itemLang.duration = subJson["duration"].stringValue
            itemLang.include = subJson["include"].stringValue
            itemLang.information = subJson["importantInfo"].stringValue
            itemLang.recomendations = subJson["recomendations"].stringValue
            
            langs.append(itemLang)
        }
        
    }
}

open class ItemEvents{
    let uid: String
    let ev_aditionalCost: Int!
    let ev_image: String!
    let ev_latitud: String!
    let ev_longitud: String!
    let ev_order: Int!
    var ev_phoneMX: String!
    var ev_phoneUS: String!
    var ev_status: Int!
    var key_park: String!
    var langs: [ItemLangDetail]!
    
    var getDetail: ItemLangDetail {
        get {
            if let item = langs.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLangDetail()
            }
        }
    }
    
    init(){
        self.uid = ""
        self.ev_aditionalCost = 0
        self.ev_image = ""
        self.ev_latitud = ""
        self.ev_longitud = ""
        self.ev_order = 0
        self.ev_phoneMX = ""
        self.ev_phoneUS = ""
        self.ev_status = 0
        self.key_park = ""
        self.langs = [ItemLangDetail]()
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.ev_aditionalCost = json["ev_aditionalCost"].intValue
        self.ev_image = json["ev_image"].stringValue
        self.ev_latitud = json["ev_latitud"].stringValue
        self.ev_longitud = json["ev_longitud"].stringValue
        self.ev_order = json["ev_order"].intValue
        self.ev_phoneMX = json["ev_phoneMX"].stringValue
        self.ev_phoneUS = json["ev_phoneUS"].stringValue
        self.ev_status = json["ev_status"].intValue
        self.key_park = json["key_park"].stringValue
        
        self.langs = [ItemLangDetail]()
        for(key, subJson) in json["lang"] {
            let itemLang : ItemLangDetail = ItemLangDetail()
            itemLang.isoLang = key
            itemLang.warning = subJson["warning"].stringValue
            itemLang.include = subJson["include"].stringValue
            itemLang.description = subJson["description"].stringValue
            itemLang.name = subJson["name"].stringValue
            langs.append(itemLang)
        }
        
    }
}

open class ItemXOStaticData{
    var image: String!
    var order: Int!
    var langs: [ItemLangDetail]!
    
    var getDetail: ItemLangDetail {
        get {
            if let item = langs.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLangDetail()
            }
        }
    }
    
    init() {
        self.image = ""
        self.order = 0
        self.langs = [ItemLangDetail]()
        
    }
    
    init(Json: JSON) {
        let json = SwiftyJSON.JSON(Json)
        self.image = json["image"].stringValue
        self.order = json["order"].intValue
        self.langs = [ItemLangDetail]()
        for(key, subJson) in json["lang"] {
            let itemLang : ItemLangDetail = ItemLangDetail()
            itemLang.isoLang = key
            itemLang.description = subJson["description"].stringValue
            itemLang.name = subJson["title"].stringValue
            langs.append(itemLang)
        }
    }
}

open class ItemXNStaticData{
    var image: String!
    var status: Int!
    var type: String
//    var order: Int!
    var langs: [ItemLangDetail]!
    
    var getDetail: ItemLangDetail {
        get {
            if let item = langs.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLangDetail()
            }
        }
    }
    
    init() {
        self.image = ""
//        self.order = 0
        self.status = 0
        self.type = ""
        self.langs = [ItemLangDetail]()
        
    }
    
    init(Json: JSON) {
        let json = SwiftyJSON.JSON(Json)
        self.image = json["image"].stringValue
        self.status = json["status"].intValue
        self.type = json["type"].stringValue
//        self.order = json["order"].intValue
        self.langs = [ItemLangDetail]()
        for(key, subJson) in json["lang"] {
            let itemLang : ItemLangDetail = ItemLangDetail()
            itemLang.isoLang = key
//            itemLang.description = subJson["description"].stringValue
            itemLang.name = subJson["name"].stringValue
            langs.append(itemLang)
        }
    }
}

open class ItemContentPrograms{
    var uid: String!
    var cont_imagen: String!
    var cont_order: Int!
    var cont_status: Int!
    var lang: [ItemLangContentPrograms]!
    
    var getDetail: ItemLangContentPrograms {
        get {
            if let item = lang.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLangContentPrograms()
            }
        }
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.cont_imagen = json["cont_imagen"].stringValue
        self.cont_order = json["cont_order"].intValue
        self.cont_status = json["cont_status"].intValue
        self.lang = [ItemLangContentPrograms]()
        
        for(key, subJson) in json["lang"] {
            let itemLang : ItemLangContentPrograms = ItemLangContentPrograms()
            itemLang.isoLang = key
            itemLang.description = subJson["cont_desc"].stringValue
            itemLang.name = subJson["cont_title"].stringValue
            lang.append(itemLang)
        }
        
    }
   
}

open class contentPrograms{
    var uid: String!
    var key_activity: String!
    var key_park: String!
    var pr_imagen: String!
    var pr_order: Int!
    var pr_status: Int!
    var lang: [ItemLangContentPrograms]!
    
    var getDetail: ItemLangContentPrograms {
        get {
            if let item = lang.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLangContentPrograms()
            }
        }
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.key_activity = json["key_activity"].stringValue
        self.key_park = json["key_park"].stringValue
        self.pr_imagen = json["pr_imagen"].stringValue
        self.pr_order = json["pr_order"].intValue
        self.pr_status = json["pr_status"].intValue
        self.lang = [ItemLangContentPrograms]()
        
        for(key, subJson) in json["lang"] {
            let itemLang : ItemLangContentPrograms = ItemLangContentPrograms()
            itemLang.isoLang = key
            itemLang.description = subJson["pr_desc"].stringValue
            itemLang.name = subJson["pr_title"].stringValue
            lang.append(itemLang)
        }
        
    }
   
}

//open class keyLabels{
//    var uid: String!
//    var lbl_key: String!
//
//    init(key: String, dictionary: Dictionary<String, AnyObject>) {
//        let json = SwiftyJSON.JSON(dictionary)
//        self.uid = key
//        self.lbl_key = json["lbl_key"].stringValue
//        }
//}


open class language{
    var uid: String!
    var lang_name: String!
    var lang_nativeName: String!
    var lang_status: Bool!
    var lang_threeLetterCode: String!
    var lang_twoLetterCode: String!
   
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.lang_name = json["lang_name"].stringValue
        self.lang_nativeName = json["lang_nativeName"].stringValue
        self.lang_status = json["lang_status"].boolValue
        self.lang_threeLetterCode = json["lang_threeLetterCode"].stringValue
        self.lang_twoLetterCode = json["lang_twoLetterCode"].stringValue
        }
}


open class langLabel{
    var uid: String!
    var name: String!
    var lbl_key: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.name = json["name"].stringValue
        self.lbl_key = json["lbl_key"].stringValue
    }
}

open class langProduct{
    var uid: String!
    var description: String!
    var key_lang: String!
    var key_product: String!
    var shortDescription: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.description = json["description"].stringValue
        self.key_lang = json["key_lang"].stringValue
        self.key_product = json["key_product"].stringValue
        self.shortDescription = json["shortDescription"].stringValue
    }
}




open class langActivity{
    var description: String!
    var include: String!
    var key_activity: String!
    var key_lang: String!
    var name: String!
    var warning: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.description = json["description"].stringValue
        self.include = json["include"].stringValue
        self.key_activity = json["key_activity"].stringValue
        self.key_lang = json["key_lang"].stringValue
        self.name = json["name"].stringValue
        self.warning = json["warning"].stringValue
    }
}

open class langBenefit{
    var description: String!
    var key_benefit: String!
    var key_lang: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.description = json["description"].stringValue
        self.key_benefit = json["key_benefit"].stringValue
        self.key_lang = json["key_lang"].stringValue
    }
}

open class langProgram{
    var key_lang: String!
    var key_program: String!
    var pr_title: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.key_lang = json["key_lang"].stringValue
        self.key_program = json["key_program"].stringValue
        self.pr_title = json["pr_title"].stringValue
    }
}

open class langPromotion{
    var description: String!
    var duration: String!
    var include: String!
    var info_window: String!
    var key_lang: String!
    var key_promotion: String!
    var months: String!
    var purchase_discount: String!
    var title: String!
    var warning: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.description = json["description"].stringValue
        self.duration = json["duration"].stringValue
        self.include = json["include"].stringValue
        self.info_window = json["info_window"].stringValue
        self.key_lang = json["key_lang"].stringValue
        self.key_promotion = json["key_promotion"].stringValue
        self.months = json["months"].stringValue
        self.purchase_discount = json["purchase_discount"].stringValue
        self.title = json["title"].stringValue
        self.warning = json["warning"].stringValue
    }
}

open class langServiceLocation{
    var key_lang: String!
    var key_servicesLocation: String!
    var name: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.key_lang = json["key_lang"].stringValue
        self.key_servicesLocation = json["key_servicesLocation"].stringValue
        self.name = json["name"].stringValue
    }
}

open class langTabOption{
    var key_lang : String!
    var key_tab_option : String!
    var name : String!
    var lang : String!
    
    init(key: String, lang : String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.key_lang = json["key_lang"].stringValue
        self.key_tab_option = json["key_tab_option"].stringValue
        self.name = json["name"].stringValue
        self.lang = lang
    }
}

open class langUdn{
    var address: String!
    var description: String!
    var include: String!
    var p_schedule: String!
    var recomendations: String!
    var slogan: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.address = json["address"].stringValue
        self.description = json["description"].stringValue
        self.include = json["include"].stringValue
        self.p_schedule = json["p_schedule"].stringValue
        self.recomendations = json["recomendations"].stringValue
        self.slogan = json["slogan"].stringValue
    }
}


open class dataLangLabel{
    var lbl_key: String!
    var name: String!
    
    init() {
        self.lbl_key = ""
        self.name = ""
        }
}


//open class Itemslangs {
//    var uid : String!
//    var itemLang : [AllItemslangs]!
//    init(key: String, dictionary: Dictionary<String, AnyObject>) {
//        self.uid = key
//        itemLang = [AllItemslangs]()
//            for prod in dictionary{
//                    let keyProd = prod.key
//                    let events = AllItemslangs(key: keyProd, dictionary: prod.value as! Dictionary<String, AnyObject>)
//                    itemLang.append(events)
//            }
//init(key: String, dictionary: Dictionary<String, AnyObject>) {
//    self.uid = key
//    itemLang = [String : AnyObject]()
//        for prod in dictionary{
//            itemLang.add([prod.key : prod.value])
//        }
//}
//    }
//}

open class Itemslangs {
    var uidProm: String!
    var uid : String!
    var currency: String!
    var description: String!
    var image: String!
    var include: String!
    var prod_code : String!
    var term_conditions: String!
    var title : String!
    var order : Int!
    var info_window : String!
    var months : String!
    var purchase_discount : String!
    var duration : String!
    var status : Bool!
    var key_category : String!
    var key_lang : String!
    var warning : String!
    var key_promotion : String!
    
    init(key: String, uidProm : String, dictionary: Dictionary<String, AnyObject>) {
        
        let aux = appDelegate.listPromotions
        print(aux)
        
        let json = SwiftyJSON.JSON(dictionary)
        
        let listPromotions = appDelegate.listPromotions.filter({$0.uid == json["key_promotion"].stringValue})
        
        if listPromotions.count > 0 {
            self.uidProm = uidProm
            self.uid = key
            self.currency = json["currency"].stringValue
            self.description = json["description"].stringValue
            self.image = listPromotions.first?.defaultImage //json["image"].stringValue
            self.include = json["include"].stringValue
            self.prod_code = listPromotions.first?.code//json["prod_code"].stringValue
            self.term_conditions = json["term_conditions"].stringValue
            self.title = json["title"].stringValue
            self.order = listPromotions.first?.order//json["order"].intValue
            self.info_window = json["info_window"].stringValue
            self.months = json["months"].stringValue
            self.purchase_discount = json["purchase_discount"].stringValue
            self.duration = json["duration"].stringValue
            self.status = Bool(integerLiteral: listPromotions.first?.status ?? 0)//json["status"].boolValue
            self.key_category = listPromotions.first?.key_category
            self.key_lang = json["key_lang"].stringValue
            self.warning = json["warning"].stringValue
            self.key_promotion = json["key_promotion"].stringValue
        }
    }
}


open class ItemsCatopcprom {
    var identifier: String!
    var uid: String!
    var key: String!
    var lang_Promo: String!
    var name: String!
    var order: Int!
    var status: Bool!
    
    init(key: String, uidProm : String ,dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = uidProm
        self.key = key
        self.identifier = json["identifier"].stringValue
        self.lang_Promo = json["lang_Promo"].stringValue
        self.name = json["name"].stringValue
        self.order = json["order"].intValue
        self.status = json["status"].boolValue
    }
    
    init() {
        self.uid = ""
        self.key = ""
        self.identifier = ""
        self.lang_Promo = ""
        self.name = ""
        self.order = 0
        self.status = false
    }
}

open class ItemsLangBenefit{
    var uid: String!
    var description: String!
    var image: String!
    var order: Int!
    var status: Bool!
    var promotion: String!
    
    init(key: String,dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.description = json["description"].stringValue
        self.image = json["image"].stringValue
        self.order = json["order"].intValue
        self.status = json["status"].boolValue
        self.promotion = json["promotion"].stringValue
    }
    
    init() {
        self.uid = ""
        self.description = ""
        self.image = ""
        self.order = 0
        self.status = false
        self.promotion = ""
    }
    
}


open class ItemsLangBenefitDesc{
    var uid: String!
    var description: String!
    var key_benefit: String!
    var key_lang: String!
    
    init(key: String,dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.description = json["description"].stringValue
        self.key_benefit = json["key_benefit"].stringValue
        self.key_lang = json["key_lang"].stringValue
    }
}


open class AllItemslangs{
    var item : [String : Dictionary<String, AnyObject>]
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        item = [String : Dictionary<String, AnyObject>]()
        item = [key : dictionary]
    }
    
    
}


open class ItemPrecios {
    var uid : String!
    var productos : [ItemProdProm]!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self.uid = key
        productos = [ItemProdProm]()
        for prod in dictionary{
            let keyProd = prod.key
            let events = ItemProdProm(key: keyProd, dictionary: prod.value as! Dictionary<String, AnyObject>)
            productos.append(events)
        }
    }
    
    init(){
        self.uid = ""
        self.productos = [ItemProdProm]()
    }
}

open class ItemCurrency {
    var uid : String!
    var country: String!
    var currency: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.country = json["country"].stringValue
        self.currency = json["currency"].stringValue
    }
    
    init(){
        self.uid = ""
        self.country = ""
        self.currency = ""
    }
}


open class ItemProdProm {
    var principal : Bool!
    var key : String!
    var uid : String!
    var packageId : Int!
    var descripcionEn : String!
    var descripcionFr : String!
    var descripcionIt : String!
    var descripcionPt : String!
    var descripcionRu : String!
    var descripcionEs : String!
    var descripcionDe : String!
    var status_product : Bool!
    var code_product : String!
    var unidadNegocio : String!
    var code_landing: String!
    var idProducto : Int!
    var cupon_promotion : String!
    var code_promotion : String!
    var code_park : String!
    var key_park : String!
    var distintivo : String!
    var extra_day : Int!
    var food: Int!
    var photopass : Int!
    var transportation: Int!
    var type_prod : String!
    var product_order : Int!
    var adulto : [ItemPrecio]!
    var menor : [ItemPrecio]!
    var product_childs : [ItemProduct_childs]!

    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.key = key
        self.uid = json["uid"].stringValue
        self.packageId = json["packageId"].intValue
        self.descripcionEn = json["descripcionEn"].stringValue
        self.descripcionFr = json["descripcionFr"].stringValue
        self.descripcionIt = json["descripcionIt"].stringValue
        self.descripcionPt = json["descripcionPt"].stringValue
        self.descripcionRu = json["descripcionRu"].stringValue
        self.descripcionEs = json["descripcionEs"].stringValue
        self.descripcionDe = json["descripcionDe"].stringValue
        self.status_product = json["status_product"].boolValue
        self.code_product = json["code_product"].stringValue
        self.unidadNegocio = json["unidadNegocio"].stringValue
        self.code_landing = json["code_landing"].stringValue
        self.idProducto = json["id_product"].intValue
        self.cupon_promotion = json["cupon_promotion"].stringValue
        self.code_promotion = json["code_promotion"].stringValue
        self.code_park = json["code_park"].stringValue
        self.key_park = json["key_park"].stringValue
        self.distintivo = json["distintivo"].stringValue
        self.extra_day = json["extra_day"].intValue
        self.food = json["food"].intValue
        self.photopass = json["photopass"].intValue
        self.transportation = json["transportation"].intValue
        self.type_prod = json["type_prod"].stringValue
        self.product_order = json["product_order"].intValue
        
        self.product_childs = [ItemProduct_childs]()
        if json["product_childs"].exists() {
            for(key, subJson) in json["product_childs"] {
                let productchilds : ItemProduct_childs = ItemProduct_childs()
                productchilds.key = subJson["key"].stringValue
                productchilds.value = subJson["value"].stringValue
                product_childs.append(productchilds)
            }
        }
        
        
        
        self.adulto = [ItemPrecio]()
        for(key, subJson) in json["adulto"] {
            let itemPrecio : ItemPrecio = ItemPrecio()
            itemPrecio.key = key
            itemPrecio.ahorro = subJson["ahorro"].intValue
            itemPrecio.tipoCambio = subJson["tipoCambio"].intValue
            itemPrecio.precio = subJson["precio"].doubleValue
            itemPrecio.precioDescuento = subJson["precioDescuento"].doubleValue
            itemPrecio.descuentoPrecompra = subJson["descuentoPrecompra"].intValue
            adulto.append(itemPrecio)
        }
        
        self.menor = [ItemPrecio]()
        for(key, subJson) in json["menor"] {
            let itemPrecio : ItemPrecio = ItemPrecio()
            itemPrecio.key = key
            itemPrecio.ahorro = subJson["ahorro"].intValue
            itemPrecio.tipoCambio = subJson["tipoCambio"].intValue
            itemPrecio.precio = subJson["precio"].doubleValue
            itemPrecio.precioDescuento = subJson["precioDescuento"].doubleValue
            itemPrecio.descuentoPrecompra = subJson["descuentoPrecompra"].intValue
            menor.append(itemPrecio)
        }
    }
    
    init() {
        self.principal = false
        self.key = ""
        self.uid = ""
        self.packageId = 0
        self.descripcionEn = ""
        self.descripcionEs = ""
        self.extra_day = 0
        self.food = 0
        self.photopass = 0
        self.transportation = 0
        self.status_product = false
        self.code_product = ""
        self.code_landing = ""
        self.idProducto = 0
        self.cupon_promotion = ""
        self.code_promotion = ""
        self.code_park = ""
        self.key_park = ""
        self.distintivo = ""
        self.type_prod = ""
    }
}

open class ItemPrecio {
    
    var key : String!
    var tipoCambio : Int!
    var ahorro : Int!
    var precio : Double!
    var precioDescuento : Double!
    var descuentoPrecompra : Int!
    
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.key = key
        self.tipoCambio = json["tipoCambio"].intValue
        self.ahorro = json["ahorro"].intValue
        self.precio = json["precio"].doubleValue
        self.precioDescuento = json["precioDescuento"].doubleValue
        self.descuentoPrecompra = json["descripcionEn"].intValue
    }
    
    init() {
        self.key = ""
        self.tipoCambio = 0
        self.ahorro = 0
        self.precio = 0.0
        self.precioDescuento = 0.0
        self.descuentoPrecompra = 0
    }

}


open class ItemProductos {
    var uid : String!
    var keyPark : String!
    var icon : String!
    var order : Int!
    var status : Bool!
    var langs : [ItemLanguage]!

    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.icon = json["icon"].stringValue
        self.keyPark = json["key_park"].stringValue
        self.order = json["order"].intValue
        self.status = json["status"].intValue == 1 ? true : false
        self.langs = [ItemLanguage]()
        for(key, subJson) in json["langs"] {
            let itemLang : ItemLanguage = ItemLanguage()
            itemLang.isoLang = key
            itemLang.name = subJson["name"].stringValue
            langs.append(itemLang)
        }
    }
}


//SALES


open class ItemBenefits {
    var uid : String!
    var icon : String!
    var status : Int!

    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.icon = json["icon"].stringValue
        self.status = json["status"].intValue
    }
}


open class ItemCategoryProduct {
    var uid : String!
    var code : String!
    var description : String!
    var status : Int!

    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.code = json["code"].stringValue
        self.description = json["description"].stringValue
        self.status = json["status"].intValue
    }
}

open class ItemCategoryPromotion {
    var uid : String!
    var code : String!
    var description : String!
    var status : Int!

    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.code = json["code"].stringValue
        self.description = json["description"].stringValue
        self.status = json["status"].intValue
    }
}

open class ItemCurrencies {
    var uid : String!
    var country : String!
    var currency : String!
    var decimal : String!
    var flag : String!
    var miles : String!
    var status : Int!
    var symbol : String!

    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.country = json["country"].stringValue
        self.currency = json["currency"].stringValue
        self.decimal = json["decimal"].stringValue
        self.flag = json["flag"].stringValue
        self.miles = json["miles"].stringValue
        self.status = json["status"].intValue
        self.symbol = json["symbol"].stringValue
    }
    
    init(){
        self.uid = ""
        self.country = ""
        self.currency = ""
        self.decimal = ""
        self.flag = ""
        self.miles = ""
        self.status = 0
        self.symbol = ""
    }
}

open class ItemProductPrices {
    var uid : String!
    var currencyChange : String!
    var key_currency : String!
    var key_product : String!
    var key_promotion : String!
    var paxType : String!
    var preBuyDiscount : String!
    var price : String!
    var priceDiscount : String!
    var saving : String!

    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.currencyChange = json["currencyChange"].stringValue
        self.key_currency = json["key_currency"].stringValue
        self.key_product = json["key_product"].stringValue
        self.key_promotion = json["key_promotion"].stringValue
        self.paxType = json["paxType"].stringValue
        self.preBuyDiscount = json["preBuyDiscount"].stringValue
        self.price = json["price"].stringValue
        self.priceDiscount = json["priceDiscount"].stringValue
        self.saving = json["saving"].stringValue
    }
}

open class DataProductPrices {
    
}

open class ItemProducts{
    var uid : String!
    var C : Int!
    var code_landing : String!
    var code_park : String!
    var code_product : String!
    var D : Int!
    var distintivo : String!
    var id_product : String!
    var order : Int!
    var P : Int!
    var status_product : Int!
    var T : Int!
    var type_prod : String!
    var uid_park : String!
    var base_product : Int!

    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.C = json["C"].intValue
        self.code_landing = json["code_landing"].stringValue
        self.code_park = json["code_park"].stringValue
        self.code_product = json["code_product"].stringValue
        self.D = json["D"].intValue
        self.distintivo = json["distintivo"].stringValue
        self.id_product = json["id_product"].stringValue
        self.order = json["order"].intValue
        self.P = json["P"].intValue
        self.status_product = json["status_product"].intValue
        self.T = json["T"].intValue
        self.type_prod = json["type_prod"].stringValue
        self.uid_park = json["uid_park"].stringValue
        self.base_product = json["base_product"].intValue
    }
}

open class ItemProductsPromotions{
    var uid : String!
    var key_product : String!
    var key_promotion : String!
    var packageId : Int!
    var status : Int!
    var product_childs : [ItemProduct_childs]!

    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.key_product = json["key_product"].stringValue
        self.key_promotion = json["key_promotion"].stringValue
        self.packageId = json["packageId"].intValue
        self.status = json["status"].intValue
        self.product_childs = [ItemProduct_childs]()
        if json["product_childs"].exists(){
            for(key, subJson) in json["product_childs"] {
                let itemproduct_childs : ItemProduct_childs = ItemProduct_childs()
                itemproduct_childs.key = key
                itemproduct_childs.value = subJson.rawString()
                product_childs.append(itemproduct_childs)
            }
        }
    }
    
    init() {
        self.packageId = 0
    }
}

open class ItemProduct_childs{
    var key : String!
    var value : String!
    
    init() {
        self.key = ""
        self.value = ""
    }
}

open class ItemPromotionBenefit{
    var uid : String!
    var key_benefit : String!
    var key_promotion : String!
    var order : Int!

    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.key_benefit = json["key_benefit"].stringValue
        self.key_promotion = json["key_promotion"].stringValue
        self.order = json["order"].intValue
    }
}

open class ItemPromotions{
    var uid : String!
    var code : String!
    var coupon : String!
    var defaultImage : String!
    var key_category : String!
    var order : Int!
    var status : Int!
    var topPreference : Int!

    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.code = json["code"].stringValue
        self.coupon = json["coupon"].stringValue
        self.defaultImage = json["defaultImage"].stringValue
        self.key_category = json["key_category"].string
        self.order = json["order"].intValue
        self.status = json["status"].intValue
        self.topPreference = json["topPreference"].intValue
    }
}

open class ItemPromotionTabOption{
    var uid : String!
    var status : Int!
    var key_promotion : String!
    var key_tabOption : String!

    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.status = json["status"].intValue
        self.key_promotion = json["key_promotion"].stringValue
        self.key_tabOption = json["key_tabOption"].stringValue
    }
}

open class ItemTabOption{
    var uid : String!
    var code : String!
    var showOrder : Int!
    var status : Int!

    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.code = json["code"].stringValue
        self.showOrder = json["showOrder"].intValue
        self.status = json["status"].intValue
    }
}


open class ItemTypeProduct{
    var uid : String!
    var code : String!
    var status : Int!

    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.code = json["code"].stringValue
        self.status = json["status"].intValue
    }
    
}

open class ItemTypex{
    var uid : String!
    var code : String!
    var status : Int!

    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.code = json["code"].stringValue
        self.status = json["status"].intValue
    }
}

open class ItemScheduleDest {
    var uid : String
    var schedule: String
    var uid_destination : String
    var status : Bool
    var order : Int
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.uid_destination = json["key_destination"].stringValue
        self.schedule = json["hour"].stringValue
        self.status = json["status"].boolValue
        self.order = 0
    }
}

open class ItemDestination{
    var uid: String!
    var key_admission: String!
    var name_image: String!
    var latitude: Double!
    var longitude: Double!
    var name: String!
    var status: Bool!
    var order: Int
    var lang: [ItemLangDestinations]!
    
    var getDetail: ItemLangDestinations {
        get {
            if let item = lang.first(where: {$0.isoLang == Constants.LANG.current}){
                return item
            }else{
                return ItemLangDestinations()
            }
        }
    }
    
    var getSchedules: [ItemScheduleDest] {
        get{
            let listSchelude = appDelegate.listScheduleDest.filter({$0.uid_destination == self.uid}).sorted(by: { (aw0, aw1) -> Bool in
                return aw0.schedule < aw1.schedule
            })
            return listSchelude
        }
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.uid = key
        self.key_admission = json["key_admission"].stringValue
        self.name_image = json["code"].stringValue
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["longitude"].doubleValue
        self.name = json["name"].stringValue
        self.status = json["status"].boolValue
        self.order = 0
        self.lang = [ItemLangDestinations]()
        
        for(key, subJson) in json["langs"] {
            let itemLang : ItemLangDestinations = ItemLangDestinations()
            itemLang.isoLang = key
            itemLang.address = subJson["address"].stringValue
            lang.append(itemLang)
        }
        
    }
    
    init(){
        self.uid = ""
        self.key_admission = ""
        self.name_image = ""
        self.latitude = 0.0
        self.longitude = 0.0
        self.name = ""
        self.status = false
        self.order = 0
        self.lang = [ItemLangDestinations]()
    }
   
}

open class ItemDiaCalendario{
    var disable : Int!
    var name : String!
    var code : String!
    var id : Int!
    var productKey : String!
    var mes : Int!
    var diaNumero : Int!
    var year : Int!
    var descuento : Int!
    var date : String!
    var amount : Double!
    var normalAmount : Double!
    var subtotalAdulto : Double!
    var ahorroAdulto : Double!
    var subtotalChildren : Double!
    var ahorroChildren : Double!
    var rateKey : [ItemRateKey]!
    var index : Int!
    var transport : Bool!
    var alimentos : Bool!
    var photo : Bool!
    var allotment : Allotment
    var family : Family
    var activitiesRatekey : String!
    var promotionApplied : PromotionApplied
    var allotmentAvail : AllotmentAvail
    

    init(disable : Int, name : String, code : String, id : Int, productKey : String, mes : Int, diaNumero : Int, year : Int, descuento : Int, date : String, amount : Double, normalAmount : Double, subtotalAdulto : Double, ahorroAdulto : Double, subtotalChildren : Double, ahorroChildren : Double, rateKey : [ItemRateKey], index : Int, transport : Bool, alimentos : Bool, photo : Bool, allotment : Allotment, family : Family, activitiesRatekey : String!, promotionApplied : PromotionApplied, allotmentAvail : AllotmentAvail){
        self.disable = disable
        self.productKey = productKey
        self.mes = mes
        self.diaNumero = diaNumero
        self.year = year
        self.descuento = descuento
        self.date = date
        self.normalAmount = normalAmount
        self.subtotalAdulto = subtotalAdulto
        self.ahorroAdulto = ahorroAdulto
        self.subtotalChildren = subtotalChildren
        self.ahorroChildren = ahorroChildren
        self.rateKey = rateKey
        self.index = index
        self.transport = transport
        self.alimentos = alimentos
        self.photo = photo
        self.allotment = allotment
        self.family = family
        self.activitiesRatekey = activitiesRatekey
        self.promotionApplied = promotionApplied
        self.allotmentAvail = allotmentAvail
}
    
    init(){
        self.disable = 1
        self.name = ""
        self.code = ""
        self.id = 0
        self.productKey = ""
        self.mes = 0
        self.diaNumero = 0
        self.year = 0
        self.descuento = 0
        self.date = ""
        self.amount = 0.0
        self.normalAmount = 0.0
        self.subtotalAdulto = 0.0
        self.ahorroAdulto = 0.0
        self.subtotalChildren = 0.0
        self.ahorroChildren = 0.0
        self.rateKey = [ItemRateKey]()
        self.index = -1
        self.transport = false
        self.alimentos = false
        self.photo = false
        self.allotment = Allotment()
        self.family = Family()
        self.activitiesRatekey = ""
        self.promotionApplied = PromotionApplied()
        self.allotmentAvail = AllotmentAvail()
    }
    
}

open class Family{
    var id : Int!
    var name : String!
    
    init() {
        self.id = 0
        self.name = ""
    }
}

open class PromotionApplied{
    var status : String!
    var message : String!
    var description : String!
    var detailStatus : DetailStatusPromotionApplied
    
    init(){
        self.status = "nodata"
        self.message = ""
        self.description = ""
        self.detailStatus = DetailStatusPromotionApplied()
    }
}

open class DetailStatusPromotionApplied {
    var description : String!
    var status : String!
    
    init(){
        self.description = ""
        self.status = ""
    }
}

open class Allotment{
    var status : Bool!
    var id : Int!
    var total : Int!
    var reserved : Int!
    var sold : Int!
    var avail : Int!
    
    init(){
        self.status = false
        self.id = 0
        self.total = 0
        self.reserved = 0
        self.sold = 0
        self.avail = 0
    }
}

open class ItemRateKey{
    var id : Int!
    var nameGeographic : String!
    var rateKey : String!
    var order : Int!
    var horarioPickup : [HorarioPickup]
    var amountLocation : AmountLocation
    
    init(id : Int, nameGeographic : String, rateKey : String, order : Int, horarioPickup : [HorarioPickup], amountLocation : AmountLocation) {
        self.id = id
        self.nameGeographic = nameGeographic
        self.rateKey = rateKey
        self.order = order
        self.horarioPickup = horarioPickup
        self.amountLocation = amountLocation
    }
    
    init(){
        self.id = 0
        self.nameGeographic = ""
        self.rateKey = ""
        self.order = 0
        self.horarioPickup = [HorarioPickup]()
        self.amountLocation = AmountLocation()
    }
}

open class AmountLocation {
    var amount : Double!
    var normalAmount : Double!
    var subtotalAdulto : Double!
    var ahorroAdulto : Double!
    var subtotalChildren : Double!
    var ahorroChildren : Double!
    
    init(){
        self.amount = 0.0
        self.normalAmount = 0.0
        self.subtotalAdulto = 0.0
        self.ahorroAdulto = 0.0
        self.subtotalChildren = 0.0
        self.ahorroChildren = 0.0
    }
}

open class HorarioPickup {
    var status : String!
    var time : String!
    var rateKey : String!
    
    init(status : String, time : String, rateKey : String) {
        self.status = status
        self.time = time
        self.rateKey = rateKey
    }
    
    init(){
        self.status = ""
        self.time = ""
        self.rateKey = ""
    }
}

open class ItemVisitantes{
    var adulto : Int!
    var ninio : Int!
    var infantes : Int!
    
    init(adulto : Int, ninio : Int, infantes : Int) {
        self.adulto = adulto
        self.ninio = ninio
        self.infantes = infantes
    }
    
    init(){
        self.adulto = 1
        self.ninio = 0
        self.infantes = 0
    }
    
}

open class ItemCarShoop{
    var status : Int!
    var keyItemEditCarShop : String!
    var availabilityStatus : Bool!
    var productAllotment : Bool!
    var allotment = ProdAllotment()
    var itemDiaCalendario = ItemDiaCalendario()
    var itemVisitantes = ItemVisitantes()
    var itemComplementos = ItemComplementos()
    var itemProdProm = [ItemProdProm]()
    var itemComprador = ItemUserShop()
    var itemVisitanteCompra = ItemUserShop()
    var itemCreditCard = ItemCreditCard()
    var dateOrder : String!
    
    init(status : Int, keyItemEditCarShop : String, availabilityStatus : Bool, productAllotment : Bool, allotment : ProdAllotment, itemDiaCalendario : ItemDiaCalendario, itemVisitantes : ItemVisitantes, itemComplementos : ItemComplementos, itemProdProm : [ItemProdProm], dateOrder : String!) {
        self.itemDiaCalendario = itemDiaCalendario
        self.itemVisitantes = itemVisitantes
        self.itemComplementos = itemComplementos
        self.itemProdProm = itemProdProm
        self.keyItemEditCarShop = keyItemEditCarShop
        self.availabilityStatus = availabilityStatus
        self.dateOrder = dateOrder
    }
    
    init(){
        self.status = 1
        self.keyItemEditCarShop = ""
        self.availabilityStatus = true
        self.productAllotment = false
        self.itemDiaCalendario = ItemDiaCalendario()
        self.itemVisitantes = ItemVisitantes()
        self.itemComplementos = ItemComplementos()
        self.itemProdProm = [ItemProdProm]()
        self.itemCreditCard = ItemCreditCard()
        self.allotment = ProdAllotment()
        self.dateOrder = ""
    }
}

open class ProdAllotment{
    var id : Int!
    var rateKey : String!
    var status : String!
    
    init() {
        self.id = 0
        self.rateKey = ""
        self.status = ""
    }
}

open class AllowedCustomerConfigPax{
    var children : Bool!
    var adults : Bool!
    var individual : Bool!
    var infants : Bool!
    
    init() {
        self.children = false
        self.adults = false
        self.individual = false
        self.infants = false
    }
}

open class ActivityAvail{
    var message : String!
    var status : String!
    var description : String!
    
    init() {
        self.message = ""
        self.status = ""
        self.description = ""
    }
}

open class AllotmentAvail{
    var allowedCustomerConfigPax = AllowedCustomerConfigPax()
    var activityAvail = ActivityAvail()
    var allotment : Bool!
    var rateKey : String!
    
    init() {
        self.allowedCustomerConfigPax = AllowedCustomerConfigPax()
        self.activityAvail = ActivityAvail()
        self.allotment = false
        self.rateKey = ""
    }
}

open class StatusBuy{
    var id : String!
    var idTicket : String!
    var enProceso : Bool!
    var statusVenta : BookingStatusCard
    
    init() {
        self.id = ""
        self.idTicket = ""
        self.enProceso = false
        self.statusVenta = .inProcessBuy
    }
}

open class ItemCreditCard{
    var creditCard : CreditCard
    var itemCardInfo : ItemCardInfo
    var banks : Banks
    var bank : Bank
    
    init(){
        self.creditCard = CreditCard()
        self.itemCardInfo = ItemCardInfo()
        self.banks = Banks()
        self.bank = Bank()
    }
}

open class CreditCard{
    var name: String
    var cardNumber: String
    var expirationDate : String
    var expirationDateMonth: String
    var expirationDateYear: String
    var cvv: String
    init(){
        self.name = ""
        self.cardNumber = ""
        self.expirationDate = ""
        self.expirationDateMonth = ""
        self.expirationDateYear = ""
        self.cvv = ""
    }
}

open class ItemLocations{
    var date : String!
    var id : Int!
    var name : String!
    var time : String!
    var itemLocation = [ItemLocation]()
    
    init(var date : String, id : Int, name : String, time : String, itemLocation : [ItemLocation]) {
        self.date = date
        self.id = id
        self.name = name
        self.time = time
        self.itemLocation = itemLocation
    }
    
    init(){
        self.date = ""
        self.id = 0
        self.name = ""
        self.time = ""
        self.itemLocation = [ItemLocation]()
    }
    
}

open class ItemLocation{
    var idLoc : Int!
    var nameLoc : String!
    var id : Int!
    var name : String!
    var time : String!
    var location = itemLocLocation()
    var pickUps = itemLocPickUps()
    
    init(idLoc : Int, nameLoc : String, id : Int, name : String, time : String,  location : itemLocLocation, pickUps : itemLocPickUps) {
        self.idLoc = idLoc
        self.nameLoc = nameLoc
        self.id = id
        self.name = name
        self.time = time
        self.location = location
        self.pickUps = pickUps
    }
    
    init(){
        self.idLoc = 0
        self.nameLoc = ""
        self.id = 0
        self.name = ""
        self.time = ""
        self.location = itemLocLocation()
        self.pickUps = itemLocPickUps()
    }
    
}

open class itemLocLocation{
    var latitude : Double!
    var longitude : Double!
    
    init(){
        self.latitude = 0.0
        self.longitude = 0.0
    }
}
    
open class itemLocPickUps{
    var id : Int!
    var time : String!
        
    init(){
        self.id = 0
        self.time = ""
    }
}

open class ItemPricePhotopass {
    var name : String!
    var amount : Int!
    var normalAmount : Int!
    var packageDiscount : Int!
    
    init(){
        self.name = ""
        self.amount = 0
        self.normalAmount = 0
        self.packageDiscount = 0
    }
}


open class ItemComplementos{
    var alimentos : Bool!
    var transporte : ItemLocation!
    var fotos : Itemfotos!
    var seguroIKE : ItemIKE!
    
    init(alimentos : Bool, transporte : ItemLocation, fotos : Itemfotos, seguroIKE : ItemIKE) {
        self.alimentos = alimentos
        self.transporte = transporte
        self.fotos = fotos
        self.seguroIKE = seguroIKE
    }
    
    init(){
        self.alimentos = false
        self.transporte = ItemLocation()
        self.fotos = Itemfotos()
        self.seguroIKE = ItemIKE()
    }
}

open class Itemfotos{
    var status : Bool!
    var id : Int!
    var packageName : String!
    var productKey : String!
    var name : String!
    var code : String!
    
    var normalAmount : Double!
    var amount : Double!
    var normalAdults : Double!
    var adults : Double!
    var normalChildren : Double!
    var children : Double!
    var normalInfant : Double!
    var infant : Double!
    var normalIndividual : Double!
    var individual : Double!
    
    var packageDiscount : Double!
    var descuento : Double!
    var rateKey : String!
    
    var itineraries : ItemfotosItineraries
    
    init(){
        self.status = false
        self.id = 0
        self.packageName = ""
        self.productKey = ""
        self.name = ""
        self.code = ""
        self.amount = 0.0
        self.normalAmount = 0.0
        self.packageDiscount = 0.0
        self.descuento = 0.0
        self.rateKey = ""
        self.itineraries = ItemfotosItineraries()
    }
}

open class ItemfotosItineraries{
    var packageId : Int!
    var itineraryId : String!
    
    init(){
        self.packageId = 0
        self.itineraryId = ""
    }
}


open class ItemIKE{
    var status : Bool!
    var id : Int!
    var productKey : String!
    var name : String!
    var code : String!
    var amount : Double!
    var normalAmount : Double!
    
    var normalAdultAmount : Double!
    var adultAmount : Double!
    var normalChildrenAmount : Double!
    var childrenAmount : Double!
    var normalInfantAmount : Double!
    var infantAmount : Double!
    var normalIndividualAmount : Double!
    var individualAmount : Double!
    
    var packageDiscount : Double!
    var descuento : Double!
    var rateKey : String!
    
    var locationname : String!
    
    init(){
        self.status = false
        self.id = 0
        self.productKey = ""
        self.name = ""
        self.code = ""
        self.amount = 0.0
        self.normalAmount = 0.0
        self.normalAdultAmount = 0.0
        self.adultAmount = 0.0
        self.normalChildrenAmount = 0.0
        self.childrenAmount = 0.0
        self.normalInfantAmount = 0.0
        self.infantAmount = 0.0
        self.normalIndividualAmount = 0.0
        self.individualAmount = 0.0
        self.packageDiscount = 0.0
        self.descuento = 0.0
        self.rateKey = ""
        self.locationname = ""
    }
}

open class ItemBuy{
    var disable : Int!
    var mes : Int!
    var diaNumero : Int!
    var year : Int!
    var descuento : Int!
    var date : String!

    init(disable : Int, mes : Int, diaNumero : Int, year : Int, descuento : Int, date : String) {
        
        self.disable = disable
        self.mes = mes
        self.diaNumero = diaNumero
        self.year = year
        self.descuento = descuento
        self.date = date
}
    
    init(){
        self.disable = 1
        self.mes = 0
        self.diaNumero = 0
        self.year = 0
        self.descuento = 0
        self.date = ""
    }
    
}

open class ValidateCarshop{
    var headers : header!
    var activitiesValidateCarshop : [activitiesValidateCarshop]
    var additionalInformation : payments!
//
//    init(header : header, activitiesValidateCarshop : activitiesValidateCarshop) {
//        self.header = header
//        self.activitiesValidateCarshop = [activitiesValidateCarshop]
//
//    }
    
    init(){
        self.headers = header()
        self.activitiesValidateCarshop = Array<activitiesValidateCarshop>()
        self.additionalInformation = payments()
    }
    
}

open class payments{
    var bankId : Int!
    var paymentMethodId : Int!
    
    init(){
        bankId = 8
        paymentMethodId = 7
    }
    
}

open class device{
    var id : Int!
    var name : String!
    
    init(){
        id = 1
        name = "Mobile"
    }
    
}

open class activitiesValidateCarshop{
    var activities : [String : String]
    var addons : [String : String]
    
//    init(activities : [String : String], addons : [String : String]) {
//        self.activities = activities
//        self.addons = addons
//    }
    
    init(){
        self.activities = ["" : ""]
        self.addons = ["" : ""]
    }
    
}

open class header{
    var channel: Int!
    var clientId : Int!
    var language : String!
    var currency : String!
    var country : String!
    
//    init(channel : Int, clientId : Int, language : String, currency : String, country : String) {
//
//        self.channel = channel
//        self.clientId = clientId
//        self.language = language
//        self.language = language
//        self.currency = currency
//        self.country = country
//    }
    
    init(){
        self.channel = 13
        self.clientId = 0
        self.language = Constants.LANG.current
        self.currency = Constants.CURR.current
        self.country = "MEX"
    }
    
    
}


open class itemsPickup{
    var id : String!
    var geographicId: String!
    var geographicName : String!
    var status : Int!
    
    init(key : String , dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.id = key
        self.geographicId = json["geographicId"].stringValue
        self.geographicName = json["geographicName"].stringValue
        self.status = json["status"].intValue
    }
    
    init(){
        self.id = ""
        self.geographicId = ""
        self.geographicName = ""
        self.status = 0
    }
}

open class itemsGeographicPickup{
    var hotelId: String!
    var key_pickup: String!
    var status: Int!
    var timeId: String!
    
    init(dictionary: Dictionary<String, AnyObject>) {
        let json = SwiftyJSON.JSON(dictionary)
        self.hotelId = json["hotelId"].stringValue
        self.key_pickup = json["key_pickup"].stringValue
        self.status = json["status"].intValue
        self.timeId = json["timeId"].stringValue
    }
    
    init(){
        self.hotelId = ""
        self.key_pickup = ""
        self.status = 0
        self.timeId = ""
    }
}

open class ItemListCarshop{
    var key : String!
    var creationDate : String!
    var currency : String!
    var status : Int!
    var totalPrice : Double!
    var totalDiscountPrice : Double!
    var detail : [ItemCarshop] = [ItemCarshop]()
    
    init(key : String, dictionary: Dictionary<String, AnyObject>){
        
        let json = SwiftyJSON.JSON(dictionary)
        self.key = key
        self.creationDate = json["creationDate"].stringValue
        self.currency = json["currency"].stringValue
        self.status = json["status"].intValue
        self.totalPrice = json["totalPrice"].doubleValue
        self.totalDiscountPrice = json["totalDiscountPrice"].doubleValue
        for(key, subJson) in json["detail"] {
            let itemCarshop : ItemCarshop = ItemCarshop()
            itemCarshop.key = key
            itemCarshop.uid = subJson["uid"].stringValue
            itemCarshop.familyId = subJson["familyId"].intValue
            itemCarshop.promotionId = subJson["promotionId"].stringValue
            itemCarshop.promotionName = subJson["promotionName"].stringValue
            itemCarshop.status = subJson["status"].intValue
            itemCarshop.saving = subJson["saving"].doubleValue
            itemCarshop.discountPrice = subJson["discountPrice"].doubleValue
            itemCarshop.price = subJson["price"].doubleValue
            
            for(key, products) in subJson["products"] {
                let productsCarShop = ProductsCarShop()
                
                let productApiRequest = products["productApiRequest"]
                productsCarShop.productApiRequest.activitiesRatekey = productApiRequest["activitiesRateKey"].stringValue
                productsCarShop.productApiRequest.addons_Ratekey = productApiRequest["addonsRateKey"].stringValue
                
                let assistance = productApiRequest["assistance"]
                productsCarShop.productApiRequest.assistanceCarShop.addOnId = assistance["addOnId"].intValue
                productsCarShop.productApiRequest.assistanceCarShop.addOnName = assistance["addOnName"].stringValue
                productsCarShop.productApiRequest.assistanceCarShop.adults = assistance["adults"].doubleValue
                productsCarShop.productApiRequest.assistanceCarShop.amount = assistance["amount"].doubleValue
                productsCarShop.productApiRequest.assistanceCarShop.normalAdults = assistance["normalAdults"].doubleValue
                productsCarShop.productApiRequest.assistanceCarShop.normalAmount = assistance["normalAmount"].doubleValue
                
                let photopass = productApiRequest["photopass"]
                productsCarShop.productApiRequest.photopassCarShop.amount = photopass["amount"].doubleValue
                productsCarShop.productApiRequest.photopassCarShop.individual = photopass["individual"].doubleValue
                productsCarShop.productApiRequest.photopassCarShop.itineraryId = photopass["itineraryId"].stringValue
                productsCarShop.productApiRequest.photopassCarShop.itineraryName = photopass["itineraryName"].stringValue
                productsCarShop.productApiRequest.photopassCarShop.normalAmount = photopass["normalAmount"].doubleValue
                productsCarShop.productApiRequest.photopassCarShop.normalIndividual = photopass["normalIndividual"].doubleValue
                productsCarShop.productApiRequest.photopassCarShop.optionId = photopass["optionId"].stringValue
                productsCarShop.productApiRequest.photopassCarShop.packageId = photopass["packageId"].intValue
                productsCarShop.productApiRequest.photopassCarShop.packageName = photopass["packageName"].stringValue
                
                let transport = productApiRequest["transport"]
                productsCarShop.productApiRequest.transportCarShop.geographicName = transport["geographicName"].stringValue
                productsCarShop.productApiRequest.transportCarShop.hotelId = transport["hotelId"].intValue
                productsCarShop.productApiRequest.transportCarShop.hotelPickupId = transport["hotelPickupId"].intValue
                productsCarShop.productApiRequest.transportCarShop.nameHotel = transport["nameHotel"].stringValue
                productsCarShop.productApiRequest.transportCarShop.schedulePark = transport["schedulePark"].stringValue
                productsCarShop.productApiRequest.transportCarShop.timePickup = transport["timePickup"].stringValue
                
                productsCarShop.key = key
                productsCarShop.productCodePromotion = products["productCodePromotion"].stringValue
                productsCarShop.productCuponPromotion = products["productCuponPromotion"].stringValue
                productsCarShop.dateOrder = products["dateOrder"].stringValue
                productsCarShop.productDate = products["productDate"].stringValue
                productsCarShop.productFood = products["productFood"].boolValue
                productsCarShop.productId = products["productId"].intValue
                productsCarShop.productIke = products["productIke"].boolValue
                productsCarShop.productName = products["productName"].stringValue
                productsCarShop.productPhotopass = products["productPhotopass"].boolValue
                productsCarShop.productTransport = products["productTransport"].boolValue
                productsCarShop.availabilityStatus = products["availabilityStatus"].boolValue
                productsCarShop.productAllotment = products["productAllotment"].boolValue
                
                let productVisitor = products["productVisitor"]
                productsCarShop.productVisitor.productAdult = productVisitor["productAdult"].intValue
                productsCarShop.productVisitor.productChild = productVisitor["productChild"].intValue
                productsCarShop.productVisitor.productInfant = productVisitor["productInfant"].intValue
                
                itemCarshop.products.append(productsCarShop)
            }
            self.detail.append(itemCarshop)
        }
    }
    
    init(){
        self.key = ""
        self.creationDate = ""
        self.currency = ""
        self.status = 0
        self.totalPrice = 0.0
        self.totalDiscountPrice = 0.0
        self.detail = [ItemCarshop]()
    }
    
}


open class ItemCarshop{
    var key : String!
    var uid : String!
    var familyId: Int!
    var products : [ProductsCarShop]
    var promotionId : String!
    var promotionName : String!
    var status : Int!
    var saving : Double!
    var discountPrice : Double!
    var price : Double!
    var close : Bool!
    var statusBuy : StatusBuy
    
    var reservation : ItemCarshopReservation? {
        get {
            if let item = appDelegate.listItemListCarshopReservation.first(where: {$0.keyItemCarshop == key}){
                return item
            }else{
                return nil
            }
        }
    }
    
    init(){
        self.key = ""
        self.uid = ""
        self.familyId = 0
        self.products = [ProductsCarShop]()
        self.promotionId = ""
        self.promotionName = ""
        self.status = 1
        self.saving = 0.0
        self.discountPrice = 0.0
        self.price = 0.0
        self.close = true
        self.statusBuy = StatusBuy()
    }
    
}

open class ProductsCarShop{
    var key : String!
    var keyDetail : String!
    var productApiRequest : ProductApiRequestCarShop
    var dateOrder : String!
    var productDate : String!
    var productFood : Bool!
    var productId : Int!
    var productIke : Bool!
    var productName : String!
    var productPhotopass : Bool!
    var productTransport : Bool!
    var productVisitor : ProductVisitor
    var productCodePromotion : String!
    var productCuponPromotion :String!
    var availabilityStatus : Bool!
    var productAllotment : Bool!
    
    init(){
        self.key = ""
        self.keyDetail = ""
        self.productApiRequest = ProductApiRequestCarShop()
        self.dateOrder = ""
        self.productDate = ""
        self.productFood = false
        self.productId = 0
        self.productIke = false
        self.productName = ""
        self.productPhotopass = false
        self.productTransport = false
        self.productVisitor = ProductVisitor()
        self.productCodePromotion = ""
        self.productCuponPromotion = ""
        self.availabilityStatus = true
        self.productAllotment = false
    }
}

open class ProductApiRequestCarShop{
    var activitiesRatekey : String!
    var addons_Ratekey : String!
    var assistanceCarShop : AssistanceCarShop
    var photopassCarShop : PhotopassCarShop
    var transportCarShop : TransportCarShop
    
    init() {
        self.activitiesRatekey = ""
        self.addons_Ratekey = ""
        self.assistanceCarShop = AssistanceCarShop()
        self.photopassCarShop = PhotopassCarShop()
        self.transportCarShop = TransportCarShop()
    }
}

open class AssistanceCarShop{
    var addOnId : Int!
    var addOnName : String!
    var adults : Double!
    var amount : Double!
    var normalAdults : Double!
    var normalAmount : Double!
    
    init() {
        self.addOnId = 0
        self.addOnName = ""
        self.adults = 0.0
        self.amount = 0.0
        self.normalAdults = 0.0
        self.normalAmount = 0.0
    }
}

open class PhotopassCarShop{
    var amount : Double!
    var individual : Double!
    var itineraryId : String!
    var itineraryName : String!
    var normalAmount : Double!
    var normalIndividual : Double!
    var optionId : String!
    var packageId : Int!
    var packageName : String!
    
    init() {
        self.amount = 0.0
        self.individual = 0.0
        self.itineraryId = ""
        self.itineraryName = ""
        self.normalAmount = 0.0
        self.normalIndividual = 0.0
        self.optionId = ""
        self.packageId = 0
        self.packageName = ""
    }
}

open class TransportCarShop{
    var geographicName: String!
    var hotelId: Int!
    var hotelPickupId: Int!
    var nameHotel: String!
    var schedulePark: String!
    var timePickup: String!
    
    init() {
        self.geographicName = ""
        self.hotelId = 0
        self.hotelPickupId = 0
        self.nameHotel = ""
        self.schedulePark = ""
        self.timePickup = ""
    }
}

open class ProductVisitor{
    var productAdult : Int!
    var productChild : Int!
    var productInfant : Int!
    
    init() {
        self.productAdult = 1
        self.productChild = 0
        self.productInfant = 0
    }
}

open class ItemUserShop{
    var titleValueTextF: ItemLangTitle!
    var nameValueTextF: String!
    var apellidoValueTextF: String!
    var emailValueTextF: String!
    var paisValueTextF: ItemLangCountry!
    var estadoValueTextF: ItemStates!
    var ciudadvalueTextF: String!
    var cpValueTextF: String!
    var ladaValuetextF : ItemPhoneCode!
    var telefonoValueTextF: String!
    
    init() {
        self.titleValueTextF = ItemLangTitle()
        self.nameValueTextF = ""
        self.apellidoValueTextF = ""
        self.emailValueTextF = ""
        self.paisValueTextF = ItemLangCountry()
        self.estadoValueTextF = ItemStates()
        self.ciudadvalueTextF = ""
        self.cpValueTextF = ""
        self.ladaValuetextF = ItemPhoneCode()
        self.telefonoValueTextF = ""
    }
}

open class ItemLangTitle{
    var key: String!
    var code: String!
    var enabled: Int!
    var langCode: String!
    var name: String!
    var value: String!
    
    init(key : String, dictionary: Dictionary<String, AnyObject>){
        let json = SwiftyJSON.JSON(dictionary)
        self.key = key
        self.code = json["code"].stringValue
        self.enabled = json["enabled"].intValue
        self.langCode = json["langCode"].stringValue
        self.name = json["name"].stringValue
        self.value = json["value"].stringValue
    }
    
    init() {
        self.key = ""
        self.code = ""
        self.enabled = 0
        self.langCode = ""
        self.name = ""
        self.value = ""
    }
}

open class ItemPhoneCode{
    var key: String!
    var code: String!
    var id: Int!
    var iso: String!
    var iso2: String!
    var name: String!
    
    init(key : String, dictionary: Dictionary<String, AnyObject>){
        let json = SwiftyJSON.JSON(dictionary)
        self.key = key
        self.code = json["code"].stringValue
        self.id = json["id"].intValue
        self.iso = json["iso"].stringValue
        self.iso2 = json["iso2"].stringValue
        self.name = json["name"].stringValue
    }
    
    init() {
        self.key = ""
        self.code = ""
        self.id = 0
        self.iso = ""
        self.iso2 = ""
        self.name = ""
    }
}

open class ItemLangCountry{
    var key: String!
    var lang: String!
    var continent: String!
    var iSO: String!
    var iSO2: String!
    var id: Int!
    var name: String!
    var region: String!
    var states: [ItemStates] = [ItemStates]()
    
    init(key : String, lang : String, dictionary: Dictionary<String, AnyObject>){
        let json = SwiftyJSON.JSON(dictionary)
        self.key = key
        self.lang = lang
        self.continent = json["continent"].stringValue
        self.iSO = json["iSO"].stringValue
        self.iSO2 = json["iSO2"].stringValue
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.region = json["region"].stringValue
        
        for(key, subJson) in json["states"] {
            let itemStates : ItemStates = ItemStates()
            itemStates.key = key
            itemStates.abbreviation = subJson["abbreviation"].stringValue
            itemStates.id = subJson["id"].intValue
            itemStates.name = subJson["name"].stringValue
            self.states.append(itemStates)
        }
    }
    
    init() {
        self.key = ""
        self.lang = ""
        self.continent = ""
        self.iSO = ""
        self.iSO2 = ""
        self.id = 0
        self.name = ""
        self.region = ""
        self.states = [ItemStates]()
    }
}


open class ItemStates{
    var key: String!
    var abbreviation: String!
    var id: Int!
    var name: String!
    
    init() {
        self.key = ""
        self.abbreviation = ""
        self.id = 0
        self.name = ""
    }
}

open class Banks{
    var cardTypes: [CardType]
    var banks: [Bank]
    
    init() {
        self.cardTypes = [CardType]()
        self.banks = [Bank]()
    }
}

open class CardType{
    var idCardType: Int
    var cardTypeCode, cardTypeName, cardTypeURLLogo: String
    
    init() {
        self.idCardType = 0
        self.cardTypeCode = ""
        self.cardTypeName = ""
        self.cardTypeURLLogo = ""
    }
}

open class Bank{
    var status : Bool!
    var bankInstallmentsIndexSelect : Int!
    var idBank: Int!
    var bankCode, bankName: String!
    var bankInstallments: [BankInstallment]
    var idSivex: Int!
    
    init() {
        self.status = false
        self.bankInstallmentsIndexSelect = 0
        self.idBank = 0
        self.bankCode = ""
        self.bankName = ""
        self.bankInstallments = [BankInstallment]()
        self.idSivex = 0
    }
}

open class BankInstallment{
    var installmentCode: InstallmentCode
    var installmentName: InstallmentName
    var installments: Int
    var commissionAmount: Double
    var commissionPercentage: Double
    var minimiumAmount: Double
    
    init() {
        self.installmentCode = InstallmentCode.the1P
        self.installmentName = InstallmentName.the1SoloPago
        self.installments = 0
        self.commissionAmount = 0
        self.commissionPercentage = 0.0
        self.minimiumAmount = 0
    }
}

enum InstallmentCode: String {
    case the12M = "12M"
    case the13M = "13M"
    case the15M = "15M"
    case the1P = "1P"
    case the3M = "3M"
    case the6M = "6M"
    case the9M = "9M"
}

enum InstallmentName: String {
    case the12Meses = "12 MESES"
    case the13Meses = "13 MESES"
    case the15Meses = "15 MESES"
    case the1SoloPago = "1 SOLO PAGO"
    case the3Meses = "3 MESES"
    case the6Meses = "6 MESES"
    case the9Meses = "9 MESES"
}


open class ItemCardInfo{
    var isoCountry : String!
    var brand : String!
    var bank : String!
    var idBanco : String!
    var bin : String!
    var info : String!
    var level : String!
    var phone : String!
    var paymentMethodName : String!
    var paymentMethodCode : String!
    var cardTypeName : String!
    var type : String!
    var country_iso : String!
    var country2_Iso : String!
    var country3_Iso : String!
    var www : String!
    var cardTypeCode : String!
    
    
    func cardType(bankType : String)-> UIImage?{
        
        let brand = bankType.lowercased()
        var prefix = ""
        
        if brand.contains("ax"){
            prefix = "amex"
        }else if brand.contains("mc"){
            prefix = "mastercard"
        }else if brand.contains("vi"){
            prefix = "visa"
        }else if brand.contains("ds"){
            prefix = "discover"
        }else if brand.contains("jc"){
            prefix = "jcb"
        }else{
            prefix = ""
        }
        
        return UIImage(named: "Card/bankType/\(prefix)")
    }
    
    func imageBank(bank : String)-> UIImage?{
        let bankName = bank
        var prefix = ""
        if bankName.contains("BAN-XICO"){
            prefix = "banxico"
        }else if bankName.contains("BANCOMEXT"){
            prefix = "bancomext"
        }else if bankName.contains("BANOBRAS"){
            prefix = "banobras"
        }else if bankName.contains("BBVA"){
            prefix = "bbva"
        }else if bankName.contains("SANTANDER"){
            prefix = "santander"
        }else if bankName.contains("BANJERCITO"){
            prefix = "inbursa"
        }else if bankName.contains("HSBC"){
            prefix = "hsbc"
        }else if bankName.contains("GE CAPITAL"){
            prefix = "ge capital"
        }else if bankName.contains("DEL BAJIO"){
            prefix = "banbajio"
        }else if bankName.contains("IXE"){
            prefix = "ixe"
        }else if bankName.contains("INBURSA"){
            prefix = "inbursa"
        }else if bankName.contains("MIFEL"){
            prefix = "mifel"
        }else if bankName.contains("SCOTIABANK"){
            prefix = "scotiabank"
        }else if bankName.contains("BANREGIO"){
            prefix = "banregio"
        }else if bankName.contains("INVEX"){
            prefix = "invex"
        }else if bankName.contains("AFIRME"){
            prefix = "afirme"
        }else if bankName.contains("BANORTE"){
            prefix = "banorte"
        }else if bankName.contains("AMERICAN EXPRESS"){
            prefix = "amex"
        }else if bankName.contains("AHORRO FAMSA"){
            prefix = "famsa"
        }else if bankName.contains("BANAMEX"){
            prefix = "banamex"
        }else if bankName.contains("LIVERPOOL"){
            prefix = "liberpool"
        }else if bankName.contains("ITAUCARD"){
            prefix = "itau"
        }else if bankName.contains("OTROS"){
            prefix = ""
        }else{
            prefix = ""
        }
        
        return UIImage(named: "Card/bankCard/\(prefix)")
    }
    
    init() {
        self.isoCountry = ""
        self.brand = ""
        self.bank = ""
        self.idBanco = ""
        self.bin = ""
        self.info = ""
        self.level = ""
        self.phone = ""
        self.paymentMethodName = ""
        self.paymentMethodCode = ""
        self.cardTypeName = ""
        self.type = ""
        self.country_iso = ""
        self.country2_Iso = ""
        self.country3_Iso = ""
        self.www = ""
        self.cardTypeCode = ""
    }
}

open class GetBookingTicket{
    var idProducto : String!
    var salesId : Int!
    var dsSalesId : String!
    var productId : Int!
    var status : Int!
    var id : Int!
    var message : String!
    var comments : String!
    var dsSaleIdInsure: String?
    var saleIdInsure: Int!
    
    init() {
        self.idProducto = ""
        self.salesId = 0
        self.dsSalesId = ""
        self.productId = 0
        self.status = 0
        self.id = 0
        self.message = ""
        self.comments = ""
        self.dsSaleIdInsure = nil
        self.saleIdInsure = 0
    }
}

open class StatusValidateCarShop{
    var simple : Bool!
    var pack : Bool!
    var statusValidateCarShopAllotmen : StatusValidateCarShopAllotment = StatusValidateCarShopAllotment()
    
    init() {
        self.statusValidateCarShopAllotmen = StatusValidateCarShopAllotment()
        self.simple = false
        self.pack = false
    }
}

open class StatusValidateCarShopAllotment{
    var holdStatusAllotment : String!
    var statusPromotion : Bool!
    var statusApplied : Bool!
    
    init() {
        self.holdStatusAllotment = ""
        self.statusPromotion = false
        self.statusApplied = false
    }
}

open class ListPriceFE{
    var uid : String!
    var uid_park : String!
    var key_promotion : String!
    var key_product : String!
    var title : String!
    var adultoPrice : String!
    var menorPrice : String!
    var orden : Int!
    var namePromotion : String!
    var paxType : String!
    
    init() {
        self.uid = ""
        self.uid_park = ""
        self.key_promotion = ""
        self.key_product = ""
        self.title = ""
        self.adultoPrice = ""
        self.menorPrice = ""
        self.orden = 0
        self.namePromotion = ""
        self.paxType = ""
    }
}

open class ItemPriceFE{
    var uid : String!
    var uid_park : String!
    var key_promotion : String!
    var key_product : String!
    var title : String!
    var price : String!
    var orden : Int!
    var namePromotion : String!
    var paxType : String!
    
    init() {
        self.uid = ""
        self.uid_park = ""
        self.key_promotion = ""
        self.key_product = ""
        self.title = ""
        self.price = ""
        self.orden = 0
        self.namePromotion = ""
        self.paxType = ""
    }
}

open class ItemCarshopReservation {
    var keyItemCarshop: String!
    var salesId: Int!
    var dsSalesId: String!
    var dsSaleIdInsure: String!
    var saleIdInsure: Int!
    
    init() {
        self.keyItemCarshop = ""
        self.salesId = 0
        self.dsSalesId = ""
        self.dsSaleIdInsure = ""
        self.saleIdInsure = 0
    }
}
