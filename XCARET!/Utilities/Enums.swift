//
//  Enums.swift
//  XCARET!
//
//  Created by Angelica Can on 11/7/18.
//  Copyright © 2018 Angelica Can. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

enum TypeEnviroment: Int{
    case develop = 0
    case preproduction = 1
    case production = 2
}
enum TypeEmptyCell : Int {
    case notfound = 0
    case searchinfo = 1
    case favorite = 2
}

enum TypeEntity : Int {
    case services  = 0
    case activities = 1
    case favorites = 2
    case search = 3
}

enum AuthenticationType : Int {
    case anonimous = 0
    case facebook = 1
    case google = 2
    case userPass = 3
    case apple = 4
}

enum AlertType: Int {
    case error = 0
    case success = 1
    case warning = 2
    case info = 3
}

enum TypeCell : Int {
    case cellActivity = 0
    case cellMap = 1
    case cellRestaurants = 2
    case cellExtra = 3
    case cellSeeAll = 4
    case cellCallCenter = 5
    case cellInfoPark = 6
    case cellConSin = 7
    case cellbasicXV = 8
    case cellAllInclusiveXV = 9
    case cellTipoEntrada = 10
    case cellSwichXP = 11
    case cellEvents = 12
    case cellXOKerMexIMG = 13
    case cellXOKermesMexicana = 14
    case cellXOMenu = 15
    case cellTitleXN = 16
    case cellActivityBasic = 17
    case cellAwardXenotes = 18
    case cellRecomendacionesXN = 19
    case cellEventsXI = 20
    case cellCenoteXI = 21
    case cellAddress = 22
    case cellProgramaMano = 23
    case cellPrefHome = 24
    case cellHome = 25
    case cellInfoParkShort = 26
    case cellScheduleAdmission = 27
    case cellLocation = 28
    case cellPriceTableFE = 29
}

enum TypeCellShop : String {
    case cellPromotions
    case cellParks
    case cellBtnAllPromotions
    case cellTours
    case cellPacks
}

enum TypeCellHotel : Int {
    case cellStack = 1
    case cellRooms = 2
    case cellAFI = 3
    case cellAddress = 4
    case cellCallCenter = 5
    case cell360 = 6
    case cellGoHotel = 7
}

enum VerticalLocation: String {
    case bottom
    case top
}

/*enum TagsAnaliticsNav: String {
    case map
    case favorites
    case home
    case menu
    case search
    case restaurants
    case detailPark
    case detailActivity
    case policyPryvacy
    case termsAndConditions
    case allActivities
    case photo
    case tickets
    
}*/

enum TypeDirectory : Int {
    case phone = 0
    case email = 1
    case title = 2
}

enum TagsContentAnalytics : String {
    //News
    case ListMain
    case Home
    case ParkDetail
    case TopActivities
    case Favorite
    case Search
    case Restaurant
    case ActivityDetail
    case Menu
    case Filters
    case AddFavorite
    case DeleteFavorite
    case Security
    case Navigation
    case Photo
    case MainNavigation
    case Currency
}

enum TagsID : String {
    case listNew
    case goMap
    case goRestaurant
    case goPinterest
    case goDetailPark
    case goPinWheel
    case goBooking
    case goGallery
    case callNow
    case listPathDoing
    case listPathFeeling
    case listMore
    case showGoogleMaps
    case showLocation
    case delete
    case addFavorite
    case logOut
    case goMain
    case privacyPolicy
    case termsConditions
    case reviewUs
    case emailUs
    case langEng
    case langES
    case goPhotopass
    case goWallet
    case guest
    case facebook
    case google
    case forgot
    case signup
    case login
    case home
    case fav
    case search
    case menu
    case goProgramaMano
    case tickets
    case promotions
    case mainTickets
    case mainPromotions
    case mainSearch
    case mainMenu
    case Promotion
    case mainTienda
}

enum TagsPhoto : String {
    case saveAlbum
    case searchAlbum
    case validateCode
    case unlockAlbum
    case shareMultiPhotos
    case shareOnlyPhoto
}

enum TagsCategoryCart : String{
    case Parks
    case Tours
}

enum GradientColorDirection {
    case vertical
    case horizontal
}

enum AnimationType{
    case ANIMATE_RIGHT
    case ANIMATE_LEFT
    case ANIMATE_UP
    case ANIMATE_DOWN
}

enum TypeButtonFavorite: Int{
    case border = 0
    case simple = 1
}

enum TypeAlertView: Int {
    case contactCenterView = 0
    case favorites = 1
    case changeLang = 2
    case invalidCode = 3
    case unblockAlbum = 4
    case excedLimitUnblock = 5
    case callCenterUnblock = 6
}

enum Vibration {
    case error
    case success
    case warning
    case light
    case medium
    case heavy
    case selection
    case oldSchool
    
    func vibrate() {
        
        switch self {
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            
        case .oldSchool:
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
        
    }
}

/*Bar code*/
enum BarcodeMode {
    case Barcode
    case QRCode
    
    var filterName :String  {
        switch self{
        case .Barcode:
            return "CICode128BarcodeGenerator"
        case .QRCode:
            return "CIQRCodeGenerator"
        }
    }
}

/*Lottie*/
enum TypeJsonLottie : String {
    case loadTicket = "loadingTickets"
    case loadPhoto = "download"
    case load = "loading"
}

/*Status Photopass*/

enum TypeAlbumStatus : Int {
    case valid = 1
    case recentAdd = 2
    case commigExpired = 3
    case expired = 4
}


enum InputType {
    case name
    case cardNumber
    case expirationDate
    case cvv
}

enum BookingStatusCard: Int{
    case inProcessBuy = 0
    case declined = 1
    case approved = 2
    case rejected = 3
    case inProcess = 5
    case paymentPlan = 6
    case errorCarShop = 50
    case unknown = 9999
    
    init?(initString: String) {
        switch (initString.lowercased()) {
        case "inProcessBuy":
            self.init(rawValue: 0)
        case "declined":
            self.init(rawValue: 1)
        case "approved":
            self.init(rawValue: 2)
        case "rejected":
            self.init(rawValue: 3)
        case "inprocess":
            self.init(rawValue: 5)
        case "paymentPlan":
            self.init(rawValue: 6)
        case "errorCarShop":
            self.init(rawValue: 50)
        default:
            self.init(rawValue: 9999)
        }
    }
}

enum WindowAlert{
    case allotment
    case help
    case errorCard
    case disconnectionAPI
    case ferry
}

enum ParkId : String {
    case xcaret = "XC" //1
    case xelha = "XH" // 3
    case xenses = "XS" // 15
    case xplor = "XP" // 2
    case xplorFuego = "XF" // 12
    case xavage = "XV" // 18
    case xenotes = "XN" // 11
    case xoximilco = "XO" // 10
    case xichen = "XI" // 0
    case xtours = "XT" //5
    case newPark = "NP" //0
    
    
    init?(initString: Int) {
        switch(initString){
        case 1:
            self = .xcaret
        case 2:
            self = .xplor
        case 3:
            self = .xelha
        case 5:
            self = .xichen
        case 10:
            self = .xoximilco
        case 11:
            self = .xenotes
        case 12:
            self = .xplorFuego
        case 15:
            self = .xenses
        case 18:
            self = .xavage
        default:
            self = .newPark
        }
    }
}

enum ReservationStatus: Int {
    case cancel = 1
    case refund = 2
    case upgrade = 3
    case inProcess = 4
    case modify = 5
    case paid = 7
    case expired = 21
    case courtesy = 23
    case reserved = 24
    case chargeBack = 25
    case penalty = 36
    case invoiced = 37
    case reservedAgency = 38
    
    case unknowned = 9999
    
    init?(initString: String) {
        switch(initString.lowercased()){
        case "cancel":
            self.init(rawValue: 1)
        case "refund":
            self.init(rawValue: 2)
        case "upgrade":
            self.init(rawValue: 3)
        case "inprocess":
            self.init(rawValue: 4)
        case "modify":
            self.init(rawValue: 5)
        case "paid":
            self.init(rawValue: 7)
        case "expired":
            self.init(rawValue: 21)
        case "courtesy":
            self.init(rawValue: 23)
        case "reserved":
            self.init(rawValue: 24)
        case "chargeback":
            self.init(rawValue: 25)
        case "penalty":
            self.init(rawValue: 36)
        case "invoiced":
            self.init(rawValue: 37)
        case "reservedagency":
            self.init(rawValue: 38)
        default:
            self = .unknowned
        }
    }

    var color: UIColor {
        switch self {
        case .inProcess:
            return #colorLiteral(red: 0.9098039216, green: 0.5960784314, blue: 0.1176470588, alpha: 1)
        case .modify:
            return #colorLiteral(red: 0.9098039216, green: 0.5960784314, blue: 0.1176470588, alpha: 1)
        case .cancel:
            return #colorLiteral(red: 0.8352941176, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        case .expired:
            return #colorLiteral(red: 0.8352941176, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        case .chargeBack:
            return #colorLiteral(red: 0.8352941176, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        case .penalty:
            return #colorLiteral(red: 0.8352941176, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
        case .refund:
            return #colorLiteral(red: 0.03921568627, green: 0.7490196078, blue: 0.3803921569, alpha: 1)
        case .upgrade:
            return #colorLiteral(red: 0.03921568627, green: 0.7490196078, blue: 0.3803921569, alpha: 1)
        case .paid:
            return #colorLiteral(red: 0.03921568627, green: 0.7490196078, blue: 0.3803921569, alpha: 1)
        case .courtesy:
            return #colorLiteral(red: 0.03921568627, green: 0.7490196078, blue: 0.3803921569, alpha: 1)
        case .reserved:
            return #colorLiteral(red: 0.03921568627, green: 0.7490196078, blue: 0.3803921569, alpha: 1)
        case .invoiced:
            return #colorLiteral(red: 0.03921568627, green: 0.7490196078, blue: 0.3803921569, alpha: 1)
        case .reservedAgency:
            return #colorLiteral(red: 0.03921568627, green: 0.7490196078, blue: 0.3803921569, alpha: 1)
        case .unknowned:
            return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    }
}
